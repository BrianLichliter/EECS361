-- This file is generated by automatic tools.
library ieee;
use ieee.std_logic_1164.all;

entity xnor_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end xnor_gate;

architecture dataflow of xnor_gate is
begin
  z <= x xnor y;
end dataflow;
