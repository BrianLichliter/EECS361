library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity and_5to1 is
	port ( 
		andIn  :  in  std_logic_vector(5 downto 0);
      	andOut :  out std_logic
	);
end and_5to1; 

architecture structural of and_5to1 is
    signal andSig : std_logic_vector(5 downto 0);
    begin
		andSig(0) <= andIn(0);
		andSig_loop : for i in 0 to 4 generate
            and_Op : and_gate 
				port map (
					x => andSig(i),
                  	y => andIn(i + 1),
                  	z => andSig(i + 1)
				);
        end generate;
        andOut <= andSig(5);                
end architecture structural;