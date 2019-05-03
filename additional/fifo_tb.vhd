--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:46:27 05/03/2019
-- Design Name:   
-- Module Name:   /home/soumya/ISE-Projects/FIFO/tb1.vhd
-- Project Name:  FIFO
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fifo
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
 
ENTITY tb1 IS
END tb1;
 
ARCHITECTURE behavior OF tb1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo
    PORT(
         rst : IN  std_logic;
         wr_clk : IN  std_logic;
         rd_clk : IN  std_logic;
         din : IN  std_logic_vector(5 downto 0);
         wr_en : IN  std_logic;
         rd_en : IN  std_logic;
         dout : OUT  std_logic_vector(5 downto 0);
         full : OUT  std_logic;
         empty : OUT  std_logic;
         rd_data_count : OUT  std_logic_vector(3 downto 0);
         wr_data_count : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal wr_clk : std_logic := '0';
   signal rd_clk : std_logic := '0';
   signal din : std_logic_vector(5 downto 0) := (others => '0');
   signal wr_en : std_logic := '0';
   signal rd_en : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(5 downto 0);
   signal full : std_logic;
   signal empty : std_logic;
   signal rd_data_count : std_logic_vector(3 downto 0);
   signal wr_data_count : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant wr_clk_period : time := 10 ns;
   constant rd_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo PORT MAP (
          rst => rst,
          wr_clk => wr_clk,
          rd_clk => rd_clk,
          din => din,
          wr_en => wr_en,
          rd_en => rd_en,
          dout => dout,
          full => full,
          empty => empty,
          rd_data_count => rd_data_count,
          wr_data_count => wr_data_count
        );

   -- Clock process definitions
   wr_clk_process :process
   begin
		wr_clk <= '0';
		wait for wr_clk_period/2;
		wr_clk <= '1';
		wait for wr_clk_period/2;
   end process;
 
   rd_clk_process :process
   begin
		rd_clk <= '0';
		wait for rd_clk_period/2;
		rd_clk <= '1';
		wait for rd_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		rst <= '1';
		wait for 10 ns;
		rst <= '0';
		wait for 100 ns;
		
		din <= "000001";
		wr_en <= '1';
		wait for wr_clk_period;
		wr_en <= '0';
		din <= "XXXXXX";
--		wait for wr_clk_period;
		
		din <= "000011";
		wr_en <= '1';
		wait for wr_clk_period;
		wr_en <= '0';
		din <= "XXXXXX";
--		wait for wr_clk_period;
		
		din <= "000111";
		wr_en <= '1';
		wait for wr_clk_period;
		wr_en <= '0';
		din <= "XXXXXX";
		wait for 3*wr_clk_period;
		
		rd_en <= '1';
		wait for rd_clk_period;
		rd_en <= '0';
--		wait for rd_clk_period;
		
		rd_en <= '1';
		wait for rd_clk_period;
		rd_en <= '0';
--		wait for rd_clk_period;
		
		rd_en <= '1';
		wait for rd_clk_period;
		rd_en <= '0';
--		wait for rd_clk_period;
		
      wait for wr_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
