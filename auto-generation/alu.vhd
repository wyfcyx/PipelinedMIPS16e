
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
    port ( 
        DataA : in std_logic_vector(15 downto 0);
        DataB : in std_logic_vector(15 downto 0);
        AluInstruction : in std_logic_vector(3 downto 0);
        T : in std_logic;
        BranchTargetAlu : in std_logic_vector(15 downto 0);

        BranchFlagForward : out std_logic;
        BranchConfirm : out std_logic;
        BranchTargetConfirm : out std_logic_vector(15 downto 0);
        Tout : out std_logic;
        Result: out std_logic_vector(15 downto 0)
    );
end alu;

architecture bhv of alu is
begin
process(DataA, DataB, AluInstruction, T, BranchTargetAlu)
begin
    
    
    -- NOP
    if (AluInstruction(3 downto 0) = "0000") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- ADD
    if (AluInstruction(3 downto 0) = "0001") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= DataA + DataB;
    end if;
    
    -- SUBU
    if (AluInstruction(3 downto 0) = "0010") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= DataA - DataB;
    end if;
    
    -- CMP
    if (AluInstruction(3 downto 0) = "0011") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= ((DataA(0) xor DataB(0)) and (DataA(1) xor DataB(1)) and (DataA(2) xor DataB(2)) and (DataA(3) xor DataB(3)) and (DataA(4) xor DataB(4)) and (DataA(5) xor DataB(5)) and (DataA(6) xor DataB(6)) and (DataA(7) xor DataB(7)) and (DataA(8) xor DataB(8)) and (DataA(9) xor DataB(9)) and (DataA(10) xor DataB(10)) and (DataA(11) xor DataB(11)) and (DataA(12) xor DataB(12)) and (DataA(13) xor DataB(13)) and (DataA(14) xor DataB(14)) and (DataA(15) xor DataB(15)));
        Result <= "0000000000000000";
    end if;
    
    -- SLTU
    if (AluInstruction(3 downto 0) = "0100") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= (((not DataA(15)) and DataB(15)) or ((DataA(15) xnor DataB(15)) and (((not DataA(14)) and DataB(14)) or ((DataA(14) xnor DataB(14)) and (((not DataA(13)) and DataB(13)) or ((DataA(13) xnor DataB(13)) and (((not DataA(12)) and DataB(12)) or ((DataA(12) xnor DataB(12)) and (((not DataA(11)) and DataB(11)) or ((DataA(11) xnor DataB(11)) and (((not DataA(10)) and DataB(10)) or ((DataA(10) xnor DataB(10)) and (((not DataA(9)) and DataB(9)) or ((DataA(9) xnor DataB(9)) and (((not DataA(8)) and DataB(8)) or ((DataA(8) xnor DataB(8)) and (((not DataA(7)) and DataB(7)) or ((DataA(7) xnor DataB(7)) and (((not DataA(6)) and DataB(6)) or ((DataA(6) xnor DataB(6)) and (((not DataA(5)) and DataB(5)) or ((DataA(5) xnor DataB(5)) and (((not DataA(4)) and DataB(4)) or ((DataA(4) xnor DataB(4)) and (((not DataA(3)) and DataB(3)) or ((DataA(3) xnor DataB(3)) and (((not DataA(2)) and DataB(2)) or ((DataA(2) xnor DataB(2)) and (((not DataA(1)) and DataB(1)) or ((DataA(1) xnor DataB(1)) and ((not DataA(0)) and DataB(0))))))))))))))))))))))))))))))));
        Result <= "0000000000000000";
    end if;
    
    -- AND
    if (AluInstruction(3 downto 0) = "0101") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= (DataA(15) and DataB(15)) & (DataA(14) and DataB(14)) & (DataA(13) and DataB(13)) & (DataA(12) and DataB(12)) & (DataA(11) and DataB(11)) & (DataA(10) and DataB(10)) & (DataA(9) and DataB(9)) & (DataA(8) and DataB(8)) & (DataA(7) and DataB(7)) & (DataA(6) and DataB(6)) & (DataA(5) and DataB(5)) & (DataA(4) and DataB(4)) & (DataA(3) and DataB(3)) & (DataA(2) and DataB(2)) & (DataA(1) and DataB(1)) & (DataA(0) and DataB(0));
    end if;
    
    -- OR
    if (AluInstruction(3 downto 0) = "0110") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= (DataA(15) or DataB(15)) & (DataA(14) or DataB(14)) & (DataA(13) or DataB(13)) & (DataA(12) or DataB(12)) & (DataA(11) or DataB(11)) & (DataA(10) or DataB(10)) & (DataA(9) or DataB(9)) & (DataA(8) or DataB(8)) & (DataA(7) or DataB(7)) & (DataA(6) or DataB(6)) & (DataA(5) or DataB(5)) & (DataA(4) or DataB(4)) & (DataA(3) or DataB(3)) & (DataA(2) or DataB(2)) & (DataA(1) or DataB(1)) & (DataA(0) or DataB(0));
    end if;
    
    -- SLL
    if (AluInstruction(3 downto 0) = "0111") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        if (DataB(2 downto 0) = "000") then
            Result <= DataA(7 downto 0) & "00000000";
        end if;
        if (DataB(2 downto 0) = "001") then
            Result <= DataA(14 downto 0) & "0";
        end if;
        if (DataB(2 downto 0) = "010") then
            Result <= DataA(13 downto 0) & "00";
        end if;
        if (DataB(2 downto 0) = "011") then
            Result <= DataA(12 downto 0) & "000";
        end if;
        if (DataB(2 downto 0) = "100") then
            Result <= DataA(11 downto 0) & "0000";
        end if;
        if (DataB(2 downto 0) = "101") then
            Result <= DataA(10 downto 0) & "00000";
        end if;
        if (DataB(2 downto 0) = "110") then
            Result <= DataA(9 downto 0) & "000000";
        end if;
        if (DataB(2 downto 0) = "111") then
            Result <= DataA(8 downto 0) & "0000000";
        end if;
    end if;
    
    -- SRA
    if (AluInstruction(3 downto 0) = "1000") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        if (DataB(2 downto 0) = "000") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 8);
        end if;
        if (DataB(2 downto 0) = "001") then
            Result <= DataA(15) & DataA(15 downto 1);
        end if;
        if (DataB(2 downto 0) = "010") then
            Result <= DataA(15) & DataA(15) & DataA(15 downto 2);
        end if;
        if (DataB(2 downto 0) = "011") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 3);
        end if;
        if (DataB(2 downto 0) = "100") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 4);
        end if;
        if (DataB(2 downto 0) = "101") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 5);
        end if;
        if (DataB(2 downto 0) = "110") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 6);
        end if;
        if (DataB(2 downto 0) = "111") then
            Result <= DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15) & DataA(15 downto 7);
        end if;
    end if;
    
    -- NEG
    if (AluInstruction(3 downto 0) = "1001") then
        BranchFlagForward <= '0';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= (not DataA(15 downto 0)) + 1;
    end if;
    
    -- B
    if (AluInstruction(3 downto 0) = "1010") then
        BranchFlagForward <= '1';
        BranchConfirm <= '1';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- BN
    if (AluInstruction(3 downto 0) = "1011") then
        BranchFlagForward <= '1';
        BranchConfirm <= '0';
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- BEQZ
    if (AluInstruction(3 downto 0) = "1100") then
        BranchFlagForward <= '1';
        BranchConfirm <= not (DataA(0) or DataA(1) or DataA(2) or DataA(3) or DataA(4) or DataA(5) or DataA(6) or DataA(7) or DataA(8) or DataA(9) or DataA(10) or DataA(11) or DataA(12) or DataA(13) or DataA(14) or DataA(15));
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- BNEZ
    if (AluInstruction(3 downto 0) = "1101") then
        BranchFlagForward <= '1';
        BranchConfirm <= (DataA(0) or DataA(1) or DataA(2) or DataA(3) or DataA(4) or DataA(5) or DataA(6) or DataA(7) or DataA(8) or DataA(9) or DataA(10) or DataA(11) or DataA(12) or DataA(13) or DataA(14) or DataA(15));
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- BTEQZ
    if (AluInstruction(3 downto 0) = "1110") then
        BranchFlagForward <= '1';
        BranchConfirm <= not T;
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
    
    -- BTNEZ
    if (AluInstruction(3 downto 0) = "1111") then
        BranchFlagForward <= '1';
        BranchConfirm <= T;
        BranchTargetConfirm <= BranchTargetAlu;
        Tout <= T;
        Result <= "0000000000000000";
    end if;
end process;
end bhv;
    