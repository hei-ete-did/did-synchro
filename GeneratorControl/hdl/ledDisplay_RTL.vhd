ARCHITECTURE RTL OF ledDisplay IS

  constant ledMiddle : positive := ledNb/2 + 1;
  constant bitThreshold1 : positive := 4;
  constant bitThreshold2 : positive := 8;

  signal levels: std_ulogic_vector(leds'range);

BEGIN
  ------------------------------------------------------------------------------
                                                                   -- middle LED
  levels(ledMiddle) <= '1' when phaseDifference = 0
    else '0';
  leds(ledMiddle) <= levels(ledMiddle);

  ------------------------------------------------------------------------------
                                                           -- LEDs around middle
  levels(ledMiddle-1) <= '1'
    when phaseDifference(phaseDifference'high downto bitThreshold1)+1 = 0
    else '0';
  levels(ledMiddle+1) <= '1'
    when phaseDifference(phaseDifference'high downto bitThreshold1) = 0
    else '0';
  leds(ledMiddle-1) <= levels(ledMiddle-1) or levels(ledMiddle);
  leds(ledMiddle+1) <= levels(ledMiddle+1) or levels(ledMiddle);

  ------------------------------------------------------------------------------
                                                                    -- next LEDs
  levels(ledMiddle-2) <= '1'
    when phaseDifference(phaseDifference'high downto bitThreshold2)+1 = 0
    else '0';
  levels(ledMiddle+2) <= '1'
    when phaseDifference(phaseDifference'high downto bitThreshold2) = 0
    else '0';
  leds(ledMiddle-2) <= levels(ledMiddle-2) or levels(ledMiddle-1) or levels(ledMiddle);
  leds(ledMiddle+2) <= levels(ledMiddle+2) or levels(ledMiddle+1) or levels(ledMiddle);

  ------------------------------------------------------------------------------
                                                                   -- outer LEDs
  levels(ledMiddle-3) <= '1' when
    (phaseDifference(phaseDifference'high) = '1') and
    (phaseDifference(phaseDifference'high downto bitThreshold2)+1 /= 0)
    else '0';
  levels(ledMiddle+3) <= '1' when
    (phaseDifference(phaseDifference'high) = '0') and
    (phaseDifference(phaseDifference'high downto bitThreshold2) /= 0)
    else '0';
  leds(ledMiddle-3) <= levels(ledMiddle-3);
  leds(ledMiddle+3) <= levels(ledMiddle+3);

END ARCHITECTURE RTL;
