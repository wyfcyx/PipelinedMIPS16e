
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

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "001") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "010") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "011") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "100") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "101") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "110") then

            if (%s) then
                Rz
                    
        if (Instruction(4 downto 2) = "111") then

            if (%s) then
                Rz
                    
        if (Instruction(7 downto 5) = "000") then

            Ry <= reg_before(15 downto 0);
            Index(7 downto 4) =  "0000"


                    
        if (Instruction(7 downto 5) = "001") then

            Ry <= reg_before(31 downto 16);
            Index(7 downto 4) =  "0001"


                    
        if (Instruction(7 downto 5) = "010") then

            Ry <= reg_before(47 downto 32);
            Index(7 downto 4) =  "0010"


                    
        if (Instruction(7 downto 5) = "011") then

            Ry <= reg_before(63 downto 48);
            Index(7 downto 4) =  "0011"


                    
        if (Instruction(7 downto 5) = "100") then

            Ry <= reg_before(79 downto 64);
            Index(7 downto 4) =  "0100"


                    
        if (Instruction(7 downto 5) = "101") then

            Ry <= reg_before(95 downto 80);
            Index(7 downto 4) =  "0101"


                    
        if (Instruction(7 downto 5) = "110") then

            Ry <= reg_before(111 downto 96);
            Index(7 downto 4) =  "0110"


                    
        if (Instruction(7 downto 5) = "111") then

            Ry <= reg_before(127 downto 112);
            Index(7 downto 4) =  "0111"


                    
        if (Instruction(10 downto 8) = "000") then

            Rx <= reg_before(15 downto 0);
            Index(3 downto 0) =  "0000"


                    
        if (Instruction(10 downto 8) = "001") then

            Rx <= reg_before(31 downto 16);
            Index(3 downto 0) =  "0001"


                    
        if (Instruction(10 downto 8) = "010") then

            Rx <= reg_before(47 downto 32);
            Index(3 downto 0) =  "0010"


                    
        if (Instruction(10 downto 8) = "011") then

            Rx <= reg_before(63 downto 48);
            Index(3 downto 0) =  "0011"


                    
        if (Instruction(10 downto 8) = "100") then

            Rx <= reg_before(79 downto 64);
            Index(3 downto 0) =  "0100"


                    
        if (Instruction(10 downto 8) = "101") then

            Rx <= reg_before(95 downto 80);
            Index(3 downto 0) =  "0101"


                    
        if (Instruction(10 downto 8) = "110") then

            Rx <= reg_before(111 downto 96);
            Index(3 downto 0) =  "0110"


                    
        if (Instruction(10 downto 8) = "111") then

            Rx <= reg_before(127 downto 112);
            Index(3 downto 0) =  "0111"


                    
end process;
end bhv;
