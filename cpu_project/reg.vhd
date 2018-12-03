
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
    signal flag2: std_logic_vector(2 downto 0); --临时变量
    signal flag3: std_logic_vector(3 downto 0); --特殊寄存器
begin
process(SP_before,IH_before,reg_before,PC0,Instruction,Target,Data)
begin
    flag1 <= '0';
    
        if (Instruction(4 downto 2) = "000") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(15 downto 0);
                index(11 downto 8) <= "0000";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "001") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(31 downto 16);
                index(11 downto 8) <= "0001";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "010") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(47 downto 32);
                index(11 downto 8) <= "0010";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "011") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(63 downto 48);
                index(11 downto 8) <= "0011";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "100") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(79 downto 64);
                index(11 downto 8) <= "0100";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "101") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(95 downto 80);
                index(11 downto 8) <= "0101";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "110") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(111 downto 96);
                index(11 downto 8) <= "0110";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "111") then

                flag2 <= "000"; --初始化
            
                if (Instruction(15 downto 11) = "10010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "001"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11110") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "010"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11101") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "011"; --临时标记
                end if;
                
                if (Instruction(15 downto 11) = "11010") then
                    flag1 <= '1'; --存在特殊情况
                    flag2 <= "100"; --临时标记
                end if;
                
            if flag2 = "000" then --正常情况
                Rz <= reg_before(127 downto 112);
                index(11 downto 8) <= "0111";
            elsif  flag2 = "001" then
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            elsif flag2 = "010" then
                Rz <= IH_before;
                index(11 downto 8) <= "1000";
                flag3 <= "1000";
            elsif flag2 = "011" then
                Rz<= PC0;
                index(11 downto 8) <= "1010";
                flag3 <= "1010";
            else
                Rz <= SP_before;
                index(11 downto 8) <= "1001";
                flag3 <= "1001";
            end if;
            
        end if;
                
        if (Instruction(7 downto 5) = "000") then

            Ry <= reg_before(15 downto 0);
            Index(7 downto 4) <=  "0000";
                    
        end if;
                
        if (Instruction(7 downto 5) = "001") then

            Ry <= reg_before(31 downto 16);
            Index(7 downto 4) <=  "0001";
                    
        end if;
                
        if (Instruction(7 downto 5) = "010") then

            Ry <= reg_before(47 downto 32);
            Index(7 downto 4) <=  "0010";
                    
        end if;
                
        if (Instruction(7 downto 5) = "011") then

            Ry <= reg_before(63 downto 48);
            Index(7 downto 4) <=  "0011";
                    
        end if;
                
        if (Instruction(7 downto 5) = "100") then

            Ry <= reg_before(79 downto 64);
            Index(7 downto 4) <=  "0100";
                    
        end if;
                
        if (Instruction(7 downto 5) = "101") then

            Ry <= reg_before(95 downto 80);
            Index(7 downto 4) <=  "0101";
                    
        end if;
                
        if (Instruction(7 downto 5) = "110") then

            Ry <= reg_before(111 downto 96);
            Index(7 downto 4) <=  "0110";
                    
        end if;
                
        if (Instruction(7 downto 5) = "111") then

            Ry <= reg_before(127 downto 112);
            Index(7 downto 4) <=  "0111";
                    
        end if;
                
        if (Instruction(10 downto 8) = "000") then

            Rx <= reg_before(15 downto 0);
            Index(3 downto 0) <=  "0000";
                    
        end if;
                
        if (Instruction(10 downto 8) = "001") then

            Rx <= reg_before(31 downto 16);
            Index(3 downto 0) <=  "0001";
                    
        end if;
                
        if (Instruction(10 downto 8) = "010") then

            Rx <= reg_before(47 downto 32);
            Index(3 downto 0) <=  "0010";
                    
        end if;
                
        if (Instruction(10 downto 8) = "011") then

            Rx <= reg_before(63 downto 48);
            Index(3 downto 0) <=  "0011";
                    
        end if;
                
        if (Instruction(10 downto 8) = "100") then

            Rx <= reg_before(79 downto 64);
            Index(3 downto 0) <=  "0100";
                    
        end if;
                
        if (Instruction(10 downto 8) = "101") then

            Rx <= reg_before(95 downto 80);
            Index(3 downto 0) <=  "0101";
                    
        end if;
                
        if (Instruction(10 downto 8) = "110") then

            Rx <= reg_before(111 downto 96);
            Index(3 downto 0) <=  "0110";
                    
        end if;
                
        if (Instruction(10 downto 8) = "111") then

            Rx <= reg_before(127 downto 112);
            Index(3 downto 0) <=  "0111";
                    
        end if;
                
        if Target(3 downto 0) < 15 then
            -- 不是输出
            led(15 downto 0)<=Data(15 downto 0);
        else 
            led(15 downto 0)<= (others=>'0');

        end if;

        if Target(3) = '0' then
            if Target(2 downto 0) = Instruction(10 downto 8) then
                Rx(15 downto 0) <= Data(15 downto 0);
            end if;

            if Target(2 downto 0) = Instruction(7 downto 5) then
                Ry(15 downto 0) <= Data(15 downto 0);
            end if;

            if flag1 = '0' then --不存在特殊情况
                if Target(2 downto 0) = Instruction(4 downto 2) then
                    Rz(15 downto 0) <= Data(15 downto 0);
                end if;
            end if;
        else
            if flag1 = '1' then --存在特殊情况
                if Target(3 downto 0) = flag3(3 downto 0) then
                    Rz(15 downto 0)<= Data(15 downto 0);
                end if;
            end if;
        end if;

            
        if (Target(3 downto 0) = "0000") then
            reg_after(15 downto 0) <= Data(15 downto 0);
        else
            reg_after(15 downto 0) <= reg_before(15 downto 0);
        end if;
                
        if (Target(3 downto 0) = "0001") then
            reg_after(31 downto 16) <= Data(15 downto 0);
        else
            reg_after(31 downto 16) <= reg_before(31 downto 16);
        end if;
                
        if (Target(3 downto 0) = "0010") then
            reg_after(47 downto 32) <= Data(15 downto 0);
        else
            reg_after(47 downto 32) <= reg_before(47 downto 32);
        end if;
                
        if (Target(3 downto 0) = "0011") then
            reg_after(63 downto 48) <= Data(15 downto 0);
        else
            reg_after(63 downto 48) <= reg_before(63 downto 48);
        end if;
                
        if (Target(3 downto 0) = "0100") then
            reg_after(79 downto 64) <= Data(15 downto 0);
        else
            reg_after(79 downto 64) <= reg_before(79 downto 64);
        end if;
                
        if (Target(3 downto 0) = "0101") then
            reg_after(95 downto 80) <= Data(15 downto 0);
        else
            reg_after(95 downto 80) <= reg_before(95 downto 80);
        end if;
                
        if (Target(3 downto 0) = "0110") then
            reg_after(111 downto 96) <= Data(15 downto 0);
        else
            reg_after(111 downto 96) <= reg_before(111 downto 96);
        end if;
                
        if (Target(3 downto 0) = "0111") then
            reg_after(127 downto 112) <= Data(15 downto 0);
        else
            reg_after(127 downto 112) <= reg_before(127 downto 112);
        end if;
                
        if (Target(3 downto 0) = "1001") then
            SP_after(15 downto 0) <= Data(15 downto 0);
        else
            SP_after(15 downto 0) <= SP_before(15 downto 0);
        end if;

        if (Target(3 downto 0) = "1000") then
            IH_after(15 downto 0) <= Data(15 downto 0);
        else
            IH_after(15 downto 0) <= IH_before(15 downto 0);
        end if;

            
end process;
end bhv;
