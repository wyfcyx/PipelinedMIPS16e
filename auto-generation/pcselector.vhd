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
        
        PC0: out std_logic_vector(15 downto 0);
        PCNext: out std_logic_vector(15 downto 0);
        PredictionFailed: out std_logic;
        BranchPredictNext: out std_logic
    )
end PCSelector;

architecture bhv of PCSelector is
begin
process(PC, BranchPredict, BranchFlag, BranchForce, BranchTarget, BranchFlagForward, BranchConfirm, BranchTargetConfirm)
begin
    PC0 <= PC + 1;
    if ((BranchForce = '1') or (BranchFlagForward = '0' and BranchFlag = '1')) then
        PCNext <= BranchTarget;
    end if;
    if (BranchForce = '0' and BranchFlagForward = '1' and BranchConfirm = '1') then
        PCNext <= BranchTargetConfirm;
    end if;
    if (BranchForce = '0' and BranchFlagForward = '0' and BranchFlag = '0') then
        PCNext <= PC + 1;
    end if;
    if (BranchForce = '0' and BranchFlagForward = '1' and BranchConfirm = '0') then
        PCNext <= PC + 1;
    end if;
    PredictionFailed <= (BranchFlagForward and (not BranchForce) and (not BranchConfirm));
    BranchPredictNext <= (BranchFlagForward and (not BranchForce) and (not BranchConfirm)) xor (BranchPredict);
end process;
end bhv;