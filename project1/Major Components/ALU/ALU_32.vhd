library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity ALU_32 is
	port (
		sel	: in std_logic_vector(1 downto 0);
		A	: in std_logic_vector(31 downto 0);
		B	: in std_logic_vector(31 downto 0);
		cin	: in std_logic;
		cout	: out std_logic;  -- ?1? -> carry out
		ovf	: out std_logic;  -- ?1? -> overflow
		R	: out std_logic_vector(31 downto 0) -- result
	);
end ALU_32;

architecture structural of ALU_32 is
	signal cin_cout : std_logic_vector(32 downto 0);
	

begin
	cin_cout(0) <= cin;
	orLoop: for i in 0 to 30 generate begin
		ALU_map : ALU_1 port map (sel => sel, A => A(i), B => B(i), cin => cin_cout(i), cout => cin_cout(i+1), R => R(i));
    	end generate; 
	ALU32_map : ALU_1 port map (sel => sel, A => A(31), B => B(31), cin => cin_cout(31), cout => cin_cout(32), R => R(31));
	xor0_map : xor_gate port map (x => cin_cout(32), y => cin_cout(31), z => ovf);
	cout <= cin_cout(32);

end;