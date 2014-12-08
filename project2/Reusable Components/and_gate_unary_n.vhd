library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.and_gate;

entity and_gate_unary_n is
	generic (
    	n  : integer
  	);
	port (
		x  : in  std_logic_vector(n-1 downto 0);
		z  : out std_logic
	);
end and_gate_unary_n;

architecture structural of and_gate_unary_n is
	signal temp: std_logic_vector(n-1 downto 0);
begin
	temp(0) <= x(0);
	orLoop: for i in 1 to n-1 generate begin
		and_map	: and_gate port map (x => temp(i-1), y => x(i), z => temp(i));
    	end generate; 
    	z <= temp(n-1); 
end;