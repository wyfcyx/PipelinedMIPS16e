library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity register is
	port (
			 -- 输入
			 PC0 : in std_logic_vector(15 downto 0);
			 Instruction : in std_logic_vector(15 downto 0);
			 Target : in std_logic_vector(3 downto 0);
			 Data : in std_logic_vector(15 downto 0);
	SP_before,IH_before: in std_logic_vector( 15 downto 0);
	reg_before: in std_logic_vector(127 downto 0);
	--输出
	Rx: out std_logic_vector(15 downto 0);
	Ry: out std_logic_vector(15 downto 0);
	Rz: out std_logic_vector(15 downto 0);
	Index: out std_logic_vector(11 downto 0);
);
end register;

architecture bhv of register is

begin
	process()
		end process;

	end bhv;
