library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity mainControl is 
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
end mainControl;

architecture structural of mainControl is 

	component whichOp is
		port ( 
			opcode  : in  std_logic_vector(5 downto 0);
			RtypeOp	: out std_logic; 
			AddiOp 	: out std_logic; 
			BeqOp 	: out std_logic;
			BneOp	: out std_logic;
			LwOp    : out std_logic;  
			SwOp  	: out std_logic
		);
	end component whichOp;
 
    signal RtypeOp 		: std_logic; 
	signal AddiOp 		: std_logic; 
	signal BeqOp 		: std_logic; 
	signal BneOp 		: std_logic; 
	signal LwOp 		: std_logic; 
	signal SwOp 		: std_logic;
	
    signal regWrTemp 	: std_logic; 
	signal ALUsrcTemp 	: std_logic;
    
	begin
		-- Classify the op-code
      isOperations : whichOp 
			port map ( 
				opcode  => opcode,
            	RtypeOp => RtypeOp,
				AddiOp  => AddiOp,
				BeqOp   => BeqOp,
				BneOp   => BneOp,
				LwOp    => LwOp,
				SwOp    => SwOp
			);
		
		-- RegDst signal
		regDst <= RtypeOp;

		-- ALUsrc signal
		-- ALUsrc 1 when addi, sw, or lw is 1
		sigALUsrcTemp : or_gate
		port map (
			x => AddiOp, 
			y => LwOp, 
			z => ALUsrcTemp
		);
		sigALUsrc : or_gate 
		port map (
			x => ALUsrcTemp, 
			y => SwOp, 
			z => ALUSrc
		);

		-- MemtoReg signal
		-- 1 when lw is 1
		memtoReg <= LwOp;
	  
		-- RegWrite signal
		-- 1 when rtype or addi is 1
		sigRegWrTemp : or_gate 
		port map (
			x => RtypeOp, 
			y => AddiOp, 
			z => regWrTemp
		);
		sigRegWr : or_gate 
			port map (
				x => regWrTemp, 
				y => LwOp, 
				z => regWrite
			);

		-- MemWrite signal
		-- 1 when sw is 1
		memWrite <= SwOp;
	  
		-- MemRead signal
		-- 1 when lw is 1
		memRead <= LwOp;

		-- Branch signal

		branch_eq <= BeqOp;
		branch_ne <= BneOp;
	  
		-- ALU operations
		-- 1 when rtype is 1
		ALUOp(1) <= RtypeOp;
		
		-- 1 when bne or beq is 1
		sigALUOp : or_gate 
			port map (
				x => BeqOp, 
				y => BneOp,
				z => ALUOp(0)
			);

end architecture structural; 
