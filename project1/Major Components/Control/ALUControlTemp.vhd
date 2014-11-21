library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity ALUControl is 
	port ( 
		ALUOp   : in  std_logic_vector(1 downto 0);
		func    : in  std_logic_vector(5 downto 0);
		ALUCtr  : out std_logic_vector(3 downto 0)
	);
end ALUControl;

architecture structural of ALUControl is 

	component whichALUOp is
		port ( 
	        ALUctl  : in  std_logic_vector(1 downto 0);
	        Funct   : in  std_logic_vector(5 downto 0);
	        LwSwOp  : out std_logic; 
			BOp     : out std_logic; 
			AddOp   : out std_logic; 
			SubOp  	: out std_logic; 
	        AndOp   : out std_logic; 
	        OrOp    : out std_logic; 
	        SltOp   : out std_logic; 
	        SllOp   : out std_logic
		);
	end component whichALUOp;
 
    signal LwSwOp 		: std_logic; 
	signal BOp 			: std_logic; 
	signal AddOp 		: std_logic; 
	signal SubOp 		: std_logic; 
	signal AndOp 		: std_logic; 
	signal OrOp 		: std_logic;
	signal SltOp 		: std_logic; 
	signal SllOp 		: std_logic; 
    
	begin
		-- Classify the op-code
      	isALUOperations : whichALUOp 
			port map ( 
				ALUCtl  => ALUOp,
				Funct   => func,
				LwSwOp  => LwSwOp,
            	BOp 	=> BOp,
				AddOp   => AddOp,
				SubOp   => SubOp,
				AndOp   => AndOp,
				OrOp    => OrOp,
				SltOp   => SltOp,
				SllOp	=> SllOp
			);

----------------

		-- ALUc0 = SltOp | OrOp | SubOp | BOp
		ALUctr0_or0 : or_gate
			port map (
				x => SltOp, 
				y => OrOp, 
				z => ALUctl0_temp0
			);
		ALUctr0_or1 : or_gate 
			port map (
				x => ALUctl0_temp0, 
				y => SubOp, 
				z => ALUctl0_temp1
			);
		ALUctr0_or2 : or_gate 
			port map (
				x => ALUctl0_temp1, 
				y => BOp, 
				z => ALUCtr(0)
			);

----------------

		-- ALUc1 = SubOp | AddOp | BOp | LwSwOp
		ALUctr1_or0 : or_gate
			port map (
				x => SubOp, 
				y => AddOp, 
				z => ALUctl1_temp0
			);
		ALUctr1_or1 : or_gate 
			port map (
				x => ALUctl1_temp0, 
				y => BOp, 
				z => ALUctl1_temp1
			);
		ALUctr1_or2 : or_gate 
			port map (
				x => ALUctl1_temp1, 
				y => LwSwOp, 
				z => ALUCtr(1)
			);

----------------

		-- 2 = SltOp
		ALUCtr(2) <= SltOp;

----------------

		-- 3 = SllOp
		ALUCtr(3) <= SllOp;

end architecture structural; 