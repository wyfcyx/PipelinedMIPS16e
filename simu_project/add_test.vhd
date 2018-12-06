--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:14:25 12/07/2018
-- Design Name:   
-- Module Name:   D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/simu_project/add_test.vhd
-- Project Name:  simu_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY add_test IS
END add_test;
 
ARCHITECTURE bhv OF add_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	
			signal DataA : std_logic_vector(15 downto 0);
        signal DataB : std_logic_vector(15 downto 0);
        signal AluInstruction : std_logic_vector(3 downto 0);
        signal T : std_logic;
        signal BranchTargetAlu : std_logic_vector(15 downto 0);
        signal RegisterTarget : std_logic_vector(3 downto 0);
        signal ModifiedIndex_before : std_logic_vector(3 downto 0);
        signal ModifiedValue_before : std_logic_vector(15 downto 0);
        signal SFlag : std_logic;
        signal PC0 : std_logic_vector(15 downto 0);

        signal BranchFlagForward : std_logic;
        signal BranchConfirm :  std_logic;
        signal BranchTargetConfirm : std_logic_vector(15 downto 0);
        signal Tout : std_logic;
        signal Result: std_logic_vector(15 downto 0);
        signal ModifiedIndex : std_logic_vector(3 downto 0);
        signal ModifiedValue : std_logic_vector(15 downto 0);
        signal NextForceNop : std_logic;
        signal BubbleNext_Alu : std_logic_vector(2 downto 0);
        signal BranchForce_Alu : std_logic;
        signal BranchTarget_Alu : std_logic_vector(15 downto 0);
		  
		  signal Result0 : std_logic_vector(15 downto 0) := (others =>'0');
begin
Result <= Result0;
process(DataA, DataB, AluInstruction, T, BranchTargetAlu, RegisterTarget, ModifiedIndex_before, ModifiedValue_before)
begin
    
    
    
    -- AND
    if (AluInstruction(3 downto 0) = "0101") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result0 <= (DataA(15) and DataB(15)) & (DataA(14) and DataB(14)) & (DataA(13) and DataB(13)) & (DataA(12) and DataB(12)) & (DataA(11) and DataB(11)) & (DataA(10) and DataB(10)) & (DataA(9) and DataB(9)) & (DataA(8) and DataB(8)) & (DataA(7) and DataB(7)) & (DataA(6) and DataB(6)) & (DataA(5) and DataB(5)) & (DataA(4) and DataB(4)) & (DataA(3) and DataB(3)) & (DataA(2) and DataB(2)) & (DataA(1) and DataB(1)) & (DataA(0) and DataB(0));
    end if;
    -- JR
    if (AluInstruction(3 downto 0) = "1010") then
        BranchFlagForward <= '1';
        BranchConfirm <= ((DataA(0) xor DataB(0)) or (DataA(1) xor DataB(1)) or (DataA(2) xor DataB(2)) or (DataA(3) xor DataB(3)) or (DataA(4) xor DataB(4)) or (DataA(5) xor DataB(5)) or (DataA(6) xor DataB(6)) or (DataA(7) xor DataB(7)) or (DataA(8) xor DataB(8)) or (DataA(9) xor DataB(9)) or (DataA(10) xor DataB(10)) or (DataA(11) xor DataB(11)) or (DataA(12) xor DataB(12)) or (DataA(13) xor DataB(13)) or (DataA(14) xor DataB(14)) or (DataA(15) xor DataB(15)));
        BranchTargetConfirm <= DataA;
        Tout <= T;
        Result0 <= "0000000000000000";
    end if;
    
    if (RegisterTarget = "1111") then
        ModifiedIndex <= ModifiedIndex_before;
        ModifiedValue <= ModifiedValue_before;
    else
        ModifiedIndex <= RegisterTarget;
        ModifiedValue <= Result0;
    end if;
    
    if (SFlag = '1' and Result0(15 downto 14) = "00") then
        NextForceNop <= '1';
        BubbleNext_Alu <= "010";
        BranchForce_Alu <= '1';
        BranchTarget_Alu <= PC0;
    else
        NextForceNop <= '0';
        BubbleNext_Alu <= "000";
        BranchForce_Alu <= '0';
        BranchTarget_Alu <= "0000000000000000";
    end if;
end process;

process
begin
	wait for 100ns;
	DataA <= x"0001";
	DataB <= x"0001";
	AluInstruction <= "0101";
end process;
end bhv;
    