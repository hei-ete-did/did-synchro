ARCHITECTURE RTL OF frequencyRegulatorPI IS

  constant signedBitNb: positive := controlAmplitude'length + 1;
  constant outputOffset: signed(signedBitNb-1 downto 0)
    := shift_left(resize("01", signedBitNb), controlAmplitude'length-1);

  signal proportionalTerm            : signed(signedBitNb-1 downto 0);
  signal integralDelta, integralTerm : signed(signedBitNb-1 downto 0);
  signal sum                         : signed(signedBitNb-1 downto 0);

BEGIN
  ------------------------------------------------------------------------------
                                                            -- proportional term
  proportionalShiftLeft: if proportionalShift >= 0 generate
    proportionalTerm <= resize(
      shift_left(periodDiff, proportionalShift),
      proportionalTerm'length
    );
  end generate proportionalShiftLeft;

  proportionalShiftRight: if proportionalShift < 0 generate
    proportionalTerm <= resize(
      shift_right(periodDiff, -proportionalShift),
      proportionalTerm'length
    );
  end generate proportionalShiftRight;

  ------------------------------------------------------------------------------
                                                                -- integral term
  integralShiftLeft: if integralShift >= 0 generate
    integralDelta <= resize(
      shift_left(periodDiff, integralShift),
      integralDelta'length
    );
  end generate integralShiftLeft;

  integralShiftRight: if integralShift < 0 generate
    integralDelta <= resize(
      shift_right(periodDiff, -integralShift),
      integralDelta'length
    );
  end generate integralShiftRight;

  accumulate: process(reset, clock)
  begin
    if reset = '1' then
      integralTerm <= outputOffset;
    elsif rising_edge(clock) then
      if en = '1' then
        integralTerm <= integralTerm + integralDelta;
      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
                                                             -- regulator output
  addTerms: process(proportionalTerm, integralTerm)
    variable sum_v: signed(sum'range);
  begin
    sum_v := proportionalTerm + integralTerm;
    if sum_v < 0 then
      sum <= (others => '0');
    else
      sum <= sum_v;
    end if;
  end process addTerms;

  controlAmplitude <= resize(unsigned(sum), controlAmplitude'length);

END ARCHITECTURE RTL;
