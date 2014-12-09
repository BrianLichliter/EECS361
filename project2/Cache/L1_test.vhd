library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L1_test is
    port ( 
        Clk             : inout std_logic;
        RequestIn           : inout std_logic;
        ReadWrite            : inout std_logic;
        Address            : inout std_logic_vector(31 downto 0);
        DataIn            : inout std_logic_vector(31 downto 0);
        DataOut           : inout std_logic_vector(31 downto 0);
        DataReady         : inout std_logic;
        DataReadyFromL2   : inout std_logic;
        RequestToL2         : inout std_logic;
        DataToL2          : inout std_logic_vector(511 downto 0);
        AddressToL2        : inout std_logic_vector(31 downto 0);
        ReadWriteToL2        : inout std_logic

    );
end L1_test;

architecture structural of L1_test is
    signal DataFromL2     : std_logic_vector(511 downto 0);

begin 
    L1_map : L1 port map (
        Clk => Clk,
        RequestIn => RequestIn,
        ReadWrite => ReadWrite,
        Address => Address,
        DataIn => DataIn,
        DataOut => DataOut,
        DataReady => DataReady,
        DataFromL2 => DataFromL2,
        DataReadyFromL2 => DataReadyFromL2,
        RequestToL2 => RequestToL2,
        DataToL2 => DataToL2,
        AddressToL2 => AddressToL2,
        ReadWriteToL2 => ReadWriteToL2);

    -- Set data from L2 to junk value for convenience
    DataFromL2 <= (511 downto 0 => '0');

    L1_test : process begin
       
       Clk <= '0';
       RequestIn <= '0';
       ReadWrite <= '0';
       Address <= x"00000000";
       DataIn <= x"00000000";
       DataReadyFromL2 <= '0';
       wait for 50 ns;
       Clk<='1';
       wait for 50 ns;

        -------------------------------------
        -- Write 1 Miss
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';
        RequestIn <= '1';
        ReadWrite <= '1';
        DataReadyFromL2 <= '1';

        Address <= x"3e8e8000";
        DataIn <= x"6c1603e6";
        wait for 50 ns;

        --Set input Addressess and data

        -- Set all input control to 1 (write)
        Clk <= '1';

        wait for 50 ns;

        -------------------------------------
        -- Write 2 Miss
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '1';
        DataReadyFromL2 <= '1';

        Address <= x"3e8e8634";
        DataIn <= x"31bca019";
        wait for 50 ns;

        --Set input Addressess and data

        -- Set all input control to 1 (write)
        Clk <= '1';
        wait for 50 ns;

        -------------------------------------
        -- Write 3 Miss
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '1';
        DataReadyFromL2 <= '1';

        Address <= x"3e8e8b94";
        DataIn <= x"2f31b261";
        wait for 50 ns;

        --Set input Addressess and data

        -- Set all input control to 1 (write)
        Clk <= '1';

        wait for 50 ns;
      -------------------------------------
      -- Write 4 Hit
      -------------------------------------

      -- Set all input control to 0 (benign)
      Clk <= '0';

      ReadWrite <= '1';
      DataReadyFromL2 <= '1';

      Address <= x"3e8e8b94";
      DataIn <= x"33333333";
      wait for 50 ns;

      --Set input Addressess and data

      -- Set all input control to 1 (write)
      Clk <= '1';

      wait for 50 ns;

        -------------------------------------
        -- Read 1 Hit
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '0';
        DataReadyFromL2 <= '0';

        Address <= x"3e8e8000";
        DataIn <= x"00000000";
        
        DataReadyFromL2 <= '0';

		wait for 50 ns;

        --Set input Addressess and data

        -- Set request in and clock to 1 (Read)
        Clk <= '1';

        wait for 50 ns;

        -------------------------------------
        -- Read 2 Hit
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '0';
        DataReadyFromL2 <= '1';

        Address <= x"3e8e8634";
        DataIn <= x"00000000";
    
	    wait for 50 ns;

        --Set input Addressess and data

        -- Set request in and clock to 1 (Read)
        Clk <= '1';


        wait for 50 ns;

        -------------------------------------
        -- Read 3 Hit
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '0';
        DataReadyFromL2 <= '1';

        Address <= x"3e8e8b94";
        DataIn <= x"00000000";

        wait for 50 ns;

        --Set input Addressess and data
        -- Set request in and clock to 1 (Read)
        Clk <= '1';

        wait for 50 ns;

    -------------------------------------
    -- Read 4 Miss
    -------------------------------------

    -- Set all input control to 0 (benign)
    Clk <= '0';

    ReadWrite <= '0';
    DataReadyFromL2 <= '1';

    Address <= x"4abcdef0";
    DataIn <= x"00000000";

    wait for 50 ns;

    --Set input Addressess and data
    -- Set request in and clock to 1 (Read)
    Clk <= '1';

    wait for 50 ns;
         -------------------------------------
         -- Read 5 Evict
         -------------------------------------
 
         -- Set all input control to 0 (benign)
         Clk <= '0';
 
         ReadWrite <= '0';
         DataReadyFromL2 <= '1';
 
         Address <= x"4e8e8b94";
         --DataFromL2 <= x"00000200";
 
         wait for 50 ns;
 
         --Set input Addressess and data
         -- Set request in and clock to 1 (Read)
         Clk <= '1';
 
         wait for 50 ns;
         Clk<='0';
         wait for 50 ns;
         clk<='1';
         wait for 50 ns;
         
         -------------------------------------
         -- Write 5 Evict
         -------------------------------------
 
         -- Set all input control to 0 (benign)
         Clk <= '0';
 
         ReadWrite <= '1';
         DataReadyFromL2 <= '0';
 
         Address <= x"4e8e8000";
         --DataFromL2 <= x"00000300";
         DataIn <= x"00000400";
 
         wait for 50 ns;
         DataReadyFromL2 <= '1';
         --Set input Addressess and data
         -- Set request in and clock to 1 (Read)
         Clk <= '1';
 
         wait for 50 ns;
         Clk<='0';
         wait for 50 ns;
         clk<='1';
         wait for 50 ns;         
 

        -------------------------------------
        -- End
        -------------------------------------

        -- Set all input control to 0 (benign)
        Clk <= '0';

        ReadWrite <= '0';
        DataReadyFromL2 <= '0';

        wait;

    end process;

end architecture structural;        
