library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity LRU is
	port (
		set_idx	: in std_logic_vector(1 downto 0);
		we		: in std_logic;
		clk		: in std_logic;
		reset	: in std_logic;
		lru_idx	: out std_logic_vector(1 downto 0)
	);
end LRU;

architecture structural of LRU is
	signal register_in			: std_logic_vector(7 downto 0);
	signal accessed_0th			: std_logic_vector(7 downto 0);
	signal accessed_1st			: std_logic_vector(7 downto 0);
	signal accessed_2nd			: std_logic_vector(7 downto 0);
	signal accessed_3rd			: std_logic_vector(7 downto 0);
	signal xor1_out				: std_logic_vector(1 downto 0);
	signal xor2_out				: std_logic_vector(1 downto 0);
	signal xor3_out				: std_logic_vector(1 downto 0);
	signal nor1_out				: std_logic;
	signal nor2_out				: std_logic;
	signal nor3_out				: std_logic;
	signal not1_out				: std_logic;
	signal not2_out				: std_logic;
	signal not_2_1				: std_logic_vector(1 downto 0);
	signal nor_2_1				: std_logic_vector(1 downto 0);
	signal reg_idx				: std_logic_vector(1 downto 0);
	signal register_in_tmp		: std_logic_vector(7 downto 0);

begin
	
	--Reset to initial values of {{ 00 01 10 11 }}
	mux1 : mux_n generic map(n=>8) port map(sel => reset , src0 => register_in_tmp, src1 => "00011011", z => register_in);


	-- Register holding current state: MRU {{ 0th 1st 2nd 3rd }} LRU
	stateRegister : register_8bit port map(clk => clk, reset_active_low => '1', write_en => we, D => register_in, Z => accessed_0th);

	-- All possible next states of the register (except no change)
	accessed_1st <= accessed_0th(5 downto 4) & accessed_0th(7 downto 6) & accessed_0th(3 downto 2) & accessed_0th(1 downto 0);
	accessed_2nd <= accessed_0th(3 downto 2) & accessed_0th(7 downto 6) & accessed_0th(5 downto 4) & accessed_0th(1 downto 0);
	accessed_3rd <= accessed_0th(1 downto 0) & accessed_0th(7 downto 6) & accessed_0th(5 downto 4) & accessed_0th(3 downto 2);

	--Find the register index of the set index
	xor1 : xor_gate_n generic map(n => 2) port map(x => set_idx, y => accessed_0th(3 downto 2), z => xor1_out);
	xor2 : xor_gate_n generic map(n => 2) port map(x => set_idx, y => accessed_0th(5 downto 4), z => xor2_out);
	xor3 : xor_gate_n generic map(n => 2) port map(x => set_idx, y => accessed_0th(7 downto 6), z => xor3_out);

	nor1 : nor_gate port map(x => xor1_out(0), y => xor1_out(1), z => nor1_out);
	nor2 : nor_gate port map(x => xor2_out(0), y => xor2_out(1), z => nor2_out);
	nor3 : nor_gate port map(x => xor3_out(0), y => xor3_out(1), z => nor3_out);

	not1 : not_gate port map(nor1_out, not1_out);
	not2 : not_gate port map(nor2_out, not2_out);

	not_2_1 <= not2_out & not1_out;
	nor_2_1 <= nor2_out & nor1_out;

	mux2 : mux_n generic map(n => 2) port map(
										sel => nor3_out,
										src0 => not_2_1,
										src1 =>nor_2_1,
										z => reg_idx);

	--Move that register index to the front
	stateMux : mux_n_4 generic map(n=>8) port map(
											sel => reg_idx,
											src0 => accessed_0th,
											src1 => accessed_1st,
											src2 => accessed_2nd,
											src3 => accessed_3rd,
											z => register_in_tmp);

	--Output LRU cach block (set index in reg index 3rd)
	lru_idx <= accessed_0th(1 downto 0);



end structural;
