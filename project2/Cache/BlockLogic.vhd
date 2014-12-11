library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity BlockLogic is
	port(
		Clk : in std_logic;
		ResetActiveHigh : in std_logic;
		RequestBlockFromL2 : in std_logic;
		AddressFromL2 : in std_logic_vector(31 downto 0);
		DataFromMem : in std_logic_vector(31 downto 0);

		BlockReadyToL2 : out std_logic;
		AddressToMem : out std_logic_vector(31 downto 0);
		DataToL2 : out std_logic_vector(2047 downto 0)
	);
end BlockLogic;

architecture structural of BlockLogic is
	signal count : std_logic_vector(31 downto 0);
	signal notRequestBlockFromL2 : std_logic;
	signal reset : std_logic;
	signal wereDone : std_logic;
	signal shiftedDataFromMem : std_logic_vector(2047 downto 0);
	signal dataIntoResponse : std_logic_vector(2047 downto 0);
	signal writeEnable : std_logic;
	signal lotsOfZeros : std_logic_vector(2047 downto 0);
	signal extDataFromMem : std_logic_vector(2047 downto 0);
	signal lower12Count : std_logic_vector(11 downto 0);
begin
	--reset counter if no request
	setNotRequestBlockFromL2 : not_gate port map(RequestBlockFromL2,
										notRequestBlockFromL2);

	setReset : or_gate port map(notRequestBlockFromL2,ResetActiveHigh,reset);

	writeEnable <= RequestBlockFromL2;

	--increment counter every clock
	--when counter == 15 and clk high, ready
	thisIsOurCounter : counter port map(WriteEnable=>writeEnable,Clk=>Clk,Reset=>reset,HighestValue=>x"0000003f",Count=>count);

	areWeDone : cmp_n generic map(n=>32) port map(a=>count,b=>x"0000003f",
											a_eq_b=>wereDone);

	setDataReady : and_gate port map(wereDone, Clk,BlockReadyToL2);

	CSRamToBuildResponse: csram generic map(INDEX_WIDTH=>1,BIT_WIDTH=>2048)
								port map (cs=>'1',oe=>'1',we=>'1',index=>"0",
									din=>dataIntoResponse,dout=>DataToL2);

  extDataFromMem <= (2015 downto 0 => '0') & DataFromMem;
  lower12Count <= count(11 downto 0);
	shftDataIn : shifter_2048 port map(Bits => extDataFromMem,Shift=>lower12Count,R=>
								shiftedDataFromMem);
	lotsOfZeros <= (2047 downto 0 =>'0');
	setDataIntoResponse : mux_n generic map(n=>2048) port map(sel=>reset,
							src0=>shiftedDataFromMem,
							src1=>lotsOfZeros,
							z=>dataIntoResponse);

	setAddressToMem : fulladder_32 port map(cin=>'0',x=>AddressFromL2,y=>count,
											z=>AddressToMem);


end structural;
