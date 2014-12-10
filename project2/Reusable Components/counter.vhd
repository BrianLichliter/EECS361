library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity counter is
	port (
		inc		: in std_logic;
		clk		: in std_logic;
		reset	: in std_logic;
		cnt		: out std_logic_vector(31 downto 0)
	);
end counter;

architecture structural of counter is
	signal resetLow		: std_logic;
	signal registerIn	: std_logic_vector(31 downto 0);
	signal registerOut	: std_logic_vector(31 downto 0);

begin

	--Not the reset so the counter is reset on high
	not1 : not_gate port map(reset, resetLow);

	-- Register countaining count
	reg : register_32bit port map(clk => clk, reset_active_low => resetLow, write_en => inc, D => registerIn, Z => registerOut);

	--Add 1 to the register output
	add : fulladder_32 port map(cin => '1', x => registerOut, y => (31 downto 0 => '0'), cout => open, z => registerIn);

	--output current count
	cnt <= registerOut;


end;
