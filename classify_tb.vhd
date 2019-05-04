--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:05:11 05/04/2019
-- Design Name:   
-- Module Name:   /home/ajd12342/CS-226-Project/classify_tb.vhd
-- Project Name:  classify
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: classify_packet
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY classify_tb IS
END classify_tb;
 
ARCHITECTURE behavior OF classify_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT classify_packet
    PORT(
         iData_av : IN  std_logic_vector(31 downto 0);
         iRd_Data : OUT  std_logic_vector(31 downto 0);
         iData_in : IN  std_logic_vector(4607 downto 0);
         oData_av : OUT  std_logic;
         oData_rd : IN  std_logic;
         oData : OUT  std_logic_vector(143 downto 0);
         MAC : IN  std_logic_vector(47 downto 0);
         valid_in : IN  std_logic;
         valid_out : OUT  std_logic;
         Opcode : OUT  std_logic_vector(2 downto 0);
         Rd_opcode : IN  std_logic;
         Input_port : OUT  std_logic_vector(4 downto 0);
         Port_mask : OUT  std_logic_vector(31 downto 0);
         Edge_ports : INOUT  std_logic_vector(31 downto 0);
         Core_Ports : INOUT  std_logic_vector(31 downto 0);
         gport : OUT  std_logic_vector(31 downto 0);
         ostatus : OUT  std_logic_vector(1 downto 0);
         oreadstatus : OUT  std_logic_vector(3 downto 0);
         debug : INOUT  std_logic_vector(15 downto 0);
         hoppointer_o : OUT  std_logic_vector(15 downto 0);
         pkt0_0 : OUT  std_logic_vector(144 downto 0);
         pkt1_0 : OUT  std_logic_vector(144 downto 0);
         pkt2_0 : OUT  std_logic_vector(144 downto 0);
         pkt3_0 : OUT  std_logic_vector(144 downto 0);
         pkt4_0 : OUT  std_logic_vector(144 downto 0);
         counter_o : OUT  std_logic_vector(3 downto 0);
         ethertype_o : OUT  std_logic_vector(15 downto 0);
         ethervalue_o : OUT  std_logic_vector(15 downto 0);
         counter_index : OUT  std_logic_vector(0 to 3);
         grantportint_o : OUT  std_logic_vector(0 to 5);
         addlpointer_o : OUT  std_logic_vector(0 to 8);
         addrpointer_o : OUT  std_logic_vector(0 to 8);
         ready2push_o : OUT  std_logic;
         dropped_o : OUT  std_logic;
         isfull_o : OUT  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal iData_av : std_logic_vector(31 downto 0) := (others => '0');
   signal iData_in : std_logic_vector(4607 downto 0) := (others => '0');
   signal oData_rd : std_logic := '0';
   signal MAC : std_logic_vector(47 downto 0) := (others => '0');
   signal valid_in : std_logic := '0';
   signal Rd_opcode : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

	--BiDirs
   signal Edge_ports : std_logic_vector(31 downto 0);
   signal Core_Ports : std_logic_vector(31 downto 0);
   signal debug : std_logic_vector(15 downto 0);

 	--Outputs
   signal iRd_Data : std_logic_vector(31 downto 0);
   signal oData_av : std_logic;
   signal oData : std_logic_vector(143 downto 0);
   signal valid_out : std_logic;
   signal Opcode : std_logic_vector(2 downto 0);
   signal Input_port : std_logic_vector(4 downto 0);
   signal Port_mask : std_logic_vector(31 downto 0);
   signal gport : std_logic_vector(31 downto 0);
   signal ostatus : std_logic_vector(1 downto 0);
   signal oreadstatus : std_logic_vector(3 downto 0);
   signal hoppointer_o : std_logic_vector(15 downto 0);
   signal pkt0_0 : std_logic_vector(144 downto 0);
   signal pkt1_0 : std_logic_vector(144 downto 0);
   signal pkt2_0 : std_logic_vector(144 downto 0);
   signal pkt3_0 : std_logic_vector(144 downto 0);
   signal pkt4_0 : std_logic_vector(144 downto 0);
   signal counter_o : std_logic_vector(3 downto 0);
   signal ethertype_o : std_logic_vector(15 downto 0);
   signal ethervalue_o : std_logic_vector(15 downto 0);
   signal counter_index : std_logic_vector(0 to 3);
   signal grantportint_o : std_logic_vector(0 to 5);
   signal addlpointer_o : std_logic_vector(0 to 8);
   signal addrpointer_o : std_logic_vector(0 to 8);
   signal ready2push_o : std_logic;
   signal dropped_o : std_logic;
   signal isfull_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: classify_packet PORT MAP (
          iData_av => iData_av,
          iRd_Data => iRd_Data,
          iData_in => iData_in,
          oData_av => oData_av,
          oData_rd => oData_rd,
          oData => oData,
          MAC => MAC,
          valid_in => valid_in,
          valid_out => valid_out,
          Opcode => Opcode,
          Rd_opcode => Rd_opcode,
          Input_port => Input_port,
          Port_mask => Port_mask,
          Edge_ports => Edge_ports,
          Core_Ports => Core_Ports,
          gport => gport,
          ostatus => ostatus,
          oreadstatus => oreadstatus,
          debug => debug,
          hoppointer_o => hoppointer_o,
          pkt0_0 => pkt0_0,
          pkt1_0 => pkt1_0,
          pkt2_0 => pkt2_0,
          pkt3_0 => pkt3_0,
          pkt4_0 => pkt4_0,
          counter_o => counter_o,
          ethertype_o => ethertype_o,
          ethervalue_o => ethervalue_o,
          counter_index => counter_index,
          grantportint_o => grantportint_o,
          addlpointer_o => addlpointer_o,
          addrpointer_o => addrpointer_o,
          ready2push_o => ready2push_o,
          dropped_o => dropped_o,
          isfull_o => isfull_o,
          clk => clk,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
