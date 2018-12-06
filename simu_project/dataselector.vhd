
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DataSelector is
    port ( 
        Data : in std_logic_vector(63 downto 0);
        DataSelectorInstruction : in std_logic_vector(5 downto 0);
        Index : in std_logic_vector(11 downto 0);
        ModifiedIndex : in std_logic_vector(3 downto 0);
        ModifiedValue : in std_logic_vector(15 downto 0);
        ModifiedIndexForward : in std_logic_vector(3 downto 0);
        ModifiedValueForward : in std_logic_vector(15 downto 0);
        
        DataA : out std_logic_vector(15 downto 0);
        DataB : out std_logic_vector(15 downto 0);
        DataS : out std_logic_vector(15 downto 0)
    );
end DataSelector;

architecture bhv of DataSelector is
begin
process(Data, DataSelectorInstruction, Index, ModifiedIndex, ModifiedValue, ModifiedIndexForward, ModifiedValueForward)
begin
    
        if (DataSelectorInstruction(1 downto 0) = "00") then

            DataA <= Data(15 downto 0);

        end if;

        if (DataSelectorInstruction(1 downto 0) = "01") then

            if (Index(3 downto 0) = ModifiedIndex(3 downto 0)) then
                DataA <= ModifiedValue;
            else
                if (Index(3 downto 0) = ModifiedIndexForward(3 downto 0)) then
                    DataA <= ModifiedValueForward;
                else
                    DataA <= Data(31 downto 16);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(1 downto 0) = "10") then

            if (Index(7 downto 4) = ModifiedIndex(3 downto 0)) then
                DataA <= ModifiedValue;
            else
                if (Index(7 downto 4) = ModifiedIndexForward(3 downto 0)) then
                    DataA <= ModifiedValueForward;
                else
                    DataA <= Data(47 downto 32);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(1 downto 0) = "11") then

            if (Index(11 downto 8) = ModifiedIndex(3 downto 0)) then
                DataA <= ModifiedValue;
            else
                if (Index(11 downto 8) = ModifiedIndexForward(3 downto 0)) then
                    DataA <= ModifiedValueForward;
                else
                    DataA <= Data(63 downto 48);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(3 downto 2) = "00") then

            DataB <= Data(15 downto 0);

        end if;

        if (DataSelectorInstruction(3 downto 2) = "01") then

            if (Index(3 downto 0) = ModifiedIndex(3 downto 0)) then
                DataB <= ModifiedValue;
            else
                if (Index(3 downto 0) = ModifiedIndexForward(3 downto 0)) then
                    DataB <= ModifiedValueForward;
                else
                    DataB <= Data(31 downto 16);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(3 downto 2) = "10") then

            if (Index(7 downto 4) = ModifiedIndex(3 downto 0)) then
                DataB <= ModifiedValue;
            else
                if (Index(7 downto 4) = ModifiedIndexForward(3 downto 0)) then
                    DataB <= ModifiedValueForward;
                else
                    DataB <= Data(47 downto 32);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(3 downto 2) = "11") then

            if (Index(11 downto 8) = ModifiedIndex(3 downto 0)) then
                DataB <= ModifiedValue;
            else
                if (Index(11 downto 8) = ModifiedIndexForward(3 downto 0)) then
                    DataB <= ModifiedValueForward;
                else
                    DataB <= Data(63 downto 48);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(5 downto 4) = "00") then

            DataS <= Data(15 downto 0);

        end if;

        if (DataSelectorInstruction(5 downto 4) = "01") then

            if (Index(3 downto 0) = ModifiedIndex(3 downto 0)) then
                DataS <= ModifiedValue;
            else
                if (Index(3 downto 0) = ModifiedIndexForward(3 downto 0)) then
                    DataS <= ModifiedValueForward;
                else
                    DataS <= Data(31 downto 16);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(5 downto 4) = "10") then

            if (Index(7 downto 4) = ModifiedIndex(3 downto 0)) then
                DataS <= ModifiedValue;
            else
                if (Index(7 downto 4) = ModifiedIndexForward(3 downto 0)) then
                    DataS <= ModifiedValueForward;
                else
                    DataS <= Data(47 downto 32);
                end if;
            end if;

        end if;

        if (DataSelectorInstruction(5 downto 4) = "11") then

            if (Index(11 downto 8) = ModifiedIndex(3 downto 0)) then
                DataS <= ModifiedValue;
            else
                if (Index(11 downto 8) = ModifiedIndexForward(3 downto 0)) then
                    DataS <= ModifiedValueForward;
                else
                    DataS <= Data(63 downto 48);
                end if;
            end if;

        end if;

end process;
end bhv;
