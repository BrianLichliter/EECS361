library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity L1 is
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
end L1;

architecture structural of L1 is
	signal tagIn : std_logic_vector (23 downto 0); 
	signal tagFromEntry : std_logic_vector (23 downto 0);
	signal dataFromEntry : std_logic_vector(536 downto 0);
	signal dataIntoCache : std_logic_vector(536 downto 0);
	signal index : std_logic_vector (3 downto 0);
	signal offset : std_logic_vector (3 downto 0);
	signal dirty : std_logic;
	signal hit : std_logic;
	signal miss : std_logic;
	signal cs : std_logic;
	signal oe : std_logic;
	signal we : std_logic;
	signal weTemp1 : std_logic;
	signal weTemp2 : std_logic;
	signal weTemp3 : std_logic;
	signal dirtyTemp1 : std_logic;
	signal dirtyTemp2 : std_logic;
	signal writeBack : std_logic;
	signal writtenBack : std_logic;
	signal notWrittenBack : std_logic;
	signal writtenBackTemp1 : std_logic;
	signal writtenBackIn : std_logic;
	signal needToWriteButHavent : std_logic;
	signal tagToL2 : std_logic_vector(23 downto 0);
	signal notTagFromEntry : std_logic_vector(23 downto 0);
	signal subtractedTags : std_logic_vector(23 downto 0);
begin
	----Parse the address----
	tagIn <= Address(31 downto 8);
	index <= Address(7 downto 4);
	offset <= Address(3 downto 0);

	----Check if hit or miss by comparing tags----	
	--Subtract the two
	setNotTagFromEntry : not_gate_n generic map(n=>24) port map(
									tagFromEntry, notTagFromEntry);
	subtractTags : fulladder_n generic map(n=>24) port map(cin=>'1',
								x=>tagIn,y=>tagFromEntry,z=>subtractedTags);
	--OR them all up
	orSubtractedTags : or_gate_unary_n generic map(n=>24) port map(
								x=>subtractedTags,z=>miss);

	setMiss : not_gate port map(miss,hit);

	----Generate write signal for cache----
	--Might have to do some fancy stuff with eviction, but probs not
	-- we = {(hit && ReadWrite) || (miss && DataReadyFromL2)} && Clk
	--       (    weTemp1     )    (       weTemp2         )
	--      {                  weTemp3                      }

	andWeWithClk : and_gate port map(weTemp3, Clk, we);
	hitAndReadWrite : and_gate port map(ReadWrite, hit, weTemp1);
	missAndDataRead : and_gate port map(miss, DataReadyFromL2, weTemp2);
	orWeTemps : or_gate port map(weTemp1, weTemp2, weTemp3);

	----Generate our data entry to insert----

	--dataIntoCache(511 downto 0) = (DataIn if hit) or (DataFromL2 if miss)
	--Make sure tag corresponds with the data we're sending
	selectTag : mux_n generic map(n=>24) port map(sel=>hit,
								src0=>tagToL2,src1=>tagIn,
								z=>dataIntoCache(535 downto 512));
	muxDataWithHit : mux_n generic map (n=>512)
							port map(sel=>hit,src0=>DataFromL2,src1=>DataIn,
									z=>dataIntoCache(511 downto 0));

	--Dirty bit = {(ReadWrite && hit) || dirty} && (miss)
	--			   (   dirtyTemp1   )
	--			  {         dirtyTemp2        }
	
	setDirtyTemp1 : and_gate port map(ReadWrite, hit, dirtyTemp1);
	setDirtyTemp2 : or_gate port map(dirtyTemp1, dirty, dirtyTemp2);
	setDirtyIn : and_gate port map(dirtyTemp2, miss, dataIntoCache(536));

	----This is our cache----
	CsramCache : csram generic map(INDEX_WIDTH=>4, BIT_WIDTH=>281)
						port map(cs=>'1',oe=>'1',we=>we,index=>index,
									din=>dataIntoCache,dout=>dataFromEntry);

	----Parse the data from the cache----
	DataToL2 <= dataFromEntry(511 downto 0);
	
	--Mux the data out by offset
	muxOutputs : mux_n_16 generic map(n=>32) port map(sel=>offset,
	                  src0=>dataFromEntry(31 downto 0),
	                  src1=>dataFromEntry(63 downto 32),
	                  src2=>dataFromentry(95 downto 64),
	                  src3=>dataFromEntry(127 downto 96),
	                  src4=>dataFromEntry(159 downto 128),
	                  src5=>datafromEntry(191 downto 160),
	                  src6=>dataFromEntry(223 downto 192),
	                  src7=>dataFromEntry(255 downto 224),
					  src8=>dataFromEntry(287 downto 256),
					  src9=>dataFromEntry(319 downto 288),
					  src10=>dataFromEntry(351 downto 320),
					  src11=>dataFromEntry(383 downto 352),
					  src12=>dataFromEntry(415 downto 384),
					  src13=>dataFromEntry(447 downto 416),
					  src14=>dataFromEntry(479 downto 448),
					  src15=>dataFromEntry(511 downto 480),
	                  z=>DataOut);

	dirty <= dataFromEntry(536);
	tagFromEntry <= dataFromEntry(535 downto 512);

	----TODO eviction----
	-- If dirty, write old to L2, wait for OK, read new from L2, wait for ok,
	-- write to L1
	--
	-- Evict if miss

	RequestToL2 <= miss;
	
	setWriteBack : and_gate port map(miss, dirty, writeBack);

	--TODO figure out writtenBack
	--(miss should maybe be notWrittenBack??)
	--writtenBack clocked <= miss && DataReadyFromL2 && writeBack
	--                           writtenBackTemp1     
	setNotWrittenBack : not_gate port map(writtenBack, notWrittenBack);
	setWrittenBackTemp1 : and_gate port map(miss, DataReadyFromL2,
											writtenBackTemp1);
	setWrittenBackIn : and_gate port map(writtenBackTemp1, writeBack,
										writtenBackIn);
	writtenBackFF : dff port map(clk=>Clk,d=>writtenBackIn,q=>writtenBack);
	--If worse comes to worst we can track the address we wrote back
	
	--ReadWriteToL2 if writeback and not writtenBack
	setReadWriteToL2 : and_gate port map(writeBack, notWrittenBack,
										needToWriteButHavent);
	ReadWriteToL2 <= needToWriteButHavent;

	--AddressToL2 is muxed on writtenBack
	setTagToL2 : mux_n generic map(n=>24)
							port map(sel=>needToWriteButHavent,src0=>tagIn,
									src1=>tagFromEntry,
									z=>tagToL2);
	AddressToL2(31 downto 8) <=tagToL2;
	AddressToL2(7 downto 4) <= index;
	AddressToL2(3 downto 0) <= "0000";

	--We're done when the request hits
	DataReady <= hit;
	
end structural;
