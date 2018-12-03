----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:58:55 12/02/2018 
-- Design Name: 
-- Module Name:    gate - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity gate is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           z : out  STD_LOGIC_VECTOR (5 downto 0));
end gate;

architecture Behavioral of gate is

begin
     z(0)<=a and b;--与门电路，将输入a和输入b进行与运算，赋值给z(0)
	  z(1)<=a nand b;--与非门电路，将输入a和输入b进行与非运算，赋值给z(1)
	  z(2)<=a or b;--或门电路，将输入a和输入b进行或运算，赋值给z(2)
	  z(3)<=a nor b;--或非门电路，将输入a和输入b进行或非运算，赋值给z(3)
	  z(4)<=a xor b;--异或门电路，将输入a和输入b进行异或运算，赋值给z(4)
	  z(5)<=a xnor b;--异或非门电路，将输入a和输入b进行异或非运算，赋值给z(5)

end Behavioral;
