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
entity memory2 is
	port(
		LFlag, SFlag : in std_logic;
		Address : in std_logic_vector(15 downto 0);
		DataS : in std_logic_vector(15 downto 0);
		InstructionAddress : in std_logic_vector(15 downto 0);
		clk : in std_logic;
		clk_scan : in std_logic;
		reset : in std_logic;
		
		Result : out std_logic_vector(15 downto 0);
        Result_L_pointer : out std_logic;
        Result_L : out std_logic_vector(15 downto 0);
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

architecture bhv of memory2 is
signal startedCache : std_logic := '0';
type FlashToRamState is (
	waiting,
	read1, read2, read3, read4, writeToRam,
	ram2_rst1, ram2_rst2,
	ram1_rst1, ram1_rst2,
	done,
	after1, after2, after3
);
type Ram1State is (readMem2, readInstruction2, waiting);

type Ram2State is (commRead2, commTest2, commWrite2, read2, waiting);
	
signal curAddr : std_logic_vector(15 downto 0) := (others => '0');
signal curData : std_logic_vector(15 downto 0) := (others => '0');
signal instructions : std_logic_vector(15 downto 0) := x"4000";
signal ram2_rst_pointer : std_logic_vector(15 downto 0) := x"4000";
signal ram1_rst_pointer : std_logic_vector(15 downto 0) := x"8000";
signal state : FlashToRamState := waiting;
signal r1State : Ram1State := waiting;
signal r2State : Ram2State := waiting;
begin
	started <= startedCache;
	process (clk, startedCache, reset)
	begin
		if (reset = '0') then
			flashOE <= '1';
			flashWE <= '1';
			flashData <= (others => 'Z');
			curAddr <= (others => '0');
			startedCache <= '0';
		elsif (clk_scan'event and clk_scan = '1') then
			if (startedCache = '0') then
				InstructionResult <= (others => '0');
				Result <= (others => '0');
				Ram1WE <= '1';
				Ram1OE <= '1';
				Ram1EN <= '1';
				rdn <= '1';
				wrn <= '1';
				case state is
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
							state <= ram2_rst1;
						else
							curAddr <= curAddr + 1;
							state <= read1;
						end if;
					when ram2_rst1 =>
						Ram2WE <= '0';
						Ram2OE <= '1';
						Ram2EN <= '0';
						Ram2Data <= (others => '0');
						Ram2Addr <= ram2_rst_pointer;
						state <= ram2_rst2;
					when ram2_rst2 =>
						if (ram2_rst_pointer + 1 = ram1_rst_pointer) then
							state <= ram1_rst1;
						else
							ram2_rst_pointer <= ram2_rst_pointer + 1;
							state <= ram2_rst1;
						end if;
					when ram1_rst1 =>
						Ram1WE <= '0';
						Ram1OE <= '1';
						Ram1EN <= '0';
						rdn <= '1';
						wrn <= '1';
						Ram1Data <= (others => '0');
						Ram1Addr <= ram1_rst_pointer;
						state <= ram1_rst2;
					when ram1_rst2 =>
						if (ram1_rst_pointer = x"ffff") then
							state <= done;
						else
							ram1_rst_pointer <= ram1_rst_pointer + 1;
							state <= ram1_rst1;
						end if;
					when done =>
						startedCache <= '1';
					when others =>
				end case;
			else
				if (clk = '1') then
					if (((LFlag = '1') or (SFlag = '1')) and Address < x"8000") then
						r1State <= waiting;
						-- instruction mem L/S
						if (LFlag = '1') then
							Ram2WE <= '1';
							Ram2OE <= '0';
							Ram2EN <= '0';
							Ram2Addr <= Address;
							Ram2Data <= (others => 'Z');
							ram2State <= readMem2;
						else
							Ram2WE <= '0';
							Ram2OE <= '1';
							Ram2EN <= '0';
							Ram2Addr <= Address;
							Ram2Data <= DataS;
							Result <= (others => '0');
							Result_L <= (others => '0');
							Result_L_pointer <= '0';
							InstructionResult <= (others => '0');
							ram2State <= waiting;
						end if;
					else
						Ram2WE <= '1';
						Ram2OE <= '0';
						Ram2EN <= '0';
						Ram2Addr <= InstructionAddress;
						Ram2Data <= (others => 'Z');
						r2State <= readInstruction2;
						if (LFlag = '1') then
							if (Address = x"bf00") then
								Ram1WE <= '1';
								Ram1OE <= '1';
								Ram1EN <= '1';
								rdn <= '0';
								r1State <= commRead2;
							elsif (Address = x"bf01") then
								Ram1WE <= '1';
								Ram1OE <= '1';
								Ram1EN <= '1';
								rdn <= '1';
								wrn <= '1';
								Ram1Data <= (others => 'Z');
								r1State <= commTest2;
							else
								Ram1WE <= '1';
								Ram1OE <= '0';
								Ram1EN <= '0';
								rdn <= '1';
								wrn <= '1';
								Ram1Data <= (others => 'Z');
								Ram1Addr <= Address;
								r1State <= read2;
							end if;
						elsif (SFlag = '1') then
							if (Address = x"bf00") then
								wrn <= '0';
								Ram1Data(7 downto 0) <= DataS(7 downto 0);
								r1State <= commWrite2;
							else
								Ram1WE <= '0';
								Ram1OE <= '1';
								Ram1EN <= '0';
								rdn <= '1';
								wrn <= '1';
								Ram1Data <= DataS;
								Ram1Addr <= Address;
								Result <= (others => '0');
								Result_L <= (others => '0');
								Result_L_pointer <= '0';
								r1State <= waiting;
							end if;
						else
							Result_L_pointer <= '0';
							Result_L <= "0000000000000000";
							Result <= Address;
							r1State <= waiting;
						end if;
					end if;
				else
					case ram2State is
						when readMem2 =>
							Result <= Ram2Data;
							Result_L <= Ram2Data;
							Result_L_pointer <= '1';
							InstructionResult <= (others => '0');
						when readInstruction2 =>
							InstructionResult <= Ram2Data;
						when others =>
					end case;
					case ram1State is
						when commRead2 =>
							Result(7 downto 0) <= Ram1Data(7 downto 0);
							Result(15 downto 8) <= (others => '0');
							Result_L_pointer <= '1';
							Result_L(7 downto 0) <= Ram1Data(7 downto 0);
							led <= x"00" & Ram1Data(7 downto 0);
							rdn <= '1';
							Ram1Data <= (others => 'Z');
						when commTest2 =>
							Result <= x"000" & "00" & dataReady & (tbre and tsre);
						when read2 =>
							Result <= Ram1Data;
							Result_L_pointer <= '1';
							Result_L <= Ram1Data;
						when commWrite2 =>
							wrn <= '1';
							Result <= (others => '0');
							Result_L <= (others => '0');
							Result_L_pointer <= '0';
							
						when others =>
					end case;
				end if;
			end if;
		end if;
	end process;
end bhv;
