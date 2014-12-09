-- This package is used for EECS 361 from Northwestern University.
-- by Kaicheng Zhang (kaichengz@gmail.com)

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

package eecs361 is
  -- Decoders
  component dec_n
    generic (
      -- Widths of the inputs.
      n	  : integer
    );
    port (
      src   : in std_logic_vector(n-1 downto 0);
      z	    : out std_logic_vector((2**n)-1 downto 0)
    );
  end component dec_n;

  -- Multiplexors
  component mux
    port (
      sel   : in  std_logic;
      src0  : in  std_logic;
      src1  : in  std_logic;
      z     : out std_logic
    );
  end component mux;

  component mux_n
    generic (
      -- Widths of the inputs.
      n	  : integer
    );
    port (
      sel   : in  std_logic;
      src0  : in  std_logic_vector(n-1 downto 0);
      src1  : in  std_logic_vector(n-1 downto 0);
      z     : out std_logic_vector(n-1 downto 0)
    );
  end component mux_n;

  component mux_32
    port (
      sel   : in  std_logic;
      src0  : in  std_logic_vector(31 downto 0);
      src1  : in  std_logic_vector(31 downto 0);
      z	    : out std_logic_vector(31 downto 0)
    );
  end component mux_32;

  -- Flip-flops

  -- D Flip-flops from Figure C.8.4 with a falling edge trigger.
  component dff
    port (
      clk   : in  std_logic;
      d	    : in  std_logic;
      q	    : out std_logic
    );
  end component dff;

  -- D Flip-flops from Figure C.8.4 with a rising edge trigger.
  component dffr
    port (
      clk   : in  std_logic;
      d	    : in  std_logic;
      q	    : out std_logic
    );
  end component dffr;

  -- D Flip-flops from Example 13-40 in http://www.altera.com/literature/hb/qts/qts_qii51007.pdf
  component dffr_a
    port (
      clk	 : in  std_logic;
      arst   : in  std_logic;
      aload  : in  std_logic;
      adata  : in  std_logic;
      d	     : in  std_logic;
      enable : in  std_logic;
      q	     : out std_logic
    );

  end component dffr_a;

  -- A 32bit SRAM from Figure C.9.1. It can only be used for simulation.
  component sram
	generic (
	  mem_file	: string
	);
	port (
	  -- chip select
	  cs	: in  std_logic;
	  -- output enable
	  oe	: in  std_logic;
	  -- write enable
	  we	: in  std_logic;
	  -- address line
	  addr	: in  std_logic_vector(31 downto 0);
	  -- data input
	  din	: in  std_logic_vector(31 downto 0);
	  -- data output
	  dout	: out std_logic_vector(31 downto 0)
	);
  end component sram;

  -- Synchronous SRAM with asynchronous reset.
  component syncram
    generic (
	  mem_file	: string
	);
	port (
      -- clock
      clk   : in  std_logic;
	  -- chip select
	  cs	: in  std_logic;
      -- output enable
	  oe	: in  std_logic;
	  -- write enable
	  we	: in  std_logic;
	  -- address line
	  addr	: in  std_logic_vector(31 downto 0);
	  -- data input
	  din	: in  std_logic_vector(31 downto 0);
	  -- data output
	  dout	: out std_logic_vector(31 downto 0)
	);
  end component syncram;

  -- n-bit full adder.
  component fulladder_n
    generic (
      n : integer
    );
    port (
      cin   : in std_logic;
      x     : in std_logic_vector(n-1 downto 0);
      y     : in std_logic_vector(n-1 downto 0);
      cout  : out std_logic;
      z     : out std_logic_vector(n-1 downto 0)
    );
  end component fulladder_n;

  -- 32-bit full adder.
  component fulladder_32
    port (
      cin   : in std_logic;
      x     : in std_logic_vector(31 downto 0);
      y     : in std_logic_vector(31 downto 0);
      z     : out std_logic_vector(31 downto 0);
      cout  : out std_logic
    );
  end component fulladder_32;

  -- Cache tester.
  component cache_test
    generic (
      addr_trace_file : string;
      data_trace_file : string
    );
    port (
      DataIn : in std_logic_vector(31 downto 0);
      clk : in std_logic;
      Ready : in std_logic;
      rst : in std_logic;
      Addr : out std_logic_vector(31 downto 0);
      Data : out Std_logic_vector(31 downto 0);
      WR : out std_logic;
      Err : out std_logic
    );
  end component cache_test;

  -- Custom RAM
  component csram
    generic (
      INDEX_WIDTH : integer;
      BIT_WIDTH : integer
    );
    port (
      cs	  : in	std_logic;
      oe	  :	in	std_logic;
      we	  :	in	std_logic;
      index   : in	std_logic_vector(INDEX_WIDTH-1 downto 0);
      din	  :	in	std_logic_vector(BIT_WIDTH-1 downto 0);
      dout    :	out std_logic_vector(BIT_WIDTH-1 downto 0)
    );
  end component csram;

  component cmp_n
    generic (
      n : integer
    );
    port (
      a      : in std_logic_vector(n-1 downto 0);
      b      : in std_logic_vector(n-1 downto 0);

      a_eq_b : out std_logic;
      a_gt_b : out std_logic;
      a_lt_b : out std_logic;

      signed_a_gt_b : out std_logic;
      signed_a_lt_b : out std_logic
    );
  end component cmp_n;
  component or_gate_unary_n
      generic (
          n : integer
        );
        port (
          x  : in  std_logic_vector(n-1 downto 0);
          z  : out std_logic
        );
   end component or_gate_unary_n;
     component and_gate_unary_n
         generic (
             n : integer
           );
           port (
             x  : in  std_logic_vector(n-1 downto 0);
             z  : out std_logic
           );
      end component and_gate_unary_n;

   component mux_n_8 is
	generic (
		n	: integer
	);
	port (
		sel	: in  std_logic_vector(2 downto 0);
		src0	: in  std_logic_vector(n-1 downto 0);
		src1	: in  std_logic_vector(n-1 downto 0);
		src2	: in  std_logic_vector(n-1 downto 0);
		src3	: in  std_logic_vector(n-1 downto 0);
		src4	: in  std_logic_vector(n-1 downto 0);
		src5	: in  std_logic_vector(n-1 downto 0);
		src6	: in  std_logic_vector(n-1 downto 0);
		src7	: in  std_logic_vector(n-1 downto 0);
		z	: out std_logic_vector(n-1 downto 0)
	);
	end component mux_n_8;
	
   component mux_n_4 is
	generic (
		n	: integer
	);
	port (
		sel	: in  std_logic_vector(1 downto 0);
		src0	: in  std_logic_vector(n-1 downto 0);
		src1	: in  std_logic_vector(n-1 downto 0);
		src2	: in  std_logic_vector(n-1 downto 0);
		src3	: in  std_logic_vector(n-1 downto 0);
		z	: out std_logic_vector(n-1 downto 0)
	);
	end component mux_n_4; 

	component mux_n_16 is
	generic (
		n	: integer
	);
	port (
		sel	: in  std_logic_vector(3 downto 0);
		src0	: in  std_logic_vector(n-1 downto 0);
		src1	: in  std_logic_vector(n-1 downto 0);
		src2	: in  std_logic_vector(n-1 downto 0);
		src3	: in  std_logic_vector(n-1 downto 0);
		src4	: in  std_logic_vector(n-1 downto 0);
		src5	: in  std_logic_vector(n-1 downto 0);
		src6	: in  std_logic_vector(n-1 downto 0);
		src7	: in  std_logic_vector(n-1 downto 0);
		src8	: in  std_logic_vector(n-1 downto 0);
		src9	: in  std_logic_vector(n-1 downto 0);
		src10	: in  std_logic_vector(n-1 downto 0);
		src11	: in  std_logic_vector(n-1 downto 0);
		src12	: in  std_logic_vector(n-1 downto 0);
		src13	: in  std_logic_vector(n-1 downto 0);
		src14	: in  std_logic_vector(n-1 downto 0);
		src15	: in  std_logic_vector(n-1 downto 0);
		z	: out std_logic_vector(n-1 downto 0)
	);
	end component mux_n_16;

  component L1 is
  port (
    Clk : in std_logic;
    RequestIn: in std_logic;
    ReadWrite : in std_logic;
    Address : in std_logic_vector (31 downto 0);
    DataIn : in std_logic_vector (31 downto 0);
    DataOut : out std_logic_vector (31 downto 0);
    DataReady : out std_logic;
    DataFromL2 : in std_logic_vector (511 downto 0);
    DataReadyFromL2 : in std_logic;
    RequestToL2 : out std_logic;
    DataToL2 : out std_logic_vector (511 downto 0);
    AddressToL2 : out std_logic_vector (31 downto 0);
    ReadWriteToL2 : out std_logic
  );
  end component L1;

  component shifter_512 is
  port (
    Bits  : in std_logic_vector(511 downto 0);
    Shift : in std_logic_vector(9 downto 0);
    R     : out std_logic_vector(511 downto 0)
  );
  end component shifter_512;

end;
