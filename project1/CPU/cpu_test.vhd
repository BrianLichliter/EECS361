library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity cpu_test is
    port ( 
        instOut : inout std_logic_vector(31 downto 0)
    );
end cpu_test;

architecture structural of cpu_test is     
    signal clk    : std_logic;
    signal reset  : std_logic;
    
 begin 
    cpu_map : cpu generic map (mem => "./Test Code/bills_branch.dat") port map (clock=>clk, reset=>reset, inst=>instOut);
               
    test_cpu : process
    begin
    	-- Start process w/ reset cycle
    	clk <= '0';
    	reset <= '1';
    	wait for 10 ns;
    	clk <= '1';
    	wait for 10 ns;
    	clk <= '0';
    	wait for 10 ns;
    	reset <= '0';
    	
        test_loop : for i in 0 to 300 loop
            exit test_loop when instOut = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop test_loop;
        wait;
    end process;

end architecture structural;        