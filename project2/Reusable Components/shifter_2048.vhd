library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux_n;

entity shifter_2048 is
	port (
		Bits	: in std_logic_vector(2047 downto 0);
		Shift	: in std_logic_vector(11 downto 0);
		R		: out std_logic_vector(2047 downto 0)
	);
end shifter_2048;

architecture structural of shifter_2048 is
	signal mux0_out		: std_logic_vector(2047 downto 0);
	signal mux1_out		: std_logic_vector(2047 downto 0);
	signal mux2_out		: std_logic_vector(2047 downto 0);
	signal mux3_out		: std_logic_vector(2047 downto 0);
	signal mux4_out		: std_logic_vector(2047 downto 0);
	signal mux5_out		: std_logic_vector(2047 downto 0);
	signal mux6_out		: std_logic_vector(2047 downto 0);
	signal mux7_out		: std_logic_vector(2047 downto 0);
	signal mux8_out		: std_logic_vector(2047 downto 0);
	signal mux9_out		: std_logic_vector(2047 downto 0);
	signal mux10_out	: std_logic_vector(2047 downto 0);

	signal mux0_in		: std_logic_vector(2047 downto 0);
	signal mux1_in		: std_logic_vector(2047 downto 0);
	signal mux2_in		: std_logic_vector(2047 downto 0);
	signal mux3_in		: std_logic_vector(2047 downto 0);
	signal mux4_in		: std_logic_vector(2047 downto 0);
	signal mux5_in		: std_logic_vector(2047 downto 0);
	signal mux6_in		: std_logic_vector(2047 downto 0);
	signal mux7_in		: std_logic_vector(2047 downto 0);
	signal mux8_in		: std_logic_vector(2047 downto 0);
	signal mux9_in 		: std_logic_vector(2047 downto 0);
	signal mux10_in 	: std_logic_vector(2047 downto 0);
	signal mux11_in 	: std_logic_vector(2047 downto 0);

begin

	mux0_in <= Bits(2046 downto 0) & '0';
	mux1_in <= mux0_out(2045 downto 0) & "00";
	mux2_in <= mux1_out(2043 downto 0) & x"0";
	mux3_in <= mux2_out(2039 downto 0) & x"00";
	mux4_in <= mux3_out(2031 downto 0) & x"0000";
	mux5_in <= mux4_out(2015 downto 0) & x"00000000";
	mux6_in <= mux5_out(1983 downto 0) & x"0000000000000000";
	mux7_in <= mux6_out(1919 downto 0) & x"00000000000000000000000000000000";
	mux8_in <= mux7_out(1791 downto 0) & x"0000000000000000000000000000000000000000000000000000000000000000";
	mux9_in <= mux8_out(1535 downto 0) & (511 downto 0 => '0');
	mux10_in <= mux9_out(1023 downto 0) & (1023 downto 0 => '0');
	mux11_in <=  (2047 downto 0 => '0');


	mux0_map : mux_n generic map (2048) port map (src1 => mux0_in, src0 => Bits, sel => Shift(0), z => mux0_out);
	mux1_map : mux_n generic map (2048) port map (src1 => mux1_in, src0 => mux0_out, sel => Shift(1), z => mux1_out);
	mux2_map : mux_n generic map (2048) port map (src1 => mux2_in, src0 => mux1_out, sel => Shift(2), z => mux2_out);
	mux3_map : mux_n generic map (2048) port map (src1 => mux3_in, src0 => mux2_out, sel => Shift(3), z => mux3_out);
	mux4_map : mux_n generic map (2048) port map (src1 => mux4_in, src0 => mux3_out, sel => Shift(4), z => mux4_out);
	mux5_map : mux_n generic map (2048) port map (src1 => mux5_in, src0 => mux4_out, sel => Shift(5), z => mux5_out);
	mux6_map : mux_n generic map (2048) port map (src1 => mux6_in, src0 => mux5_out, sel => Shift(6), z => mux6_out);
	mux7_map : mux_n generic map (2048) port map (src1 => mux7_in, src0 => mux6_out, sel => Shift(7), z => mux7_out);
	mux8_map : mux_n generic map (2048) port map (src1 => mux8_in, src0 => mux7_out, sel => Shift(8), z => mux8_out);
	mux9_map : mux_n generic map (2048) port map (src1 => mux9_in, src0 => mux8_out, sel => Shift(9), z => mux9_out);
	mux10_map : mux_n generic map (2048) port map (src1 => mux10_in, src0 => mux9_out, sel => Shift(10), z => mux10_out);
	mux11_map : mux_n generic map (2048) port map (src1 => mux11_in, src0 => mux10_out, sel => Shift(11), z => R);

end;
