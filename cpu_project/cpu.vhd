library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- scan clock
		clk_scan : in std_logic;
		reset : in std_logic;
		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;
		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		-- flash
		
		flashByte : out std_logic;
		flashVpen : out std_logic;
		flashCE : out std_logic;
		flashOE : out std_logic;
		flashWE : out std_logic;
		flashRP : out std_logic;
		flashAddr : out std_logic_vector(22 downto 1);
		flashData : inout std_logic_vector(15 downto 0);
		-- debug data output
		led : out std_logic_vector(15 downto 0);
		started : out std_logic
	);
end cpu;

architecture bhv of cpu is 
-- Global Regs lock
signal PC_in, PC_out : std_logic_vector(15 downto 0) := (others => '0'); -- r10
signal SP_in, SP_out : std_logic_vector(15 downto 0) := (others => '0'); -- r9
signal IH_in, IH_out : std_logic_vector(15 downto 0) := (others => '0'); -- r8
signal reg_in, reg_out : std_logic_vector(127 downto 0) := (others => '0'); -- r0(15 downto 0), r1(31 downto 16), ...
signal T_in, T_out : std_logic := '0';
-- Local Regs lock
signal BranchPredict_in, BranchPredict_out : std_logic := '0';
signal PredictionFailed_in, PredictionFailed_out : std_logic := '0';
-- transfer signals
signal DataA, DataB : std_logic_vector(15 downto 0);
signal BranchForce, BranchConfirm, BranchFlag, BranchForce_Alu : std_logic := '0';
signal BranchTarget, BranchConfirmTarget, BranchTarget_Alu : std_logic_vector(15 downto 0) := (others => '0');
signal BranchFlagForward : std_logic := '0';
signal Data : std_logic_vector(63 downto 0) := (others => '0');
-- IF/ID lock
signal IF_ID_PC0_in, IF_ID_PC0_out : std_logic_vector(15 downto 0) := (others => '0');
signal IF_ID_Instruction_in, IF_ID_Instruction_out : std_logic_vector(15 downto 0) := (others => '0');
signal IF_ID_Bubble_in, IF_ID_Bubble_out : std_logic_vector(2 downto 0) := "000";

signal IF_ID_Bubble_in_Alu : std_logic_vector(2 downto 0) := "000";
-- ID/EX lock
signal ID_EX_PC0_in, ID_EX_PC0_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_LFlag_in, ID_EX_LFlag_out : std_logic := '0';
signal ID_EX_SFlag_in, ID_EX_SFlag_out : std_logic := '0';
signal ID_EX_BranchTargetAlu_in, ID_EX_BranchTargetAlu_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_RegisterTarget_in, ID_EX_RegisterTarget_out : std_logic_vector(3 downto 0) := (others => '1');
signal ID_EX_AluInstruction_in, ID_EX_AluInstruction_out : std_logic_vector(3 downto 0) := (others => '0');
signal ID_EX_Immediate_in, ID_EX_Immediate_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_DataSelectorInstruction_in, ID_EX_DataSelectorInstruction_out : std_logic_vector(5 downto 0) := (others => '0');
signal ID_EX_Rx_in, ID_EX_Rx_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_Ry_in, ID_EX_Ry_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_Rz_in, ID_EX_Rz_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_Index_in, ID_EX_Index_out : std_logic_vector(11 downto 0) := (others => '0');
signal ID_EX_ModifiedIndex_in, ID_EX_ModifiedIndex_out : std_logic_vector(3 downto 0) := "1111";
signal ID_EX_ModifiedValue_in, ID_EX_ModifiedValue_out : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_ModifiedValue_in_L : std_logic_vector(15 downto 0) := (others => '0');
signal ID_EX_ModifiedValue_in_L_pointer : std_logic := '0';
signal ID_EX_NextForceNop_in : std_logic := '0';
-- EX/MEM lock
signal EX_MEM_LFlag_in, EX_MEM_LFlag_out : std_logic := '0';
signal EX_MEM_SFlag_in, EX_MEM_SFlag_out : std_logic := '0';
signal EX_MEM_RegisterTarget_in, EX_MEM_RegisterTarget_out : std_logic_vector(3 downto 0) := "1111";
signal EX_MEM_AluResult_in, EX_MEM_AluResult_out : std_logic_vector(15 downto 0) := (others => '0');
signal EX_MEM_DataS_in, EX_MEM_DataS_out : std_logic_vector(15 downto 0) := (others => '0');
-- MEM/WB lock
signal MEM_WB_RegisterTarget_in, MEM_WB_RegisterTarget_out : std_logic_vector(3 downto 0) := "1111";
signal MEM_WB_WriteInData_in, MEM_WB_WriteInData_out : std_logic_vector(15 downto 0) := (others => '0');
-- debug led
signal led_reg : std_logic_vector(15 downto 0) := (others => '0');
signal led_test : std_logic_vector(15 downto 0) := (others => '0');
signal led_memory : std_logic_vector(15 downto 0) := (others => '0');
signal startedCache : std_logic := '0';
-- Components
component decoder is
	port(
		ForceNop : in std_logic;
		PC0 : in std_logic_vector(15 downto 0);
		Bubble : in std_logic_vector(2 downto 0);
		Instruction : in std_logic_vector(15 downto 0);
		BranchPredict : in std_logic;
		reg : in std_logic_vector(127 downto 0);

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
		DataA, DataB : in std_logic_vector(15 downto 0);
		AluInstruction : in std_logic_vector(3 downto 0);
		T : in std_logic;
		BranchTargetAlu : in std_logic_vector(15 downto 0);
		
		RegisterTarget : in std_logic_vector(3 downto 0);
        ModifiedIndex_before : in std_logic_vector(3 downto 0);
        ModifiedValue_before : in std_logic_vector(15 downto 0);
		
		SFlag : in std_logic;
        PC0 : in std_logic_vector(15 downto 0);

        BranchFlagForward : out std_logic;
        BranchConfirm : out std_logic;
        BranchTargetConfirm : out std_logic_vector(15 downto 0);
        Tout : out std_logic;
        Result: out std_logic_vector(15 downto 0);
        
        ModifiedIndex : out std_logic_vector(3 downto 0);
        ModifiedValue : out std_logic_vector(15 downto 0);
        
        NextForceNop : out std_logic;
        BubbleNext_Alu : out std_logic_vector(2 downto 0);
        BranchForce_Alu : out std_logic;
        BranchTarget_Alu : out std_logic_vector(15 downto 0)
	);
end component;

component pcselector is
	port(
		PC : in std_logic_vector(15 downto 0);
		BranchPredict : in std_logic;
		BranchFlag : in std_logic;
		BranchForce : in std_logic;
		BranchTarget : in std_logic_vector(15 downto 0);
		BranchFlagForward : in std_logic;
		BranchConfirm : in std_logic;
		BranchTargetConfirm : in std_logic_vector(15 downto 0);
        
        BranchForce_Alu: in std_logic;
        BranchTarget_Alu: in std_logic_vector(15 downto 0);
		
		PC0 : out std_logic_vector(15 downto 0);
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
		clk_scan : in std_logic;
		reset : in std_logic;
		
		Result : out std_logic_vector(15 downto 0);
        Result_L_pointer : out std_logic;
        Result_L : out std_logic_vector(15 downto 0);
		InstructionResult : out std_logic_vector(15 downto 0);

		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;

		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		
		-- flash
		flashByte : out std_logic;
		flashVpen : out std_logic;
		flashCE : out std_logic;
		flashOE : out std_logic;
		flashWE : out std_logic;
		flashRP : out std_logic;
		flashAddr : out std_logic_vector(22 downto 1);
		flashData : inout std_logic_vector(15 downto 0);
		
		-- led
		led : out std_logic_vector(15 downto 0);
		started : out std_logic
	);
end component;
begin
	-- led-debug setting
	--led <= ID_EX_RegisterTarget_in & ID_EX_AluInstruction_in & ID_EX_DataSelectorInstruction_in & IF_ID_Bubble_in(1 downto 0);
	--led <= IF_ID_Instruction_out;
	--led <= IF_ID_Instruction_out(15 downto 8) & ID_EX_Immediate_in(3 downto 0) & IF_ID_PC0_out(3 downto 0);
	--led <= ID_EX_RegisterTarget_in;
	--led <= PC_in;
	--led <= ID_EX_AluInstruction_in(3 downto 0) & ID_EX_Rx_in(3 downto 0) & EX_MEM_AluResult_in(3 downto 0) & DataA(3 downto 0);
	--led <= IF_ID_Bubble_out(2 downto 0) & IF_ID_Instruction_out(15 downto 11) & IF_ID_PC0_out(3 downto 0) & ID_EX_AluInstruction_in(3 downto 0);
	--led <= PC_out(3 downto 0) & IF_ID_PC0_in(3 downto 0) & BranchTarget(2 downto 0) &  BranchForce& IF_ID_Instruction_in(3 downto 0);
	--led <= led_reg;
	--led <= IF_ID_Bubble_out(2 downto 0) & BranchForce& IF_ID_Instruction_out(3 downto 0) & IF_ID_PC0_out(3 downto 0) & ID_EX_AluInstruction_in(3 downto 0);
	--led <= IF_ID_Bubble_out(2 downto 0) & IF_ID_Instruction_out(15 downto 11) & IF_ID_PC0_out(3 downto 0) & ID_EX_AluInstruction_in(3 downto 0);
	--led <= ID_EX_AluInstruction_out(3 downto 0) & ID_EX_Rx_out(3 downto 0) & EX_MEM_AluResult_out(3 downto 0) & DataA(3 downto 0);
	--led <= EX_MEM_AluResult_out(11 downto 8) & DataB(3 downto 0) & ID_EX_ModifiedIndex_out(3 downto 0) & ID_EX_ModifiedValue_out(11 downto 8);
	--led <= ID_EX_ModifiedIndex_out(3 downto 0) & ID_EX_ModifiedValue_out(7 downto 4) & ID_EX_Ry_out(7 downto 4) & EX_MEM_DataS_in(7 downto 4);
	--led <= EX_MEM_DataS_out(7 downto 4) & EX_MEM_AluResult_out(15 downto 12) & EX_MEM_LFlag_out & EX_MEM_SFlag_out & "00" & MEM_WB_WriteInData_in(7 downto 4);
	--led <= led_memory;
	--led <= EX_MEM_RegisterTarget_out & MEM_WB_WriteInData_in(7 downto 4) & DataA(7 downto 4) & DataB(7 downto 4);
	--led <= PC_out(3 downto 0) & BranchConfirmTarget(3 downto 0) & BranchPredict_out & BranchFlag & BranchForce & BranchFlagForward & BranchConfirm & PredictionFailed_in & BranchPredict_in & "0";
	--led <= reg_out(7 downto 0) & reg_out(23 downto 16);
	--led <= EX_MEM_DataS_out(7 downto 0) & EX_MEM_AluResult_out(7 downto 0);
	--led <= EX_MEM_DataS_in(11 downto 8) & ID_EX_ModifiedValue_out(11 downto 8) & ID_EX_ModifiedIndex_out(1 downto 0) & ID_EX_DataSelectorInstruction_out(5 downto 0);
	--led <= IF_ID_Instruction_out(15 downto 6) & EX_MEM_LFlag_out & EX_MEM_SFlag_out & PC_out(3 downto 0);
	--led <= EX_MEM_AluResult_out(15 downto 2) & EX_MEM_LFlag_out & EX_MEM_SFlag_out;
	led <= PC_out;
	-- register-forward routes
	started <= startedCache;
    ID_EX_PC0_in <= IF_ID_PC0_out;
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
        Result_L_pointer => ID_EX_ModifiedValue_in_L_pointer,
        Result_L => ID_EX_ModifiedValue_in_L,
		InstructionResult => IF_ID_Instruction_in,
		-- ram & comm
		clk => clk,
		clk_scan => clk_scan,
		reset => reset,
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
		led => led_memory,
		started => startedCache
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
		led => led_reg
	);

	Data <= (ID_EX_Rz_out & ID_EX_Ry_out & ID_EX_Rx_out & ID_EX_Immediate_out);
	dataselector_instance : dataselector port map(
		-- in
		Data => Data,
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
		RegisterTarget => ID_EX_RegisterTarget_out,
		ModifiedIndex_before => ID_EX_ModifiedIndex_out,
		ModifiedValue_before => ID_EX_ModifiedValue_out,
        
        SFlag => ID_EX_SFlag_out,
        PC0 => ID_EX_PC0_out,
		-- out
		BranchFlagForward => BranchFlagForward,
		BranchConfirm => BranchConfirm,
		BranchTargetConfirm => BranchConfirmTarget,
		Tout => T_in,
		Result => EX_MEM_AluResult_in,
		ModifiedIndex => ID_EX_ModifiedIndex_in,
		ModifiedValue => ID_EX_ModifiedValue_in,
        
        NextForceNop => ID_EX_NextForceNop_in,
        BubbleNext_Alu => IF_ID_Bubble_in_Alu,
        BranchForce_Alu => BranchForce_Alu,
        BranchTarget_Alu => BranchTarget_Alu
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
		BranchTargetConfirm => BranchConfirmTarget,
        
        BranchForce_Alu => BranchForce_Alu,
        BranchTarget_Alu => BranchTarget_Alu,
		-- out
      	PC0 => IF_ID_PC0_in,
		PCNext => PC_in,
		PredictionFailed => PredictionFailed_in,
		BranchPredictNext => BranchPredict_in
	);
	-- dynamic routes
    
    
	process (clk)
	begin
		if (clk'event and clk = '0' and startedCache = '1') then
			-- led debug-area
			led_test <= led_test + 1;
			-- led debug-area
			PC_out <= PC_in;
			SP_out <= SP_in;
			IH_out <= IH_in;
			reg_out <= reg_in;
			BranchPredict_out <= BranchPredict_in;
			PredictionFailed_out <= PredictionFailed_in;
			T_out <= T_in;

			IF_ID_PC0_out <= IF_ID_PC0_in;
			IF_ID_Instruction_out <= IF_ID_Instruction_in;
            if (IF_ID_Bubble_in_Alu = "00") then
                IF_ID_Bubble_out <= IF_ID_Bubble_in;
            else
                IF_ID_Bubble_out <= IF_ID_Bubble_in_Alu;
            end if;
            
            ID_EX_PC0_out <= ID_EX_PC0_in;
            if (ID_EX_NextForceNop_in = '1') then
                ID_EX_LFlag_out <= '0';
                ID_EX_SFlag_out <= '0';
                ID_EX_BranchTargetAlu_out <= x"0000";
                ID_EX_RegisterTarget_out <= "1111";
                ID_EX_AluInstruction_out <= "0000";
                ID_EX_Immediate_out <= "0000000000000000";
                ID_EX_DataSelectorInstruction_out <= "000000";
                ID_EX_Rx_out <= "0000000000000000";
                ID_EX_Ry_out <= "0000000000000000";
                ID_EX_Rz_out <= "0000000000000000";
                ID_EX_Index_out <= "000000000000";
                ID_EX_ModifiedIndex_out <= "1111";
                ID_EX_ModifiedValue_out <= x"0000";
            else
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
                if (ID_EX_ModifiedValue_in_L_pointer = '0') then
                    ID_EX_ModifiedValue_out <= ID_EX_ModifiedValue_in;
                else
                    ID_EX_ModifiedValue_out <= ID_EX_ModifiedValue_in_L;
                end if;
            end if;

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