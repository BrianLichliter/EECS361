library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity control is 
    port ( 
        opcode    : in  std_logic_vector(5 downto 0);
        func      : in  std_logic_vector(5 downto 0);
		  
        ALUCtr    : out std_logic_vector(2 downto 0);
	
        regDst    : out std_logic;
        ALUSrc    : out std_logic;
        memtoReg  : out std_logic;
        regWrite  : out std_logic;
        memWrite  : out std_logic;
		  memRead	: out std_logic;
        branch    : out std_logic
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
			memRead	 : out std_logic;
			branch    : out std_logic
		);
	end component mainControl;

	component ALUControl is
		port ( 
			ALUOp   : in  std_logic_vector(1 downto 0);
         func    : in  std_logic_vector(5 downto 0);
         ALUCtr  : out std_logic_vector(2 downto 0));
	end component ALUControl;

	signal ALUOp : std_logic_vector(1 downto 0);

   begin
		mainCtr_map : mainControl 
			port map (
				opcode   => opcode, 
				ALUOp    => ALUOp,
				regDst   => regDst,
				ALUSrc   => ALUSrc,
				memtoReg => memtoReg,
				regWrite => regWrite,
				memWrite => memWrite,
				memRead  => memRead,
				branch   => branch
			);

		ALUCtr_map : ALUControl
			port map (
				AlUOp  => ALUOp,
				func   => func,
				ALUCtr => ALUCtr
			);

end architecture structural;
