----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:25:59 10/26/2011 
-- Design Name: 
-- Module Name:    serial - Behavioral 
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

entity serial is
    Port ( ctl_send : in  STD_LOGIC; --ÿ��ȡ��ʱд����
	        ctl_recv : in std_logic; --ÿ��ȡ��ʱ������
			  reset : in std_logic;
			  clk1152 : in std_logic;--��ྦྷ��ʱ�ӵ�1152��Ƶ
			  rdn,wrn : out std_logic;
			  data_ready : in std_logic;
			  --data_read : out std_logic_vector(7 downto 0);--�Ӵ��ڶ���������
			  data_in : in std_logic_vector(7 downto 0);--�������������
			  data_out : inout std_logic_vector(7 downto 0)--���������ߣ���ram1������
	);
end serial;

architecture Behavioral of serial is
	type serial_state is (
		waiting,
		send0, send1,
		recv0, recv1,
		done
	);
	signal state : serial_state := waiting;
	signal ctl_recv_last, ctl_send_last : std_logic;
	
	signal data_read : std_logic_vector(7 downto 0);--�Ӵ��ڶ���������
	
	signal counter : std_logic_vector(13 downto 0);
begin
	process (clk1152, reset, ctl_send, ctl_recv)
	begin		
		if (reset = '0') then
			state <= waiting;
			wrn <= '1';
			rdn <= '1';
			ctl_recv_last <= ctl_recv;
			ctl_send_last <= ctl_send;
			data_out <= (others => 'Z');
			--data_read <= (others => '0');
		elsif (clk1152'event and clk1152 = '1') then
			case state is
			when waiting =>
				if (ctl_send /= ctl_send_last) then
					ctl_send_last <= ctl_send;
					state <= send0;
				elsif (ctl_recv /= ctl_recv_last) then
					ctl_recv_last <= ctl_recv;
					state <= recv0;
				end if;
			when send0 =>
				state <= send1;
				data_out <= data_in;
			when send1 =>
				wrn <= '0';
				state <= done;
			when recv0 =>
				if (data_ready = '1') then
					rdn <= '0';
					state <= recv1;
				end if;
			when recv1 =>
				data_read <= data_out;
				state <= done;
			when others =>
				state <= waiting;
				data_out <= (others => 'Z');
				wrn <= '1';
				rdn <= '1';
			end case;
		end if;
	end process;
	
	
end Behavioral;

