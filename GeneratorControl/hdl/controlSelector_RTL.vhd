ARCHITECTURE RTL OF controlSelector IS

BEGIN
  ------------------------------------------------------------------------------
                                                                 -- select input
  selectInput: process(
    selectManual, periodDifference,
    phaseRegVal, frequencyRegVal, manualVal
  )
  begin
    if selectManual = '1' then
      amplitude <= manualVal;
    else
      amplitude <= frequencyRegVal;
    end if;
  end process selectInput;

END ARCHITECTURE RTL;
