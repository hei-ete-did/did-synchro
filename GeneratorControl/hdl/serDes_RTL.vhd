LIBRARY Common;
  USE Common.CommonLib.all;
LIBRARY RS232;

ARCHITECTURE RTL OF serDes IS

  constant defaultOut: unsigned(parallelOut'range)
    := shift_left(resize("01", parallelOut'length), parallelOut'length-1);
                                                                  -- serial port
  constant baudRateDivide : positive := 66E6/115200 / 10;
  constant uartBitNb : positive := 8;
  constant uartFifoDepth : positive := 1;
  signal txData_unsigned : unsigned(uartBitNb-1 downto 0);
  constant nibbleBitNb : positive := 4;
  constant sendNibbleCount : positive := ((parallelIn'length-1)/nibbleBitNb)+1;
  constant sendCounterBitNb : positive := requiredBitNb(sendNibbleCount+2);
  signal sendCounter : unsigned(sendCounterBitNb-1 downto 0);
  signal txWr_int, rxRd_int : std_ulogic;
  signal sendShiftRegister : unsigned(sendNibbleCount*nibbleBitNb-1 downto 0);
  signal sendNibble : unsigned(nibbleBitNb-1 downto 0);
  constant receiveNibbleCount : positive := ((parallelOut'length-1)/nibbleBitNb)+1;
  signal receiveShiftRegister : unsigned(receiveNibbleCount*nibbleBitNb-1 downto 0);
  signal lastReceivedWasControl : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                    -- counter for sending value
  countSentNibbleSequence: process(reset, clock)
  begin
    if reset = '1' then
      sendCounter <= (others => '0');
    elsif rising_edge(clock) then
      if sendCounter = 0 then
        if send = '1' then
          sendCounter <= sendCounter + 1;
        end if;
      elsif txFull = '0' then
        sendCounter <= sendCounter + 1;
      end if;
    end if;
  end process countSentNibbleSequence;

  txWr_int <= '1' when (sendCounter > 0) and (sendCounter <= sendNibbleCount+2) and (txFull = '0')
    else '0';
  txWr <= txWr_int;
                                                          -- send shift register
  shiftSentNibbles: process(reset, clock)
  begin
    if reset = '1' then
      sendShiftRegister <= (others => '0');
    elsif rising_edge(clock) then
      if (send = '1') and (sendCounter = 0) then
        sendShiftRegister <= unsigned(resize(parallelIn, sendShiftRegister'length));
      elsif txWr_int = '1' then
        sendShiftRegister <= shift_left(sendShiftRegister, nibbleBitNb);
      end if;
    end if;
  end process shiftSentNibbles;

  sendNibble <= resize(
    shift_right(sendShiftRegister, sendShiftRegister'length-nibbleBitNb),
    sendNibble'length
  );

  selectSentData: process(sendCounter, sendNibble)
  begin
    if sendCounter <= sendNibbleCount then
      if sendNibble < 10 then
        txData_unsigned <= X"3" & sendNibble;
      else
        txData_unsigned <= X"4" & (sendNibble-10+1);
      end if;
    elsif sendCounter = sendNibbleCount+1 then
      txData_unsigned <= to_unsigned(character'pos(cr), txData_unsigned'length);
    elsif sendCounter = sendNibbleCount+2 then
      txData_unsigned <= to_unsigned(character'pos(lf), txData_unsigned'length);
    else
      txData_unsigned <= (others => '-');
    end if;
  end process selectSentData;

  txData <= std_ulogic_vector(txData_unsigned);

  ------------------------------------------------------------------------------
  rxRd_int <= not rxEmpty;
  rxRd <= rxRd_int;
                                                       -- receive shift register
  shiftReceivedNibbles: process(reset, clock)
    variable highNibble, lowNibble : unsigned(nibbleBitNb-1 downto 0);
  begin
    if reset = '1' then
      receiveShiftRegister <= (others => '0');
      lastReceivedWasControl <= '0';
      parallelOut <= defaultOut;
    elsif rising_edge(clock) then
      if rxRd_int = '1' then
        highNibble := resize(
          shift_right(unsigned(rxData), nibbleBitNb),
          highNibble'length
        );
        lowNibble := resize( unsigned(rxData), highNibble'length);
        if highNibble = 3 then
          receiveShiftRegister <= shift_left(receiveShiftRegister, lowNibble'length);
          receiveShiftRegister(lowNibble'range) <= lowNibble;
          lastReceivedWasControl <= '0';
        elsif (highNibble = 4) or (highNibble = 6) then
          receiveShiftRegister <= shift_left(receiveShiftRegister, lowNibble'length);
          receiveShiftRegister(lowNibble'range) <= lowNibble + 9;
          lastReceivedWasControl <= '0';
        elsif highNibble = 0 then
          if lastReceivedWasControl = '0' then
            parallelOut <= resize(
              receiveShiftRegister, parallelOut'length
            );
          end if;
          lastReceivedWasControl <= '1';
          receiveShiftRegister <= (others => '0');
        end if;
      end if;
    end if;
  end process shiftReceivedNibbles;

END ARCHITECTURE RTL;
