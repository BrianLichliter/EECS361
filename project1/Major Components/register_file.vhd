library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity register_file is
	port (
		clk : in std_logic;
		reset_active_low : in std_logic;
		write_en : in std_logic;
		write_data : in std_logic_vector(31 downto 0);
		read_index_A : in std_logic_vector(4 downto 0);
		read_index_B : in std_logic_vector(4 downto 0);
		write_index : in std_logic_vector(4 downto 0);
		read_op_A : out std_logic_vector(31 downto 0);
		read_op_B: out std_logic_vector(31 downto 0)
	);
end register_file;

architecture structural of register_file is
	signal write_ens : std_logic_vector(31 downto 0);
	type reg_outs_type is array (0 to 31) of std_logic_vector(31 downto 0);
	signal reg_outs : reg_outs_type;
	type level1_out_type is array (0 to 7) of std_logic_vector(31 downto 0);
	signal level1_out_A : level1_out_type;
	signal level1_out_B : level1_out_type;
	type level2_out_type is array (0 to 1) of std_logic_vector(31 downto 0);
	signal level2_out_A : level2_out_type;
   signal level2_out_B : level2_out_type;
	signal decoded_write_en : std_logic_vector(31 downto 0);
	signal write_en_32 : std_logic_vector(31 downto 0);
begin



	--Decode write address and generate write_enables
	decode_write_ad: decoder_5_32 port map(x=>write_index,z=>decoded_write_en);

   write_en_32(31 downto 0) <= (31 downto 0 => write_en);
	and_we: and_gate_32 port map(x=>decoded_write_en, y=>write_en_32, z=>write_ens);

	--Mux the outputs
	gen_level_1:
	for I in 0 to 7 generate
		muxA: mux_n_4 generic map(n => 32) port map(sel=>read_index_A(1 downto 0), src0=>reg_outs(I*4), src1=>reg_outs(I*4 + 1),src2=>reg_outs(I*4+2),src3=>reg_outs(I*4+3), z=>level1_out_A(I));
		muxB: mux_n_4 generic map(n => 32) port map(sel=>read_index_B(1 downto 0), src0=>reg_outs(I*4), src1=>reg_outs(I*4 + 1),src2=>reg_outs(I*4+2),src3=>reg_outs(I*4+3),z=>level1_out_B(I));
	end generate gen_level_1;
	
	gen_level_2:
	for I in 0 to 1 generate
		muxA2: mux_n_4 generic map(n => 32) port map(sel=>read_index_A(3 downto 2), src0=>level1_out_A(I*4), src1=>level1_out_A(I*4 + 1),src2=>level1_out_A(I*4+2),src3=>level1_out_A(I*4+3), z=>level2_out_A(I));
		muxB2: mux_n_4 generic map(n => 32) port map(sel=>read_index_B(3 downto 2), src0=>level1_out_B(I*4), src1=>level1_out_B(I*4 + 1),src2=>level1_out_B(I*4+2),src3=>level1_out_B(I*4+3),z=>level2_out_B(I));
	end generate gen_level_2;

	final_mux_A: mux_32 port map (sel=>read_index_A(4),src0=>level2_out_A(0),src1=>level2_out_A(1),z=>read_op_A);
	final_mux_B: mux_32 port map (sel=>read_index_B(4),src0=>level2_out_B(0),src1=>level2_out_B(1),z=>read_op_B);
	
	
	reg0: register_32bit port map(clk=>clk,reset_active_low=>reset_active_low,write_en=>'0',D=>write_data,Z=>reg_outs(0));
	--instatiate the registers
   gen_regs:
   for I in 1 to 31 generate
      regx: register_32bit port map(clk=>clk,reset_active_low=>reset_active_low,write_en=>write_ens(I),D=>write_data,Z=>reg_outs(I));
   end generate gen_regs;
end structural;