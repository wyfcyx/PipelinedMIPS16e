library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Keyboard is
    Port ( 
    	   fclk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ps2clk : in  STD_LOGIC;
           ps2data : in  STD_LOGIC;
		   key : out STD_LOGIC_VECTOR(7 downto 0);
		   is_press : out STD_LOGIC
          );
end Keyboard;

architecture Behavioral of Keyboard is

	type state is (start,ready,reading,check,over);
	signal now_state : state;
	signal data, clk, clk1, clk2, odd_check : std_logic;
	signal data_arr : std_logic_vector(7 downto 0);
	signal int : integer;
	signal press : std_logic;
	signal prev_data : STD_LOGIC_VECTOR(7 downto 0);

begin
	
	clk1 <= ps2clk when rising_edge(fclk);
	clk2 <= clk1 when rising_edge(fclk);
	clk  <= (not clk1) and clk2;
	data <= ps2data when rising_edge(clk);
	odd_check <= data_arr(0) xor data_arr(1) xor data_arr(2) xor data_arr(3) xor data_arr(4) xor data_arr(5) xor data_arr(6) xor data_arr(7);
	is_press <= press;

	process (clk,rst)
	begin
		if (rst = '0') then
			now_state <= start;
			int <= 0;
			prev_data <= "11110000";

		elsif (clk'event and clk = '1') then
			
			case now_state is
				when start =>
					now_state <= ready;
					int <= 0;

				when ready =>
					if (clk = '1') then
						if (data = '0') then
							now_state <= reading;
						end if;
					end if;

				when reading =>
					if (clk = '1') then
						data_arr(int) <= data;
						if (int < 7) then
							int <= int + 1;
						else
							now_state <= check;
						end if;
					end if;

				when check =>
					if (clk = '1') then
						if ((odd_check xor data) = '1') then
							now_state <= over;
						else
							now_state <= start;
						end if;
					end if;

				when over =>
					if (clk = '1') then
						if (data = '1') then
							if (prev_data = "11110000" or data_arr = "11110000") then
								press <= '0';
							else 
								press <= '1';
							end if;
							prev_data <= data_arr;
						end if;
						now_state <= start;
					end if;
				when others =>
					now_state <= start;
			end case;
		end if;
	end process;
	
	with prev_data select
		key <= 
			"01000001" when "00011100" , 		--A
			"01000010" when "00110010" , 		--B
			"01000011" when "00100001" , 		--C
			"01000100" when "00100011" , 		--D
			"01000101" when "00100100" , 		--E
			"01000110" when "00101011" , 		--F
			"01000111" when "00110100" , 		--G
			"01001000" when "00110011" , 		--H
			"01001001" when "01000011" , 		--I
			"01001010" when "00111011" , 		--J
			"01001011" when "01000010" , 		--K
			"01001100" when "01001011" , 		--L
			"01001101" when "00111010" , 		--M
			"01001110" when "00110001" , 		--N
			"01001111" when "01000100" , 		--O
			"01010000" when "01001101" , 		--P
			"01010001" when "00010101" , 		--Q
			"01010010" when "00101101" , 		--R
			"01010011" when "00011011" , 		--S
			"01010100" when "00101100" , 		--T
			"01010101" when "00111100" , 		--U
			"01010110" when "00101010" , 		--V
			"01010111" when "00011101" , 		--W
			"01011000" when "00100010" , 		--X
			"01011001" when "00110101" , 		--Y
			"01011010" when "00011010" , 		--Z
			"00001101" when "01011010" , 		--enter
			"00001010" when "01100110" , 		--backspace
			"00000000" when others;
			
end Behavioral;