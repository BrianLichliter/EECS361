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
begin
    and_clk : and_gate port map(x=>clk,y=>write_en,z=>anded_clock);
    gen_ffs:
    for I in 0 to 31 generate
		rst: and_gate port map (x=>D(I),y=>reset_active_low,z=>data_in(I));
       dffx: dff port map (clk=>anded_clock,d=>data_in(I),q=>Z(I));
   end generate gen_ffs;
end architecture structural;
