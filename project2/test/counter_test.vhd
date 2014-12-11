library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity counter_test is
    port ( 
        inc     : inout std_logic;
        clk     : inout std_logic;
        reset   : inout std_logic;
        cnt     : inout std_logic_vector(31 downto 0)

    );
end counter_test;

architecture structural of counter_test is

begin 
    counter_map : counter port map (
                    WriteEnable => inc,
                    clk => clk,
                    reset => reset,
                    Count => cnt,
                    HighestValue =>(31 downto 0 => '1'));

    counter_test : process begin

        -------------------------------------
        -- Reset
        -------------------------------------

        clk <= '1';
        reset <= '1';

        wait for 50 ns;

        clk <= '0';
        reset <= '0';

        wait for 50 ns;  


        -------------------------------------
        -- Count normal
        -------------------------------------

        test_loop_norm : for i in 0 to 5 loop

            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

        end loop test_loop_norm;

        -------------------------------------
        -- Cycle but don't count
        -------------------------------------

        test_loop_dc : for i in 0 to 5 loop

            clk <= '1';
            inc <= '0';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

        end loop test_loop_dc;

        -------------------------------------
        -- Count with sticky inc
        -------------------------------------

        test_loop_stk : for i in 0 to 5 loop

            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '1';
            wait for 50 ns;

        end loop test_loop_stk;

        -------------------------------------
        -- Count Varried
        -------------------------------------
            
            --dc
            clk <= '1';
            inc <= '0';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

            --normal
            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

            --sticky
            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '1';
            wait for 50 ns;

            --dc
            clk <= '1';
            inc <= '0';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

            --dc
            clk <= '1';
            inc <= '0';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;

            --sticky
            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '1';
            wait for 50 ns;

            --normal
            clk <= '1';
            inc <= '1';
            wait for 50 ns;

            clk <= '0';
            inc <= '0';
            wait for 50 ns;


        wait;

    end process;

end architecture structural;        
