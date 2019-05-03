LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY classify_tb IS
END classify_tb;
 
ARCHITECTURE behavior OF classify_tb IS 
 
    COMPONENT classify_packet
    PORT(
			  iData_av : in  STD_LOGIC_VECTOR (3 downto 0);
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
           rst : in  STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal iData_av : std_logic_vector(3 downto 0) := (others => '0');
   signal iData1 : std_logic_vector(5 downto 0) := (others => '0');
   signal iData2 : std_logic_vector(5 downto 0) := (others => '0');
   signal iData3 : std_logic_vector(5 downto 0) := (others => '0');
   signal MAC : std_logic := '0';
	signal valid : std_logic := '0';
   signal Rd_opcode : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal iRd_Data : std_logic_vector(3 downto 0);
   signal oData_av : std_logic;
   signal oData : std_logic_vector(5 downto 0);
   signal Opcode : std_logic;
   signal Input_port : std_logic_vector(3 downto 0);
   signal Port_mask : std_logic_vector(3 downto 0);
   signal Edge_ports : std_logic_vector(3 downto 0);
   signal Core_Ports : std_logic_vector(3 downto 0);
	signal gport : STD_LOGIC_VECTOR (3 downto 0);  --debug
	signal ostatus : STD_LOGIC_VECTOR(1 downto 0); --debug
	signal oreadstatus : STD_LOGIC_VECTOR(3 downto 0); --debug
	signal debug : STD_LOGIC_VECTOR(1 downto 0); --debug
	signal hoppointer_o : STD_LOGIC_VECTOR(1 downto 0); --debug

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: classify_packet PORT MAP (
          iData_av => iData_av,
          iRd_Data => iRd_Data,
          iData1 => iData1,
          iData2 => iData2,
          iData3 => iData3,
          oData_av => oData_av,
          oData => oData,
          MAC => MAC,
			 valid => valid,
          Opcode => Opcode,
          Rd_opcode => Rd_opcode,
          Input_port => Input_port,
          Port_mask => Port_mask,
          Edge_ports => Edge_ports,
          Core_Ports => Core_Ports,
			 gport => gport,  --debug
			 ostatus => ostatus, --debug
			 oreadstatus => oreadstatus, --debug
			 debug => debug, --debug
			 hoppointer_o => hoppointer_o, --debug
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

      -- insert stimulus here 
		 iData_av <= "0001";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "110011";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '1';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "110111";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <='1';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "111011";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '1';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "110111";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '1';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "111011";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '1';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '1';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period;
		 
		 iData_av <= "0000";
		 iData1 <= "000000";
		 iData2 <= "000000";
		 iData3 <= "000000";
		 valid <= '0';
		 MAC <= '0';
		 Rd_opcode <= '0';
		 rst <= '0';
		 wait for clk_period*50;
		 
      wait;
   end process;

END;
