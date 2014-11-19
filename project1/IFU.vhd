library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_32bit is
	generic (
		mem	: string
	);
	port (
		clock	: in std_logic;
		branch	: in std_logic;
		zero	: in std_logic;
		inst	: inout std_logic_vector(31 downto 0)
	);
end register_32bit;

architecture structural of register_32bit is
	signal PC_ff_in		: std_logic_vector(29 downto 0);
	signal PC_ff_out	: std_logic_vector(29 downto 0);
	signal PC_plus_4	: std_logic_vector(29 downto 0);
	signal imm_16_ext	: std_logic_vector(29 downto 0);
	signal PC_plus_imm	: std_logic_vector(29 downto 0);
	signal branch_zero	: std_logic;
	signal PC_full		: std_logic_vector(31 downto 0);
	signal imm16		: std_logic_vector(15 downto 0);
	signal dont_care	: std_logic_vector(31 downto 0);
begin

	-- PC Storage in FFs
	gen_ff: for i in 0 to 29 generate
		dff_PC : dff port map (clk=>clock, d=>PC_ff_in(i),q=>PC_ff_out(i));
	end generate gen_ff;

	-- Add 4 to PC
	add_4_PC : fulladder_s_n generic map (n=> 30) port map (A=>PC_ff_out, B=>"000000000000000000000000000001", R=>PC_plus_4);

	-- Sign extend Imm16
	ext_imm : signextender_n_m generic map (n=>16, m=>30) port map (A=>imm16, R=>imm_16_ext);

	-- Add Imm16 to PC+4
	add_imm_PC : fulladder_s_n generic map (n=> 30) port map (A=>PC_plus_4, B=>imm_16_ext, R=>PC_plus_imm);

	-- And Branch and Zero
	and_b_z : and_gate port map (x=>branch, y=>zero, z=>branch_zero);

	-- Mux PC+4 and PC+4+Imm16
	PC_Mux : mux_n generic map (n=>30) port map (sel=> branch_zero,src0=>PC_plus_4, src1=>PC_plus_imm, z=>PC_ff_in);

	-- Create full instruction address
	PC_full <= PC_ff_in & "00";

	-- Get next instruction from s-ram
	dont_care <= "--------------------------------";
	insMem_map: sram generic map (mem_file => mem) port map (cs=>'1', oe=>'1', we=>'0', addr=>PC_full, din=>dont_care, dout=>inst);

	-- Get Imm16
	imm16 <= inst(15 downto 0);
	

end architecture structural;