library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity cpu is
	generic (
		mem		: string
	);
	port (
		clock		: in std_logic;
		reset		: in std_logic
	);
end cpu;

architecture structural of cpu is
	signal inst			: std_logic_vector(31 downto 0);
	signal branch		: std_logic;
	signal zero			: std_logic;
	signal regWr		: std_logic;
	signal regDst		: std_logic;
	signal ALUsrc		: std_logic;
	signal ALUctl		: std_logic_vector(3 downto 0);
	signal memWr		: std_logic;
	signal memRd		: std_logic;
	signal memToReg		: std_logic;
	signal Rw			: std_logic_vector(4 downto 0);
	signal busW			: std_logic_vector(31 downto 0);
	signal busA			: std_logic_vector(31 downto 0);
	signal busB			: std_logic_vector(31 downto 0);
	signal imm32		: std_logic_vector(31 downto 0);
	signal imm_or_B		: std_logic_vector(31 downto 0);
	signal ALU_out		: std_logic_vector(31 downto 0);
	signal mem_out		: std_logic_vector(31 downto 0);
   signal write_data : std_logic_vector(31 downto 0);
   signal reset_low : std_logic;

begin

	-- IFU
	IFU_map : IFU generic map (mem=>mem) port map (clock=>clock, reset=>reset, branch=>branch, zero=>zero, inst=>inst);

	-- Control
	ctrl : control port map (opcode=>inst(31 downto 26), func=>inst(5 downto 0), ALUCtr=>ALUctl, regDst=>regDst, ALUSrc=>ALUsrc, memtoReg=>memToReg, regWrite=>regWr, memWrite=>memWr, memRead=>memRd, branch=>branch);

	-- Chose write register (0:Rt, 1:Rd)
	mux_rw : mux_n generic map (n=>5) port map (sel=>regDst, src0=>inst(20 downto 16), src1=>inst(15 downto 11), z=>Rw);

	-- Registers (Rw:Rw, Ra:Rs, Rb:Rt)
	not_reset: not_gate port map(reset,reset_low);
	reg : register_file port map(clk=>clock, reset_active_low=>reset_low, write_data=>busW,write_index=>Rw, read_index_A=>inst(20 downto 16), read_index_B=>inst(25 downto 21), read_op_A=>busA, read_op_B=>busB, write_en=>regWr);

	-- Sign extend the immediate
	ext : signextender_n_m generic map (n=>16, m=>32) port map (A=>inst(15 downto 0), R=>imm32);

	-- Mux extended immediate and busB (0:busB, 1:imm32)
	mux_imm_B : mux_n generic map (n=>32) port map (sel=>ALUsrc, src0=>busB, src1=>imm32, z=>imm_or_B);

	-- ALU
	alu_map : alu port map (ctrl=>ALUctl, A=>busA, B=>imm_or_B, cout=>open, ovf=>open, ze=>zero, R=>ALU_out);

	-- Data Memory
	dataMem: syncram generic map (mem_file=>mem) port map (clk=>clock, cs=>'1', oe=>memRd, we=>memWr, addr=>ALU_out, din=>busB, dout=>mem_out);

	-- Mux ALU and memory output (0:ALU_out, 1:mem_out)
	mux_ALU_mem : mux_n generic map (n=>32) port map (sel=>memToReg, src0=>ALU_out, src1=>mem_out, z=>busW);



end architecture structural;