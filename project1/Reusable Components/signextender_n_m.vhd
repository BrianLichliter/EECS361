library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity signextender_n_m is
	generic (
    		n 	: integer;
		m 	: integer
  	);
	port (
		A	: in std_logic_vector (n-1 downto 0);
		R	: out std_logic_vector (m-1 downto 0)
	);
end signextender_n_m;

architecture structural of signextender_n_m is

begin
	R(n-1 downto 0) <= A;
	gen_ext: for i in n to m-1 generate
		R(i) <= A(n-1);
	end generate gen_ext;
end;