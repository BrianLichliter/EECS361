library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity control is 
    port ( 
    	-- inputs from instruction
        opcode    : in  std_logic_vector(5 downto 0);
        func      : in  std_logic_vector(5 downto 0);
		  
		-- 4 bit ALU control
        ALUCtr    : out std_logic_vector(3 downto 0);
	
		-- 7 control signals
        regDst    : out std_logic;
        ALUSrc    : out std_logic;
        memtoReg  : out std_logic;
        regWrite  : out std_logic;
        memWrite  : out std_logic;
		memRead	  : out std_logic;
        branch_ne : out std_logic;
        branch_eq : out std_logic
    );
end entity control;

architecture structural of control is

	component mainControl is
      	port ( 
			opcode    : in  std_logic_vector(5 downto 0);
			ALUOp     : out std_logic_vector(1 downto 0);
			regDst    : out std_logic;
			ALUSrc    : out std_logic;
			memtoReg  : out std_logic;
			regWrite  : out std_logic;
			memWrite  : out std_logic;
			memRead	  : out std_logic;
			branch_eq : out std_logic;
			branch_ne : out std_logic

		);
	end component mainControl;

	component ALUControl is
		port ( 
			ALUOp   : in  std_logic_vector(1 downto 0);
         	func    : in  std_logic_vector(5 downto 0);
         	ALUCtr  : out std_logic_vector(3 downto 0)
        );
	end component ALUControl;

	-- comes out of mainControl
	-- goes into ALUControl
	signal ALUOp : std_logic_vector(1 downto 0);

   	begin
		mainCtr_map : mainControl 
			port map (
				opcode    => opcode, 
				ALUOp     => ALUOp,
				regDst    => regDst,
				ALUSrc    => ALUSrc,
				memtoReg  => memtoReg,
				regWrite  => regWrite,
				memWrite  => memWrite,
				memRead   => memRead,
				branch_ne => branch_ne,
				branch_eq => branch_eq
			);

		ALUCtr_map : ALUControl
			port map (
				ALUOp  => ALUOp,
				func   => func,
				ALUCtr => ALUCtr
			);

end architecture structural;
