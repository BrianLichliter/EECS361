library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity counter is
	port (
		WriteEnable		: in std_logic;
		Clk		: in std_logic;
		Reset	: in std_logic;
		HighestValue : in std_logic_vector(31 downto 0);
		Count		: out std_logic_vector(31 downto 0)
	);
end counter;

architecture structural of counter is
	signal ResetLow			: std_logic;
	signal registerInNext	: std_logic_vector(31 downto 0);
	signal registerOut		: std_logic_vector(31 downto 0);
	signal registerIn 		: std_logic_vector(31 downto 0);
	signal notRegisterOut 	: std_logic_vector(31 downto 0);
	signal maxedOut : std_logic;
begin

	--Not the Reset so the counter is Reset on high
	not1 : not_gate port map(Reset, ResetLow);

	-- Register countaining count
	reg : register_32bit port map(Clk => Clk, Reset_active_low => ResetLow, write_en => WriteEnable, D => registerIn, Z => registerOut);

	--Add 1 to the register output
	add : fulladder_32 port map(cin => '1', x => registerOut, y => (31 downto 0 => '0'), cout => open, z => registerInNext);

	compareWithHighestValue : cmp_n port map(a=>registerOut,
									b=>HighestValue,a_eq_b=>maxedOut);

	ResetIfMaxed : mux_n generic map(n=>32) port map(sel=>maxedOut,
									src0=>registerInNext,
									src1=>x"00000000",
									z=>registerIn);
	--output current count
	Count <= registerOut;


end;
