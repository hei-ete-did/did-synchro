ARCHITECTURE RTL OF phaseRegulator IS

  constant outputOffset: unsigned(controlAmplitude'range)
    := shift_left(resize("1", controlAmplitude'length), controlAmplitude'length-1);

  constant proportionalBitNb: positive := controlAmplitude'length;
  signal proportionalShifted: signed(phaseDifference'length+proportionalShift-1 downto 0);
  signal proportionalOverflow: std_ulogic;
  signal proportional: signed(proportionalBitNb-1 downto 0);

  constant integratorBitNb: positive := controlAmplitude'length;
  signal integrator: signed(integratorBitNb-1 downto 0);

BEGIN
  ------------------------------------------------------------------------------
                                                            -- proportional term
  proportionalShifted <= shift_left(
    resize(phaseDifference, proportionalShifted'length),
    proportionalShift
  );

  proportionalOverflow <= '0' when shift_right(proportionalShifted, phaseDifference'length) = 0
    else '0' when shift_right(proportionalShifted, phaseDifference'length)+1 = 0
    else '1';

  limitOverflow: process(proportionalOverflow, proportionalShifted)
  begin
    if proportionalOverflow = '0' then
      proportional <= resize(
        shift_right(
          proportionalShifted,
          phaseDifference'length - proportional'length
        ),
        proportional'length
      );
    else
      proportional <= (others => not proportionalShifted(proportionalShifted'high));
      proportional(proportional'high) <= proportionalShifted(proportionalShifted'high);
    end if;
  end process limitOverflow;

  ------------------------------------------------------------------------------
                                                              -- integrator term
  updateIntegratorTerm: process(reset, clock)
  begin
    if reset = '1' then
      integrator <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        if phaseDifference > 0 then
          integrator <= integrator + integratorShift;
        elsif phaseDifference < 0 then
          integrator <= integrator - integratorShift;
        end if;
      end if;
    end if;
  end process updateIntegratorTerm;

  ------------------------------------------------------------------------------
                                                             -- regulator output
  controlAmplitude <= outputOffset + unsigned(proportional);
--  controlAmplitude <= outputOffset + unsigned(proportional + integrator);

END ARCHITECTURE RTL;
