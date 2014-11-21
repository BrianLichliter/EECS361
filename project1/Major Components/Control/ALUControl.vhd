library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity ALUControl is 
	port ( 
		ALUOp   : in  std_logic_vector(1 downto 0);
		func    : in  std_logic_vector(5 downto 0);
		ALUCtr  : out std_logic_vector(2 downto 0)
	);
end ALUControl;

architecture structural of ALUControl is 

	signal nALUOp : std_logic_vector(2 downto 0);
	signal nfunc  : std_logic_vector(5 downto 0);

	signal bit2_Temp0 : std_logic; 
	signal bit2_Temp1 : std_logic;
	signal bit2_Temp2 : std_logic; 
	signal bit2_Temp3 : std_logic;

	signal bit1_Temp0 : std_logic;

	signal bit0_Temp0 : std_logic; 
	signal bit0_Temp1 : std_logic; 
	signal bit0_Temp2 : std_logic;
	signal bit0_Temp3 : std_logic;
	signal bit0_Temp4 : std_logic; 
	signal bit0_Temp5 : std_logic;
	signal bit0_Temp6 : std_logic;
	signal bit0_Temp7 : std_logic; 
	signal bit0_Temp8 : std_logic;
	signal bit0_Temp9 : std_logic; 
	signal bit0_Temp10 : std_logic; 
	signal bit0_Temp11 : std_logic;
	signal bit0_Temp12 : std_logic; 
	signal bit0_Temp13 : std_logic;

	begin
        -- Find the compliment of ALUOp
        nALUOp_loop : for i in 0 to 1 generate
	        not_ALUOp : not_gate 
		        port map (
		        	x => ALUOp(i), 
		        	z => nALUOp(i)
		        );
        end generate;

        -- Find the compliment of func
        nfunc_loop : for i in 0 to 5 generate
        	not_func : not_gate 
        		port map (
        			x => func(i), 
        			z => nfunc(i)
        		);
        end generate;

        -- Generate ALUCtr(2)
        ---- bit2_Temp1 = !ALUOp(1) & ALUOp(0)
        bit2_map0 : and_gate 
        	port map (
        		x => nALUOp(1),
        		y => ALUOp(0),
        		z => bit2_Temp0
        	);

        ---- bit2_Temp4 = !func(2) & !func(1) & func(5) & ALUOp(1)
        bit2_map1 : and_gate 
        	port map (
        		x => nfunc(2),
        		y => func(1),
        		z => bit2_Temp1
        	);
        bit2_map2 : and_gate 
        	port map (
        		x => bit2_Temp1,
        		y => func(5),
        		z => bit2_Temp2
        	);
        bit2_map3 : and_gate 
        	port map (
        		x => bit2_Temp2,
        		y => ALUOp(1),
        		z => bit2_Temp3
        	);

        ---- ALUCtr(2) = bit2_Temp0 + bit2_Temp3
        bit2_map4 : or_gate 
        	port map (
        		x => bit2_Temp0,
        		y => bit2_Temp3,
        		z => ALUCtr(2)
        	);

        -- Generate ALUCtr(1)
        ---- bit1_Temp1 = !func(2) & ALUOp(1)
        bit1_map1 : and_gate 
        	port map (
        		x => nfunc(2),
        		y => ALUOp(1),
        		z => bit1_Temp0
        	);

        ---- ALUCtr(1) = !AlUOp(1) + bit1_Temp0
        bit1_map2 : or_gate 
        	port map (
        		x => bit1_Temp0,
        		y => nALUOp(1),
        		z => ALUCtr(1)
        	);

        -- Generate ALUCtr(0)
        ---- bit0_Temp3 = func(5) & !func(3) & func(2) 
        ----             & !func(1) & func(0) 
        bit0_map0 : and_gate 
        	port map (
        		x => func(5),
        		y => nfunc(3),
        		z => bit0_Temp0
        	);
        bit0_map1 : and_gate 
        	port map (
        		x => bit0_Temp0,
        		y => func(2),
        		z => bit0_Temp1
        	);
        bit0_map2 : and_gate 
        	port map (
        		x => bit0_Temp1,
        		y => nfunc(1),
        		z => bit0_Temp2
        	);
        bit0_map3 : and_gate 
        	port map (
        		x => bit0_Temp2,
        		y => func(0),
        		z => bit0_Temp3
        	);

        ---- bit0_Temp7 = func(5) & func(3) & !func(2) 
        ----             & func(1) & !func(0) 
        bit0_map4 : and_gate 
        	port map (
        		x => func(5),
        		y => func(3),
        		z => bit0_Temp4
        	);
        bit0_map5 : and_gate 
        	port map (
        		x => bit0_Temp4,
        		y => nfunc(2),
        		z => bit0_Temp5
        	);
        bit0_map6 : and_gate 
        	port map (
        		x => bit0_Temp5,
        		y => func(1),
        		z => bit0_Temp6
        	);
        bit0_map7 : and_gate 
        	port map (
        		x => bit0_Temp6,
        		y => nfunc(0),
        		z => bit0_Temp7
        	);

        ---- bit0_Temp11 = !func(5) & !func(3) & !func(2) 
        ----              & !func(1) & !func(0) 
        bit0_map8 : and_gate 
        	port map (
        		x => nfunc(5),
        		y => nfunc(3),
        		z => bit0_Temp8
        	);
        bit0_map9 : and_gate 
        	port map (
        		x => bit0_Temp8,
        		y => nfunc(2),
        		z => bit0_Temp9
        	);
        bit0_map10 : and_gate 
        	port map (
        		x => bit0_Temp9,
        		y => nfunc(1),
        		z => bit0_Temp10
        	);
        bit0_map11 : and_gate 
        	port map (
        		x => bit0_Temp10,
        		y => nfunc(0),
        		z => bit0_Temp11
        	);

        ---- bit0_Temp13 = bit0_Temp3 + bit0_Temp7 + bit0_Temp11
        bit0_map12 : or_gate 
	        port map (
	        	x => bit0_Temp3,
	        	y => bit0_Temp7,
	        	z => bit0_Temp12
        	);
        bit0_map13 : or_gate 
	        port map (
	        	x => bit0_Temp12,
	        	y => bit0_Temp11,
	        	z => bit0_Temp13
        	);

        ---- ALUCtr(0) = ALUOp(2) & bit0_Temp13
        bit0_map14 : and_gate 
	        port map (
	        	x => ALUOp(1),
	        	y => bit0_Temp13,
	        	z => ALUCtr(0)
        	);
end architecture structural;
