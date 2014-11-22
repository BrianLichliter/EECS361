library ieee;
use ieee.std_logic_1164.all;

entity test_ALUControl is
    port ( ALUCtr : out std_logic_vector(3 downto 0));
end test_ALUControl;

architecture structural of test_ALUControl is

    component ALUControl is 
        port ( ALUOp   : in  std_logic_vector(1 downto 0);
               func    : in  std_logic_vector(5 downto 0);
               ALUCtr  : out std_logic_vector(3 downto 0));
    end component ALUControl;

    signal ALUOp : std_logic_vector(1 downto 0);
    signal func  : std_logic_vector(5 downto 0);

    begin
        ALUControl_map : ALUControl port map (ALUOp  => ALUOp,
                                              func   => func,
                                              ALUCtr => ALUCtr);
      
        test_proc : process
        begin
            -- Test addi/lw/sw
            ALUOp <= "00";
            wait for 5 ns;

            -- Test beq/bne
            ALUOp <= "01";
            wait for 5 ns;

            -- Test add
            ALUOp <= "10";
            func  <= "100000";
            wait for 5 ns;

            -- Test addu
            ALUOp <= "10";
            func  <= "100001";
            wait for 5 ns;

            -- Test subALUOp func
            ALUOp <= "10";
            func  <= "100010";
            wait for 5 ns;

            -- Test and
            ALUOp <= "10";
            func  <= "100100";
            wait for 5 ns;

            -- Test or
            ALUOp <= "10";
            func  <= "100101";
            wait for 5 ns;

            -- Test slt
            ALUOp <= "10";
            func  <= "101010";
            wait for 5 ns;

            -- Test sll
            ALUOp <= "10";
            func  <= "000000";
            wait for 5 ns;

            wait;
        end process;

end architecture structural;
