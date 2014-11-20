library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity fulladder_1 is
	port (
		x	: in std_logic;
		y	: in std_logic;
		cin	: in std_logic;
		z	: out std_logic;
		cout	: out std_logic
	);
end fulladder_1;

architecture structural of fulladder_1 is
	signal xor0 : std_logic;
	signal and0 : std_logic;
	signal and1 : std_logic;

	begin
		xor0_map : xor_gate port map (x => x, y => y, z => xor0);
		xor1_map : xor_gate port map (x => xor0, y => cin, z => z);
		and0_map : and_gate port map (x => x, y => y, z => and0);
		and1_map : and_gate port map (x => xor0, y => cin, z => and1);
		or0_map : or_gate port map (x => and0, y => and1, z => cout);
	end
architecture structural;