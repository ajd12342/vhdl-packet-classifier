library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL; 

entity classify_packet is
    Port ( iData_av : in  STD_LOGIC_VECTOR (3 downto 0);
           iRd_Data : out  STD_LOGIC_VECTOR (3 downto 0);
           iData1 : in  STD_LOGIC_VECTOR (5 downto 0);
           iData2 : in  STD_LOGIC_VECTOR (5 downto 0);
           iData3 : in  STD_LOGIC_VECTOR (5 downto 0);
           oData_av : out  STD_LOGIC;
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
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC);
end classify_packet;

architecture Behavioral of classify_packet is
component rrarbiter is
generic ( CNT : integer := 4 );
 port (
 clk   : in std_logic;
 rst_n : in std_logic;
 req   : in std_logic_vector(CNT-1 downto 0);
 ack   : in std_logic;
 grant : out   std_logic_vector(CNT-1 downto 0)
 );
 end component;

type overallstatus is (idle,iav,oav,reading);
signal pstatus , nstatus : overallstatus := idle;
type status is (r0,r1,r2,r3,r4,rcont,r0out,r1out,r2out,r3out,r4out,rover);
signal preadstatus , nreadstatus : status := r0;
signal currack , ready2push : std_logic := '0';
signal grantport : std_logic_vector(3 downto 0) := "0000";

type arrayofvector is array (0 to 2) of std_logic_vector(3 downto 0);
signal counter : arrayofvector;    --a counter for each port

signal allportzero : std_logic_vector(3 downto 0);
signal ethertype , ethervalue : std_logic;
signal opcodetmp : std_logic;

signal noofhops, hoppointer : std_logic_vector(1 downto 0);
signal pathvector : std_logic_vector(17 downto 0);
signal addlpointer , addrpointer : std_logic_vector(4 downto 0);
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
		else
			oreadstatus <= "1011";
		end if;
	end if;
end process;

process(clk)
	begin
		if(rising_edge(clk)) then
			
			case nstatus is
				when idle => 
					case iData_av is                        --check if data available
						when "0000" => nstatus <= pstatus;
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
						when r3out => nreadstatus <= rover;
						when rover => nreadstatus <= r0;          --read over
										  nstatus <= idle;
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
			if (counter(0) > 0) then                      --counter 0
				counter(0) <= counter(0) - "0001";
			else
				counter(0) <= counter(0);
			end if;
			
			if (counter(1) > 0) then                      --counter 1
				counter(1) <= counter(1) - "0001";
			else
				counter(1) <= counter(1);
			end if;
			
			if (counter(2) > 0) then                      --counter 2
				counter(2) <= counter(2) - "0001";
			else
				counter(2) <= counter(2);
			end if;	
			
case nstatus is
	when idle => case Core_ports is
						when "UUUU" => Core_ports <= "0000";
						when others => 
					end case;
					
					case Edge_ports is
						when "UUUU" => Edge_ports <= "0000";
						when others => 
					end case;
					
					port_mask <= "0000";
					debug <= "00";
					--input_port <= "0000"; 
	
	when iav => currack <= '1';
		
	when oav => iRd_data <= grantport;
	
	when reading => 
		case nreadstatus is
			when r0 =>
				ethertype <= iData1(2);
				ethervalue <= iData1(1);
				opcodetmp <= ethervalue;
				if (opcodetmp = '0') then               --if packet is of type inter-switch
					if (counter(to_integer(unsigned(grantport))) > 0) then  --timer doesn't time-out
						Edge_ports(to_integer(unsigned(grantport))) <= '0';
						Core_ports(to_integer(unsigned(grantport))) <= '1';
					else                              --timer times out
						Edge_ports(to_integer(unsigned(grantport))) <= '1';
						Core_ports(to_integer(unsigned(grantport))) <= '0';
					end if;
					counter(to_integer(unsigned(grantport))) <= "1111";
				end if;
				pkt0 <= iData1;
			when r1 =>
				noofhops <= iData1(5 downto 4);
				hoppointer <= iData1(3 downto 2);
				--hoppointer_o <= hoppointer;
				pkt1 <= iData1;
				--debug <= "11";
				--debug <= hoppointer;-- + "01";
				pkt1(3) <= debug(1);
				pkt1(2) <= debug(0);
			when r2 =>
				debug <= hoppointer + "01";
				pkt2 <= iData1;
			when r3 =>
				ready2push <= '1';
				pkt3 <= iData1;
			when r4 =>
				ready2push <= '1';
				targetMAC <= iData1(1);
				pathvector <= pkt1(1 downto 0) & pkt2 & pkt3 & iData1(5 downto 2);
				pkt4 <= iData1;
				if (hoppointer < noofhops) then
					--pktaddtmp <= pkt1(3) + '1';  --incrementing path pointer
					--pkt1(3) <= pktaddtmp(0);
					addlpointer <= "10010"-(hoppointer&'0');    -- multiplication??????
					addrpointer <= "10010"-((hoppointer+"01")&'0'); --multiplication??????
					seloutport <= pathvector(to_integer(unsigned(addlpointer)) downto (to_integer(unsigned(addrpointer))));
					pkt0(1) <= '1'; --setting opcode
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
			when rover =>
				oData_av <= '1';
				currack <= '0';
			when others => 
		end case;
end case;

case ready2push is	               --debug purpose			
	when '0' => oData <= "000000";
	when '1' => oData <= pkt0;
	when others =>
end case;

case Rd_opcode is                   -- reading our opcode from remote logic
	when '0' => Opcode <= '0';
	when '1' => Opcode <= opcodetmp;
	when others =>
end case;
end if;
end process;

end Behavioral;

