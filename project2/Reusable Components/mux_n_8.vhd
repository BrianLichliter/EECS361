library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity mux_n_8 is
	generic (
		n	: integer
	);
	port (
		sel	: in  std_logic_vector(2 downto 0);
		src0	: in  std_logic_vector(n-1 downto 0);
		src1	: in  std_logic_vector(n-1 downto 0);
		src2	: in  std_logic_vector(n-1 downto 0);
		src3	: in  std_logic_vector(n-1 downto 0);
		src4	: in  std_logic_vector(n-1 downto 0);
		src5	: in  std_logic_vector(n-1 downto 0);
		src6	: in  std_logic_vector(n-1 downto 0);
		src7	: in  std_logic_vector(n-1 downto 0);
		z	: out std_logic_vector(n-1 downto 0)
	);
end mux_n_8;

architecture structural of mux_n_8 is
	signal mux0 : std_logic_vector(n-1 downto 0);
	signal mux1 : std_logic_vector(n-1 downto 0);

begin
	mux0_map : mux_n_4 generic map (n => n) port map (src0 => src0, src1 => src1,src2=>src2,src3=>src3, sel => sel(1 downto 0), z => mux0);
	mux1_map : mux_n_4 generic map (n => n) port map (src0 => src4, src1 => src5,src2=>src6,src3=>src7, sel => sel(1 downto 0), z => mux1);
	mux2_map : mux_n generic map (n => n) port map (src0 => mux0, src1 => mux1, sel => sel(2), z => z);
end;
