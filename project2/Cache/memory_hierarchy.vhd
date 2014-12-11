library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity memory_hierarchy is   
	generic (     
		-- mem_file is used to initialize your main memory.     
		mem_file : string   
		);   
	port (     
		-- clock     
		clk : in std_logic;
		     
		-- EN = ‘1’ means the inputs are ready in the coming rising edge. 		    
		EN : in std_logic;  
		   
		-- WR = ‘1’ means the next request is a write request.     
		WR : in std_logic;
		     
		-- Addr is the address of the request.     
		Addr : in std_logic_vector(31 downto 0);
		     
		-- DataIn is the data to be written. It is only valid when the request is a write request.     
		DataIn : in std_logic_vector(31 downto 0);
		     
		-- Ready = ‘1’ means your cache have finish the current request. Before you rise Ready to ‘1’, your cache should either finished the write request, or you have get the data of the read request at DataOut port.     
		Ready : out std_logic;
		     
		-- DataOut is the data for read requests.     
		DataOut : out std_logic_vector(31 downto 0);

		ResetActiveHigh : in std_logic;
		     
		-- Below are the counters of your caches.     
		l1_hit_cnt : out std_logic_vector(31 downto 0);     
		l1_miss_cnt : out std_logic_vector(31 downto 0);     
		l1_evict_cnt : out std_logic_vector(31 downto 0);     
		l2_hit_cnt : out std_logic_vector(31 downto 0);
	    l2_miss_cnt : out std_logic_vector(31 downto 0);     
		l2_evict_cnt : out std_logic_vector(31 downto 0)   
	); 
end memory_hierarchy;
--this is a comment
architecture structural of memory_hierarchy is
	signal dataFromL2ToL1 : std_logic_vector (511 downto 0);
	signal dataFromL1ToL2 : std_logic_vector (511 downto 0);
	signal dataFromL2ToSub : std_logic_vector (511 downto 0);
	signal dataFromBlockToL2 : std_logic_vector(2047 downto 0);
	signal dataFromMem : std_logic_vector(31 downto 0);
	signal dataToMem : std_logic_vector(31 downto 0);
	signal dataReadyL2 : std_logic;
	signal dataReadyL1 : std_logic;
	signal dataReadySub : std_logic;
	signal dataReadyBlock : std_logic;
	signal requestL2 : std_logic;
	signal requestSub : std_logic;
	signal requestBlock : std_logic;
	signal addressToL2 : std_logic_vector(31 downto 0);
	signal addressToMem : std_logic_vector(31 downto 0);
	signal addressFromSub : std_logic_vector(31 downto 0);
	signal addressFromBlock : std_logic_vector(31 downto 0);
	signal readWriteToL2 : std_logic;
	signal L1hit : std_logic;
	signal L1miss : std_logic;
	signal L2hit : std_logic;
	signal L2miss : std_logic;
	signal writeToMem : std_logic;
	signal muxedAddress : std_logic_vector(31 downto 0);
	signal L1missCount : std_logic_vector(31 downto 0);
	signal L1hitCount : std_logic_vector(31 downto 0);
	signal L1totalCount : std_logic_vector(31 downto 0);
	signal notL1missCount : std_logic_vector(31 downto 0);
	signal L2hitCount : std_logic_vector(31 downto 0);
	signal L2missCount : std_logic_vector(31 downto 0);
	signal L2totalCount : std_logic_vector(31 downto 0);
	signal notL2missCount : std_logic_vector(31 downto 0);
	signal we : std_logic;
begin
	--This is our L1
	Ready <= dataReadyL1;
	L1map : L1 port map (Clk=>clk, RequestIn=>EN,ReadWrite=>Wr,
						Address=>Addr,DataIn=>DataIn, DataOut=>DataOut,
						DataReady=>dataReadyL1,DataFromL2=>DataFromL2ToL1,
						DataReadyFromL2=>dataReadyL2,RequestToL2=>requestL2,
						DataToL2=>dataFromL1ToL2,AddressToL2=>addressToL2,
						ReadWriteToL2=>readWriteToL2, L1hit=>L1hit,L1miss=>L1miss);


	--This is our L2
	L2map : L2 port map (Clk=>clk,ResetActiveHigh=>ResetActiveHigh,
						ReadWriteFromL1=>readWriteToL2,AddressFromL1=>addressToL2,
						DataReadyToL1=>dataReadyL2,RequestFromL1=>requestL2,
						DataToL1=>dataFromL2ToL1,
						SubBlockFromMemReady=>dataReadySub,
						RequestSubBlockFromMem=>requestSub,
						AddressToMem=>addressToMem,SubBlockToMem=>dataFromL2ToSub,
						BlockFromMem=>dataFromBlockToL2,
						BlockFromMemReady=>dataReadyBlock,
						RequestBlockFromMem=>requestBlock,
						DataFromL1=>dataFromL1ToL2,
						L2hit=>L2hit,L2miss=>L2miss);

	--SubBlockLogic
	SubBlockmap : SubBlockLogic port map (Clk=>clk,ResetActiveHigh=>ResetActiveHigh,
						SubBlockFromL2=>dataFromL2ToSub,
						RequestSubBlockFromL2=>requestSub,
						AddressFromL2=>addressToMem,
						DataFromMem=>dataFromMem,
						SubBlockReadyToL2=>dataReadySub,
						AddressToMem=>addressFromSub,
						DataToMem=>dataToMem,
						WriteToMem=>writeToMem);

	--BlockLogic
	Blockmap : BlockLogic port map(Clk=>clk,ResetActiveHigh=>ResetActiveHigh,
						RequestBlockFromL2=>requestBlock,
						AddressFromL2=>addressToMem,
						DataFromMem=>dataFromMem,
						BlockReadyToL2=>dataReadyBlock,
						AddressToMem=>addressFromBlock,
						DataToL2=>dataFromBlockToL2);

	--This is our Mem
	setWe : and_gate port map(writeToMem,clk,we);
	--mux addresses--
	addrMap : mux_n generic map(n=>32) port map(sel=>writeToMem,
						src0=>addressFromBlock,
						src1=>addressFromSub,
						z=>muxedAddress);

	Memmap : sram generic map(mem_file=>mem_file) port map(cs=>'1',oe=>'1',
						we=>we,addr=>muxedAddress,din=>dataToMem,
						dout=>dataFromMem);
								

	--Hit Counters
	L1missMap : counter port map(WriteEnable=>EN,Clk=>L1miss,ClkRes=>clk,Reset=>ResetActiveHigh,
						HighestValue=>x"ffffffff",Count=>L1missCount);
	L1totalMap : counter port map(WriteEnable=>EN,Clk=>dataReadyL1,ClkRes=>clk,Reset=>ResetActiveHigh,
						HighestValue=>x"ffffffff",Count=>L1totalCount);
	L2missMap : counter port map(WriteEnable=>EN,Clk=>L2miss,ClkRes=>clk,Reset=>ResetActiveHigh,
						HighestValue=>x"ffffffff",Count=>L2missCount);
	L2totalMap : counter port map(WriteEnable=>EN,Clk=>dataReadyL2,ClkRes=>clk,Reset=>ResetActiveHigh,
						HighestValue=>x"ffffffff",Count=>L2totalCount);

	setnotL1Miss : not_gate_n generic map(n=>32) port map(L1missCount, notL1missCount);
	getTotal : fulladder_32 port map(cin=>'1',x=>L1totalCount,y=>notL1missCount,
						z=>L1hitCount);

	setnotL2Miss : not_gate_n generic map(n=>32) port map(L2missCount, notL2missCount);
	getTotal2 : fulladder_32 port map(cin=>'1',x=>L2totalCount,y=>notL2missCount,
						z=>L2hitCount);

	l1_hit_cnt <= L1hitCount;
	l1_miss_cnt <= L1missCount;
	l1_evict_cnt <= L1missCount;
	l2_hit_cnt <= L2hitCount;
	l2_miss_cnt <= L2missCount;
	l2_evict_cnt <= L2missCount;

end structural;
