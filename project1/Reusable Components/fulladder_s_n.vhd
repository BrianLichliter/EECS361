library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity fulladder_s_n is
	generic (
    		n	: integer
  	);
	port (
		A	: in std_logic_vector (n-1 downto 0);
		B	: in std_logic_vector (n-1 downto 0);
		R	: out std_logic_vector (n-1 downto 0)
	);
end fulladder_s_n;

architecture structural of fulladder_s_n is
	signal cin_cout	: std_logic_vector (n downto 0);

begin
	cin_cout(0) <= '0';
	gen_add: for i in 0 to n-1 generate
		add_map : fulladder_1 port map (x => A(i), y => B(i), cin => cin_cout(i), cout => cin_cout(i+1), z => R(i));
	end generate gen_add;
end;