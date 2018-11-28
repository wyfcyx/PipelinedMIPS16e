library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;
		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		-- debug data output
		regOutput : out std_logic_vector(15 downto 0)
	);
end cpu;

architecture bhv of cpu is 
-- Global Regs lock
signal PC_in, PC_out : std_logic_vector(15 downto 0); -- r10
signal SP_in, SP_out : std_logic_vector(15 downto 0); -- r9
signal IH_in, IH_out : std_logic_vector(15 downto 0); -- r8
signal reg_in, reg_out : std_logic_vector(127 downto 0); -- r0(15 downto 0), r1(31 downto 16), ...
signal BranchPredict_in, BranchPredict_out : std_logic;
signal T_in, T_out : std_logic;
-- IF/ID lock
signal IF_ID_PC0_in, IF_ID_PC0_out : std_logic_vector(15 downto 0);
signal IF_ID_Instruction_in, IF_ID_Instruction_out : std_logic_vector(15 downto 0);
signal IF_ID_Bubble_in, IF_ID_Bubble_out : std_logic_vector(2 downto 0);
-- ID/EX lock
signal ID_EX_LFlag_in, ID_EX_LFlag_out : std_logic;
signal ID_EX_SFlag_in, ID_EX_SFlag_out : std_logic;
signal ID_EX_BranchFlag_in, ID_EX_BranchFlag_out : std_logic;
signal ID_EX_BranchTargetAlu_in, ID_EX_BranchTargetAlu_out : std_logic_vector(15 downto 0);
signal ID_EX_RegisterTarget_in, ID_EX_RegisterTarget_out : std_logic_vector(3 downto 0);
signal ID_EX_AluInstruction_in, ID_EX_AluInstruction_out : std_logic_vector(3 downto 0);
signal ID_EX_Immediate_in, ID_EX_Immediate_out : std_logic_vector(15 downto 0);
signal ID_EX_DataSelectorInstruction_in, ID_EX_DataSelectorInstruction_out : std_logic_vector(5 downto 0);
signal ID_EX_Rx_in, ID_EX_Rx_out : std_logic_vector(15 downto 0);
signal ID_EX_Ry_in, ID_EX_Ry_out : std_logic_vector(15 downto 0);
signal ID_EX_Rz_in, ID_EX_Rz_out : std_logic_vector(15 downto 0);
signal ID_EX_Index_in, ID_EX_Index_out : std_logic_vector(11 downto 0);
signal ID_EX_ModifiedIndex_in, ID_EX_ModifiedIndex_out : std_logic_vector(3 downto 0);
signal ID_EX_ModifiedValue_in, ID_EX_ModifiedValue_out : std_logic_vector(15 downto 0);
-- EX/MEM lock
signal EX_MEM_LFlag_in, EX_MEM_LFlag_out : std_logic;
signal EX_MEM_SFlag_in, EX_MEM_SFlag_out : std_logic;
signal EX_MEM_RegisterTarget_in, EX_MEM_RegisterTarget_out : std_logic_vector(3 downto 0);
signal EX_MEM_AluResult_in, EX_MEM_AluResult_out : std_logic_vector(15 downto 0);
signal EX_MEM_DataS_in, EX_MEM_DataS_out : std_logic_vector(15 downto 0);
-- MEM/WB lock
signal MEM_WB_RegisterTarget_in, MEM_WB_RegisterTarget_out : std_logic_vector(3 downto 0);
signal MEM_WB_WriteInData_in, MEM_WB_WriteInData_out : std_logic_vector(15 downto 0);

-- Components
component decoder is
	port(
		ForceNop : in std_logic;
		PC0 : in std_logic_vector(15 downto 0);
		Bubble : in std_logic_vector(2 downto 0);
		Instruction : in std_logic_vector(15 downto 0);
		BranchPredict : in std_logic;

		LFlag : out std_logic;
		SFlag : out std_logic;
		BranchFlag : out std_logic;
		BranchForce : out std_logic;
		BranchTarget : out std_logic_vector(15 downto 0);
		BranchTargetAlu : out std_logic_vector(15 downto 0);
		RegisterTarget : out std_logic_vector(3 downto 0);
		AluInstruction : out std_logic_vector(3 downto 0);
		Immediate : out std_logic_vector(15 downto 0);
		DataSelectorInstruction : out std_logic_vector(5 downto 0);
		BubbleNext : out std_logic_vector(2 downto 0)
	);
end component;

component reg is
	port(
		SP_before, IH_before : in std_logic_vector(15 downto 0);
		reg_before : in std_logic_vector(127 downto 0);
		PC0 : in std_logic_vector(15 downto 0);
		Instruction : in std_logic_vector(15 downto 0);
		Target : in std_logic_vector(3 downto 0);
		Data : in std_logic_vector(15 downto 0);

		SP_after, IH_after : out std_logic_vector(15 downto 0);
		reg_after : out std_logic_vector(127 downto 0);
		Rx, Ry, Rz : out std_logic_vector(15 downto 0);
		Index : out std_logic_vector(11 downto 0);
		led : out std_logic_vector(15 downto 0)
	);
end component;

component dataselector is
	port(
		Data : in std_logic_vector(63 downto 0);
		DataSelectorInstruction : in std_logic_vector(5 downto 0);
		Index : in std_logic_vector(11 downto 0);
		ModifiedIndex : in std_logic_vector(3 downto 0);
		ModifiedValue : in std_logic_vector(15 downto 0);

		DataA, DataB, DataS : out std_logic_vector(15 downto 0);
	);
end component;

component alu is
	port(
		BranchFlag : in std_logic;
		DataA, DataB : in std_logic_vector(15 downto 0);
		AluInstruction : in std_logic_vector(3 downto 0);
		T_before : in std_logic;
		BranchTargetAlu : in std_logic_vector(15 downto 0);

		BranchFlag : out std_logic;
		BranchConfirm : out std_logic;
		BranchTargetConfirm : out std_logic;
		T_after : out std_logic;
		Result : out std_logic_vector(15 downto 0)
	);
end component;

component pcselector is
	port(
		PC0 : in std_logic_vector(15 downto 0);
		BranchPredict : in std_logic;
		BranchFlag : in std_logic;
		BranchForce : in std_logic;
		BranchTarget : in std_logic_vector(15 downto 0);
		BranchFlagForward : in std_logic;
		BranchConfirm : in std_logic;
		BranchTargetConfirm : in std_logic_vector(15 downto 0);
		
		PCNext : out std_logic_vector(15 downto 0);
		PredictionFailed : out std_logic;
		BranchPredictNext : out std_logic
	);
end component;

component memory is
	port(
		LFlag, SFlag : in std_logic;
		Address : in std_logic_vector(15 downto 0);
		DataS : in std_logic_vector(15 downto 0);

		Result : out std_logic_vector(15 downto 0);

		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;
		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic
	);
end component;
begin
	-- static routes
	-- dynamic routes
end bhv;
		
		
