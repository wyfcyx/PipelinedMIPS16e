--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:08:44 12/03/2018
-- Design Name:   
-- Module Name:   D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/cpu_project/reg_test.vhd
-- Project Name:  cpu_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg
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
 
ENTITY reg_test IS
END reg_test;
 
ARCHITECTURE behavior OF reg_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg
    PORT(
         SP_before : IN  std_logic_vector(15 downto 0);
         IH_before : IN  std_logic_vector(15 downto 0);
         reg_before : IN  std_logic_vector(127 downto 0);
         PC0 : IN  std_logic_vector(15 downto 0);
         Instruction : IN  std_logic_vector(15 downto 0);
         Target : IN  std_logic_vector(3 downto 0);
         Data : IN  std_logic_vector(15 downto 0);
         SP_after : OUT  std_logic_vector(15 downto 0);
         IH_after : OUT  std_logic_vector(15 downto 0);
         reg_after : OUT  std_logic_vector(127 downto 0);
         Rx : OUT  std_logic_vector(15 downto 0);
         Ry : OUT  std_logic_vector(15 downto 0);
         Rz : OUT  std_logic_vector(15 downto 0);
         Index : OUT  std_logic_vector(11 downto 0);
         led : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SP_before : std_logic_vector(15 downto 0) := (others => '0');
   signal IH_before : std_logic_vector(15 downto 0) := (others => '0');
   signal reg_before : std_logic_vector(127 downto 0) := (others => '0');
   signal PC0 : std_logic_vector(15 downto 0) := (others => '0');
   signal Instruction : std_logic_vector(15 downto 0) := (others => '0');
   signal Target : std_logic_vector(3 downto 0) := (others => '0');
   signal Data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal SP_after : std_logic_vector(15 downto 0);
   signal IH_after : std_logic_vector(15 downto 0);
   signal reg_after : std_logic_vector(127 downto 0);
   signal Rx : std_logic_vector(15 downto 0);
   signal Ry : std_logic_vector(15 downto 0);
   signal Rz : std_logic_vector(15 downto 0);
   signal Index : std_logic_vector(11 downto 0);
   signal led : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg PORT MAP (
          SP_before => SP_before,
          IH_before => IH_before,
          reg_before => reg_before,
          PC0 => PC0,
          Instruction => Instruction,
          Target => Target,
          Data => Data,
          SP_after => SP_after,
          IH_after => IH_after,
          reg_after => reg_after,
          Rx => Rx,
          Ry => Ry,
          Rz => Rz,
          Index => Index,
          led => led
        );

	process
	begin
		Target <= "0001";
		Data <= x"3456";
		wait for 1ms;
	end process;

END;
