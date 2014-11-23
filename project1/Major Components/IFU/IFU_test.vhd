library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity IFU_test is
    port ( 
        instOut : inout std_logic_vector(31 downto 0)
    );
end IFU_test;

architecture structural of IFU_test is     
    signal clk    : std_logic;
    signal reset  : std_logic;
    
 begin 
     IFU_map : IFU generic map (mem => "./Test Code/bills_branch.dat") port map (clock=>clk, reset=>reset, branch=>'0', zero=>'0', inst=>instOut);
                   
     test_IFU : process
     begin
	-- Start process w/ reset cycle
	clk <= '0';
	reset <= '1';
	wait for 10 ns;
	clk <= '1';
	wait for 10 ns;
	reset <= '0';
	
        test_loop : for i in 0 to 71 loop
             clk <= '0';
             wait for 10 ns;
             clk <= '1';
             wait for 10 ns;
        end loop test_loop;
        wait;
     end process;

end architecture structural;        