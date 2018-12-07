
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
begin
process(SP_before,IH_before,reg_before,PC0,Instruction,Target,Data)
begin
    
        if (Instruction(4 downto 2) = "000") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0000" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "0000";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "001") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0001" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(31 downto 16);
                    end if;
                    index(11 downto 8) <= "0001";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "010") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0010" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(47 downto 32);
                    end if;
                    index(11 downto 8) <= "0010";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "011") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0011" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(63 downto 48);
                    end if;
                    index(11 downto 8) <= "0011";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "100") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0100" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(79 downto 64);
                    end if;
                    index(11 downto 8) <= "0100";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "101") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0101" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(95 downto 80);
                    end if;
                    index(11 downto 8) <= "0101";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "110") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0110" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(111 downto 96);
                    end if;
                    index(11 downto 8) <= "0110";
                end if;
            
        end if;
                
        if (Instruction(4 downto 2) = "111") then

                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "0111" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(127 downto 112);
                    end if;
                    index(11 downto 8) <= "0111";
                end if;
            
        end if;
                
        if (Instruction(7 downto 5) = "000") then

            if Target(3 downto 0) = "0000" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(15 downto 0);
            end if;
            Index(7 downto 4) <=  "0000";
                    
        end if;
                
        if (Instruction(7 downto 5) = "001") then

            if Target(3 downto 0) = "0001" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(31 downto 16);
            end if;
            Index(7 downto 4) <=  "0001";
                    
        end if;
                
        if (Instruction(7 downto 5) = "010") then

            if Target(3 downto 0) = "0010" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(47 downto 32);
            end if;
            Index(7 downto 4) <=  "0010";
                    
        end if;
                
        if (Instruction(7 downto 5) = "011") then

            if Target(3 downto 0) = "0011" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(63 downto 48);
            end if;
            Index(7 downto 4) <=  "0011";
                    
        end if;
                
        if (Instruction(7 downto 5) = "100") then

            if Target(3 downto 0) = "0100" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(79 downto 64);
            end if;
            Index(7 downto 4) <=  "0100";
                    
        end if;
                
        if (Instruction(7 downto 5) = "101") then

            if Target(3 downto 0) = "0101" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(95 downto 80);
            end if;
            Index(7 downto 4) <=  "0101";
                    
        end if;
                
        if (Instruction(7 downto 5) = "110") then

            if Target(3 downto 0) = "0110" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(111 downto 96);
            end if;
            Index(7 downto 4) <=  "0110";
                    
        end if;
                
        if (Instruction(7 downto 5) = "111") then

            if Target(3 downto 0) = "0111" then
                Ry <= Data(15 downto 0);
            else
                Ry <= reg_before(127 downto 112);
            end if;
            Index(7 downto 4) <=  "0111";
                    
        end if;
                
        if (Instruction(10 downto 8) = "000") then

            if Target(3 downto 0) = "0000" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(15 downto 0);
            end if;
            Index(3 downto 0) <=  "0000";
                    
        end if;
                
        if (Instruction(10 downto 8) = "001") then

            if Target(3 downto 0) = "0001" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(31 downto 16);
            end if;
            Index(3 downto 0) <=  "0001";
                    
        end if;
                
        if (Instruction(10 downto 8) = "010") then

            if Target(3 downto 0) = "0010" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(47 downto 32);
            end if;
            Index(3 downto 0) <=  "0010";
                    
        end if;
                
        if (Instruction(10 downto 8) = "011") then

            if Target(3 downto 0) = "0011" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(63 downto 48);
            end if;
            Index(3 downto 0) <=  "0011";
                    
        end if;
                
        if (Instruction(10 downto 8) = "100") then

            if Target(3 downto 0) = "0100" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(79 downto 64);
            end if;
            Index(3 downto 0) <=  "0100";
                    
        end if;
                
        if (Instruction(10 downto 8) = "101") then

            if Target(3 downto 0) = "0101" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(95 downto 80);
            end if;
            Index(3 downto 0) <=  "0101";
                    
        end if;
                
        if (Instruction(10 downto 8) = "110") then

            if Target(3 downto 0) = "0110" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(111 downto 96);
            end if;
            Index(3 downto 0) <=  "0110";
                    
        end if;
                
        if (Instruction(10 downto 8) = "111") then

            if Target(3 downto 0) = "0111" then
                Rx <= Data(15 downto 0);
            else
                Rx <= reg_before(127 downto 112);
            end if;
            Index(3 downto 0) <=  "0111";
                    
        end if;
                
        if Target(3 downto 0) < 15 then
            led(15 downto 0)<=Data(15 downto 0);
        else 
            led(15 downto 0)<= (others=>'0');
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
