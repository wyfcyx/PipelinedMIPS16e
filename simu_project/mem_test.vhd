--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:30:15 12/06/2018
-- Design Name:   
-- Module Name:   D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/simu_project/mem_test.vhd
-- Project Name:  simu_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memory
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
 
ENTITY mem_test IS
END mem_test;
 
ARCHITECTURE behavior OF mem_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory
    PORT(
         LFlag : IN  std_logic;
         SFlag : IN  std_logic;
         Address : IN  std_logic_vector(15 downto 0);
         DataS : IN  std_logic_vector(15 downto 0);
         InstructionAddress : IN  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         clk_scan : IN  std_logic;
         reset : IN  std_logic;
         Result : OUT  std_logic_vector(15 downto 0);
         Result_L_pointer : OUT  std_logic;
         Result_L : OUT  std_logic_vector(15 downto 0);
         InstructionResult : OUT  std_logic_vector(15 downto 0);
         Ram1Data : INOUT  std_logic_vector(15 downto 0);
         Ram1Addr : OUT  std_logic_vector(15 downto 0);
         Ram1OE : OUT  std_logic;
         Ram1WE : OUT  std_logic;
         Ram1EN : OUT  std_logic;
         dataReady : INOUT  std_logic;
         rdn : INOUT  std_logic;
         wrn : INOUT  std_logic;
         tbre : INOUT  std_logic;
         tsre : INOUT  std_logic;
         Ram2Data : INOUT  std_logic_vector(15 downto 0);
         Ram2Addr : OUT  std_logic_vector(15 downto 0);
         Ram2OE : OUT  std_logic;
         Ram2WE : OUT  std_logic;
         Ram2EN : OUT  std_logic;
         flashByte : OUT  std_logic;
         flashVpen : OUT  std_logic;
         flashCE : OUT  std_logic;
         flashOE : OUT  std_logic;
         flashWE : OUT  std_logic;
         flashRP : OUT  std_logic;
         flashAddr : OUT  std_logic_vector(22 downto 1);
         flashData : INOUT  std_logic_vector(15 downto 0);
         led : OUT  std_logic_vector(15 downto 0);
         started : OUT  std_logic;
         trigger : OUT  std_logic_vector(49 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal LFlag : std_logic := '0';
   signal SFlag : std_logic := '0';
   signal Address : std_logic_vector(15 downto 0) := (others => '0');
   signal DataS : std_logic_vector(15 downto 0) := (others => '0');
   signal InstructionAddress : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal clk_scan : std_logic := '0';
   signal reset : std_logic := '0';

	--BiDirs
   signal Ram1Data : std_logic_vector(15 downto 0);
   signal dataReady : std_logic;
   signal rdn : std_logic;
   signal wrn : std_logic;
   signal tbre : std_logic;
   signal tsre : std_logic;
   signal Ram2Data : std_logic_vector(15 downto 0);
   signal flashData : std_logic_vector(15 downto 0);

 	--Outputs
   signal Result : std_logic_vector(15 downto 0);
   signal Result_L_pointer : std_logic;
   signal Result_L : std_logic_vector(15 downto 0);
   signal InstructionResult : std_logic_vector(15 downto 0);
   signal Ram1Addr : std_logic_vector(15 downto 0);
   signal Ram1OE : std_logic;
   signal Ram1WE : std_logic;
   signal Ram1EN : std_logic;
   signal Ram2Addr : std_logic_vector(15 downto 0);
   signal Ram2OE : std_logic;
   signal Ram2WE : std_logic;
   signal Ram2EN : std_logic;
   signal flashByte : std_logic;
   signal flashVpen : std_logic;
   signal flashCE : std_logic;
   signal flashOE : std_logic;
   signal flashWE : std_logic;
   signal flashRP : std_logic;
   signal flashAddr : std_logic_vector(22 downto 1);
   signal led : std_logic_vector(15 downto 0);
   signal started : std_logic;
   signal trigger : std_logic_vector(49 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
   constant clk_scan_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memory PORT MAP (
          LFlag => LFlag,
          SFlag => SFlag,
          Address => Address,
          DataS => DataS,
          InstructionAddress => InstructionAddress,
          clk => clk,
          clk_scan => clk_scan,
          reset => reset,
          Result => Result,
          Result_L_pointer => Result_L_pointer,
          Result_L => Result_L,
          InstructionResult => InstructionResult,
          Ram1Data => Ram1Data,
          Ram1Addr => Ram1Addr,
          Ram1OE => Ram1OE,
          Ram1WE => Ram1WE,
          Ram1EN => Ram1EN,
          dataReady => dataReady,
          rdn => rdn,
          wrn => wrn,
          tbre => tbre,
          tsre => tsre,
          Ram2Data => Ram2Data,
          Ram2Addr => Ram2Addr,
          Ram2OE => Ram2OE,
          Ram2WE => Ram2WE,
          Ram2EN => Ram2EN,
          flashByte => flashByte,
          flashVpen => flashVpen,
          flashCE => flashCE,
          flashOE => flashOE,
          flashWE => flashWE,
          flashRP => flashRP,
          flashAddr => flashAddr,
          flashData => flashData,
          led => led,
          started => started,
          trigger => trigger
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   clk_scan_process :process
   begin
		clk_scan <= '0';
		wait for clk_scan_period/2;
		clk_scan <= '1';
		wait for clk_scan_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 50 ns;	
		reset <= '1';
		wait for 20ns;
		reset <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
