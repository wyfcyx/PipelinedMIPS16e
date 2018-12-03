LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- 门电路调用声明(UUT)
    COMPONENT gate
    PORT(
         a : IN  std_logic;
         b : IN  std_logic;
         z : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
   --输入信号
   signal a : std_logic := '0';
   signal b : std_logic := '0';

 	--输出信号
   signal z : std_logic_vector(5 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
  
	-- 调用门电路
   uut: gate PORT MAP (
          a => a,
          b => b,
          z => z
        );
   --设置输入信号
   init:process begin
		   a<='0';
			b<='0';
			wait for 100 ns;
			
			a<='0';
			b<='1';
			wait for 100 ns;
			
			a<='1';
			b<='0';
			wait for 100 ns;
			
			a<='1';
			b<='1';
			wait for 100 ns;
	end process;
END behavior;