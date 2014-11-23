library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity whichALUOp is
    port ( 
        ALUctl  : in  std_logic_vector(1 downto 0);
        Funct    : in  std_logic_vector(5 downto 0);
        LwSwOp  : out std_logic; 
		  BOp     : out std_logic; 
		  AddOp   : out std_logic; 
		  SubOp   : out std_logic; 
        AndOp   : out std_logic; 
        OrOp    : out std_logic; 
        SltOp   : out std_logic; 
        SllOp   : out std_logic
	);
end whichALUOp;

architecture structural of whichALUOp is
	component and_8to1 is
		port ( 
			andIn  : in std_logic_vector(7 downto 0);
            andOut : out std_logic
		);
	end component and_8to1;

	-- signals for which ALU instruction
    -- 7 downto 6 are ALU and 5 downto 0 are funct

    signal tLwSw  : std_logic_vector(7 downto 0);
    signal tB     : std_logic_vector(7 downto 0);
    signal tAdd   : std_logic_vector(7 downto 0);
    signal tAddU   : std_logic_vector(7 downto 0);
    signal tSub   : std_logic_vector(7 downto 0);
    signal tAnd   : std_logic_vector(7 downto 0);
    signal tOr    : std_logic_vector(7 downto 0);
    signal tSlt   : std_logic_vector(7 downto 0);
    signal tSll   : std_logic_vector(7 downto 0);
	
	signal AddUOp_temp : std_logic;
	signal AddOp_temp : std_logic;
	

    -- ALUCtl(1,0)Funct(5,4,3,2,1,0)
    signal ALUFunct : std_logic_vector(7 downto 0);

    begin
		  ALUFunct(7 downto 6) <= ALUctl(1 downto 0);
        ALUFunct(5 downto 0) <= Funct(5 downto 0);
		  

		-- logic to check for lw or sw
        -- ALUctl = 00 Funct = xxxxxx
        t_lw6 : not_gate port map (x => ALUFunct(6), z => tLwSw(6));
        t_lw7 : not_gate port map (x => ALUFunct(7), z => tLwSw(7));
		  
        and_LwSw : and_gate port map (x => tLwSw(6), y => tLwSw(7),z => LwSwOp);
		  
----------------------------------------

		-- logic to check for beq or bne
        -- ALUctl = 01 Funct = xxxxxx
        tB(6) <= ALUFunct(6); 
        t_b7 : not_gate port map (x => ALUFunct(7), z => tB(7));
          
        and_B : and_gate port map (x => tB(6), y => tB(7),z => BOp);
		  
----------------------------------------
		  
		-- logic to check for add 
        -- ALUctl = 10 Funct = 100000
        t_Add0 : not_gate port map (x => ALUFunct(0), z => tAdd(0));
        t_Add1 : not_gate port map (x => ALUFunct(1), z => tAdd(1));
        t_Add2 : not_gate port map (x => ALUFunct(2), z => tAdd(2));
        t_Add3 : not_gate port map (x => ALUFunct(3), z => tAdd(3));
        t_Add4 : not_gate port map (x => ALUFunct(4), z => tAdd(4));
        tAdd(5) <= ALUFunct(5);
        t_Add6 : not_gate port map (x => ALUFunct(6), z => tAdd(6));
        tAdd(7) <= ALUFunct(7);
        
        and_Add : and_8to1 port map (andIn => tAdd, andOut => AddOp_temp);
		
----------------------------------------
		  
		-- logic to check for addU 
        -- ALUctl = 10 Funct = 100001
        tAddU(0) <= ALUFunct(0);
        t_AddU1 : not_gate port map (x => ALUFunct(1), z => tAddU(1));
        t_AddU2 : not_gate port map (x => ALUFunct(2), z => tAddU(2));
        t_AddU3 : not_gate port map (x => ALUFunct(3), z => tAddU(3));
        t_AddU4 : not_gate port map (x => ALUFunct(4), z => tAddU(4));
        tAddU(5) <= ALUFunct(5);
        t_AddU6 : not_gate port map (x => ALUFunct(6), z => tAddU(6));
        tAddU(7) <= ALUFunct(7);
        
        and_AddU : and_8to1 port map (andIn => tAddU, andOut => AddUOp_temp);
		
		or_Add : or_gate port map (x => AddUOp_temp, y => AddOp_temp,z => AddOp);
         
----------------------------------------
			
        -- logic to check for subtract 
        -- ALUctl = 10 Funct = 100010
        t_Sub0 : not_gate port map (x => ALUFunct(0), z => tSub(0));
        tSub(1) <= ALUFunct(1);
        t_Sub2 : not_gate port map (x => ALUFunct(2), z => tSub(2));
        t_Sub3 : not_gate port map (x => ALUFunct(3), z => tSub(3));
        t_Sub4 : not_gate port map (x => ALUFunct(4), z => tSub(4));
        tSub(5) <= ALUFunct(5);
        t_Sub6 : not_gate port map (x => ALUFunct(6), z => tSub(6));
        tSub(7) <= ALUFunct(7);
        
        and_Sub : and_8to1 port map (andIn => tSub, andOut => SubOp);

----------------------------------------
		  
        -- logic to check for and 
        -- ALUctl = 10 Funct = 100010
        t_And0 : not_gate port map (x => ALUFunct(0), z => tAnd(0));
        t_And1 : not_gate port map (x => ALUFunct(1), z => tAnd(1));
        tAnd(2) <= ALUFunct(2);
        t_And3 : not_gate port map (x => ALUFunct(3), z => tAnd(3));
        t_And4 : not_gate port map (x => ALUFunct(4), z => tAnd(4));
        tAnd(5) <= ALUFunct(5);
        t_And6 : not_gate port map (x => ALUFunct(6), z => tAnd(6));
        tAnd(7) <= ALUFunct(7);
        
        and_And : and_8to1 port map (andIn => tAnd, andOut => AndOp);

----------------------------------------
		  
        -- logic to check for or 
        -- ALUctl = 10 Funct = 100101
        tOr(0) <= ALUFunct(0);
        t_Or1 : not_gate port map (x => ALUFunct(1), z => tOr(1));
        tOr(2) <= ALUFunct(2);
        t_Or3 : not_gate port map (x => ALUFunct(3), z => tOr(3));
        t_Or4 : not_gate port map (x => ALUFunct(4), z => tOr(4));
        tOr(5) <= ALUFunct(5);
        t_Or6 : not_gate port map (x => ALUFunct(6), z => tOr(6));
        tOr(7) <= ALUFunct(7);
        
        and_Or : and_8to1 port map (andIn => tOr, andOut => OrOp);

----------------------------------------
          
        -- logic to check for slt 
        -- ALUctl = 10 Funct = 101010
        t_Slt0 : not_gate port map (x => ALUFunct(0), z => tSlt(0));
        tSlt(1) <= ALUFunct(1);
        t_Slt2 : not_gate port map (x => ALUFunct(2), z => tSlt(2));
        tSlt(3) <= ALUFunct(3);
        t_Slt4 : not_gate port map (x => ALUFunct(4), z => tSlt(4));
        tSlt(5) <= ALUFunct(5);
        t_Slt6 : not_gate port map (x => ALUFunct(6), z => tSlt(6));
        tSlt(7) <= ALUFunct(7);
        
        and_Slt : and_8to1 port map (andIn => tSlt, andOut => SltOp);

----------------------------------------
          
        -- logic to check for sll 
        -- ALUctl = 10 Funct = 000000
        t_Sll0 : not_gate port map (x => ALUFunct(0), z => tSll(0));
        t_Sll1 : not_gate port map (x => ALUFunct(1), z => tSll(1));
        t_Sll2 : not_gate port map (x => ALUFunct(2), z => tSll(2));
        t_Sll3 : not_gate port map (x => ALUFunct(3), z => tSll(3));
        t_Sll4 : not_gate port map (x => ALUFunct(4), z => tSll(4));
        t_Sll5 : not_gate port map (x => ALUFunct(5), z => tSll(5));
        t_Sll6 : not_gate port map (x => ALUFunct(6), z => tSll(6));
        tSll(7) <= ALUFunct(7);
        
        and_Sll : and_8to1 port map (andIn => tSll, andOut => SllOp);

end architecture structural;
