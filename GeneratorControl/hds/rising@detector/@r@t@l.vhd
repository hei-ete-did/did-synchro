ARCHITECTURE RTL OF risingDetector IS
  signal signalInDelayed: std_uLogic;
BEGIN

  delay: process(reset, clock)
  begin
    if reset = '1' then
      signalInDelayed <= '0';
    elsif rising_edge(clock) then
      signalInDelayed <= sigIn;
    end if;
  end process delay;

  findRising: process(sigIn, signalInDelayed)
  begin
    if (sigIn = '1') and (signalInDelayed = '0') then
      rising <= '1';
    else
      rising <= '0';
    end if;
  end process findRising;

END RTL;
