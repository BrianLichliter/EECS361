library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity decoder_5_32 is
	port (
		x : in std_logic_vector (4 downto 0);
		z : out std_logic_vector (31 downto 0)
	);
end decoder_5_32;

architecture structural of decoder_5_32 is
	signal notx : std_logic_vector(4 downto 0);
	type concat_array_type is array (31 downto 0) of std_logic_vector(4 downto 0);
	signal concat_array : concat_array_type;
begin
	--Invert X
	invertx: not_gate_n generic map(n=>5) port map(x=>x,z=>notx);
   
   
	--All of the and gates
    concat_array(31) <= 	(x(4)&x(3)&x(2)&x(1)&x(0));
	concat_array(30) <=		(x(4)&x(3)&x(2)&x(1)&notx(0));
	concat_array(29) <= 	(x(4)&x(3)&x(2)&notx(1)&x(0));
	concat_array(28) <= 	(x(4)&x(3)&x(2)&notx(1)&notx(0));
	concat_array(27) <= 	(x(4)&x(3)&notx(2)&x(1)&x(0));
	concat_array(26) <= 	(x(4)&x(3)&notx(2)&x(1)&notx(0));
	concat_array(25) <= 	(x(4)&x(3)&notx(2)&notx(1)&x(0));
	concat_array(24) <= 	(x(4)&x(3)&notx(2)&notx(1)&notx(0));
	concat_array(23) <= 	(x(4)&notx(3)&x(2)&x(1)&x(0));
	concat_array(22) <= 	(x(4)&notx(3)&x(2)&x(1)&notx(0));
	concat_array(21) <= 	(x(4)&notx(3)&x(2)&notx(1)&x(0));
	concat_array(20) <= 	(x(4)&notx(3)&x(2)&notx(1)&notx(0));
	concat_array(19) <= 	(x(4)&notx(3)&notx(2)&x(1)&x(0));
	concat_array(18) <= 	(x(4)&notx(3)&notx(2)&x(1)&notx(0));
	concat_array(17) <= 	(x(4)&notx(3)&notx(2)&notx(1)&x(0));
	concat_array(16) <= 	(x(4)&notx(3)&notx(2)&notx(1)&notx(0));
	concat_array(15) <= 	(notx(4)&x(3)&x(2)&x(1)&x(0));
	concat_array(14) <= 	(notx(4)&x(3)&x(2)&x(1)&notx(0));
	concat_array(13) <= 	(notx(4)&x(3)&x(2)&notx(1)&x(0));
	concat_array(12) <= 	(notx(4)&x(3)&x(2)&notx(1)&notx(0));
	concat_array(11) <= 	(notx(4)&x(3)&notx(2)&x(1)&x(0));
	concat_array(10) <= 	(notx(4)&x(3)&notx(2)&x(1)&notx(0));
	concat_array(9) <= 	(notx(4)&x(3)&notx(2)&notx(1)&x(0));
	concat_array(8) <= 	(notx(4)&x(3)&notx(2)&notx(1)&notx(0));
	concat_array(7) <= 	(notx(4)&notx(3)&x(2)&x(1)&x(0));
	concat_array(6) <= 	(notx(4)&notx(3)&x(2)&x(1)&notx(0));
	concat_array(5) <= 	(notx(4)&notx(3)&x(2)&notx(1)&x(0));
	concat_array(4) <= 	(notx(4)&notx(3)&x(2)&notx(1)&notx(0));
	concat_array(3) <= 	(notx(4)&notx(3)&notx(2)&x(1)&x(0));
	concat_array(2) <= 	(notx(4)&notx(3)&notx(2)&x(1)&notx(0));
	concat_array(1) <= 	(notx(4)&notx(3)&notx(2)&notx(1)&x(0));
	concat_array(0) <= 	(notx(4)&notx(3)&notx(2)&notx(1)&notx(0));

	gen_ands:
	for I in 0 to 31 generate
		and5: and_gate_unary_n generic map (n=>5) port map(x=>concat_array(I),z=>z(I));
	end generate gen_ands;
end structural;
