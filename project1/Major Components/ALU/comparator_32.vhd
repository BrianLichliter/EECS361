library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity comparator_32 is
	port (
		A	: in std_logic_vector(31 downto 0);
		B	: in std_logic_vector(31 downto 0);
		sgn	: in std_logic; --1: signed compare, 0: unsigned compare
		R	: out std_logic_vector(31 downto 0) -- result
	);
end comparator_32;

architecture structural of comparator_32 is
	signal cin_cout : std_logic_vector(32 downto 0);
	signal mux0	: std_logic;
	signal mux1	: std_logic;
	

begin
	cin_cout(0) <= '0';
	orLoop: for i in 0 to 30 generate begin
		comparator_map : comparator_1 port map (x => A(i), y => b(i), cin => cin_cout(i), z => cin_cout(i+1));
    	end generate;
	mux0_map : mux port map (sel => sgn, src0 => A(31), src1 => B(31), z => mux0); 
	mux1_map : mux port map (sel => sgn, src0 => B(31), src1 => A(31), z => mux1); 
	comparator_map : comparator_1 port map (x => mux0, y => mux1, cin => cin_cout(31), z => cin_cout(32));
	R <= "0000000000000000000000000000000"& cin_cout(32);
end;