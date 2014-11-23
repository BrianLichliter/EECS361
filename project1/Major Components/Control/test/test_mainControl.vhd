library ieee;
use ieee.std_logic_1164.all;

entity test_mainControl is
    port (         
        ALUOp     : out std_logic_vector(1 downto 0);
        regDst    : out std_logic;
        ALUSrc    : out std_logic;
        memtoReg  : out std_logic;
        regWrite  : out std_logic;
        memWrite  : out std_logic;
		    memRead	: out std_logic;
        branch    : out std_logic);
end test_mainControl;

architecture structural of test_mainControl is

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
			  branch    : out std_logic
		);
    end component mainControl;

    signal op_tb  : std_logic_vector(5 downto 0);

    begin
        mainControl_map : mainControl port map (opcode  => op_tb,
                                                ALUOp => ALUOp,
                                                regDst => regDst,
                                                ALUSrc => ALUSrc,
                                                memtoReg => memtoReg,
                                                regWrite => regWrite,
                                                memWrite => memWrite,
																memRead => memRead,
                                                branch => branch
                                                );
      
        test_proc : process
        begin
            -- Test R-type
            op_tb <= "000000";
            wait for 5 ns;

            -- Test addi
            op_tb <= "001000";
            wait for 5 ns;

            -- Test beq
            op_tb	<= "000100";
            wait for 5 ns;

            -- Test bne
            op_tb <= "000101";
            wait for 5 ns;

            -- Test lw
            op_tb <= "100011";
            wait for 5 ns;

            -- Test sw
            op_tb <= "101011";
            wait for 5 ns;

            wait;
        end process;

end architecture structural;
