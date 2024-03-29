--===========================================================================--
--  Design units : CoCa.serialPortTransmitter.rtl
--
--  File name : serialPortTransmitter.vhd
--
--  Purpose : Transmit a 8 bit data word over a serial line
--            add start and stop bits
--
--  Parameters : dataBitNb : number of data bits
--               stopBitNb : number of stop bits
--
--  
--
--  Errors: : None known
--
--  Library : Common
--
--  Dependencies : None
--
--  Author : 
--  Haute ecole d'ingenierie (HEI/HES-SO)
--  Institut systemes industriels (ISI)
--  Rue de l'industrie 23
--  1950 Sion
--  Switzerland (CH)
--
--  Simulator : Mentor ModelSim V10.7c
------------------------------------------------
--  Revision list
--  Version Author Date Changes
--
--  V1.0 04.04.2022 - First version
--===========================================================================--

library Common;
  use Common.CommonLib.all;

architecture RTL of serialPortTransmitter is

  signal dividerCounter: unsigned(requiredBitNb(baudRateDivide)-1 downto 0);
  signal dividerCounterReset: std_uLogic;
  signal txData: unsigned(dataBitNb-1 downto 0);
  signal send1: std_uLogic;
  signal txShiftEnable: std_uLogic;
  signal txShiftReg: unsigned(dataBitNb+stopBitNb downto 0);
  signal txSendingByte: std_uLogic;
  signal txSendingByteAndStop: std_uLogic;

begin

  divide: process(reset, clock)
  begin
    if reset = '1' then
      dividerCounter <= (others => '0');
    elsif rising_edge(clock) then
      if dividerCounterReset = '1' then
        dividerCounter <= to_unsigned(1, dividerCounter'length);
      else
        dividerCounter <= dividerCounter + 1;
      end if;
    end if;
  end process divide;

  endOfCount: process(dividerCounter, send1)
  begin
    if dividerCounter = baudRateDivide then
      dividerCounterReset <= '1';
    elsif send1 = '1' then
      dividerCounterReset <= '1';
    else
      dividerCounterReset <= '0';
    end if;
  end process endOfCount;

  txShiftEnable <= dividerCounterReset;

  storeData: process(reset, clock)
  begin
    if reset = '1' then
      txData <= (others => '1');
    elsif rising_edge(clock) then
      if send = '1' then
        txData <= unsigned(dataIn);
      end if;
    end if;
  end process storeData;

  delaySend: process(reset, clock)
  begin
    if reset = '1' then
      send1 <= '0';
    elsif rising_edge(clock) then
      send1 <= send;
    end if;
  end process delaySend;

  shiftReg: process(reset, clock)
  begin
    if reset = '1' then
      txShiftReg <= (others => '1');
    elsif rising_edge(clock) then
      if txShiftEnable = '1' then
        if send1 = '1' then
          txShiftReg <= (others => '1');                 -- stop bits
          txShiftReg(0) <= '0';                          -- start bit
          txShiftReg(txData'high+1 downto 1) <= txData;  -- data
          txShiftReg(txShiftReg'high) <= '0';            -- end flag
        else
          txShiftReg <= shift_right(txShiftReg, 1);
          txShiftReg(txShiftReg'high) <= '1';
        end if;
      end if;
    end if;
  end process shiftReg;

  txSendingByte <= '1' when
    (txShiftReg(txShiftReg'high downto 1) /= (txShiftReg'high downto 1 => '1'))
    else '0';

  txSendingByteAndStop <= '1' when
    txShiftReg /= (txShiftReg'high downto 0 => '1')
    else '0';

  TxD <= txShiftReg(0) when txSendingByte = '1' else '1';
  busy <= txSendingByteAndStop or send1 or send;

end RTL;
