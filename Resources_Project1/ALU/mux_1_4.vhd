library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux;

entity mux_1_4 is
	port (
		sel	: in  std_logic_vector(1 downto 0);
		src0	: in  std_logic;
		src1	: in  std_logic;
		src2	: in  std_logic;
		src3	: in  std_logic;
		z	: out std_logic
	);
end mux_1_4;

architecture structural of mux_1_4 is
	signal mux0 : std_logic;
	signal mux1 : std_logic;

	begin
		mux0_map : mux port map (src0 => src0, src1 => src1, sel => sel(0), z => mux0);
		mux1_map : mux port map (src0 => src2, src1 => src3, sel => sel(0), z => mux1);
		mux2_map : mux port map (src0 => mux0, src1 => mux1, sel => sel(1), z => z);
	end
architecture structural;

-- Sel(0,0): src0
-- Sel(0,1): src1
-- Sel(1,0): src2
-- Sel(1,1): src3

