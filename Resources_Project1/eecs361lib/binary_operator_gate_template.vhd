-- This file is generated by automatic tools.
library ieee;
use ieee.std_logic_1164.all;

entity %GATE%_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end %GATE%_gate;

architecture dataflow of %GATE%_gate is
begin
  z <= x %GATE% y;
end dataflow;
