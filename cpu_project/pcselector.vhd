library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PCSelector is
    port (
        PC: in std_logic_vector(15 downto 0);
        BranchPredict: in std_logic;
        BranchFlag: in std_logic;
        BranchForce: in std_logic;
        BranchTarget: in std_logic_vector(15 downto 0);
        BranchFlagForward: in std_logic;
        BranchConfirm: in std_logic;
        BranchTargetConfirm: in std_logic_vector(15 downto 0);
        
        BranchForce_Alu: in std_logic;
        BranchTarget_Alu: in std_logic_vector(15 downto 0);
        
        PC0: out std_logic_vector(15 downto 0);
        PCNext: out std_logic_vector(15 downto 0);
        PredictionFailed: out std_logic;
        BranchPredictNext: out std_logic
    );
end PCSelector;

architecture bhv of PCSelector is
begin
process(PC, BranchPredict, BranchFlag, BranchForce, BranchTarget, BranchFlagForward, BranchConfirm, BranchTargetConfirm)
begin
    if (BranchForce_Alu = '1') then
        PCNext <= BranchTarget_Alu;
        PC0 <= BranchTarget_Alu;
    else
        if (BranchForce = '1') then
            PCNext <= BranchTarget;
            PC0 <= PC + 1;
        end if;
        if (BranchFlagForward = '0' and BranchFlag = '1') then
            PCNext <= BranchTarget;
            PC0 <= BranchTarget;
        end if;
        if (BranchForce = '0' and BranchFlagForward = '1' and BranchConfirm = '1') then
            PCNext <= BranchTargetConfirm;
            PC0 <= BranchTargetConfirm;
        end if;
        if (BranchForce = '0' and BranchFlagForward = '0' and BranchFlag = '0') then
            PCNext <= PC + 1;
            PC0 <= PC + 1;
        end if;
        if (BranchForce = '0' and BranchFlagForward = '1' and BranchConfirm = '0') then
            PCNext <= PC + 1;
            PC0 <= PC + 1;
        end if;
    end if;
    
    PredictionFailed <= (BranchFlagForward and (not BranchForce) and (not BranchForce_Alu) and BranchConfirm);
    BranchPredictNext <= (BranchFlagForward and (not BranchForce) and (not BranchForce_Alu) and BranchConfirm) xor (BranchPredict);
end process;
end bhv;