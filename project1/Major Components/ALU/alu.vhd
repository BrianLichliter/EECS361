library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity alu is
	port (
		ctrl   : in std_logic_vector(3 downto 0);
		A      : in std_logic_vector(31 downto 0);
		B      : in std_logic_vector(31 downto 0);
		cout   : out std_logic;  -- ?1? -> carry out
		ovf    : out std_logic;  -- ?1? -> overflow
		ze     : out std_logic;  -- ?1? -> is zero
		R      : out std_logic_vector(31 downto 0) -- result
	);
end alu;

architecture structural of alu is
	signal ALU_out		: std_logic_vector(31 downto 0);
	signal comparator_out	: std_logic_vector(31 downto 0);
	signal shifter_out	: std_logic_vector(31 downto 0);
	signal mux_out		: std_logic_vector(31 downto 0);
	signal dont_care	: std_logic_vector(31 downto 0);
	signal or0		: std_logic;

begin
	dont_care <= "--------------------------------";

	ALU_32_map : ALU_32 port map (A => A, B => B, sel => ctrl(1 downto 0), cin => ctrl(0), cout => cout, ovf => ovf, R => ALU_out);
	comparator_32_map : comparator_32 port map (A => A, B => B, sgn => ctrl(0), R => comparator_out);
	shifter_32_map : shifter_32 port map (A => A, B => B, R => shifter_out);
	mux_map : mux_n_4 generic map (n => 32) port map (src0 => ALU_out, src1 => comparator_out, src2 => shifter_out, src3 => dont_care, sel => ctrl(3 downto 2), z => mux_out);
	or0_map  : or_gate_unary_n generic map (n => 32) port map (x => mux_out, z => or0);
	not0_map : not_gate port map (x => or0, z => ze);
	R <= mux_out;
end;

-- ctrl (0000): and
-- ctrl (0001): or
-- ctrl (0010): add
-- ctrl (0011): sub
-- ctrl (0100): sltu
-- ctrl (0101): slt
-- ctrl (1000): sll