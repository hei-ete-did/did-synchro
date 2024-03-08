LIBRARY Common;
  USE Common.CommonLib.all;

ARCHITECTURE RTL OF buttonRepeatCounter IS

  constant counterBitNb : positive := requiredBitNb(integer(
    clockFrequency / repeatFrequency
  ));
  signal repeatCounter: unsigned(counterBitNb-1 downto 0);

BEGIN

  countRepeatPeriod: process(reset, clock)
  begin
    if reset = '1' then
      repeatCounter <= (others => '0');
    elsif rising_edge(clock) then
      if restartCounter = '1' then
        repeatCounter <= to_unsigned(1, repeatCounter'length);
      elsif repeatCounter > 0 then
        repeatCounter <= repeatCounter + 1;
      end if;
    end if;
  end process countRepeatPeriod;

  counterDone <= '1' when repeatCounter+1 = 0
    else '0';

END ARCHITECTURE RTL;
