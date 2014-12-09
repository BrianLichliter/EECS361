library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L2 is
	port (
		Clk : in std_logic;
		
		ReadWriteFromL1 : in std_logic;
		AddressFromL1 : in std_logic_vector (31 downto 0);
		DataReadyToL1 : out std_logic;
		DataFromL1 : in std_logic_vector (511 downto 0);
		RequestFromL1 : in std_logic;
		DataToL1 : out std_logic_vector (511 downto 0);
		
		AddressToMem : out std_logic_vector(31 downto 0);
		DataFromMem : in std_logic_vector(31 downto 0);
		DataToMem : out std_logic_vector(31 downto 0);
		
		ReadWriteToMem : out std_logic
	);
end L2;

architecture structural of L2 is	
	-- signals for cache
	signal we1 : std_logic;
	signal we2 : std_logic;
	signal we3 : std_logic;
	signal we4 : std_logic;
	signal dataIntoCache : std_logic_vector (2075 downto 0);
	signal dataFromEntry1 : std_logic_vector(2075 downto 0);
	signal dataFromEntry2 : std_logic_vector(2075 downto 0);
	signal dataFromEntry3 : std_logic_vector(2075 downto 0);
	signal dataFromEntry4 : std_logic_vector(2075 downto 0);
	
	-- signals for address
	signal tagIn : std_logic_vector (23 downto 0);
	signal index : std_logic_vector (1 downto 0);
	signal offset : std_logic_vector (1 downto 0);
	
	-- signals for hit and miss logic
	signal miss1 : std_logic;
	signal miss2 : std_logic;
	signal miss3 : std_logic;
	signal miss4 : std_logic;
	signal missVector : std_logic_vector(3 downto 0);
	signal miss : std_logic;
	
	signal hit1 : std_logic;
	signal hit2 : std_logic;
	signal hit3 : std_logic;
	signal hit4 : std_logic;
	signal hitVector : std_logic_vector(3 downto 0);
	signal hit : std_logic;
	
	-- signals for tag comparisons 
	signal tagFromEntry1 : std_logic_vector (23 downto 0);
	signal tagFromEntry2 : std_logic_vector (23 downto 0);
	signal tagFromEntry3 : std_logic_vector (23 downto 0);
	signal tagFromEntry4 : std_logic_vector (23 downto 0);
	
	signal notTagFromEntry1 : std_logic_vector (23 downto 0);
	signal notTagFromEntry2 : std_logic_vector (23 downto 0);
	signal notTagFromEntry3 : std_logic_vector (23 downto 0);
	signal notTagFromEntry4 : std_logic_vector (23 downto 0);

	signal subtractedTags1 : std_logic_vector (23 downto 0);
	signal subtractedTags2 : std_logic_vector (23 downto 0);
	signal subtractedTags3 : std_logic_vector (23 downto 0);
	signal subtractedTags4 : std_logic_vector (23 downto 0);
	
	signal DataOut1 : std_logic_vector(511 downto 0);
	signal DataOut2 : std_logic_vector(511 downto 0);
	signal DataOut3 : std_logic_vector(511 downto 0);
	signal DataOut4 : std_logic_vector(511 downto 0);
	
	-- we enable calculations
	signal we1Temp1 : std_logic;
	signal we1Temp2 : std_logic;
	signal we1Temp3 : std_logic;
	signal we1Temp4 : std_logic;
	
	signal we2Temp1 : std_logic;
	signal we2Temp2 : std_logic;
	signal we2Temp3 : std_logic;
	signal we2Temp4 : std_logic;
	
	signal we3Temp1 : std_logic;
	signal we3Temp2 : std_logic;
	signal we3Temp3 : std_logic;
	signal we3Temp4 : std_logic;

	signal we4Temp1 : std_logic;
	signal we4Temp2 : std_logic;
	signal we4Temp3 : std_logic;	
	signal we4Temp4 : std_logic;
	
	signal pickedByLRU1 : std_logic;
	signal pickedByLRU2 : std_logic;
	signal pickedByLRU3 : std_logic;
	signal pickedByLRU4 : std_logic;
	
	signal ExtDataIn : std_logic_vector (2071 downto 0);
	signal ShiftAmt : std_logic_vector (11 downto 0);
begin
	-- parse the address --
	tagIn <= AddressFromL1 (31 downto 8);
	index <= AddressFromL1 (7 downto 6);
	offset <= AddressFromL1 (5 downto 4);
	
	----------------------------------------
	-- parse data from cache blocks --
	-- cache block 1 --
	-- mux the data out by offset --
	muxOutputs1 : mux_n_4 generic map(n=>512) port map(sel=>offset,
	                  src0=>dataFromEntry1(511 downto 0),
	                  src1=>dataFromEntry1(1023 downto 512),
	                  src2=>dataFromEntry1(1535 downto 1024),
	                  src3=>dataFromEntry1(2047 downto 1536),
	                  z=>DataOut1);
	tagFromEntry1 <= dataFromEntry1(2071 downto 2048);
	
	
	-- cache block 2 --
	-- mux the data out by offset --
	muxOutputs2 : mux_n_4 generic map(n=>512) port map(sel=>offset,
	                  src0=>dataFromEntry2(511 downto 0),
	                  src1=>dataFromEntry2(1023 downto 512),
	                  src2=>dataFromEntry2(1535 downto 1024),
	                  src3=>dataFromEntry2(2047 downto 1536),
	                  z=>DataOut2);
	tagFromEntry2 <= dataFromEntry2(2071 downto 2048);
	
	
	-- cache block 3 --
	-- mux the data out by offset --
	muxOutputs3 : mux_n_4 generic map(n=>512) port map(sel=>offset,
	                  src0=>dataFromEntry3(511 downto 0),
	                  src1=>dataFromEntry3(1023 downto 512),
	                  src2=>dataFromentry3(1535 downto 1024),
	                  src3=>dataFromEntry3(2047 downto 1536),
	                  z=>DataOut3);
	tagFromEntry3 <= dataFromEntry3(2071 downto 2048);
	
	
	-- cache block 4 --
	-- mux the data out by offset --
	muxOutputs4 : mux_n_4 generic map(n=>512) port map(sel=>offset,
	                  src0=>dataFromEntry4(511 downto 0),
	                  src1=>dataFromEntry4(1023 downto 512),
	                  src2=>dataFromEntry4(1535 downto 1024),
	                  src3=>dataFromEntry4(2047 downto 1536),
	                  z=>DataOut4);
	tagFromEntry4 <= dataFromEntry4(2071 downto 2048);
	
	
	----------------------------------------
	-- check if cache block 1 is hit or miss --
	----Check if hit or miss by comparing tags----	
	--Subtract the two
	setNotTagFromEntry1 : not_gate_n generic map(n=>24) port map(
									tagFromEntry1, notTagFromEntry1);
	subtractTags1 : fulladder_n generic map(n=>24) port map(cin=>'1',
								x=>tagIn,y=>notTagFromEntry1,z=>subtractedTags1);
	--OR them all up
	orSubtractedTags1 : or_gate_unary_n generic map(n=>24) port map(
								x=>subtractedTags1,z=>miss1);
	setMiss1 : not_gate port map(miss1,hit1);
	
								
	-- check if cache block 2 is hit or miss --
	----Check if hit or miss by comparing tags----	
	--Subtract the two
	setNotTagFromEntry2 : not_gate_n generic map(n=>24) port map(
									tagFromEntry2, notTagFromEntry2);
	subtractTags2 : fulladder_n generic map(n=>24) port map(cin=>'1',
								x=>tagIn,y=>notTagFromEntry2,z=>subtractedTags2);
	--OR them all up
	orSubtractedTags2 : or_gate_unary_n generic map(n=>24) port map(
								x=>subtractedTags2,z=>miss2);
	setMiss2 : not_gate port map(miss2,hit2);
								
								
	-- check if cache block 3 is hit or miss --
	----Check if hit or miss by comparing tags----	
	--Subtract the two
	setNotTagFromEntry3 : not_gate_n generic map(n=>24) port map(
									tagFromEntry3, notTagFromEntry3);
	subtractTags3 : fulladder_n generic map(n=>24) port map(cin=>'1',
								x=>tagIn,y=>notTagFromEntry3,z=>subtractedTags3);
	--OR them all up
	orSubtractedTags3 : or_gate_unary_n generic map(n=>24) port map(
								x=>subtractedTags3,z=>miss3);
	setMiss3 : not_gate port map(miss3,hit3);
								
								
	-- check if cache block 4 is hit or miss --
	----Check if hit or miss by comparing tags----	
	--Subtract the two
	setNotTagFromEntry4 : not_gate_n generic map(n=>24) port map(
									tagFromEntry4, notTagFromEntry4);
	subtractTags4 : fulladder_n generic map(n=>24) port map(cin=>'1',
								x=>tagIn,y=>notTagFromEntry4,z=>subtractedTags4);
	--OR them all up
	orSubtractedTags4 : or_gate_unary_n generic map(n=>24) port map(
								x=>subtractedTags4,z=>miss4);
	setMiss4 : not_gate port map(miss4,hit4);
	
	
	----------------------------------------
	-- get overall miss and hit signals
	missVector <= miss1 & miss2 & miss3 & miss4;
	orMissVector : or_gate_unary_n generic map(n=> 4) port map(
								x=>missVector,z=>miss);
	
	hitVector <= hit1 & hit2 & hit3 & hit4;
	orHitVector : or_gate_unary_n generic map(n=> 4) port map(
								x=>hitVector,z=>hit);	
								
								
	----------------------------------------
	-- determine write enables
	-- we = {{hit && readwrite} || {miss && LRUpicked}} && clk
	-- we for cache block 1 --
	hitAndReadWrite1 : and_gate port map(ReadWriteFromL1, hit1, we1Temp1);
	missAndLRU1 : and_gate port map(miss1, pickedByLRU1, we1Temp2);
	orWeTemps1 : or_gate port map(we1Temp1, we1Temp2, we1Temp3);
	andWeWtihRequest1 : and_gate port map(we1temp3, RequestFromL1, we1temp4); 
	andWeWithClk1 : and_gate port map(we1Temp4, Clk, we);
	
	-- we for cache block 2 --
	hitAndReadWrite2 : and_gate port map(ReadWriteFromL1, hit2, we2Temp1);
	missAndLRU2 : and_gate port map(miss2, pickedByLRU2, we2Temp2);
	orWeTemps2 : or_gate port map(we2Temp1, we2Temp2, we2Temp3);
	andWeWtihRequest2 : and_gate port map(we2temp3, RequestFromL1, we2temp4);
	andWeWithClk2 : and_gate port map(we2Temp4, Clk, we);
	
	-- we for cache block 3 -- 
	hitAndReadWrite3 : and_gate port map(ReadWriteFromL1, hit3, we3Temp1);
	missAndLRU3 : and_gate port map(miss3, pickedByLRU3, we3Temp2);
	orWeTemps3 : or_gate port map(we3Temp1, we3Temp2, we3Temp3);
	andWeWtihRequest3 : and_gate port map(we3temp3, RequestFromL1, we3temp4);
	andWeWithClk3 : and_gate port map(we3Temp4, Clk, we);
	
	-- we for cache block 4 --
	hitAndReadWrite4 : and_gate port map(ReadWriteFromL1, hit4, we4Temp1);
	missAndLRU4 : and_gate port map(miss4, pickedByLRU4, we4Temp2);
	orWeTemps4 : or_gate port map(we4Temp1, we4Temp2, we4Temp3);
	andWeWtihRequest4 : and_gate port map(we4temp3, RequestFromL1, we4temp4);
	andWeWithClk4 : and_gate port map(we4Temp4, Clk, we);
	
	-- insert dataFromL1 into Cache Line (not writing yet) --
	ExtDataIn <= (2071 downto 512 => '0') & DataFromL1;
	
	ShftAmt : mux_n_4 generic map(n=>12) port map(sel => offset,
								src0 => "000000000000",
								src1 => "001000000000",
								src2 => "010000000000",
								src3 => "100000000000",
								z => ShiftAmt);
	
		----This is cache block 1----
	CsramCache1 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2072)
						port map(cs=>'1',oe=>'1',we=>we1,index=>index,
									din=>dataIntoCache,dout=>dataFromEntry1);
		----This is cache block 2----
	CsramCache2 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2072)
						port map(cs=>'1',oe=>'1',we=>we2,index=>index,
									din=>dataIntoCache,dout=>dataFromEntry2);
		----This is cache block 3----
	CsramCache3 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2072)
						port map(cs=>'1',oe=>'1',we=>we3,index=>index,
									din=>dataIntoCache,dout=>dataFromEntry3);
		----This is cache block 4----
	CsramCache4 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2072)
						port map(cs=>'1',oe=>'1',we=>we4,index=>index,
									din=>dataIntoCache,dout=>dataFromEntry4);
									
end structural;