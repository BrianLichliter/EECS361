library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L1_test is
    port ( 
        clk             : inout std_logic;
        reqIn           : inout std_logic;
        rdWr            : inout std_logic;
        addr            : inout std_logic_vector(31 downto 0);
        dtIn            : inout std_logic_vector(31 downto 0);
        dtOut           : inout std_logic_vector(31 downto 0);
        dtReady         : inout std_logic;
        dtReadyFromL2   : inout std_logic;
        reqToL2         : inout std_logic;
        dtToL2          : inout std_logic_vector(511 downto 0);
        addrToL2        : inout std_logic_vector(31 downto 0);
        rdWrToL2        : inout std_logic

    );
end L1_test;

architecture structural of L1_test is
    signal dtFromL2     : std_logic_vector(511 downto 0);

begin 
    L1_map : L1 port map (
        Clk => clk,
        RequestIn => reqIn,
        ReadWrite => rdWr,
        Address => addr,
        DataIn => dtIn,
        DataOut => dtOut,
        DataReady => dtReady,
        DataFromL2 => dtFromL2,
        DataReadyFromL2 => dtReadyFromL2,
        RequestToL2 => reqToL2,
        DataToL2 => dtToL2,
        AddressToL2 => addrToL2,
        ReadWriteToL2 => rdWrToL2);

    -- Set data from L2 to junk value for convenience
    dtFromL2 <= (511 downto 0 => '0');

    L1_test : process begin

        -------------------------------------
        -- Write 1
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8000";
        dtIn <= x"6c1603e6";

        -- Set all input control to 1 (write)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '1';
        dtReadyFromL2 <= '1';

        wait for 50 ns;

        -------------------------------------
        -- Write 2
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8634";
        dtIn <= x"31bca019";

        -- Set all input control to 1 (write)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '1';
        dtReadyFromL2 <= '1';

        wait for 50 ns;

        -------------------------------------
        -- Write 3
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8b94";
        dtIn <= x"2f31b261";

        -- Set all input control to 1 (write)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '1';
        dtReadyFromL2 <= '1';

        wait for 50 ns;

        -------------------------------------
        -- Read 1
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8000";
        dtIn <= x"00000000";

        -- Set request in and clock to 1 (Read)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Read 2
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8634";
        dtIn <= x"00000000";

        -- Set request in and clock to 1 (Read)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Read 3
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        --Set input address and data
        addr <= x"3e8e8b94";
        dtIn <= x"00000000";

        -- Set request in and clock to 1 (Read)
        clk <= '1';
        reqIn <= '1';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait for 50 ns;

        -------------------------------------
        -- End
        -------------------------------------

        -- Set all input control to 0 (benign)
        clk <= '0';
        reqIn <= '0';
        rdWr <= '0';
        dtReadyFromL2 <= '0';

        wait;

    end process;

end architecture structural;        