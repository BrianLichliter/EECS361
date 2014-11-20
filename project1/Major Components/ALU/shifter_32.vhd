library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux_32;
use work.eecs361_gates.or_gate_unary_n;

entity shifter_32 is
	port (
		A	: in std_logic_vector(31 downto 0);
		B	: in std_logic_vector(31 downto 0);
		R	: out std_logic_vector(31 downto 0)
	);
end shifter_32;

architecture structural of shifter_32 is
	signal mux0_out	: std_logic_vector(31 downto 0);
	signal mux1_out	: std_logic_vector(31 downto 0);
	signal mux2_out	: std_logic_vector(31 downto 0);
	signal mux3_out	: std_logic_vector(31 downto 0);
	signal mux4_out	: std_logic_vector(31 downto 0);
	signal or0	: std_logic;

	signal mux0_in	: std_logic_vector(31 downto 0);
	signal mux1_in	: std_logic_vector(31 downto 0);
	signal mux2_in	: std_logic_vector(31 downto 0);
	signal mux3_in	: std_logic_vector(31 downto 0);
	signal mux4_in	: std_logic_vector(31 downto 0);

begin

	mux0_in <= A(30 downto 0) & '0';
	mux1_in <= mux0_out(29 downto 0) & "00";
	mux2_in <= mux1_out(27 downto 0) & "0000";
	mux3_in <= mux2_out(23 downto 0) & "00000000";
	mux4_in <= mux3_out(15 downto 0) & "0000000000000000";

	mux0_map : mux_32 port map (src1 => mux0_in, src0 => A, sel => B(0), z => mux0_out);
	mux1_map : mux_32 port map (src1 => mux1_in, src0 => mux0_out, sel => B(1), z => mux1_out);
	mux2_map : mux_32 port map (src1 => mux2_in, src0 => mux1_out, sel => B(2), z => mux2_out);
	mux3_map : mux_32 port map (src1 => mux3_in, src0 => mux2_out, sel => B(3), z => mux3_out);
	mux4_map : mux_32 port map (src1 => mux4_in, src0 => mux3_out, sel => B(4), z => mux4_out);
	or0_map  : or_gate_unary_n generic map (n => 27) port map (x => B(31 downto 5), z => or0);
	mux5_map : mux_32 port map (src1 => "00000000000000000000000000000000", src0 => mux4_out, sel => or0, z => R);

end;
