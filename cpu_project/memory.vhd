library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
-- using " word address " below
-- system instruction area : 0x0000 ~ 0x3fff
-- user instruction area : 0x4000 ~ 0x7fff
-- system data area : 0x8000 ~ 0xbeff
-- com1 : 0xbf00 ~ 0xbf01
-- com2 : 0xbf02 ~ 0xbf03
-- resident : 0xbf04 ~ 0xbf0f
-- system heap stack : 0xbf10 ~ 0xbfff
-- user data area : 0xc000 ~ 0xffff
entity memory is
	port(
		LFlag, SFlag : in std_logic;
		Address : in std_logic_vector(15 downto 0);
		DataS : in std_logic_vector(15 downto 0);
		InstructionAddress : in std_logic_vector(15 downto 0);
		clk : in std_logic;
		clk_scan : in std_logic;
		reset : in std_logic;
		
		Result : out std_logic_vector(15 downto 0);
		InstructionResult : out std_logic_vector(15 downto 0);

		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;

		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		
		-- flash
		flashByte : out std_logic;
		flashVpen : out std_logic;
		flashCE : out std_logic;
		flashOE : out std_logic;
		flashWE : out std_logic;
		flashRP : out std_logic;
		flashAddr : out std_logic_vector(22 downto 1);
		flashData : inout std_logic_vector(15 downto 0);
		
		-- led
		led : out std_logic_vector(15 downto 0);
		started : out std_logic
	);
end memory;

-- no comm, no write instruction mem now
architecture bhv of memory is
type Ram1State is (
	waiting, read1, read2, write1, done
);
type Ram2State is (
	waiting, read1, read2, write1, done
);
signal r1State : Ram1State := waiting;
signal r2State : Ram2State := waiting;
signal r1Trigger : std_logic_vector(17 downto 0) := (others => '1');
signal r2Trigger : std_logic_vector(15 downto 0) := (others => '1');
signal curAddr : std_logic_vector(15 downto 0) := (others => '0');
signal curData : std_logic_vector(15 downto 0);
signal instructions : std_logic_vector(15 downto 0) := x"4000";
type FlashToRamState is (
	waiting, read1, read2, read3, read4, writeToRam, done, readTest
);
signal state : FlashToRamState := waiting;
signal startedCache : std_logic := '0';
begin
--	process (r2State)
--	begin
--		case r2State is
--			when waiting =>
--				led <= "0010000000000000";
--			when read1 =>
--				led <= "0100000000000000";
--			when read2 =>
--				led <= "0110000000000000";
--			when write1 =>
--				led <= "1000000000000000";
--			when done =>
--				led <= "1010000000000000";
--			when others =>
--		end case;
--	end process;

	flashByte <= '1';
	flashVpen <= '1';
	flashRP <= '1';
	flashCE <= '0';
	started <= startedCache;
	led <= InstructionAddress;
	process (LFlag, SFlag, startedCache, clk_scan, clk, reset)
	begin
		if (reset = '0') then
			flashOE <= '1';
			flashWE <= '1';
			flashData <= (others => 'Z');
			curAddr <= (others => '0');
			startedCache <= '0';
			state <= read1;
		elsif (clk_scan'event and clk_scan = '1') then
			if (startedCache = '1') then
				-- fetch instruction
				if (r2Trigger /= InstructionAddress) then
					r2Trigger <= InstructionAddress;
					r2State <= waiting;
				end if;
				case r2State is
					when waiting =>
						if (InstructionAddress < x"4000") then
							r2State <= read1;
						else
							r2State <= done;
							InstructionResult <= (others => '0');
						end if;
					when read1 =>
						Ram2WE <= '1';
						Ram2OE <= '0';
						Ram2EN <= '0';
						Ram2Data <= (others => 'Z');
						Ram2Addr <= InstructionAddress;
						r2State <= read2;
					when read2 =>
						InstructionResult <= Ram2Data;
						--led <= Ram2Data;
						r2State <= done;
					when done =>
					when others =>
				end case;
				-- data mem operation
				if (r1Trigger /= (LFlag & SFlag & Address)) then
					r1State <= waiting;
					r1Trigger <= (LFlag & SFlag & Address);
				end if;
				case r1State is
					when waiting =>
						if (LFlag = '1') then
							r1State <= read1;
						elsif (SFlag = '1') then
							r1State <= write1;
						else
							r1State <= done;
						end if;
					when read1 =>
						Ram1WE <= '1';
						Ram1OE <= '0';
						Ram1EN <= '0';
						Ram1Data <= (others => 'Z');
						Ram1Addr <= Address;
						r1State <= read2;
					when read2 =>
						Result <= Ram1Data;
						r1State <= done;
					when write1 =>
						Ram1WE <= '0';
						Ram1OE <= '1';
						Ram1EN <= '0';
						Ram1Data <= DataS;
						Ram1Addr <= Address;
						r1State <= done;
					when done =>
					when others =>
				end case;
			else
				InstructionResult <= (others => '0');
				Result <= (others => '0');
				case state is
					when read1 =>
						flashData <= x"00FF";
						state <= read2;
					when read2 =>
						flashWE <= '1';
						state <= read3;
					when read3 =>
						flashOE <= '0';
						flashAddr <= "000000" & curAddr;
						flashData <= (others => 'Z');
						state <= read4;
					when read4 =>
						curData <= flashData;
						state <= writeToRam;
					when writeToRam =>
						Ram2WE <= '0';
						Ram2OE <= '1';
						Ram2EN <= '0';
						Ram2Data <= curData;
						Ram2Addr <= curAddr;
						if (curAddr + 1 = instructions) then
							state <= done;
						else
							curAddr <= curAddr + 1;
							state <= read1;
						end if;
					when done =>
						Ram2WE <= '1';
						Ram2OE <= '0';
						Ram2EN <= '0';
						Ram2Addr <= (others => '0');
						Ram2Data <= (others => 'Z');
						state <= readTest;
					when readTest =>
						startedCache <= '1';
						--led <= Ram2Data;
					when others =>
				end case;
			end if;
		end if;
	end process;
end bhv;
