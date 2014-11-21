library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity whichOp is
    port ( 
        opcode    : in  std_logic_vector(5 downto 0);
        RtypeOp   : out std_logic; 
		AddiOp    : out std_logic; 
		BeqOp     : out std_logic;
        BneOp     : out std_logic;  
		LwOp      : out std_logic;   
		SwOp  	  : out std_logic
	);
end whichOp;

architecture structural of whichOp is
	component and_5to1 is
		port ( 
			andIn  : in std_logic_vector(5 downto 0);
            andOut : out std_logic
		);
	end component and_5to1;

	-- signals for which instruction type (R-Type, addi, lw, sw, beq, bne) 
    signal tRtype : std_logic_vector(5 downto 0); 
	signal tAddi  : std_logic_vector(5 downto 0); 
	signal tBeq   : std_logic_vector(5 downto 0);
    signal tBne	  : std_logic_vector(5 downto 0); 
	signal tLw	  : std_logic_vector(5 downto 0); 
	signal tSw    : std_logic_vector(5 downto 0);

    begin
		-- logic to check for Rtype
		t_Rtype_loop : for i in 0 to 5 generate
            t_Rtype : not_gate 
				port map (
					x =>opcode(i), 
					z => tRtype(i)
				);
        end generate;
		  
        and_Rtype : and_5to1 port map (andIn => tRtype, andOut => RtypeOp);
		  
----------------------------------------

		-- logic to check for add immediate
        tAddi(3) <= opcode(3);
        t_Addi0 : not_gate port map (x =>opcode(0), z => tAddi(0));
        t_Addi1 : not_gate port map (x =>opcode(1), z => tAddi(1));
        t_Addi2 : not_gate port map (x =>opcode(2), z => tAddi(2));
        t_Addi4 : not_gate port map (x =>opcode(4), z => tAddi(4));
        t_Addi5 : not_gate port map (x =>opcode(5), z => tAddi(5));

        and_Addi : and_5to1 port map (andIn => tAddi, andOut => AddiOp);
		  
----------------------------------------
		  
		-- logic to check for store word
        tSw(0) <= opcode(0);
        tSw(1) <= opcode(1);
        t_Sw2 : not_gate port map (x =>opcode(2), z => tSw(2));
        tSw(3) <= opcode(3);
        t_Sw4 : not_gate port map (x =>opcode(4), z => tSw(4));
        tSw(5) <= opcode(5);
        
        and_Sw : and_5to1 port map (andIn => tSw, andOut => SwOp);
         
----------------------------------------
			
		-- logic to check for branch equal
        t_Beq0 : not_gate port map (x =>opcode(0), z => tBeq(0));
        t_Beq1 : not_gate port map (x =>opcode(1), z => tBeq(1));
        tBeq(2) <= opcode(2);
        t_Beq3 : not_gate port map (x =>opcode(3), z => tBeq(3));
        t_Beq4 : not_gate port map (x =>opcode(4), z => tBeq(4));
        t_Beq5 : not_gate port map (x =>opcode(5), z => tBeq(5));

        and_Beq : and_5to1 port map (andIn => tBeq, andOut => BeqOp);

----------------------------------------
		  
		-- logic to check for branch not equal
        tBne(0) <= opcode(0);
        t_Bne1 : not_gate port map (x =>opcode(1), z => tBne(1));
        tBne(2) <= opcode(2);
        t_Bne3 : not_gate port map (x =>opcode(3), z => tBne(3));
        t_Bne4 : not_gate port map (x =>opcode(4), z => tBne(4));
        t_Bne5 : not_gate port map (x =>opcode(5), z => tBne(5));

        and_Bne : and_5to1 port map (andIn => tBne, andOut => BneOp);

----------------------------------------
		  
		-- logic to check for load word
        tLw(0) <= opcode(0);
        tLw(1) <= opcode(1);
        t_Lw2 : not_gate port map (x =>opcode(2), z => tLw(2));
        t_Lw3 : not_gate port map (x =>opcode(3), z => tLw(3));
        t_Lw4 : not_gate port map (x =>opcode(4), z => tLw(4));
        tLw(5) <= opcode(5);

        and_Lw : and_5to1 port map (andIn => tLw, andOut => LwOp);

end architecture structural;
