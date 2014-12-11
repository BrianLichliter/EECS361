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
	signal dataOut : std_logic_vector(2047 downto 0);
	signal oredDataFromMem : std_logic_vector(2047 downto 0);
	signal alignedAddress : std_logic_vector(31 downto 0);
begin
	--reset counter if no request
	setNotRequestBlockFromL2 : not_gate port map(RequestBlockFromL2,
										notRequestBlockFromL2);

	setReset : or_gate port map(notRequestBlockFromL2,ResetActiveHigh,reset);

	writeEnable <= RequestBlockFromL2;

	--increment counter every clock
	--when counter == 15 and clk high, ready
	thisIsOurCounter : counter4 port map(WriteEnable=>writeEnable,Clk=>Clk,Reset=>reset,HighestValue=>x"000000fc",Count=>count);
	
	areWeDone : cmp_n generic map(n=>32) port map(a=>count,b=>x"000000fc",
											a_eq_b=>wereDone);

	setDataReady : and_gate port map(wereDone, Clk,BlockReadyToL2);

	CSRamToBuildResponse: csram generic map(INDEX_WIDTH=>2,BIT_WIDTH=>2048)
								port map (cs=>'1',oe=>'1',we=>Clk,index=>"01",
									din=>dataIntoResponse,dout=>dataOut);

  extDataFromMem <= (2015 downto 0 => '0') & DataFromMem;
  lower12Count <= count(8 downto 0)& (2 downto 0 =>'0');
	shftDataIn : shifter_2048 port map(Bits => extDataFromMem,Shift=>lower12Count,R=>
								shiftedDataFromMem);

	setOr : or_gate_n generic map(n=>2048) port map(shiftedDataFromMem, dataOut,oredDataFromMem);
	lotsOfZeros <= (2047 downto 0 =>'0');
	setDataIntoResponse : mux_n generic map(n=>2048) port map(sel=>reset,
							src0=>oredDataFromMem,
							src1=>lotsOfZeros,
							z=>dataIntoResponse);
	alignedAddress <= AddressFromL2(31 downto 8) & (7 downto 0 => '0');
	setAddressToMem : fulladder_32 port map(cin=>'0',x=>alignedAddress,y=>count,
											z=>AddressToMem);

	DataToL2 <= dataIntoResponse;
end structural;
