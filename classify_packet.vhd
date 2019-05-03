library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
USE ieee.numeric_std.ALL; 

entity classify_packet is
    Port ( iData_av : in  STD_LOGIC_VECTOR (3 downto 0);
           iRd_Data : out  STD_LOGIC_VECTOR (3 downto 0);
           iData1 : in  STD_LOGIC_VECTOR (5 downto 0);
           iData2 : in  STD_LOGIC_VECTOR (5 downto 0);
           iData3 : in  STD_LOGIC_VECTOR (5 downto 0);
           oData_av : out  STD_LOGIC;
			  oData_rd : in STD_LOGIC;
           oData : out  STD_LOGIC_VECTOR (5 downto 0); 
           MAC : in  STD_LOGIC;
			  valid : in STD_LOGIC;
           Opcode : out  STD_LOGIC;
           Rd_opcode : in  STD_LOGIC;
           Input_port : out  STD_LOGIC_VECTOR (3 downto 0);
           Port_mask : out  STD_LOGIC_VECTOR (3 downto 0);
           Edge_ports : inout  STD_LOGIC_VECTOR (3 downto 0);
           Core_Ports : inout  STD_LOGIC_VECTOR (3 downto 0);
			  gport : out  STD_LOGIC_VECTOR (3 downto 0);  --debug
			  ostatus : out STD_LOGIC_VECTOR(1 downto 0); --debug
			  oreadstatus : out STD_LOGIC_VECTOR(3 downto 0); --debug
			  debug : inout STD_LOGIC_VECTOR(1 downto 0); --debug
			  hoppointer_o : out STD_LOGIC_VECTOR(1 downto 0); --debug
			  pkt0_0 : out STD_LOGIC_VECTOR(5 downto 0);  --debug
			  pkt1_0 : out STD_LOGIC_VECTOR(5 downto 0);  --debug
			  pkt2_0 : out STD_LOGIC_VECTOR(5 downto 0);  --debug
			  pkt3_0 : out STD_LOGIC_VECTOR(5 downto 0);  --debug
			  pkt4_0 : out STD_LOGIC_VECTOR(5 downto 0);  --debug
			  counter_o : out STD_LOGIC_VECTOR(3 downto 0); --debug
			  ethertype_o : out STD_LOGIC; --debug
			  ethervalue_o : out STD_LOGIC; --debug
			  counter_index : out integer range 0 to 15 := 5; --debug
			  grantportint_o : out integer range 1 to 4;   --debug
			  addlpointer_o : out integer range 1 to 4;   --debug
			  addrpointer_o : out integer range 1 to 4;   --debug
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end classify_packet;

architecture Behavioral of classify_packet is
component rrarbiter is
--generic ( CNT : integer := 4 );
 port (
 clk   : in std_logic;
 rst_n : in std_logic;
 req   : in std_logic_vector(3 downto 0);
 ack   : in std_logic;
 grant : out   std_logic_vector(3 downto 0)
 );
 end component;
 
COMPONENT FIFO
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    rd_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    wr_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

type overallstatus is (idle,iav,oav,reading);
signal pstatus , nstatus : overallstatus := idle;
type status is (r0,r1,r2,r3,r4,rcont,r0out,r1out,r2out,r3out,r4out,rjustover,rover);
signal preadstatus , nreadstatus : status := r0;
signal currack , ready2push : std_logic := '0';
signal grantport : std_logic_vector(3 downto 0) := "0001";
signal grantportint : integer range 0 to 15;

type arrayofvector is array (0 to 2) of std_logic_vector(3 downto 0);
signal counter : arrayofvector := (others => (others => '0'));    --a counter for each port

signal allportzero : std_logic_vector(3 downto 0);
signal ethertype , ethervalue : std_logic;
signal opcodetmp : std_logic;

signal noofhops, hoppointer : std_logic_vector(1 downto 0);
signal pathvector : std_logic_vector(17 downto 0);
signal addlpointer , addrpointer : integer range 0 to 31;
signal targetMAC : std_logic;
signal seloutport : std_logic_vector (1 downto 0);

signal dropped : std_logic;
signal pkt0,pkt1,pkt2,pkt3,pkt4 : std_logic_vector(5 downto 0);
signal pktaddtmp : std_logic_vector(1 downto 0);

begin

process(clk)
begin
	if(rising_edge(clk)) then
		pstatus <= nstatus;
		preadstatus <= nreadstatus;
		input_port <= grantport;
		gport <= grantport;
		hoppointer_o <= hoppointer;
		ethertype_o <= ethertype;
		ethervalue_o <= ethervalue;
		counter_o <= counter(0);
		grantportint_o <= grantportint;
		addlpointer_o <= addlpointer;
		addrpointer_o <= addrpointer;
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

process(clk)
	begin
		if(rising_edge(clk)) then
			
			case nstatus is
				when idle => 
					case iData_av is                        --check if data available
						when "0000" => nstatus <= idle;
						when others => nstatus <= iav;
					end case;
					
				when iav => nstatus <= oav;
				when oav => nstatus <= reading;
				when reading =>
					case nreadstatus is
						when r0 => nreadstatus <= r1;
						when r1 => nreadstatus <= r2;
						when r2 => nreadstatus <= r3;
						when r3 => nreadstatus <= r4;
						when r4 => nreadstatus <= rcont; 
						when rcont => 
							case valid is                          --if still data exists
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
			rst_n => rst,
			req => iData_av,
			ack => currack,
			grant => grantport
);

process(clk)
begin
if (rising_edge(clk)) then	
			if (counter(0) > "0001") then                      --counter 0
				counter(0) <= counter(0) - "0001";
			else
				counter(0) <= counter(0);
			end if;
			
			if (counter(1) > "0001") then                      --counter 1
				counter(1) <= counter(1) - "0001";
			else
				counter(1) <= counter(1);
			end if;
			
			if (counter(2) > "0001") then                      --counter 2
				counter(2) <= counter(2) - "0001";
			else
				counter(2) <= counter(2);
			end if;	
			
			if (counter(0) = "0001") then                             --timer times out
					Edge_ports(0) <= '1';
					Core_ports(0) <= '0';
					--counter(0) <= "1111";
			end if;
			
			if (counter(1) = "0001") then                             --timer times out
					Edge_ports(1) <= '1';
					Core_ports(1) <= '0';
					--counter(1) <= "1111";
			end if;
			
			if (counter(2) = "0001") then                             --timer times out
					Edge_ports(2) <= '1';
					Core_ports(2) <= '0';
					--counter(2) <= "1111";
			end if;
			
case nstatus is
	when idle => case Core_ports is
						when "UUUU" => Core_ports <= "1111";
						when others => 
					end case;
					
					case Edge_ports is
						when "UUUU" => Edge_ports <= "0000";
						when others => 
					end case;
					 
					port_mask <= "0000";
					debug <= "00";
					--currack <= '1';
					--input_port <= "0000"; 
	
	when iav => currack <= '1';
		
	when oav => iRd_data <= grantport;
	
	when reading => 
		case nreadstatus is
			when r0 =>
				ethertype <= iData1(2);
				ethervalue <= iData1(1);
				opcodetmp <= iData1(1);
				
				counter_index <= to_integer(unsigned(grantport));
				grantportint <= integer(log2(real(to_integer(unsigned(grantport)))));
				
				
				pkt0 <= iData1;
			when r1 =>
				noofhops <= iData1(5 downto 4);
				hoppointer <= iData1(3 downto 2);
				--hoppointer_o <= hoppointer;
				
				if (opcodetmp = '0' and ((counter(grantportint)) > "0001" or counter(grantportint) = "0000")) then  --timer doesn't time-out
					Edge_ports(grantportint) <= '0';
					Core_ports(grantportint) <= '1';
					counter(grantportint) <= "1111";
				end if;
				
				pkt1 <= iData1;
				--debug <= "11";
				--debug <= hoppointer;-- + "01";               --if packet is of type inter-switch
			when r2 =>
				pkt2 <= iData1;
				debug <= hoppointer + "01";
				--pkt1(3) <= debug(1);
				--pkt1(2) <= debug(0);
			when r3 =>
				pkt3 <= iData1;
				pkt1(3) <= debug(1);
				pkt1(2) <= debug(0);
			when r4 =>
				ready2push <= '1';
				--pkt1(3) <= debug(1);
				--pkt1(2) <= debug(0);
				targetMAC <= iData1(1);
				pathvector <= "101010101010101010";
				--pathvector <= pkt1(1 downto 0) & pkt2 & pkt3 & iData1(5 downto 2);
				pkt4 <= iData1;
				if (hoppointer < noofhops) then
					--pktaddtmp <= pkt1(3) + '1';  --incrementing path pointer
					--pkt1(3) <= pktaddtmp(0);
					addlpointer <= to_integer(unsigned("10001"-("00"&hoppointer&'0')));    -- multiplication??????
					addrpointer <= to_integer(unsigned("10001"-(("00"&(hoppointer+"01")&'0')-"00001"))); --multiplication??????
					--seloutport <= "00";
					seloutport(1) <= pathvector(addrpointer+1);
					seloutport(0) <= pathvector(addrpointer);
					pkt0(1) <= '1'; --setting opcode
					Port_mask(0) <= '1';
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
				pkt4 <= iData1;
			when r0out =>
				ready2push <= '1';
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
				pkt0 <= "000000";
			when rover =>
				oData_av <= '1';
				currack <= '0';
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
	when '0' => Opcode <= opcodetmp;
	when '1' => Opcode <= opcodetmp;
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
    wr_en => ready2push,
    rd_en => oData_rd,
    dout => oData,
    full => open,
    empty => open,
    rd_data_count => open,
    wr_data_count => open
  );
  
end Behavioral;

