library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
USE ieee.numeric_std.ALL; 

entity classify_packet is
    Port ( iData_av : in  STD_LOGIC_VECTOR (32-1 downto 0);
           iRd_Data : out  STD_LOGIC_VECTOR (32-1 downto 0);
           iData0 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData1 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData2 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData3 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData4 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData5 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData6 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData7 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData8 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData9 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData10 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData11 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData12 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData13 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData14 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData15 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData16 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData17 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData18 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData19 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData20 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData21 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData22 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData23 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData24 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData25 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData26 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData27 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData28 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData29 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData30 : in  STD_LOGIC_VECTOR (143 downto 0);
			  iData31 : in  STD_LOGIC_VECTOR (143 downto 0);
           oData_av : out  STD_LOGIC;
			  oData_rd : in STD_LOGIC;
           oData : out  STD_LOGIC_VECTOR (143 downto 0);
           MAC : in  STD_LOGIC_vector(47 downto 0);
			  valid_in : in STD_LOGIC;
			  valid_out : out std_logic;
           Opcode : out  STD_LOGIC_vector(2 downto 0);
           Rd_opcode : in  STD_LOGIC;
           Input_port : out  STD_LOGIC_VECTOR (4 downto 0);
           Port_mask : out  STD_LOGIC_VECTOR (31 downto 0);
           Edge_ports : inout  STD_LOGIC_VECTOR (31 downto 0);
           Core_Ports : inout  STD_LOGIC_VECTOR (31 downto 0);
			  gport : out  STD_LOGIC_VECTOR (31 downto 0);  --debug
			  ostatus : out STD_LOGIC_VECTOR(1 downto 0); --debug
			  oreadstatus : out STD_LOGIC_VECTOR(3 downto 0); --debug
			  debug : inout STD_LOGIC_VECTOR(15 downto 0); --debug
			  hoppointer_o : out STD_LOGIC_VECTOR(15 downto 0); --debug
			  pkt0_0 : out STD_LOGIC_VECTOR(144 downto 0);  --debug
			  pkt1_0 : out STD_LOGIC_VECTOR(144 downto 0);  --debug
			  pkt2_0 : out STD_LOGIC_VECTOR(144 downto 0);  --debug
			  pkt3_0 : out STD_LOGIC_VECTOR(144 downto 0);  --debug
			  pkt4_0 : out STD_LOGIC_VECTOR(144 downto 0);  --debug
			  counter_o : out STD_LOGIC_VECTOR(23 downto 0); --debug
			  ethertype_o : out STD_LOGIC_vector(15 downto 0); --debug
			  ethervalue_o : out STD_LOGIC_vector(15 downto 0); --debug
			  counter_index : out integer range 0 to 15 := 0; --debug
			  grantportint_o : out integer range 1 to 32;   --debug
			  addlpointer_o : out integer range 0 to 479;   --debug
			  addrpointer_o : out integer range 0 to 479;   --debug
			  ready2push_o : out std_logic;
			  dropped_o : out std_logic;
			  isfull_o : out std_logic;
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end classify_packet;

architecture Behavioral of classify_packet is
component rrarbiter is
--generic ( CNT : integer := 4 );
 port (
 clk   : in std_logic;
 rst_n : in std_logic;
 req   : in std_logic_vector(31 downto 0);
 ack   : in std_logic;
 grant : out   std_logic_vector(31 downto 0)
 );
 end component;
 
COMPONENT FIFO
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(144 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(144 DOWNTO 0);
    full : OUT STD_LOGIC;
	 prog_full: OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    rd_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    wr_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;
type arrayofinput is array(0 to 31) of std_logic_vector(143 downto 0);
signal iData : arrayofinput := (others => (others => '0'));
signal odatanew: std_logic_vector(144 downto 0);
type overallstatus is (idle,iav,oav,reading);
signal pstatus , nstatus : overallstatus := idle;
type status is (r0,r1,r2,r3,r4,rcont,r0out,r1out,r2out,r3out,r4out,rjustover,rover);
signal preadstatus , nreadstatus : status := r0;
signal currack :  std_logic := '1';
signal ready2push : std_logic := '0';
signal grantport : std_logic_vector(31 downto 0) := (others => '0');
signal grantportint : integer range 0 to 31;

type arrayofvector is array (0 to 31) of std_logic_vector(23 downto 0);
signal counter : arrayofvector := (others => (others => '0'));    --a counter for each port

signal allportzero : std_logic_vector(31 downto 0);
signal ethertype , ethervalue : std_logic_vector(15 downto 0);
signal opcodetmp : std_logic_vector(7 downto 0);

signal noofhops, hoppointer : std_logic_vector(15 downto 0);
signal hoppointer_imp : std_logic_vector(5 downto 0); 
signal pathvector : std_logic_vector(479 downto 0);
signal addlpointer , addrpointer : integer range 0 to 479;
signal targetMAC : std_logic_vector(47 downto 0);
signal seloutport : std_logic_vector (4 downto 0);

signal dropped : std_logic;
signal ready2pushmodified: std_logic;
signal isempty: std_logic;
signal isfull: std_logic;
signal arbitrst: std_logic;
signal pkt0,pkt1,pkt2,pkt3,pkt4 : std_logic_vector(144 downto 0);
--signal pktaddtmp : std_logic_vector(4 downto 0);

begin
-- Map input vector to the iData array
iData(0) <= iData0;
iData(1) <= iData1;
iData(2) <= iData2;
iData(3) <= iData3;
iData(4) <= iData4;
iData(5) <= iData5;
iData(6) <= iData6;
iData(7) <= iData7;
iData(8) <= iData8;
iData(9) <= iData9;
iData(10) <= iData10;
iData(11) <= iData11;
iData(12) <= iData12;
iData(13) <= iData13;
iData(14) <= iData14;
iData(15) <= iData15;
iData(16) <= iData16;
iData(17) <= iData17;
iData(18) <= iData18;
iData(19) <= iData19;
iData(20) <= iData20;
iData(21) <= iData21;
iData(22) <= iData22;
iData(23) <= iData23;
iData(24) <= iData24;
iData(25) <= iData25;
iData(26) <= iData26;
iData(27) <= iData27;
iData(28) <= iData28;
iData(29) <= iData29;
iData(30) <= iData30;
iData(31) <= iData31;



-- Temp vars
ready2pushmodified<=ready2push and (not dropped);
odata_av <= not isempty;
odata <= odatanew(143 downto 0);
valid_out <= odatanew(144);
arbitrst <= rst or isfull;

--OneHot2Bin 
grantportint <= 
	0 when grantport = "00000000000000000000000000000001" else 
	1 when grantport = "00000000000000000000000000000010" else 
	2 when grantport = "00000000000000000000000000000100" else 
	3 when grantport = "00000000000000000000000000001000" else 
	4 when grantport = "00000000000000000000000000010000" else 
	5 when grantport = "00000000000000000000000000100000" else 
	6 when grantport = "00000000000000000000000001000000" else 
	7 when grantport = "00000000000000000000000010000000" else 
	8 when grantport = "00000000000000000000000100000000" else 
	9 when grantport = "00000000000000000000001000000000" else 
	10 when grantport = "00000000000000000000010000000000" else 
	11 when grantport = "00000000000000000000100000000000" else 
	12 when grantport = "00000000000000000001000000000000" else 
	13 when grantport = "00000000000000000010000000000000" else 
	14 when grantport = "00000000000000000100000000000000" else 
	15 when grantport = "00000000000000001000000000000000" else 
	16 when grantport = "00000000000000010000000000000000" else 
	17 when grantport = "00000000000000100000000000000000" else 
	18 when grantport = "00000000000001000000000000000000" else 
	19 when grantport = "00000000000010000000000000000000" else 
	20 when grantport = "00000000000100000000000000000000" else 
	21 when grantport = "00000000001000000000000000000000" else 
	22 when grantport = "00000000010000000000000000000000" else 
	23 when grantport = "00000000100000000000000000000000" else 
	24 when grantport = "00000001000000000000000000000000" else 
	25 when grantport = "00000010000000000000000000000000" else 
	26 when grantport = "00000100000000000000000000000000" else 
	27 when grantport = "00001000000000000000000000000000" else 
	28 when grantport = "00010000000000000000000000000000" else 
	29 when grantport = "00100000000000000000000000000000" else 
	30 when grantport = "01000000000000000000000000000000" else 
	31 when grantport = "10000000000000000000000000000000";
-- Main processes
process(rst,clk)
begin
	if(rising_edge(clk)) then
		pstatus <= nstatus;
		preadstatus <= nreadstatus;
		input_port <= std_logic_vector(to_unsigned(grantportint,5));
		gport <= grantport;
		hoppointer_o <= hoppointer;
		ethertype_o <= ethertype;
		ethervalue_o <= ethervalue;
		counter_o <= counter(0);
		grantportint_o <= grantportint;
		addlpointer_o <= addlpointer;
		addrpointer_o <= addrpointer;
		ready2push_o <= ready2push;
		dropped_o <= dropped;
		isfull_o <= isfull;
		pkt0_0 <= pkt0;
		pkt1_0 <= pkt1;
		pkt2_0 <= pkt2;
		pkt3_0 <= pkt3;
		pkt4_0 <= pkt4;
		if (nstatus = idle) then
			ostatus <= "00";
		elsif (nstatus = iav) then
			ostatus <= "01";
		elsif (nstatus = oav) then
			ostatus <= "10";
		else
			ostatus <= "11";
		end if;
		
		if (nreadstatus = r0) then
			oreadstatus <= "0000";
		elsif (nreadstatus = r1) then
			oreadstatus <= "0001";
		elsif (nreadstatus = r2) then
			oreadstatus <= "0010";
		elsif (nreadstatus = r3) then
			oreadstatus <= "0011";
		elsif (nreadstatus = r4) then
			oreadstatus <= "0100";
		elsif (nreadstatus = rcont) then
			oreadstatus <= "0101";
		elsif (nreadstatus = r0out) then
			oreadstatus <= "0110";
		elsif (nreadstatus = r1out) then
			oreadstatus <= "0111";
		elsif (nreadstatus = r2out) then
			oreadstatus <= "1000";
		elsif (nreadstatus = r3out) then
			oreadstatus <= "1001";
		elsif (nreadstatus = r4out) then
			oreadstatus <= "1010";
		elsif (nreadstatus = rjustover) then
			oreadstatus <= "1011";
		else 
			oreadstatus <= "1100";
		end if;
	end if;
end process;

process(rst,clk)
	begin
		if(rising_edge(clk)) then
			
			case nstatus is
				when idle =>  
					case iData_av is                        --check if data available
						when "00000000000000000000000000000000" => nstatus <= idle;
						when others => nstatus <= iav;
					end case;
				when iav => nstatus <= oav;
				when oav => 
					nstatus <= reading;
					nreadstatus <= r0;
				when reading =>
					case nreadstatus is
						when r0 => 
							if(valid_in='1') then 
								nreadstatus <= r1;
							end if;
						when r1 => nreadstatus <= r2;
						when r2 => nreadstatus <= r3;
						when r3 => nreadstatus <= r4;
						when r4 => nreadstatus <= rcont; 
						when rcont => 
							case valid_in is                          --if still data exists
								when '1' => nreadstatus <= rcont;
								when '0' => nreadstatus <= r0out;
								when others => 
							end case;
						when r0out => nreadstatus <= r1out;
						when r1out => nreadstatus <= r2out;
						when r2out => nreadstatus <= r3out;
						when r3out => nreadstatus <= rjustover;
						when rjustover => nreadstatus <= rover; 
						when rover => nreadstatus <= r0;          --read over
										  nstatus <= idle;
										  --ready2push <= '0';
						when others => 
					end case;
			end case;
	end if;
end process;

arbiter : rrarbiter 
port map (clk => clk,
			rst_n => arbitrst,
			req => iData_av,
			ack => currack,
			grant => grantport
);

process(rst,clk)
--variable code: std_logic_vector(grantportint' range);
begin
if (rising_edge(clk)) then	
			for i in counter' range loop
				if (counter(i) > "000000000000000000000001") then                      --counter 0
					counter(i) <= counter(i) - "000000000000000000000001";
				else
					counter(i) <= counter(i);
				end if;
			
				if (counter(i) = "000000000000000000000001") then                             --timer times out
						Edge_ports(i) <= '1';
						Core_ports(i) <= '0';
						--counter(i) <= "1111";
				end if;
			
			end loop;
			
case nstatus is
	when idle => case Core_ports is
						when "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" =>
						Core_ports <= "00000000000000000000000000000000";
						when others => 
					end case;
					
					case Edge_ports is
						when "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" => 
						Edge_ports <= "00000000000000000000000000000000";
						when others => 
					end case;
					 
					port_mask <= "00000000000000000000000000000000";
					debug <= "0000000000000000";
					iRd_Data <= "00000000000000000000000000000000";
					dropped <= '0';
					--currack <= '1';
					--input_port <= "0000"; 
	
	when iav => currack <= '0';
		
	when oav => 
	iRd_data <= grantport;
	counter_index <= to_integer(unsigned(grantport));
--	grantportint <= integer(log2(real(to_integer(unsigned(grantport)))));
	
--	code := (others => '0');
--	for N in grantport'RANGE loop
--		if grantport(N) = '1' then
--			code := code OR std_logic_vector(to_unsigned(N, code'LENGTH));
--		end if;
--	end loop;
--	grantportint <= code;
	
	when reading => 
		case nreadstatus is
			when r0 =>
				ethertype <= iData(grantportint)(47 downto 32);
				ethervalue <= iData(grantportint)(31 downto 16);
				opcodetmp <= iData(grantportint)(23 downto 16);
				
				
				pkt0 <= '1'&iData(grantportint);
			when r1 =>
				noofhops <= iData(grantportint)(143 downto 128);
				hoppointer <= iData(grantportint)(127 downto 112);
				--hoppointer_o <= hoppointer;
				
				if (opcodetmp = "00000001" and 
				((counter(grantportint)) > "000000000000000000000001" 
				or counter(grantportint) = "000000000000000000000000"))
				then  --timer doesn't time-out
					Edge_ports(grantportint) <= '0';
					Core_ports(grantportint) <= '1';
					counter(grantportint) <= "100110001001011010000001"; --10**7+1
				end if;
				
				pkt1 <= '1'&iData(grantportint);
				--debug <= "11";
				--debug <= hoppointer;-- + "01";               --if packet is of type inter-switch
			when r2 =>
				pkt2 <= '1'&iData(grantportint);
				debug <= hoppointer + "0000000000000001";
				hoppointer_imp <= hoppointer(5 downto 0);
				--pkt1(3) <= debug(1);
				--pkt1(2) <= debug(0);
			when r3 =>
				pkt3 <= '1'&iData(grantportint);
				pkt1(127 downto 112) <= debug;
				--pkt1(2) <= debug(0);
			when r4 =>
				ready2push <= '1';
				--pkt1(3) <= debug(1);
				--pkt1(2) <= debug(0);
				targetMAC <= iData(grantportint)(63 downto 16);
				--pathvector <= "101010101010101010";
				pathvector <= pkt1(111 downto 0) & pkt2(143 downto 0) & 
				pkt3(143 downto 0) & iData(grantportint)(143 downto 64);
				pkt4 <= '1'&iData(grantportint);
				if (hoppointer < noofhops) then
					--pktaddtmp <= pkt1(3) + '1';  --incrementing path pointer
					--pkt1(3) <= pktaddtmp(0);
					addlpointer <= to_integer(unsigned("111011111"-(hoppointer_imp&"000")));    -- multiplication??????
					addrpointer <= to_integer(unsigned("111011111"-(((hoppointer_imp+"000001")&"000")-"000000001"))); --multiplication??????
					--seloutport <= "00";
					seloutport(4) <= pathvector(addrpointer+4);
					seloutport(3) <= pathvector(addrpointer+3);
					seloutport(2) <= pathvector(addrpointer+2);
					seloutport(1) <= pathvector(addrpointer+1);
					seloutport(0) <= pathvector(addrpointer);
					--pkt0(1) <= '1'; --setting opcode
					pkt0(23 downto 16) <= "00000001";
					Port_mask(to_integer(unsigned(seloutport))) <= '1';  --setting dest. port
				else
					if (targetMAC = MAC) then
						opcodetmp <= opcodetmp;
					else
						dropped <= '1';
					end if;
				end if;
			when rcont =>
				--ready2push <= '1';
				pkt0 <= pkt1;
				pkt1 <= pkt2;
				pkt2 <= pkt3;
				pkt3 <= pkt4;
				pkt4 <= '1'&iData(grantportint);
			when r0out =>
				--ready2push <= '1';
				pkt0 <= pkt1;
				pkt1 <= pkt2;
				pkt2 <= pkt3;
				pkt3 <= pkt4;
			when r1out =>
				pkt0 <= pkt1;
				pkt1 <= pkt2;
				pkt2 <= pkt3;
			when r2out =>
				pkt0 <= pkt1;
				pkt1 <= pkt2;
			when r3out =>
				pkt0 <= pkt1;
			when rjustover =>
				pkt0 <= '0'&"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			when rover =>
				currack <= '1';
				ready2push <= '0';
			when others => 
		end case;
end case;

--case ready2push is	               --debug purpose			
--	when '0' => oData <= "000000";
--	when '1' => oData <= pkt0; 
--	when others =>
--end case; 

case Rd_opcode is                   -- reading our opcode from remote logic
	when '0' => Opcode <= "000";
	when '1' => 
	case opcodetmp is
		when "00000001" => Opcode <= "000";
		when "00000010" => Opcode <= "001";
		when "00000100" => Opcode <= "010";
		when "00001000" => Opcode <= "011";
		when "00010000" => Opcode <= "100";
		when "00100000" => Opcode <= "101";
		when "01000000" => Opcode <= "110";
		when "10000000" => Opcode <= "111";
		when others => 
	end case;
	when others =>
end case;
end if;
end process;

classify_fifo : FIFO
  PORT MAP (
    rst => rst,
    wr_clk => clk,
    rd_clk => clk,
    din => pkt0,
    wr_en => ready2pushmodified,--modified,
    rd_en => oData_rd,
    dout => oDatanew,
    full => open,
	 prog_full => isfull,
    empty => isempty,
    rd_data_count => open,
    wr_data_count => open
  );
  
end Behavioral;

