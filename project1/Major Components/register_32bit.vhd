library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_32bit is
    port (
        clock : in std_logic;
        write_en: in std_logic;
        D   : in std_logic_vector(31 downto 0);
        Z   : out std_logic_vector(31 downto 0)
    );
end register_32bit;

architecture structural of register_32bit is
    signal anded_clock : std_logic;
begin
    and_clk : and_gate port map(x=>clock,y=>write_en,z=>anded_clock);
    gen_ffs:
    for I in 0 to 31 generate
       dffx: dff port map (clk=>anded_clock,d=>D(I),q=>Z(I));
   end generate gen_ffs;
end architecture structural;
