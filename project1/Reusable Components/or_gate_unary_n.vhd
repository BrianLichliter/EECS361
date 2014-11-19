library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.or_gate;

entity or_gate_unary_n is
	generic (
    		n  : integer
  	);
	port (
		x  : in  std_logic_vector(n-1 downto 0);
		z  : out std_logic
	);
end or_gate_unary_n;

architecture structural of or_gate_unary_n is
	signal temp: std_logic_vector(N-1 downto 0);
begin
	temp(0) <= x(0);
	orLoop: for i in 1 to N-1 generate begin
		or0_map	: or_gate port map (x => temp(i-1), y => x(i), z => temp(i));
    	end generate; 
    	z <= temp(N-1); 
end;

--Effectively creates a line of or gates.
--The first in the line takes two bits from the input vector.
--The rest of the or gates take one bit from the input vector and one bit from the previous or gate.
