library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_32bit is
    port (
        clk : in std_logic;
		reset_active_low : in std_logic;
        write_en: in std_logic;
        D   : in std_logic_vector(31 downto 0);
        Z   : out std_logic_vector(31 downto 0)
    );
end register_32bit;

architecture structural of register_32bit is
    signal anded_clock : std_logic;
	signal data_in : std_logic_vector(31 downto 0);
	signal data_i : std_logic_vector(31 downto 0);
	signal not_reset : std_logic;
	signal actual_write_en : std_logic;
	signal tempZ : std_logic_vector(31 downto 0);
begin

    reset_wr : not_gate port map(reset_active_low,not_reset);
    get_actl_we : or_gate port map(write_en,not_reset,actual_write_en);
    gen_ffs:
    for I in 0 to 31 generate
    		 rst: and_gate port map (x=>D(I),y=>reset_active_low,z=>data_in(I));
    		 mux_we: mux port map(sel=>actual_write_en, src0=>tempZ(I),src1=>data_in(I),z=>data_i(I));
       dffx: dff port map (clk=>clk,d=>data_i(I),q=>tempZ(I));
   end generate gen_ffs;
   Z<=tempZ;
end architecture structural;
