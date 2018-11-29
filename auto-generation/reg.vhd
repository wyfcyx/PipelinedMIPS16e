
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg is
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
end reg;
architecture bhv of reg is
    signal flag1: std_logic; --说明是否存在特殊情况
    signal flag2: std_logic; --临时变量
begin
process(SP_before,IH_before,reg_before,PC0,Instruction,Target,Data)
begin
    flag1 <= "0";
    
        if (Instruction(4 downto 2) = "000") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(15 downto 0)
                index(11 downto 8) = "0000"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1000"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1000"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1000"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "001") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "0001"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1001"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1001"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1001"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "010") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "0010"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1010"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1010"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1010"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "011") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(63 downto 48)
                index(11 downto 8) = "0011"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1011"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1011"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1011"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "100") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(79 downto 64)
                index(11 downto 8) = "0100"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1100"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1100"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1100"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "101") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(95 downto 80)
                index(11 downto 8) = "0101"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1101"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1101"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1101"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "110") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(111 downto 96)
                index(11 downto 8) = "0110"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1110"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1110"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1110"
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "111") then

                flag2 <= "0" --初始化
            
                if Instrction(15 downto 11) = "10010" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "1" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11110" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "2" --临时标记
                end if;
                
                if Instrction(15 downto 11) = "11101" then
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "3" --临时标记
                end if;
                
            if flag2 = "0" then --正常情况
                Rz <= reg_before(127 downto 112)
                index(11 downto 8) = "0111"
            elsif  flag2 = "1" then
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "1111"
            elsif flag2 = "2" then
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "1111"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "1111"
            end if;
            
        end if;
                
        if (Instruction(7 downto 5) = "000") then

            Ry <= reg_before(15 downto 0);
            Index(7 downto 4) =  "0000"
                    
        end if;
                
        if (Instruction(7 downto 5) = "001") then

            Ry <= reg_before(31 downto 16);
            Index(7 downto 4) =  "0001"
                    
        end if;
                
        if (Instruction(7 downto 5) = "010") then

            Ry <= reg_before(47 downto 32);
            Index(7 downto 4) =  "0010"
                    
        end if;
                
        if (Instruction(7 downto 5) = "011") then

            Ry <= reg_before(63 downto 48);
            Index(7 downto 4) =  "0011"
                    
        end if;
                
        if (Instruction(7 downto 5) = "100") then

            Ry <= reg_before(79 downto 64);
            Index(7 downto 4) =  "0100"
                    
        end if;
                
        if (Instruction(7 downto 5) = "101") then

            Ry <= reg_before(95 downto 80);
            Index(7 downto 4) =  "0101"
                    
        end if;
                
        if (Instruction(7 downto 5) = "110") then

            Ry <= reg_before(111 downto 96);
            Index(7 downto 4) =  "0110"
                    
        end if;
                
        if (Instruction(7 downto 5) = "111") then

            Ry <= reg_before(127 downto 112);
            Index(7 downto 4) =  "0111"
                    
        end if;
                
        if (Instruction(10 downto 8) = "000") then

            Rx <= reg_before(15 downto 0);
            Index(3 downto 0) =  "0000"
                    
        end if;
                
        if (Instruction(10 downto 8) = "001") then

            Rx <= reg_before(31 downto 16);
            Index(3 downto 0) =  "0001"
                    
        end if;
                
        if (Instruction(10 downto 8) = "010") then

            Rx <= reg_before(47 downto 32);
            Index(3 downto 0) =  "0010"
                    
        end if;
                
        if (Instruction(10 downto 8) = "011") then

            Rx <= reg_before(63 downto 48);
            Index(3 downto 0) =  "0011"
                    
        end if;
                
        if (Instruction(10 downto 8) = "100") then

            Rx <= reg_before(79 downto 64);
            Index(3 downto 0) =  "0100"
                    
        end if;
                
        if (Instruction(10 downto 8) = "101") then

            Rx <= reg_before(95 downto 80);
            Index(3 downto 0) =  "0101"
                    
        end if;
                
        if (Instruction(10 downto 8) = "110") then

            Rx <= reg_before(111 downto 96);
            Index(3 downto 0) =  "0110"
                    
        end if;
                
        if (Instruction(10 downto 8) = "111") then

            Rx <= reg_before(127 downto 112);
            Index(3 downto 0) =  "0111"
                    
        end if;
                
        if Target(3 downto 0) != "1111" then
            --不是输出
            led(15 downto 0)=Data(15 downto 0)
        end if;
            
end process;
end bhv;
