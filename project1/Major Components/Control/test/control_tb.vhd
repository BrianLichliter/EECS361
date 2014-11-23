library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity control_tb is
    port ( 
		  
        ALUCtr_tb    : out std_logic_vector(3 downto 0);
	
        regDst_tb    : out std_logic;
        ALUSrc_tb    : out std_logic;
        memtoReg_tb  : out std_logic;
        regWrite_tb  : out std_logic;
        memWrite_tb  : out std_logic;
		memRead_tb	 : out std_logic;
        branch_tb    : out std_logic
    );
end control_tb;

architecture structural of control_tb is

    component control is 
		 port ( 
			  opcode    : in  std_logic_vector(5 downto 0);
			  func      : in  std_logic_vector(5 downto 0);
			  
			  ALUCtr    : out std_logic_vector(3 downto 0);
		
			  regDst    : out std_logic;
			  ALUSrc    : out std_logic;
			  memtoReg  : out std_logic;
			  regWrite  : out std_logic;
			  memWrite  : out std_logic;
			  memRead	: out std_logic;
			  branch    : out std_logic
		 );
    end component control;

    signal opcode_tb : std_logic_vector(5 downto 0);
	signal func_tb   : std_logic_vector(5 downto 0);

    begin
        Control_map : control port map (
				opcode  => opcode_tb,
				func => func_tb,
				ALUCtr => ALUCtr_tb,
				regDst => regDst_tb,
				ALUSrc => ALUSrc_tb,
				memtoReg => memtoReg_tb,
				regWrite => regWrite_tb,
				memWrite => memWrite_tb,
				memRead => memRead_tb,
				branch => branch_tb
			);

     test_proc : process
        begin
      -- Test add
      opcode_tb <= "000000";
			func_tb <= "100000";
            wait for 5 ns;

      -- Test sub
      opcode_tb <= "000000";
			func_tb <= "100010";
            wait for 5 ns;

			-- Test and
      opcode_tb <= "000000";
			func_tb <= "100100";
            wait for 5 ns;
				
			-- Test or
      opcode_tb <= "000000";
			func_tb <= "100101";
            wait for 5 ns;
				
			-- Test slt
      opcode_tb <= "000000";
			func_tb <= "101010";
            wait for 5 ns;
			
			-- Test sll
      opcode_tb <= "000000";
			func_tb <= "000000";
            wait for 5 ns;

			-- Test addi
      opcode_tb <= "001000";
			func_tb <= "000000";
            wait for 5 ns;
            
            			-- Test beq
      opcode_tb <= "000100";
			func_tb <= "000000";
            wait for 5 ns;
            
            			-- Test bne
      opcode_tb <= "000101";
			func_tb <= "000000";
            wait for 5 ns;
            
            			-- Test lw
      opcode_tb <= "100011";
			func_tb <= "000000";
            wait for 5 ns;

            			-- Test sw
      opcode_tb <= "101011";
			func_tb <= "000000";
            wait for 5 ns;


            wait;
        end process;

end architecture structural;
