library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity comparator_1 is
	port (
		x	: in std_logic;
		y	: in std_logic;
		cin	: in std_logic;
		z	: out std_logic
	);
end comparator_1;

architecture structural of comparator_1 is
	signal xor0 : std_logic;

begin
	xor0_map : xor_gate port map (x => x, y => y, z => xor0);
	mux_map : mux port map (src0 => cin, src1 => y, sel => xor0, z => z);
end;