library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity SubBlockLogic is
	port(
		Clk : in std_logic;
		ResetActiveHigh : in std_logic;
		SubBlockFromL2 : in std_logic_vector(511 downto 0);
		RequestSubBlockFromL2 : in std_logic;
		AddressFromL2 : in std_logic_vector(31 downto 0);
		DataFromMem : in std_logic_vector(31 downto 0);

		SubBlockReadyToL2 : out std_logic;
		AddressToMem : out std_logic_vector(31 downto 0);
		DataToMem : out std_logic_vector(31 downto 0);
		WriteToMem : out std_logic
	);
end SubBlockLogic;

architecture structural of SubBlockLogic is
	signal count : std_logic_vector(31 downto 0);
	signal notRequestSubBlockFromL2 : std_logic;
	signal reset : std_logic;
	signal wereDone : std_logic;
	signal writeEnable : std_logic;
	signal offset : std_logic_vector(3 downto 0);
begin
  
  offset <= count (3 downto 0);
	--reset counter if no request
	setNotRequestSubBlockFromL2 : not_gate port map(RequestSubBlockFromL2,
										notRequestSubBlockFromL2);

	setReset : or_gate port map(notRequestSubBlockFromL2,ResetActiveHigh,reset);

	--increment counter every clock
	--when counter == 15 and clk high, ready
	writeEnable <= RequestSubBlockFromL2;
	thisIsOurCounter : counter port map(WriteEnable=>writeEnable,Clk=>Clk,ClkRes=>Clk,Reset=>reset,HighestValue=>x"0000000f",Count=>count);

	areWeDone : cmp_n generic map(n=>32) port map(a=>count,b=>x"0000000f",
											a_eq_b=>wereDone);

	setDataReady : and_gate port map(wereDone, Clk,SubBlockReadyToL2);
	

	muxOutputs : mux_n_16 generic map(n=>32) port map(sel=>offset,
	                  src0=>SubBlockFromL2(31 downto 0),
	                  src1=>SubBlockFromL2(63 downto 32),
	                  src2=>SubBlockFromL2(95 downto 64),
	                  src3=>SubBlockFromL2(127 downto 96),
	                  src4=>SubBlockFromL2(159 downto 128),
	                  src5=>SubBlockFromL2(191 downto 160),
	                  src6=>SubBlockFromL2(223 downto 192),
	                  src7=>SubBlockFromL2(255 downto 224),
					  src8=>SubBlockFromL2(287 downto 256),
					  src9=>SubBlockFromL2(319 downto 288),
					  src10=>SubBlockFromL2(351 downto 320),
					  src11=>SubBlockFromL2(383 downto 352),
					  src12=>SubBlockFromL2(415 downto 384),
					  src13=>SubBlockFromL2(447 downto 416),
					  src14=>SubBlockFromL2(479 downto 448),
					  src15=>SubBlockFromL2(511 downto 480),
	                  z=>DataToMem);

	WriteToMem <= RequestSubBlockFromL2;

	setAddressToMem : fulladder_32 port map(cin=>'0',x=>AddressFromL2,y=>count,
											z=>AddressToMem);
end structural;

