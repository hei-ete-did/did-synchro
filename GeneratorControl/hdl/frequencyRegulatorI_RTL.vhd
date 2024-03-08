LIBRARY Common;
  USE Common.CommonLib.all;

ARCHITECTURE masterVersion OF frequencyRegulatorI IS

  constant defaultAmplitude: unsigned(controlAmplitude'range)
    := shift_left(
      resize("01", controlAmplitude'length),
      controlAmplitude'length-1
    );
  signal accumulator: unsigned(controlAmplitude'range);

BEGIN
  ------------------------------------------------------------------------------
                                                                   -- integrator
  integrateAndZeroError: process(reset, clock)
  begin
    if reset = '1' then
      accumulator <= defaultAmplitude;
    elsif rising_edge(clock) then
      if sel = '1' then
        if en = '1' then
          if periodDiff < 0 then
            accumulator <= accumulator - 1;
          elsif periodDiff > 0 then
            accumulator <= accumulator + 1;
          end if;
        end if;
      else
--        accumulator <= defaultAmplitude - shift_right(defaultAmplitude, 2);
        accumulator <= defaultAmplitude;
      end if;
    end if;
  end process integrateAndZeroError;

  controlAmplitude <= accumulator;

END ARCHITECTURE masterVersion;
