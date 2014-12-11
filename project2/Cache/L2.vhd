library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L2 is
	port (
		Clk : in std_logic;
		ResetActiveHigh : in std_logic;
		
		ReadWriteFromL1 : in std_logic;
		AddressFromL1 : in std_logic_vector (31 downto 0);
		DataReadyToL1 : out std_logic;
		DataFromL1 : in std_logic_vector (511 downto 0);
		RequestFromL1 : in std_logic;
		DataToL1 : out std_logic_vector (511 downto 0);

		--SubBlock Logic--		
		SubBlockFromMemReady : in std_logic;

		RequestSubBlockFromMem : out std_logic;
		AddressToMem : out std_logic_vector(31 downto 0);
		SubBlockToMem : out std_logic_vector(511 downto 0);

		--Block Logic--
		BlockFromMem : in std_logic_vector(2047 downto 0);
		BlockFromMemReady : in std_logic;
		
		RequestBlockFromMem : out std_logic;
		
		L2hit : out std_logic;
		L2miss : out std_logic
	);
end L2;

architecture structural of L2 is	
	-- signals for cache
	signal we1 : std_logic;
	signal we2 : std_logic;
	signal we3 : std_logic;
	signal we4 : std_logic;
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
	signal we1Temp5 : std_logic;
	signal we2Temp1 : std_logic;
	signal we2Temp2 : std_logic;
	signal we2Temp3 : std_logic;
	signal we2Temp4 : std_logic;
	signal we2Temp5 : std_logic;
	
	signal we3Temp1 : std_logic;
	signal we3Temp2 : std_logic;
	signal we3Temp3 : std_logic;
	signal we3Temp4 : std_logic;
	signal we3Temp5 : std_logic;

	signal we4Temp1 : std_logic;
	signal we4Temp2 : std_logic;
	signal we4Temp3 : std_logic;	
	signal we4Temp4 : std_logic;
	signal we4Temp5 : std_logic;
	
	signal pickedByLRU1 : std_logic;
	signal pickedByLRU2 : std_logic;
	signal pickedByLRU3 : std_logic;
	signal pickedByLRU4 : std_logic;
	
	-- write calculations
	signal ExtDataIn : std_logic_vector (2047 downto 0);
	signal ShiftDataIn : std_logic_vector(2047 downto 0);
	signal ShiftAmt : std_logic_vector (11 downto 0);
	signal InvMask : std_logic_vector(2047 downto 0);
	signal Mask : std_logic_vector(2047 downto 0);
	
	signal maskedDataFromEntry1 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry2 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry3 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry4 : std_logic_vector(2047 downto 0);
	
	signal CacheLineIn1 : std_logic_vector(2047 downto 0);
	signal CacheLineIn2 : std_logic_vector(2047 downto 0);
	signal CacheLineIn3 : std_logic_vector(2047 downto 0);
	signal CacheLineIn4 : std_logic_vector(2047 downto 0);
	
	signal tagToMem : std_logic_vector(23 downto 0);
	signal dataIntoCache1 : std_logic_vector(2075 downto 0);
	signal dataIntoCache2 : std_logic_vector(2075 downto 0);
	signal dataIntoCache3 : std_logic_vector(2075 downto 0);
	signal dataIntoCache4 : std_logic_vector(2075 downto 0);
	
	signal valid1_1 : std_logic;
	signal valid2_1 : std_logic;
	signal valid3_1 : std_logic;
	signal valid4_1 : std_logic;

	signal valid1_2 : std_logic;
	signal valid2_2 : std_logic;
	signal valid3_2 : std_logic;
	signal valid4_2 : std_logic;

	signal valid1_3 : std_logic;
	signal valid2_3 : std_logic;
	signal valid3_3 : std_logic;
	signal valid4_3 : std_logic;
	
	signal valid1_4 : std_logic;
	signal valid2_4 : std_logic;
	signal valid3_4 : std_logic;
	signal valid4_4 : std_logic;
	
	signal andedValidVector1 : std_logic_vector(3 downto 0);
	signal andedValidVector2 : std_logic_vector(3 downto 0);
	signal andedValidVector3 : std_logic_vector(3 downto 0);
	signal andedValidVector4 : std_logic_vector(3 downto 0);
	
	signal oredValidVectorsTemp1 : std_logic_vector(3 downto 0);
	signal oredValidVectorsTemp2 : std_logic_vector(3 downto 0);
	signal oredValidVectors : std_logic_vector(3 downto 0);
	
	signal writeTagMissValids  : std_logic_vector(3 downto 0);
	signal readMissValids : std_logic_vector(3 downto 0);
	signal writeTagHitValids : std_logic_vector(3 downto 0);
	signal validInput : std_logic_vector(3 downto 0);

	signal hit1vector : std_logic_vector(3 downto 0);
	signal hit2vector : std_logic_vector(3 downto 0);
	signal hit3vector : std_logic_vector(3 downto 0);
	signal hit4vector : std_logic_vector(3 downto 0);
	signal tagHitVector : std_logic_vector(3 downto 0);
	signal tagHit : std_logic;
	
	signal valid1vector : std_logic_vector(3 downto 0);
	signal valid2vector : std_logic_vector(3 downto 0);
	signal valid3vector : std_logic_vector(3 downto 0);
	signal valid4vector : std_logic_vector(3 downto 0);
		
	signal andedValidBit1 : std_logic;	
	signal andedValidBit2 : std_logic;
	signal andedValidBit3 : std_logic;
	signal andedValidBit4 : std_logic;
	
	signal andedHitVector : std_logic_vector(3 downto 0);
	signal validSel : std_logic_vector(1 downto 0);
	
	signal ExtDataIn1 : std_logic_vector (2047 downto 0);
	signal ShiftDataIn1 : std_logic_vector(2047 downto 0);
	signal ShiftAmt1 : std_logic_vector (11 downto 0);
	signal InvMask1 : std_logic_vector(2047 downto 0);
	signal Mask1 : std_logic_vector(2047 downto 0);
	
	signal maskedDataFromEntry11 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry21 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry31 : std_logic_vector(2047 downto 0);
	signal maskedDataFromEntry41 : std_logic_vector(2047 downto 0);
	
	signal CacheLineFromSubBlock1 : std_logic_vector(2047 downto 0);
  signal CacheLineFromSubBlock2 : std_logic_vector(2047 downto 0);
  signal CacheLineFromSubBlock3 : std_logic_vector(2047 downto 0);
  signal CacheLineFromSubBlock4 : std_logic_vector(2047 downto 0);
  	
  signal DataFromMem1 : std_logic_vector(2047 downto 0);	
  signal DataFromMem2 : std_logic_vector(2047 downto 0);
  signal DataFromMem3 : std_logic_vector(2047 downto 0);
  signal DataFromMem4 : std_logic_vector(2047 downto 0);  	

  signal muxedDataFromEntry : std_logic_vector(2075 downto 0);
  
  signal requestTemp1 : std_logic;
  signal LRUindexOut : std_logic_vector (1 downto 0);
  signal MRUindex : std_logic_vector (1 downto 0);
  -- datareadyfrommem--
  -- notreadwritefroml1--
  -- make subblockfrommem into datafromL1 extdatain1--
  
  signal pickedByLRUvector : std_logic_vector (3 downto 0);
  signal weLRU : std_logic;  	
  signal LRUindexIn : std_logic_vector(1 downto 0);
  
  signal DataReadyFromMem : std_logic;
  signal notReadWriteFromL1 : std_logic;
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
	
	--TODO subblock miss logic--
	--get valid bits--
	--check valid bit--
	--Generate request to mem--
	
	--GetValidBits
	--TestAppropriateValidBit
	valid1_1 <= DataFromEntry1(2072);
	valid2_1 <= DataFromEntry1(2073);
	valid3_1 <= DataFromEntry1(2074);
	valid4_1 <= DataFromEntry1(2075);

	valid1_2 <= DataFromEntry2(2072);
	valid2_2 <= DataFromEntry2(2073);
	valid3_2 <= DataFromEntry2(2074);
	valid4_2 <= DataFromEntry2(2075);

	valid1_3 <= DataFromEntry3(2072);
	valid2_3 <= DataFromEntry3(2073);
	valid3_3 <= DataFromEntry3(2074);
	valid4_3 <= DataFromEntry3(2075);

	valid1_4 <= DataFromEntry4(2072);
	valid2_4 <= DataFromEntry4(2073);
	valid3_4 <= DataFromEntry4(2074);
	valid4_4 <= DataFromEntry4(2075);

	--Read miss, set all Valids to 1
	readMissValids <= "1111";

	--Write Tag Hit, valid miss, set that valid to 1
	

	orValids1 : or_gate_n generic map(n=>4) port map(andedValidVector1,andedValidVector2,oredValidVectorsTemp1);
	orValids2 : or_gate_n generic map(n=>4) port map(oredValidVectorsTemp1,andedValidVector3,oredValidVectorsTemp2);
	orValids3 : or_gate_n generic map(n=>4) port map(oredValidVectorsTemp2,andedValidVector4,oredValidVectors);

	setWriteTagHitsValids : or_gate_n generic map(n=>4) port map(writeTagMissValids,oredValidVectors,writeTagHitValids);
	--Write Tag Miss, set that valid to 1, rest to 0
	setWriteTagMissValids : mux_n_4 generic map(n=>4) port map(sel=>offset,
							src0=>"0001",
							src1=>"0010",
							src2=>"0100",
							src3=>"1000",
							z=>writeTagMissValids);

	validSel(1) <= ReadWriteFromL1;
	validSel(0) <= tagHit;
	
	setValidInput : mux_n_4 generic map(n=>4) port map(sel=>validSel, src0=>readMissValids,
											src1=>oredValidVectors,
											src2=>writeTagMissValids,
											src3=>writeTagHitValids,
											z=>validInput);
	
	----------------------------------------
	-- get overall miss and hit signals
	
	hit1vector <= (3 downto 0 => hit1);
	hit2vector <= (3 downto 0 => hit2);
	hit3vector <= (3 downto 0 => hit3);
	hit4vector <= (3 downto 0 => hit4);

	tagHitVector <= hit1 & hit2 & hit3 & hit4;
	setTagHit: or_gate_unary_n generic map(n=>4) port map(tagHitVector,tagHit);

	valid1vector <= valid4_1 & valid3_1 & valid2_1 & valid1_1;
	valid2vector <= valid4_2 & valid3_2 & valid2_2 & valid1_2;
	valid3vector <= valid4_3 & valid3_3 & valid2_3 & valid1_3;
	valid4vector <= valid4_4 & valid3_4 & valid2_4 & valid1_4;

	setAndedValidVector1 : and_gate_n generic map(n=>4) port map(hit1vector,valid1vector,andedValidVector1);
	setAndedValidVector2 : and_gate_n generic map(n=>4) port map(hit2vector,valid2vector,andedValidVector2);
	setAndedValidVector3 : and_gate_n generic map(n=>4) port map(hit3vector,valid3vector,andedValidVector3);
	setAndedValidVector4 : and_gate_n generic map(n=>4) port map(hit4vector,valid4vector,andedValidVector4);
	
	muxValidBits1 : mux_1_4 port map(sel=>offset,src0=>andedValidVector1(0),
										src1=>andedValidVector1(1),
										src2=>andedValidVector1(2),
										src3=>andedValidVector1(3),
										z=>andedValidBit1);
	
	muxValidBits2 : mux_1_4 port map(sel=>offset,src0=>andedValidVector2(0),
										src1=>andedValidVector2(1),
										src2=>andedValidVector2(2),
										src3=>andedValidVector2(3),
										z=>andedValidBit2);
	
	muxValidBits3 : mux_1_4 port map(sel=>offset,src0=>andedValidVector3(0),
										src1=>andedValidVector3(1),
										src2=>andedValidVector3(2),
										src3=>andedValidVector3(3),
										z=>andedValidBit3);
	
	muxValidBits4 : mux_1_4 port map(sel=>offset,src0=>andedValidVector4(0),
										src1=>andedValidVector4(1),
										src2=>andedValidVector4(2),
										src3=>andedValidVector4(3),
										z=>andedValidBit4);
	
	andedHitVector <= andedValidBit1 & andedValidBit2 & andedValidBit3 & andedValidBit4;
	orHitVector : or_gate_unary_n generic map(n=> 4) port map(
								x=>andedHitVector,z=>hit);
	setMiss : not_gate port map(hit,miss);
	L2miss <= miss;
	L2hit <= hit;	
								
	
								
	BlockAndSubBlockReady : or_gate port map(BlockFromMemReady, SubBlockFromMemReady, DataReadyFromMem);							
	----------------------------------------
	-- determine write enables
	-- we = {{hit && readwrite} || {miss && LRUpicked && DataReadyFromMem}} && && RequestFromL1 && clk
	-- we for cache block 1 --
	hitAndReadWrite1 : and_gate port map(ReadWriteFromL1, hit1, we1Temp1);
	missAndLRU1 : and_gate port map(miss1, pickedByLRU1, we1Temp2);
	we1Temp2AndDataReady : and_gate port map(we1Temp2,DataReadyFromMem,we1Temp5);
	orWeTemps1 : or_gate port map(we1Temp1, we1Temp5, we1Temp3);
	andWeWtihRequest1 : and_gate port map(we1temp3, RequestFromL1, we1temp4); 
	andWeWithClk1 : and_gate port map(we1Temp4, Clk, we1);
	
	-- we for cache block 2 --
	hitAndReadWrite2 : and_gate port map(ReadWriteFromL1, hit2, we2Temp1);
	missAndLRU2 : and_gate port map(miss2, pickedByLRU2, we2Temp2);
	we2Temp2AndDataReady : and_gate port map(we2Temp2,DataReadyFromMem,we2Temp5);
	orWeTemps2 : or_gate port map(we2Temp1, we2Temp5, we2Temp3);
	andWeWtihRequest2 : and_gate port map(we2temp3, RequestFromL1, we2temp4);
	andWeWithClk2 : and_gate port map(we2Temp4, Clk, we2);
	
	-- we for cache block 3 -- 
	hitAndReadWrite3 : and_gate port map(ReadWriteFromL1, hit3, we3Temp1);
	missAndLRU3 : and_gate port map(miss3, pickedByLRU3, we3Temp2);
	we3Temp2AndDataReady : and_gate port map(we3Temp2,DataReadyFromMem,we3Temp5);
	orWeTemps3 : or_gate port map(we3Temp1, we3Temp5, we3Temp3);
	andWeWtihRequest3 : and_gate port map(we3temp3, RequestFromL1, we3temp4);
	andWeWithClk3 : and_gate port map(we3Temp4, Clk, we3);
	
	-- we for cache block 4 --
	hitAndReadWrite4 : and_gate port map(ReadWriteFromL1, hit4, we4Temp1);
	missAndLRU4 : and_gate port map(miss4, pickedByLRU4, we4Temp2);
	we4Temp2AndDataReady : and_gate port map(we4Temp2,DataReadyFromMem,we4Temp5);
	orWeTemps4 : or_gate port map(we4Temp1, we4Temp5, we4Temp3);
	andWeWtihRequest4 : and_gate port map(we4temp3, RequestFromL1, we4temp4);
	andWeWithClk4 : and_gate port map(we4Temp4, Clk, we4);
	
	-- insert dataFromL1 into Cache Line (not writing yet) --
	ExtDataIn <= (1535 downto 0 => '0') & DataFromL1;
	
	ShftAmt : mux_n_4 generic map(n=>12) port map(sel => offset,
								src0 => "000000000000",
								src1 => "001000000000",
								src2 => "010000000000",
								src3 => "100000000000",
								z => ShiftAmt);
								
	shftDataIn : shifter_2048 port map(Bits => ExtDataIn, Shift => ShiftAmt, R => ShiftDataIn);
	
	-- create the bit mask
	shiftMask : shifter_2048 port map (Bits => (2047 downto 512 => '0', 511 downto 0 => '1'), Shift => ShiftAmt, R=> InvMask);
	notInvMask : not_gate_n generic map (n=>2048) port map (InvMask, Mask);
	
	-- mask each possible data entry
	maskEntry1 : and_gate_n generic map (n=>2048) port map (x => Mask, y => dataFromEntry1(2047 downto 0),z => maskedDataFromEntry1);
	maskEntry2 : and_gate_n generic map (n=>2048) port map (x => Mask, y => dataFromEntry2(2047 downto 0),z => maskedDataFromEntry2);
	maskEntry3 : and_gate_n generic map (n=>2048) port map (x => Mask, y => dataFromEntry3(2047 downto 0),z => maskedDataFromEntry3);
	maskEntry4 : and_gate_n generic map (n=>2048) port map (x => Mask, y => dataFromEntry4(2047 downto 0),z => maskedDataFromEntry4);
	
	-- create all the possible cacheline we would write back
	dataInAndEntry1 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn, y => maskedDataFromEntry1, z => CacheLineIn1);	
	dataInAndEntry2 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn, y => maskedDataFromEntry2, z => CacheLineIn2);	
	dataInAndEntry3 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn, y => maskedDataFromEntry3, z => CacheLineIn3);	
	dataInAndEntry4 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn, y => maskedDataFromEntry4, z => CacheLineIn4);	
	


	----TODO Do masking for sublocks from Mem----

	-- insert dataFromL1 into Cache Line (not writing yet) --
	ExtDataIn1 <= (1535 downto 0 => '0') & DataFromL1;
	
	ShftAmt1 : mux_n_4 generic map(n=>12) port map(sel => offset,
								src0 => "000000000000",
								src1 => "001000000000",
								src2 => "010000000000",
								src3 => "100000000000",
								z => ShiftAmt1);
								
	shftDataIn1 : shifter_2048 port map(Bits => ExtDataIn1, Shift => ShiftAmt1, R => ShiftDataIn1);
	
	-- create the bit mask
	shiftMask1 : shifter_2048 port map (Bits => (2047 downto 512 => '0', 511 downto 0 => '1'), Shift => ShiftAmt1, R=> InvMask1);
	notInvMask1 : not_gate_n generic map (n=>2048) port map (InvMask1, Mask1);
	
	-- mask each possible data entry
	maskEntry11 : and_gate_n generic map (n=>2048) port map (x => Mask1, y => dataFromEntry1(2047 downto 0),z => maskedDataFromEntry11);
	maskEntry21 : and_gate_n generic map (n=>2048) port map (x => Mask1, y => dataFromEntry2(2047 downto 0),z => maskedDataFromEntry21);
	maskEntry31 : and_gate_n generic map (n=>2048) port map (x => Mask1, y => dataFromEntry3(2047 downto 0),z => maskedDataFromEntry31);
	maskEntry41 : and_gate_n generic map (n=>2048) port map (x => Mask1, y => dataFromEntry4(2047 downto 0),z => maskedDataFromEntry41);
	
	-- create all the possible cacheline we would write back
	dataInAndEntry11 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn1, y => maskedDataFromEntry11, z => CacheLineFromSubBlock1);	
	dataInAndEntry21 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn1, y => maskedDataFromEntry21, z => CacheLineFromSubBlock2);	
	dataInAndEntry31 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn1, y => maskedDataFromEntry31, z => CacheLineFromSubBlock3);	
	dataInAndEntry41 : or_gate_n generic map (n=>2048) port map(x => ShiftDataIn1, y => maskedDataFromEntry41, z => CacheLineFromSubBlock4);	
	-- Chose data entry to write --
		-- dataIntoCache(511 downto 0) = (DataIn if hit) or (mem, if miss)
		-- make sure tag corresponds with the data we're sending
	--DataFromMem = CacheLineFromSubBlock if write, BlockFromMem if read
	muxDataFromMem1 : mux_n generic map(n=>2048) port map(sel=>ReadWriteFromL1, src0=>BlockFromMem,
												src1=>CacheLineFromSubBlock1,z=>DataFromMem1);

	muxDataFromMem2 : mux_n generic map(n=>2048) port map(sel=>ReadWriteFromL1, src0=>BlockFromMem,
												src1=>CacheLineFromSubBlock2,z=>DataFromMem2);

	muxDataFromMem3 : mux_n generic map(n=>2048) port map(sel=>ReadWriteFromL1, src0=>BlockFromMem,
												src1=>CacheLineFromSubBlock3,z=>DataFromMem3);
	
	muxDataFromMem4 : mux_n generic map(n=>2048) port map(sel=>ReadWriteFromL1, src0=>BlockFromMem,
												src1=>CacheLineFromSubBlock4,z=>DataFromMem4);
	
	dataIntoCache1(2071 downto 2048) <= tagIn;
	dataIntoCache2(2071 downto 2048) <= tagIn;
	dataIntoCache3(2071 downto 2048) <= tagIn;
	dataIntoCache4(2071 downto 2048) <= tagIn;
	--selectTag1 : mux_n generic map(n=>24) port map(sel=>hit, 
	--								src0=>tagToMem, src1 => tagIn, 
	--								z=>dataIntoCache1(2071 downto 2048));
	--selectTag2 : mux_n generic map(n=>24) port map(sel=>hit, 
	--								src0=>tagToMem, src1 => tagIn, 
	--								z=>dataIntoCache2(2071 downto 2048));
	--selectTag3 : mux_n generic map(n=>24) port map(sel=>hit, 
	--								src0=>tagToMem, src1 => tagIn, 
	--								z=>dataIntoCache3(2071 downto 2048));
	--selectTag4 : mux_n generic map(n=>24) port map(sel=>hit, 
	--								src0=>tagToMem, src1 => tagIn, 
	--								z=>dataIntoCache4(2071 downto 2048));

	dataIntoCache1(2075 downto 2072) <= validInput;
	dataIntoCache2(2075 downto 2072) <= validInput;
	dataIntoCache3(2075 downto 2072) <= validInput;
	dataIntoCache4(2075 downto 2072) <= validInput;
	
	muxDataWithHit1 : mux_n generic map (n=>2048)
								port map(sel=>hit1, src0=>DataFromMem1, src1 => CacheLineIn1,
										z=>dataIntoCache1(2047 downto 0));
	muxDataWithHit2 : mux_n generic map (n=>2048)
								port map(sel=>hit2, src0=>DataFromMem2, src1 => CacheLineIn2,
										z=>dataIntoCache2(2047 downto 0));
	muxDataWithHit3 : mux_n generic map (n=>2048)
								port map(sel=>hit3, src0=>DataFromMem3, src1 => CacheLineIn3,
										z=>dataIntoCache3(2047 downto 0));
	muxDataWithHit4 : mux_n generic map (n=>2048)
								port map(sel=>hit4, src0=>DataFromMem4, src1 => CacheLineIn4,
										z=>dataIntoCache4(2047 downto 0));
										
	----Set DataFromMem----
	--DataReadyToL1 = (hit && RequestFromL1)
	SetDataReady: and_gate port map(hit, RequestFromL1, DataReadyToL1);	
		
	--RequestSubBlock if write and RequestIn
	SetRequestSubBlockFromMem : and_gate port map(ReadWriteFromL1, RequestFromL1,RequestSubBlockFromMem);

	AddressToMem <= AddressFromL1;
	SubBlockToMem <= DataFromL1;


  notReadWriteMap : not_gate port map (ReadWriteFromL1, notReadWriteFromL1);
	--Request Block when reading, miss, and request from L1
	setRequestBlockFromMem : and_gate port map(notReadWriteFromL1, miss, requestTemp1);
	setRequestBlockFromMem2: and_gate port map(RequestFromL1, requestTemp1, RequestBlockFromMem);


	-----------------------------------------------------
	-----------------incomplete------------------------
	-----------------------------------------------------	
	------ write to mem not done ------
	------ read from mem not done ----
	------ lines 186+ from L1 not translated -----
	
		----This is cache block 1----
	CsramCache1 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2076)
						port map(cs=>'1',oe=>'1',we=>we1,index=>index,
									din=>dataIntoCache1,dout=>dataFromEntry1);
		----This is cache block 2----
	CsramCache2 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2076)
						port map(cs=>'1',oe=>'1',we=>we2,index=>index,
									din=>dataIntoCache2,dout=>dataFromEntry2);
		----This is cache block 3----
	CsramCache3 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2076)
						port map(cs=>'1',oe=>'1',we=>we3,index=>index,
									din=>dataIntoCache3,dout=>dataFromEntry3);
		----This is cache block 4----
	CsramCache4 : csram generic map(INDEX_WIDTH=>2, BIT_WIDTH=>2076)
						port map(cs=>'1',oe=>'1',we=>we4,index=>index,
									din=>dataIntoCache4,dout=>dataFromEntry4);
								
	setMuxedDataFromEntry : mux_n_4 generic map(n=>2076) port map(sel=>MRUindex,
								src0=>dataFromEntry1,
								src1=>dataFromEntry2,
								src2=>dataFromEntry3,
								src3=>dataFromEntry4,
								z=>muxedDataFromEntry);
	setDataToL1 : mux_n_4 generic map(n=>512) port map(sel=>offset,
								src0=>muxedDataFromEntry(511 downto 0),
								src1=>muxedDataFromEntry(1023 downto 512),
								src2=>muxedDataFromEntry(1535 downto 1024),
								src3=>muxedDataFromEntry(2047 downto 1536),
								z=>DataToL1);
								
		----LRU instantiation----
	getIndexOfLineAccessed : mux_n_16 generic map(n=>2) port map(sel=>tagHitVector,
								src0=>LRUindexOut,
								src1=>"00",
								src2=>"01",
								src3=>"00",
								src4=>"10",
								src5=>"00",
								src6=>"00",
								src7=>"00",
								src8=>"11",
								src9=>"00",
								src10=>"00",
								src11=>"00",
								src12=>"00",
								src13=>"00",
								src14=>"00",
								src15=>"00",
								z=>MRUindex);
	
	setWeLRU : and_gate port map(RequestFromL1, hit,weLRU);
	LRUmap : LRU port map(set_idx=>LRUindexIn,we=>weLRU,clk=>Clk,reset=>ResetActiveHigh,lru_idx=>MRUindex);

	setPickedByLRUs : mux_n_4 generic map(n=>4) port map(sel=>LRUindexOut,
							src0=>"0001",
							src1=>"0010",
							src2=>"0100",
							src3=>"1000",
							z=>pickedByLRUvector);

	pickedByLRU1 <= pickedByLRUvector(0);
	pickedByLRU2 <= pickedByLRUvector(1);
	pickedByLRU3 <= pickedByLRUvector(2);
	pickedByLRU4 <= pickedByLRUvector(3);

end structural;
