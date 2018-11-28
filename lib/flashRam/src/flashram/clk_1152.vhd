----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:58:41 10/29/2011 
-- Design Name: 
-- Module Name:    clk_1152 - Behavioral 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_1152 is
    Port ( clk : in  STD_LOGIC;-- ‰»Î◊Û≤‡æß’Ò
			  clk_flash : out std_logic; --256∑÷∆µ
           clk5000 : out  STD_LOGIC--5000∑÷∆µ
	 );
end clk_1152;

architecture Behavioral of clk_1152 is
	signal count : std_logic_vector(20 downto 0);
	signal clk_tmp : std_logic;
	
	signal count64 : std_logic_vector(5 downto 0);
	--signal clk256_tmp : std_logic;
begin
	clk5000 <= clk_tmp;
	clk_flash <= count64(5);
	process(clk)
	begin
		if (clk'event and clk = '1') then
			--if (count = 575) then
			if (count = 2500) then
				count <= (others => '0');
				clk_tmp <= not clk_tmp;
			else
				count <= count + 1;
			end if;
			count64 <= count64 + 1;
		end if;
	end process;
end Behavioral;

