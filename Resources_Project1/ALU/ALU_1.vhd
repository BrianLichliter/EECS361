library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity ALU_1 is
	port (
		A	: in std_logic;
		B	: in std_logic;
		sel	: in std_logic_vector(1 downto 0);
		cin	: in std_logic;
		cout	: out std_logic;
		R	: out std_logic
	);
end ALU_1;

architecture structural of ALU_1 is
	signal and0	: std_logic;
	signal or0	: std_logic;
	signal xor0	: std_logic;
	signal add0	: std_logic;
	signal cout0	: std_logic;

begin
	and0_map : and_gate port map (x => A, y => B, z => and0);
	or0_map	: or_gate port map (x => A, y => B, z => or0);
	xor0_map : xor_gate port map (x => sel(0), y => B, z => xor0);
	add0_map : fulladder_1 port map (x => A, y => xor0, cin => cin, cout => cout0, z => add0);
	and1_map : and_gate port map (x => cout0, y => sel(1), z => cout);
	mux_map : mux_1_4 port map (src0 => and0, src1 => or0, src2 => add0, src3 => add0, sel => sel, z => R);
end;
-- sel(0,0): and
-- sel(0,1): or
-- sel(1,0): add
-- sel(1,1): subtract

--Note: inversion of B for subtraction controlled by sel[0]