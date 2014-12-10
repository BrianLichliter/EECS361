library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity LRU_test is
    port ( 
        set_idx : inout std_logic_vector(1 downto 0);
        we      : inout std_logic;
        clk     : inout std_logic;
        reset   : inout std_logic;
        lru_idx : inout std_logic_vector(1 downto 0)

    );
end LRU_test;

architecture structural of LRU_test is

begin 
    LRU_map : LRU port map (
        set_idx => set_idx,
        we => we,
        clk => clk,
        reset => reset,
        lru_idx => lru_idx);

    LRU_test : process begin

        -------------------------------------
        -- Reset
        -------------------------------------

        clk <= '1';
        reset <= '1';
        we <= '1';
        set_idx <= "00";

        wait for 50 ns;

        clk <= '0';
        reset <= '0';

        wait for 50 ns;  


        -------------------------------------
        -- Accessed 0th
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "00";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 1st
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "01";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 2nd
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "10";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 3rd
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "11";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 2nd
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "10";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 0th
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "00";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 2nd
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "10";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 1st
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "01";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 3rd
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "10";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 0th
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "00";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;

        -------------------------------------
        -- Accessed 0th
        -------------------------------------

        clk <= '1';
        we <= '1';
        set_idx <= "00";

        wait for 50 ns;

        clk <= '0';

        wait for 50 ns;


        wait;

    end process;

end architecture structural;        
