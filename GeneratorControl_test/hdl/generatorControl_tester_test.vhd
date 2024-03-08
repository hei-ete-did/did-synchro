library ieee;
  use ieee.math_real.all;
LIBRARY Common_test;
  use Common_test.testUtils.all;
LIBRARY RS232;

ARCHITECTURE test OF generatorControl_tester IS
                                                              -- clock and reset
  constant clockPeriod: time := 1.0/clockFrequency * 1 sec;
  signal sClock: std_uLogic := '1';
  signal sReset: std_uLogic;
                                                                        -- mains
  constant mainsPeriod: time := 1.0/mainsFrequency * 1 sec;
  signal sMains: std_uLogic := '1';
                                                                      -- buttons
  constant operatorDelay: time := 100 us;
  constant regulationTimeSpan: time := 20 ms;
  constant manual_autoId: positive := 1;
  constant decrementAmplitudeId: positive := 2;
  constant incrementAmplitudeId: positive := 3;
  signal regulationMode : string(1 to 20) := (others => ' ');
                                                                -- RS232 control
  constant uartBuildStep : boolean := false;
  constant baudRateDivide : positive := integer(clockFrequency/rs232BaudRate);
  constant rs232DataBitNb: positive := 8;
  constant nibbleBitNb: positive := 4;
  signal rxData, txData: std_ulogic_vector(rs232DataBitNb-1 downto 0);
  signal rxDataValid: std_ulogic;
  signal phaseDifferenceBuild, phaseDifference: integer := 0;
  signal controlAmplitude: integer := 2**(controlAmplitudeBitNb-1);
  signal txStart, txSend, txBusy: std_ulogic;
                                                            -- motors simulation
--  constant lowpassShift: positive := 24;
--  signal lowpassAccumulator: real := 0.5 * 2.0**lowpassShift;
--  signal lowpassValue: real := 0.5;
  constant lowpassShift: positive := 12;
  signal lowpassAccumulator: real := 0.0;
  signal lowpassValue: real := 0.0;

  signal motorFrequency: real := 0.0;
  signal tReal: real := 0.0;
  signal generatorVoltage: real := 0.0;
  signal generatorPhase: real := 0.0;
                                                                   -- components
  COMPONENT serialPortReceiver
  GENERIC (
    dataBitNb      : positive := 8;
    baudRateDivide : positive := 2083
  );
  PORT (
    RxD       : IN     std_ulogic;
    clock     : IN     std_ulogic;
    reset     : IN     std_ulogic;
    dataOut   : OUT    std_ulogic_vector(dataBitNb-1 DOWNTO 0);
    dataValid : OUT    std_ulogic
  );
  END COMPONENT;

  COMPONENT serialPortTransmitter
  GENERIC (
    dataBitNb      : positive := 8;
    baudRateDivide : positive := 2083
  );
  PORT (
    TxD    : OUT    std_ulogic;
    clock  : IN     std_ulogic;
    reset  : IN     std_ulogic;
    dataIn : IN     std_ulogic_vector(dataBitNb-1 DOWNTO 0);
    send   : IN     std_ulogic;
    busy   : OUT    std_ulogic
  );
  END COMPONENT;

BEGIN
  ------------------------------------------------------------------------------
  -- clock and reset
  --
  sReset <= '1', '0' after 4*clockPeriod;
  reset <= sReset;

  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after 9.0/10.0 * clockPeriod;

  ------------------------------------------------------------------------------
  -- mains
  --
  sMains <= not sMains after mainsPeriod/2;
  mains <= sMains when rising_edge(sClock) and (now < 14 ms);

  ------------------------------------------------------------------------------
  -- buttons
  --
  buttonControl: process
  begin
    buttons <= (others => '0');
                                                           -- PI regulation mode
--    wait for regulationTimeSpan;
    wait for operatorDelay;
                                                            -- go to manual mode
    print("");
    print(cr & "Testing manual mode");
    regulationMode <= pad("manual", regulationMode'length);
    buttons(manual_autoId) <= '1';
    wait for operatorDelay;
    buttons(manual_autoId) <= '0';
    wait for operatorDelay;
                                                            -- increment control
    for index in 1 to 10 loop
      buttons(incrementAmplitudeId) <= '1';
      wait for operatorDelay;
      buttons(incrementAmplitudeId) <= '0';
      wait for operatorDelay;
    end loop;
                                                            -- decrement control
    for index in 1 to 10 loop
      buttons(decrementAmplitudeId) <= '1';
      wait for operatorDelay;
      buttons(decrementAmplitudeId) <= '0';
      wait for operatorDelay;
    end loop;
                                                      -- go to I regulation mode
    print(cr & "Testing fixed step I regulation");
    regulationMode <= pad("fixed step I", regulationMode'length);
    buttons(manual_autoId) <= '1';
    wait for operatorDelay;
    buttons(manual_autoId) <= '0';
    wait for regulationTimeSpan;
                                                   -- go to UART regulation mode
    print(cr & "Testing external regulation");
    regulationMode <= pad("UART", regulationMode'length);
    buttons(manual_autoId) <= '1';
    wait for operatorDelay;
    buttons(manual_autoId) <= '0';
    wait for regulationTimeSpan;
                                                     -- go to PI regulation mode
    print(cr & "Testing PI regulation");
    regulationMode <= pad("PI", regulationMode'length);
    buttons(manual_autoId) <= '1';
    wait for operatorDelay;
    buttons(manual_autoId) <= '0';
    wait for regulationTimeSpan;
                                                               -- end simulation
    assert false
      report "End of simulation"
      severity failure;
    wait;
  end process buttonControl;

  ------------------------------------------------------------------------------
  -- RS232 control
  --
  I_Rx : serialPortReceiver
    GENERIC MAP (
      dataBitNb      => rs232DataBitNb,
      baudRateDivide => baudRateDivide
    )
    PORT MAP (
      RxD       => TxD,
      clock     => sClock,
      reset     => sReset,
      dataOut   => rxData,
      dataValid => rxDataValid
    );
                                                       -- receive measured value

  shiftRxData: process(rxDataValid)
    variable highNibble, lowNibble, nibbleCount: integer;
    variable lastWasControl, numberIsPositive: boolean;
  begin
    if falling_edge(rxDataValid) then
      highNibble := to_integer(
        unsigned(rxData(rxData'high downto rxData'high-nibbleBitNb+1))
      );
      lowNibble := to_integer(
        unsigned(rxData(nibbleBitNb-1 downto 0))
      );
      if highNibble = 3 then
        phaseDifferenceBuild <= phaseDifferenceBuild*16 + lowNibble;
        nibbleCount := nibbleCount + 1;
        if lastWasControl then
          if lowNibble < 8 then
            numberIsPositive := true;
          else
            numberIsPositive := false;
          end if;
        end if;
        lastWasControl := false;
      elsif highNibble = 4 then
        phaseDifferenceBuild <= phaseDifferenceBuild*16 + lowNibble+9;
        nibbleCount := nibbleCount + 1;
        if lastWasControl then
          numberIsPositive := false;
        end if;
        lastWasControl := false;
      elsif highNibble = 0 then
        if not lastWasControl then
          if numberIsPositive then
            phaseDifference <= phaseDifferenceBuild;
          else
            phaseDifference <= -(2**(4*nibbleCount) - phaseDifferenceBuild);
          end if;
        end if;
        phaseDifferenceBuild <= 0;
        nibbleCount := 0;
        lastWasControl := true;
      end if;
    end if;
  end process shiftRxData;
                                                        -- compute control value
  regulateI: if not uartBuildStep generate
    process
    begin
      txStart <= '0';
      wait until phaseDifference'event;
      -- controlAmplitude <= 16#19A#;
      if phaseDifference < 0 then
        controlAmplitude <= controlAmplitude - 1;
      elsif phaseDifference > 0 then
        controlAmplitude <= controlAmplitude + 1;
      end if;
      wait until rising_edge(sClock);
      wait for clockPeriod/10;
      txStart <= '1';
      wait for clockPeriod;
    end process;
  end generate regulateI;

  buildStep: if uartBuildStep generate
    process
      variable startOfStep : time := 4.5 ms;
    begin
      txStart <= '0';
      wait until phaseDifference'event;
      if now > startOfStep then
        controlAmplitude <= 2**controlAmplitudeBitNb / 4;
      end if;
      if now > startOfStep + regulationTimeSpan/2 then
        controlAmplitude <= (2**controlAmplitudeBitNb * 3) / 4;
      end if;
      wait until rising_edge(sClock);
      wait for clockPeriod/10;
      txStart <= '1';
      wait for clockPeriod;
    end process;
  end generate buildStep;
                                                           -- send control value
  shiftTxData: process
    constant nibbleCount: positive := (controlAmplitudeBitNb-1)/nibbleBitNb + 1;
    variable txNibble: unsigned(nibbleBitNb-1 downto 0);
  begin
    txSend <= '0';
    wait until rising_edge(txStart);
    for index in nibbleCount-1 downto 0 loop
      txSend <= '1';
      txNibble := resize(
        shift_right(
          to_unsigned(controlAmplitude, 2**(nibbleBitNb*nibbleCount)),
          nibbleBitNb*index
        ),
        txNibble'length
      );
      if txNibble < 10 then
        txData <= X"3" & std_ulogic_vector(txNibble);
      else
        txData <= X"4" & std_ulogic_vector(txNibble-9);
      end if;
      wait for clockPeriod;
      txSend <= '0';
      wait until rising_edge(sClock) and (txBusy = '0');
    end loop;
    txSend <= '1';
    txData <= std_ulogic_vector(to_unsigned(character'pos(cr), txData'length));
    wait for clockPeriod;
    txSend <= '0';
    wait until rising_edge(sClock) and (txBusy = '0');
    txSend <= '1';
    txData <= std_ulogic_vector(to_unsigned(character'pos(lf), txData'length));
    wait for clockPeriod;
    txSend <= '0';
    wait until rising_edge(sClock) and (txBusy = '0');
  end process shiftTxData;

  I_Tx : serialPortTransmitter
    GENERIC MAP (
      dataBitNb      => rs232DataBitNb,
      baudRateDivide => baudRateDivide
    )
    PORT MAP (
      TxD    => RxD,
      clock  => sClock,
      reset  => sReset,
      dataIn => txData,
      send   => txSend,
      busy   => txBusy
    );

  ------------------------------------------------------------------------------
  -- motors simulation
  --
                                                        -- lowpass filter on PWM
  lowpassIntegrator: process
  begin
    wait until rising_edge(sClock);
    if pwm = '1' then
      lowpassAccumulator <= lowpassAccumulator - lowpassValue + 1.0;
    else
      lowpassAccumulator <= lowpassAccumulator - lowpassValue;
    end if;
  end process lowpassIntegrator;

  lowpassValue <= lowpassAccumulator / 2.0**lowpassShift;
                                              -- filtered PWM to motor frequency
  motorFrequency <= 0.9 * lowpassValue * 2.0 * mainsFrequency;
                                                           -- generator sinewave
  process(sClock)
  begin
    if rising_edge(sClock) then
      tReal <= tReal + (1.0/clockFrequency);
      generatorPhase <= generatorPhase + 2.0*math_pi*motorFrequency*(1.0/clockFrequency);
    end if;
  end process;

  generatorVoltage <= cos(generatorPhase);
                                                           -- triggered sinewave
  generator <= '1' when generatorVoltage > 0.5
    else '0' when generatorVoltage < -0.5;

END ARCHITECTURE test;
