
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
    port ( 
        ForceNop : in std_logic;
        PC0 : in std_logic_vector(15 downto 0);
        Bubble: in std_logic_vector(2 downto 0);
        Instruction : in std_logic_vector(15 downto 0);
        BranchPredict : in std_logic;
        
        -- 寄存器
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
end decoder;

architecture bhv of decoder is
begin
process(PC0, Bubble, ForceNop, Instruction, BranchPredict)
begin
    -- 判断是否因为预测失败强制解析为NOP
    if (ForceNop = '1') then
            LFlag <= '0';
        SFlag <= '0';
        BranchFlag <= '0';
        BranchForce <= '0';

        BranchTargetAlu <= "0000000000000000";
        BranchTarget <= "0000000000000000";
        RegisterTarget <= "1111";
        AluInstruction <= "0000";
        Immediate <= "0000000000000000";
        DataSelectorInstruction <= "000000";
        BubbleNext <= "000";

    else
        if ((Bubble(0) = '1') or (Bubble(1) = '1') or (Bubble(2) = '1')) then
                LFlag <= '0';
            SFlag <= '0';
            BranchFlag <= '0';
            BranchForce <= '0';

            BranchTargetAlu <= "0000000000000000";
            BranchTarget <= "0000000000000000";
            RegisterTarget <= "1111";
            AluInstruction <= "0000";
            Immediate <= "0000000000000000";
            DataSelectorInstruction <= "000000";
            BubbleNext <= "000";

            if ((Bubble(0) = '1') or (Bubble(1) = '1')) then
                BranchForce <= '1';
                BranchTarget <= PC0;
            end if;
            BubbleNext <= Bubble + "111";
        else
    

            -- ADDIU
            if ((Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '0') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0001";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- ADDIU3
            if ((Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '0') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(7 downto 5);
                AluInstruction <= "0001";
                Immediate <= Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- ADDSP
            if ((Instruction(8) = '1') and (Instruction(9) = '1') and (Instruction(10) = '0') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1001";
                AluInstruction <= "0001";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000011";
                BubbleNext <= "000";
            end if;

            -- ADDU
            if ((Instruction(0) = '1') and (Instruction(1) = '0') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(4 downto 2);
                AluInstruction <= "0001";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- AND
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '1') and (Instruction(3) = '1') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0101";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- B
            if ((Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '0') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '1';
                BranchForce <= '0';

                BranchTargetAlu <= PC0 + 1;
                BranchTarget <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                                RegisterTarget <= "1010";
                AluInstruction <= "1011";
                Immediate <= Instruction(10) & Instruction(10) & Instruction(10) & Instruction(10) & Instruction(10) & Instruction(10 downto 0);
                DataSelectorInstruction <= "000011";
                BubbleNext <= "000";
            end if;

            -- BEQZ
            if ((Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '1';
                BranchForce <= '0';

                if (BranchPredict = '0') then
                    BranchTarget <= PC0 + 1;
                    BranchTargetAlu <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                else
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                end if;
                                RegisterTarget <= "1010";

                if (BranchPredict = '0') then
                    AluInstruction <= "1100";
                else
                    AluInstruction <= "1101";
                end if;
                                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- BNEZ
            if ((Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '1';
                BranchForce <= '0';

                if (BranchPredict = '0') then
                    BranchTarget <= PC0 + 1;
                    BranchTargetAlu <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                else
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                end if;
                                RegisterTarget <= "1010";

                if (BranchPredict = '0') then
                    AluInstruction <= "1101";
                else
                    AluInstruction <= "1100";
                end if;
                                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- BTEQZ
            if ((Instruction(8) = '0') and (Instruction(9) = '0') and (Instruction(10) = '0') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '1';
                BranchForce <= '0';

                if (BranchPredict = '0') then
                    BranchTarget <= PC0 + 1;
                    BranchTargetAlu <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                else
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= PC0 + (Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0));
                end if;
                                RegisterTarget <= "1010";

                if (BranchPredict = '0') then
                    AluInstruction <= "1110";
                else
                    AluInstruction <= "1111";
                end if;
                                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000011";
                BubbleNext <= "000";
            end if;

            -- CMP
            if ((Instruction(0) = '0') and (Instruction(1) = '1') and (Instruction(2) = '0') and (Instruction(3) = '1') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0011";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- CMPI
            if ((Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0011";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- JR
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(5) = '0') and (Instruction(6) = '0') and (Instruction(7) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '1';
                BranchForce <= '0';

                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(15 downto 0);
                    Immediate <= reg(15 downto 0);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(31 downto 16);
                    Immediate <= reg(31 downto 16);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(47 downto 32);
                    Immediate <= reg(47 downto 32);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(63 downto 48);
                    Immediate <= reg(63 downto 48);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(79 downto 64);
                    Immediate <= reg(79 downto 64);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(95 downto 80);
                    Immediate <= reg(95 downto 80);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(111 downto 96);
                    Immediate <= reg(111 downto 96);
                end if;
                
                if ((Instruction(8) = '0') and (Instruction(7) = '1') and (Instruction(6) = '0')) then
                    BranchTargetAlu <= PC0 + 1;
                    BranchTarget <= reg(127 downto 112);
                    Immediate <= reg(127 downto 112);
                end if;
                                RegisterTarget <= "1010";
                AluInstruction <= "1010";
                DataSelectorInstruction <= "000001";
                BubbleNext <= "000";
            end if;

            -- LI
            if ((Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0101";
                Immediate <= "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & Instruction(7 downto 0);
                DataSelectorInstruction <= "000000";
                BubbleNext <= "001";
                BranchForce <= '1';
                BranchTarget <= PC0;
            end if;

            -- LW
            if ((Instruction(11) = '1') and (Instruction(12) = '1') and (Instruction(13) = '0') and (Instruction(14) = '0') and (Instruction(15) = '1')) then
                LFlag <= '1';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(7 downto 5);
                AluInstruction <= "0001";
                Immediate <= Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4 downto 0);
                DataSelectorInstruction <= "000001";
                BubbleNext <= "001";
                BranchForce <= '1';
                BranchTarget <= PC0;
            end if;

            -- LW_SP
            if ((Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '0') and (Instruction(14) = '0') and (Instruction(15) = '1')) then
                LFlag <= '1';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0001";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000011";
                BubbleNext <= "001";
                BranchForce <= '1';
                BranchTarget <= PC0;
            end if;

            -- MFIH
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(5) = '0') and (Instruction(6) = '0') and (Instruction(7) = '0') and (Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0101";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001111";
                BubbleNext <= "000";
            end if;

            -- MFPC
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(5) = '0') and (Instruction(6) = '1') and (Instruction(7) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0101";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001111";
                BubbleNext <= "000";
            end if;

            -- MTIH
            if ((Instruction(0) = '1') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(5) = '0') and (Instruction(6) = '0') and (Instruction(7) = '0') and (Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1000";
                AluInstruction <= "0101";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "000101";
                BubbleNext <= "000";
            end if;

            -- MTSP
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(8) = '0') and (Instruction(9) = '0') and (Instruction(10) = '1') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1001";
                AluInstruction <= "0101";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "000101";
                BubbleNext <= "000";
            end if;

            -- NEG
            if ((Instruction(0) = '1') and (Instruction(1) = '1') and (Instruction(2) = '0') and (Instruction(3) = '1') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "1001";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "000010";
                BubbleNext <= "000";
            end if;

            -- NOP
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(5) = '0') and (Instruction(6) = '0') and (Instruction(7) = '0') and (Instruction(8) = '0') and (Instruction(9) = '0') and (Instruction(10) = '0') and (Instruction(12) = '0') and (Instruction(13) = '0') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0000";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "000000";
                BubbleNext <= "000";
            end if;

            -- OR
            if ((Instruction(0) = '1') and (Instruction(1) = '0') and (Instruction(2) = '1') and (Instruction(3) = '1') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0110";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- SLL
            if ((Instruction(0) = '0') and (Instruction(1) = '0') and (Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '1') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "0111";
                Immediate <= Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4 downto 1);
                DataSelectorInstruction <= "000010";
                BubbleNext <= "000";
            end if;

            -- SLTU
            if ((Instruction(0) = '1') and (Instruction(1) = '1') and (Instruction(2) = '0') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0100";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- SRA
            if ((Instruction(0) = '1') and (Instruction(1) = '1') and (Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '1') and (Instruction(14) = '0') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(10 downto 8);
                AluInstruction <= "1000";
                Immediate <= Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4 downto 1);
                DataSelectorInstruction <= "000010";
                BubbleNext <= "000";
            end if;

            -- SRAV
            if ((Instruction(0) = '1') and (Instruction(1) = '1') and (Instruction(2) = '1') and (Instruction(3) = '0') and (Instruction(4) = '0') and (Instruction(11) = '1') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(7 downto 5);
                AluInstruction <= "1000";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "000110";
                BubbleNext <= "000";
            end if;

            -- SUBU
            if ((Instruction(0) = '1') and (Instruction(1) = '1') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "0" & Instruction(4 downto 2);
                AluInstruction <= "0010";
                Immediate <= "0000000000000000";
                DataSelectorInstruction <= "001001";
                BubbleNext <= "000";
            end if;

            -- SW
            if ((Instruction(11) = '1') and (Instruction(12) = '1') and (Instruction(13) = '0') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '1';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0001";
                Immediate <= Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4) & Instruction(4 downto 0);
                DataSelectorInstruction <= "100001";
                BubbleNext <= "000";
            end if;

            -- SW_RS
            if ((Instruction(8) = '0') and (Instruction(9) = '1') and (Instruction(10) = '0') and (Instruction(11) = '0') and (Instruction(12) = '0') and (Instruction(13) = '1') and (Instruction(14) = '1') and (Instruction(15) = '0')) then
                LFlag <= '0';
                SFlag <= '0';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0000";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "000000";
                BubbleNext <= "000";
            end if;

            -- SW_SP
            if ((Instruction(11) = '0') and (Instruction(12) = '1') and (Instruction(13) = '0') and (Instruction(14) = '1') and (Instruction(15) = '1')) then
                LFlag <= '0';
                SFlag <= '1';
                BranchFlag <= '0';
                BranchForce <= '0';

                BranchTargetAlu <= "0000000000000000";
                BranchTarget <= "0000000000000000";
                RegisterTarget <= "1111";
                AluInstruction <= "0001";
                Immediate <= Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7) & Instruction(7 downto 0);
                DataSelectorInstruction <= "010011";
                BubbleNext <= "000";
            end if;
        end if;
    end if;
end process;
end bhv;
    