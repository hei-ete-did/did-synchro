ARCHITECTURE RTL OF manualControl IS

  signal controlAmplitude_int: unsigned(controlAmplitude'range);

BEGIN
  accumulate: process(reset, clock)
  begin
    if reset = '1' then
      controlAmplitude_int <= (others => '0');
      controlAmplitude_int(controlAmplitude_int'high) <= '1';
    elsif rising_edge(clock) then
      if increment = '1' then
        controlAmplitude_int <= controlAmplitude_int + 1;
      elsif decrement = '1' then
        controlAmplitude_int <= controlAmplitude_int - 1;
      end if;
    end if;
  end process accumulate;

  controlAmplitude <= controlAmplitude_int;

END ARCHITECTURE RTL;
