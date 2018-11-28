----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:59 10/26/2011 
-- Design Name: 
-- Module Name:    flashram - Behavioral 
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

entity flashram is
    Port ( swl : in std_logic_vector(7 downto 0);
	        swr : in std_logic_vector(7 downto 0);
			  k1 : in std_logic;
			  reset : in std_logic;
			  clk : in std_logic;
			  data_ready : in std_logic;
			  key : in std_logic;
			  rdn,wrn : out std_logic;
			  ledr, ledl : out std_logic_vector(7 downto 0);
			  data_ram1 : inout std_logic_vector(15 downto 0);
			  data_ram2 : inout std_logic_vector(15 downto 0);
			  addr_ram1 : inout std_logic_vector(16 downto 0);--Êµ¼ÊÖ»Ê¹ÓÃ15 downto 0
			  addr_ram2 : inout std_logic_vector(16 downto 0);--Êµ¼ÊÖ»Ê¹ÓÃ15 downto 0
			  
			  ram1_en, ram2_en : out std_logic;
			  ram1_oe, ram2_oe : out std_logic;
			  ram1_rw, ram2_rw : out std_logic;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  --flash_sts : in std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0)
	);
end flashram;

architecture Behavioral of flashram is
	signal clk_flash, clock: std_logic;
	--signal ctl_serial_send, ctl_serial_recv : std_logic;
	--signal data_serial : std_logic_vector(7 downto 0);
	
	signal sendflag : std_logic;

	signal ctl_read, ctl_write, ctl_erase : std_logic;
	signal flash_addr_input : std_logic_vector(22 downto 1);
	signal flash_data_input : std_logic_vector(15 downto 0);
	signal flash_data_output : std_logic_vector(15 downto 0);
	
	signal response : std_logic_vector(7 downto 0);
	signal high : std_logic;
	
	signal blockaddr : std_logic_vector(5 downto 0);
	--signal insideaddr : std_logic_vector(16 downto 0);
	
	signal staddr, edaddr : std_logic_vector(23 downto 0);
	
	signal data_tmp : std_logic_vector(15 downto 0);
	
	type main_state is (
		waiting, readcmd,
		--nop1, nop2,
		erase0, erase1, erase2, erase3, erase4, erase5,
		readflash0, readflash1, readflash1X, readflash2, readflash3, readflash4, readflash5,
		writeflash0, writeflash1, writeflash2, writeflash3, writeflash4, writeflash5,
		readramA0, readramA1, readramA2, readramA3, readramA4, readramA5, readramA6,
		writeramA0, writeramA1, writeramA2, writeramA3, writeramA4, writeramA5,
		readramB0, readramB1, readramB2, readramB3, readramB4, readramB5, readramB6,
		writeramB0, writeramB1, writeramB2, writeramB3, writeramB4, writeramB5,
		respondcmd0, respondcmd1, respondcmd2, respondcmd3,
		readsize0, readsize1, readsize2, readsize3, readsize4, readsize5, readsize6, readsize7,
		readsize8, readsize9, readsize10, readsize11, readsize12,
		done
	);
	signal state : main_state := waiting;
	signal next_state, readsize_state : main_state;
	signal nop_state : main_state;
	
	
	component flash_io
    Port ( addr : in  STD_LOGIC_VECTOR (22 downto 1);
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in std_logic;--Ëæ±ãÊ²Ã´Ê±ÖÓ
			  reset : in std_logic;
			  
			  flash_byte : out std_logic;--BYTE#
			  flash_vpen : out std_logic;
			  flash_ce : out std_logic;
			  flash_oe : out std_logic;
			  flash_we : out std_logic;
			  flash_rp : out std_logic;
			  --flash_sts : in std_logic;
			  flash_addr : out std_logic_vector(22 downto 1);
			  flash_data : inout std_logic_vector(15 downto 0);
			  
           ctl_read : in  STD_LOGIC;
           ctl_write : in  STD_LOGIC;
			  ctl_erase : in STD_LOGIC
	);
	end component;
	
	component clk_1152
    Port ( clk : in  STD_LOGIC;--ÊäÈë×ó²à¾§Õñ
	        clk_flash : out std_logic; --256·ÖÆµ
           clk5000 : out  STD_LOGIC--1152·ÖÆµ
		);
	end component;
begin
	clk_producer: clk_1152 PORT MAP (
		clk => clk,
		clk_flash => clk_flash,
		clk5000 => clock);
		
	flash : flash_io PORT MAP (
		addr => flash_addr_input,
		data_in => flash_data_input,
		data_out => flash_data_output,
		clk => clk_flash,
		reset => reset,
		flash_byte => flash_byte,
		flash_vpen => flash_vpen,
		flash_ce => flash_ce,
		flash_oe => flash_oe,
		flash_we => flash_we,
		flash_rp => flash_rp,
		--flash_sts => flash_sts,
		flash_addr => flash_addr,
		flash_data => flash_data,
		ctl_read => ctl_read,
		ctl_write => ctl_write,
		ctl_erase => ctl_erase
	);
		
	
	ram1_en <= '0';
	ram2_en <= '0';
	
	process (clock, reset)
	begin		
		if (reset = '0') then
			state <= waiting;
			wrn <= '1';
			rdn <= '1';
			ram1_rw <= '1';
			ram2_rw <= '1';
			ram1_oe <= '1';
			ram2_oe <= '1';
			data_ram1 <= (others => 'Z');
			ledl <= (others => '0');
			ledr <= (others => '0');
		elsif (clock'event and clock = '1') then
			case state is
			when waiting =>
				if (data_ready = '1') then
					rdn <= '0';
					state <= readcmd;
				end if;
			when readcmd =>
				ledl <= data_ram1(7 downto 0);
				rdn <= '1';
				case data_ram1(1 downto 0) is
					when "00" =>    --flashÃüÁî
						if (data_ram1(2) = '0') then--¶Áflash
							state <= readflash0;
						else--Ğ´flash
							state <= writeflash0;
						end if;
					when "01" =>    --ram1ÃüÁî
						if (data_ram1(2) = '0') then--¶Áram1
							state <= readramA0;
						else--Ğ´ram1
							state <= writeramA0;
						end if;
					when "10" =>    --ram2ÃüÁî
						if (data_ram1(2) = '0') then--¶Áram2
							state <= readramB0;
						else
							state <= writeramB0;
						end if;
					when others =>    --ERASE
						state <= erase0;
						blockaddr <= data_ram1(7 downto 2);
				end case;
			when readflash0 =>
				next_state <= readflash1;
				state <= respondcmd0;
				response <= "00100011";
			when readflash1 =>
				state <= readsize0;
				readsize_state <= readflash1X;
			when readflash1X =>
				sendflag <= '0';
				high <= '0';
				state <= readflash2;
				flash_addr_input <= staddr(21 downto 0);
			when readflash2 =>
				wrn <= '1';
				if (sendflag = '1') then
					state <= done;
				else
					state <= readflash3;
				end if;
			when readflash3 =>
				state <= readflash4;
			when readflash4 =>
				ctl_read <= not ctl_read;
				state <= readflash5;
			when readflash5 =>
				if (flash_addr_input(22 downto 1) = edaddr(21 downto 0) and high = '1') then
					sendflag <= '1';
				end if;
				wrn <= '0';
				if (high = '0') then
					high <= '1';
					data_ram1(7 downto 0) <= flash_data_output(7 downto 0);
				else
					high <= '0';
					data_ram1(7 downto 0) <= flash_data_output(15 downto 8);
					flash_addr_input <= flash_addr_input + 1;
				end if;
				state <= readflash2;
				
			when writeflash0 =>
				next_state <= writeflash1;
				state <= respondcmd0;
				response <= "00100011";
			when writeflash1 =>
				state <= readsize0;
				readsize_state <= writeflash2;
			when writeflash2 =>
				flash_addr_input <= staddr(21 downto 0) - 1;
				high <= '1';
				state <= writeflash3;
			when writeflash3 =>				
				if (data_ready = '1') then
					if (high = '1') then
						flash_addr_input <= flash_addr_input + 1;
						high <= '0';
					else
						high <= '1';
					end if;
					
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= writeflash4;
				end if;
			when writeflash4 =>
				rdn <= '1';
				if (high = '0') then
					data_tmp(7 downto 0) <= data_ram1(7 downto 0);
				else
					flash_data_input(7 downto 0) <= data_tmp(7 downto 0);
					flash_data_input(15 downto 8) <= data_ram1(7 downto 0);
					ctl_write <= not ctl_write;
				end if;
				
				if (flash_addr_input(22 downto 1) = edaddr(21 downto 0) and high = '1') then
					state <= done;
				else
					state <= writeflash3;
				end if;
				
			when readramA0 =>
				--sendflag <= '0';
				--insideaddr <= (others => '0');
				next_state <= readramA1;
				state <= respondcmd0;
				response <= "00100011";
			when readramA1 =>
				state <= readsize0;
				readsize_state <= readramA2;
			when readramA2 =>
				sendflag <= '0';
				state <= readramA3;
				addr_ram1 <= staddr(16 downto 0);
				high <= '0';
			when readramA3 =>
				wrn <= '1';
				if (sendflag = '1') then
					state <= done;
				else
					state <= readramA4;
				end if;
			when readramA4 =>
				state <= readramA5;
				ram1_oe <= '0';
				data_ram1 <= (others => 'Z');
			when readramA5 =>
				state <= readramA6;
				data_tmp <= data_ram1;
				ram1_oe <= '1';
			when readramA6 =>
				if (addr_ram1 = edaddr(16 downto 0) and high = '1') then
					sendflag <= '1';
				end if;
				wrn <= '0';
				--data_ram1 <= data_tmp;
				if (high = '1') then
					addr_ram1 <= addr_ram1 + 1;
					data_ram1(7 downto 0) <= data_tmp(15 downto 8);
					high <= '0';
				else
					data_ram1(7 downto 0) <= data_tmp(7 downto 0);
					high <= '1';
				end if;
				state <= readramA3;
				
			when writeramA0 =>
				next_state <= writeramA1;
				state <= respondcmd0;
				response <= "00100011";
			when writeramA1 =>
				state <= readsize0;
				readsize_state <= writeramA2;
			when writeramA2 =>
				addr_ram1 <= staddr(16 downto 0) - 1;
				high <= '1';
				state <= writeramA3;
			when writeramA3 =>
				ram1_rw <= '1';
				if (data_ready = '1') then
					if (high = '1') then
						addr_ram1 <= addr_ram1 + 1;
						high <= '0';
					else
						high <= '1';
					end if;
					
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= writeramA4;
				end if;
			when writeramA4 =>
				rdn <= '1';
				if (high = '0') then
					data_tmp(7 downto 0) <= data_ram1(7 downto 0);
				else
					data_ram1(7 downto 0) <= data_tmp(7 downto 0);
					data_ram1(15 downto 8) <= data_ram1(7 downto 0);
					ram1_rw <= '0';
				end if;
				if (addr_ram1 = edaddr(16 downto 0) and high = '1') then
					state <= done;
				else
					state <= writeramA3;
				end if;

			when readramB0 =>
				next_state <= readramB1;
				state <= respondcmd0;
				response <= "00100011";
			when readramB1 =>
				state <= readsize0;
				readsize_state <= readramB2;
			when readramB2 =>
				sendflag <= '0';
				state <= readramB3;
				addr_ram2 <= staddr(16 downto 0);
				high <= '0';
			when readramB3 =>
				wrn <= '1';
				if (sendflag = '1') then
					state <= done;
				else
					state <= readramB4;
				end if;
			when readramB4 =>
				state <= readramB5;
				ram2_oe <= '0';
				data_ram2 <= (others => 'Z');
			when readramB5 =>
				state <= readramB6;
				data_tmp <= data_ram2;
				ram2_oe <= '1';
			when readramB6 =>
				if (addr_ram2 = edaddr(16 downto 0) and high = '1') then
					sendflag <= '1';
				end if;
				wrn <= '0';
				--data_ram1 <= data_tmp;
				if (high = '1') then
					addr_ram2 <= addr_ram2 + 1;
					data_ram1(7 downto 0) <= data_tmp(15 downto 8);
					high <= '0';
				else
					data_ram1(7 downto 0) <= data_tmp(7 downto 0);
					high <= '1';
				end if;
				state <= readramB3;
				
			when writeramB0 =>
				next_state <= writeramB1;
				state <= respondcmd0;
				response <= "00100011";
			when writeramB1 =>
				state <= readsize0;
				readsize_state <= writeramB2;
			when writeramB2 =>
				addr_ram2 <= staddr(16 downto 0) - 1;
				high <= '1';
				state <= writeramB3;
			when writeramB3 =>
				ram2_rw <= '1';
				if (data_ready = '1') then
					if (high = '1') then
						addr_ram2 <= addr_ram2 + 1;
						high <= '0';
					else
						high <= '1';
					end if;
					
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= writeramB4;
				end if;
			when writeramB4 =>
				rdn <= '1';
				if (high = '0') then
					data_tmp(7 downto 0) <= data_ram1(7 downto 0);
				else
					data_ram2(7 downto 0) <= data_tmp(7 downto 0);
					data_ram2(15 downto 8) <= data_ram1(7 downto 0);
					ram2_rw <= '0';
				end if;
				if (addr_ram2 = edaddr(16 downto 0) and high = '1') then
					state <= done;
				else
					state <= writeramB3;
				end if;
				
			when erase0 =>
				flash_addr_input(22 downto 17) <= blockaddr;
				ctl_erase <= not ctl_erase;
				state <= erase1;
			when erase1 =>
				if (flash_data_output(0) = '1') then
					state <= respondcmd0;
					response <= x"23";
					next_state <= done;
				end if;
				
			when respondcmd0 =>
				wrn <= '0';
				data_ram1(7 downto 0) <= response;
				state <= respondcmd1;
			when respondcmd1 =>
				wrn <= '1';
				state <= respondcmd2;
			when respondcmd2 =>
				state <= respondcmd3;
			when respondcmd3 =>
				state <= next_state;
				
			when readsize0 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize1;
				end if;
			when readsize1 =>
				rdn <= '1';
				staddr(23 downto 16) <= data_ram1(7 downto 0);
				--ledl <= data_ram1;
				--ledr <= x"13";
				response <= x"24";
				state <= respondcmd0;
				next_state <= readsize2;
			when readsize2 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize3;
				end if;
			when readsize3 =>
				rdn <= '1';
				--ledr <= data_ram1;
				staddr(15 downto 8) <= data_ram1(7 downto 0);
				state <= respondcmd0;
				response <= x"25";
				next_state <= readsize4;
			when readsize4 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize5;
				end if;
			when readsize5 =>
				rdn <= '1';
				--ledr <= data_ram1;
				staddr(7 downto 0) <= data_ram1(7 downto 0);
				state <= respondcmd0;
				response <= x"26";
				next_state <= readsize6;
			when readsize6 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize7;
				end if;
			when readsize7 =>
				rdn <= '1';
				--ledr <= data_ram1;
				edaddr(23 downto 16) <= data_ram1(7 downto 0);
				state <= respondcmd0;
				response <= x"27";
				next_state <= readsize8;
			when readsize8 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize9;
				end if;
			when readsize9 =>
				rdn <= '1';
				--ledr <= data_ram1;
				edaddr(15 downto 8) <= data_ram1(7 downto 0);
				state <= respondcmd0;
				response <= x"28";
				next_state <= readsize10;
			when readsize10 =>
				if (data_ready = '1') then
					rdn <= '0';
					data_ram1 <= (others => 'Z');
					state <= readsize11;
				end if;
			when readsize11 =>
				rdn <= '1';
				--ledr <= data_ram1;
				edaddr(7 downto 0) <= data_ram1(7 downto 0);
				state <= respondcmd0;
				response <= x"29";
				next_state <= readsize12;
			when readsize12 =>
				state <= readsize_state;
				
--			when nop1 =>
--				state <= nop_state;
--			when nop2 =>
--				state <= nop1;
			when others =>
				state <= waiting;
				data_ram1 <= (others => 'Z');
				wrn <= '1';
				rdn <= '1';
				ram1_rw <= '1';
				ram2_rw <= '1';
				ram1_oe <= '1';
				ram2_oe <= '1';
			end case;
		end if;
	end process;

end Behavioral;

