library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- pipeline is started
		started : in std_logic;
		-- scan clock
		clk_scan : in std_logic;
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
		led : out std_logic_vector(15 downto 0)
	);
end cpu;

architecture bhv of cpu is 
-- Global Regs lock
signal PC_in, PC_out : std_logic_vector(15 downto 0); -- r10
signal SP_in, SP_out : std_logic_vector(15 downto 0); -- r9
signal IH_in, IH_out : std_logic_vector(15 downto 0); -- r8
signal reg_in, reg_out : std_logic_vector(127 downto 0); -- r0(15 downto 0), r1(31 downto 16), ...
signal T_in, T_out : std_logic;
-- Local Regs lock
signal BranchPredict_in, BranchPredict_out : std_logic;
signal PredictionFailed_in, PredictionFailed_out : std_logic;
-- transfer signals
signal DataA, DataB : std_logic_vector(15 downto 0);
signal BranchTarget, BranchForce, BranchConfirm, BranchConfirmTarget : std_logic;
signal BranchFlagForward : std_logic;
-- IF/ID lock
signal IF_ID_PC0_in, IF_ID_PC0_out : std_logic_vector(15 downto 0);
signal IF_ID_Instruction_in, IF_ID_Instruction_out : std_logic_vector(15 downto 0);
signal IF_ID_Bubble_in, IF_ID_Bubble_out : std_logic_vector(2 downto 0);
-- ID/EX lock
signal ID_EX_LFlag_in, ID_EX_LFlag_out : std_logic;
signal ID_EX_SFlag_in, ID_EX_SFlag_out : std_logic;
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

		DataA, DataB, DataS : out std_logic_vector(15 downto 0)
	);
end component;

component alu is
	port(
		BranchFlag : in std_logic;
		DataA, DataB : in std_logic_vector(15 downto 0);
		AluInstruction : in std_logic_vector(3 downto 0);
		T_before : in std_logic;
		BranchTargetAlu : in std_logic_vector(15 downto 0);
		BranchFlagForward : out std_logic;
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
		InstructionAddress : in std_logic_vector(15 downto 0);
		clk : in std_logic;
		started : in std_logic;
		clk_scan : in std_logic;

		Result : out std_logic_vector(15 downto 0);
		InstructionResult : out std_logic_vector(15 downto 0);

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
	-- register-forward routes
	EX_MEM_LFlag_in <= ID_EX_LFlag_out;
	EX_MEM_SFlag_in <= ID_EX_SFlag_out;
	EX_MEM_RegisterTarget_in <= ID_EX_RegisterTarget_out;
	MEM_WB_RegisterTarget_in <= EX_MEM_RegisterTarget_out;
	-- component routes
	memory_instance : memory port map(
		-- in
		LFlag => EX_MEM_LFlag_out,
		SFlag => EX_MEM_SFlag_out,
		Address => EX_MEM_AluResult_out,
		DataS => EX_MEM_DataS_out,
		InstructionAddress => PC_out,
		-- out
		Result => MEM_WB_WriteInData_in,
		InstructionResult => IF_ID_Instruction_in,
		-- ram & comm
		clk => clk,
		started => started,
		clk_scan => clk_scan,
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
		Ram2EN => Ram2EN
	);
	
	decoder_instance : decoder port map(
		-- in
		ForceNop => PredictionFailed_out,
		PC0 => IF_ID_PC0_out,
		Bubble => IF_ID_Bubble_out,
		Instruction => IF_ID_Instruction_out,
		reg => reg_out,
		BranchPredict => BranchPredict_out,
		-- out
		LFlag => ID_EX_LFlag_in,
		SFlag => ID_EX_SFlag_in,
		BranchFlag => BranchFlag, 
		BranchForce => BranchForce,
		BranchTarget => BranchTarget,
		BranchTargetAlu => ID_EX_BranchTargetAlu_in,
		RegisterTarget => ID_EX_RegisterTarget_in,
		AluInstruction => ID_EX_AluInstruction_in,
		Immediate => ID_EX_Immediate_in,
		DataSelectorInstruction => ID_EX_DataSelectorInstruction_in,
		BubbleNext => IF_ID_Bubble_in
	);
	
	reg_instance : reg port map(
		-- in
		SP_before => SP_out, IH_before => IH_out,
		reg_before => reg_out,
		PC0 => IF_ID_PC0_out,
		Instruction => IF_ID_Instruction_out,
		Target => MEM_WB_RegisterTarget_out,
		Data => MEM_WB_WriteInData_out,
		-- out
		SP_after => SP_in, IH_after => IH_in,
		reg_after => reg_in,
		Rx => ID_EX_Rx_in, Ry => ID_EX_Ry_in, Rz => ID_EX_Rz_in,
		Index => ID_EX_Index_in,
		led => led
	);

	dataselector_instance : dataselector port map(
		-- in
		Data => ID_EX_Rz_out & ID_EX_Ry_out & ID_EX_Rx_out & ID_EX_Immediate_out;
		DataSelectorInstruction => ID_EX_DataSelectorInstruction_out,
		Index => ID_EX_Index_out,
		ModifiedIndex => ID_EX_ModifiedIndex_out,
		ModifiedValue => ID_EX_ModifiedValue_out,
		-- out
		DataA => DataA,
		DataB => DataB,
		DataS => EX_MEM_DataS_in
	);

	alu_instance : alu port map(
		-- in
		DataA => DataA,
		DataB => DataB,
		AluInstruction => ID_EX_AluInstruction_out,
		T => T_out,
		BranchTargetAlu => ID_EX_BranchTargetAlu_out,
		-- out
        BranchFlagForward => BranchFlagForward,
		BranchConfirm => BranchConfirm,
		BranchConfirmTarget => BranchConfirmTarget,
		Tout => T_in,
		Result => EX_MEM_AluResult_in
	);

	pcselector_instance : pcselector port map(
		-- in
		PC => PC_out,
		BranchPredict => BranchPredict_out,
		BranchFlag => BranchFlag,
		BranchForce => BranchForce, 
		BranchTarget => BranchTarget,
		BranchFlagForward => BranchFlagForward,
		BranchConfirm => BranchConfirm,
		BranchConfirmTarget => BranchConfirmTarget,
		-- out
        PC0 => IF_ID_PC0_in,
		PCNext => PC_in,
		PredictionFailed => PredictionFailed_in,
		BranchPredictNext => BranchPredict_in
	);
	-- dynamic routes
    
    
	process (clk)
	begin
		if (clk'event and clk = '1') then
			PC_out <= PC_in;
			SP_out <= SP_in;
			IH_out <= IH_in;
			reg_out <= reg_in;
			BranchPredict_out <= BranchPredict_in;
			PredictionFailed_out <= PredictionFailed_in;
			T_out <= T_in;

			IF_ID_PC0_out <= IF_ID_PC0_in;
			IF_ID_Instruction_out <= IF_ID_Instruction_in;
			IF_ID_Bubble_out <= IF_ID_Bubble_in;

			ID_EX_LFlag_out <= ID_EX_LFlag_in;
			ID_EX_SFlag_out <= ID_EX_SFlag_in;
			ID_EX_BranchTargetAlu_out <= ID_EX_BranchTargetAlu_in;
			ID_EX_RegisterTarget_out <= ID_EX_RegisterTarget_in;
			ID_EX_AluInstruction_out <= ID_EX_AluInstruction_in;
			ID_EX_Immediate_out <= ID_EX_Immediate_in;
			ID_EX_DataSelectorInstruction_out <= ID_EX_DataSelectorInstruction_in;
			ID_EX_Rx_out <= ID_EX_Rx_in;
			ID_EX_Ry_out <= ID_EX_Ry_in;
			ID_EX_Rz_out <= ID_EX_Rz_in;
			ID_EX_Index_out <= ID_EX_Index_in;
			ID_EX_ModifiedIndex_out <= ID_EX_ModifiedIndex_in;
			ID_EX_ModifiedValue_out <= ID_EX_ModifiedValue_in;

			EX_MEM_LFlag_out <= EX_MEM_LFlag_in;
			EX_MEM_SFlag_out <= EX_MEM_SFlag_in;
			EX_MEM_RegisterTarget_out <= EX_MEM_RegisterTarget_in;
			EX_MEM_AluResult_out <= EX_MEM_AluResult_in;
			EX_MEM_DataS_out <= EX_MEM_DataS_in;

			MEM_WB_RegisterTarget_out <= MEM_WB_RegisterTarget_in;
			MEM_WB_WriteInData_out <= MEM_WB_WriteInData_in;
		end if;
	end process;
end bhv;
