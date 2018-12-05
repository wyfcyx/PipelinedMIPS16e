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
        --Result_L_pointer : out std_logic;
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

-- no comm, no write instruction mem now
architecture bhv of memory is
type Ram1State is (
	waiting,
	read1, read2, write1,
	commTest1, commTest2,
	commRead1, commRead2, commRead3,
	commWrite1, commWrite2, commWrite3, commWrite4, commWrite5,
	done
);
type Ram2State is (
	waiting,
	readInstruction1, readInstruction2,
	readMem1, readMem2,
	writeMem1, writeMem2,
	done
);
signal r1State : Ram1State := done;
signal r2State : Ram2State := done;
signal trigger : std_logic_vector(49 downto 0) := (others => '1');
signal curAddr : std_logic_vector(15 downto 0) := (others => '0');
signal curData : std_logic_vector(15 downto 0) := (others => '0');
signal instructions : std_logic_vector(15 downto 0) := x"4000";
signal ram2_rst_pointer : std_logic_vector(15 downto 0) := x"4000";
signal ram1_rst_pointer : std_logic_vector(15 downto 0) := x"8000";
type FlashToRamState is (
	waiting,
	read1, read2, read3, read4, writeToRam,
	ram2_rst1, ram2_rst2,
	ram1_rst1, ram1_rst2,
	done,
	after1, after2, after3
);
signal state : FlashToRamState := waiting;
signal startedCache : std_logic := '0';
begin
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
			
		elsif (clk_scan'event and clk_scan = '0') then
			if (startedCache = '1') then
				if (trigger /= (LFlag & SFlag & Address & DataS & InstructionAddress)) then
					trigger <= (LFlag & SFlag & Address & DataS & InstructionAddress);
					r1State <= waiting;
					r2State <= waiting;
				end if;
				case r2State is
					when waiting =>
						if ((LFlag = '1' or SFlag = '1') and (Address < x"4000")) then
							if (LFlag = '1') then
								r2State <= readMem1;
							else
								r2State <= writeMem1;
							end if;
						else
							r2State <= readInstruction1;
						end if;
					when readInstruction1 =>
						Ram2WE <= '1';
						Ram2OE <= '0';
						Ram2EN <= '0';
						Ram2Data <= (others => 'Z');
						Ram2Addr <= InstructionAddress;
						r2State <= readInstruction2;
					when readInstruction2 =>
						InstructionResult <= Ram2Data;
						r2State <= done;
					when readMem1 =>
						Ram2WE <= '1';
						Ram2OE <= '0';
						Ram2EN <= '0';
						Ram2Data <= (others => 'Z');
						Ram2Addr <= Address;
						r2State <= readMem2;
					when readMem2 =>
						Result <= Ram2Data;
						Result_L <= Ram2Data;
						--Result_L_pointer <= '1';
						InstructionResult <= (others => '0');
						r2State <= done;
					when writeMem1 =>
						Ram2WE <= '0';
						Ram2OE <= '1';
						Ram2EN <= '0';
						Ram2Data <= DataS;
						Ram2Addr <= Address;
						r2State <= writeMem2;
					when writeMem2 =>
						Result <= (others => '0');
						Result_L <= (others => '0');
						--Result_L_pointer <= '0';
						InstructionResult <= (others => '0');
						r2State <= done;
					when done =>
					when others =>
				end case;
				case r1State is
					when waiting =>
						if ((LFlag = '1' or SFlag = '1') and (Address < x"4000")) then
							r1State <= done;
						elsif (LFlag = '1') then
							if (Address = x"bf00") then
								r1State <= commRead1;
							elsif (Address = x"bf01") then
								r1State <= commTest1;
							else
								r1State <= read1;
							end if;
						elsif (SFlag = '1') then
							if (Address = x"bf00") then
								r1State <= commWrite1;
							else
								r1State <= write1;
							end if;
						else
                            --Result_L_pointer <= '0';
                            Result_L <= Address;
							Result <= Address;
							r1State <= done;
						end if;
					when read1 =>
						Ram1WE <= '1';
						Ram1OE <= '0';
						Ram1EN <= '0';
						rdn <= '1';
						wrn <= '1';
						Ram1Data <= (others => 'Z');
						Ram1Addr <= Address;
						r1State <= read2;
					when read2 =>
						Result <= Ram1Data;
                        --Result_L_pointer <= '1';
                        Result_L <= Ram1Data;
						r1State <= done;
					when write1 =>
						Ram1WE <= '0';
						Ram1OE <= '1';
						Ram1EN <= '0';
						rdn <= '1';
						wrn <= '1';
						Ram1Data <= DataS;
						Ram1Addr <= Address;
						r1State <= done;
						Result <= (others => '0');
						Result_L <= (others => '0');
						--Result_L_pointer <= '0';
					when commTest1 =>
						Ram1WE <= '1';
						Ram1OE <= '1';
						Ram1EN <= '1';
						rdn <= '1';
						wrn <= '1';
						Ram1Data <= (others => 'Z');
						r1State <= commTest2;
					when commTest2 =>
						Result <= x"000" & "00" & dataReady & '1';
						r1State <= done;
					when commRead1 =>
						Ram1WE <= '1';
						Ram1OE <= '1';
						Ram1EN <= '1';
						rdn <= '0';
						r1State <= commRead2;
					when commRead2 =>
						Result <= Ram1Data;
						--Result_L_pointer <= '1';
						Result_L <= Ram1Data;
						rdn <= '1';
						r1State <= done;
					when commWrite1 =>
						Ram1WE <= '1';
						Ram1OE <= '1';
						Ram1EN <= '1';
						wrn <= '1';
						r1State <= commWrite2;
					when commWrite2 =>
						wrn <= '0';
						Ram1Data <= DataS;
						r1State <= commWrite3;
					when commWrite3 =>
						wrn <= '1';
						r1State <= commWrite4;
					when commWrite4 =>
						if (tbre = '1') then
							r1State <= commWrite5;
						end if;
					when commWrite5 =>
						if (tsre = '1') then
							r1State <= done;
							Result <= (others => '0');
							Result_L <= (others => '0');
							--Result_L_pointer <= '0';
						end if;
					when done =>
					when others =>	
				end case;
			else
				InstructionResult <= (others => '0');
				Result <= (others => '0');
				Ram1WE <= '1';
				Ram1OE <= '1';
				Ram1EN <= '1';
				rdn <= '1';
				wrn <= '1';
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
			end if;
		end if;
	end process;
end bhv;
