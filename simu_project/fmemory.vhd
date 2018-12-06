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
		--trigger : out std_logic_vector(49 downto 0)
	);
end memory;

architecture bhv of memory is
type ramBlock is array(31 downto 0) of std_logic_vector(15 downto 0);
signal Ram1, Ram2 : ramBlock;

-- instruction [0000,0013]
-- data [c000,c013]
signal startedCache : std_logic := '0';
signal triggerCache : std_logic_vector(49 downto 0) := (others => '1');
begin
	started <= startedCache;
	--trigger <= triggerCache;
	led <= (others => '0');
	process (LFlag, SFlag, startedCache, clk_scan, clk, reset)
	begin
		if (reset = '1') then
			startedCache <= '1';
			--0168 0169 2ae8 0260 0008 0008 0210 0008 0008 29e0
			Ram2(0) <= x"6801";
			Ram2(1) <= x"6901";
			Ram2(2) <= x"e82a";
			Ram2(3) <= x"6002";
			Ram2(4) <= x"0000";
			Ram2(5) <= x"0000";
			Ram2(6) <= x"1002";
			Ram2(7) <= x"0000";
			Ram2(8) <= x"0000";
			Ram2(9) <= x"e029";
			Ram2(10) <= x"0000";
			Ram2(11) <= (others => '0');
			Ram2(12) <= (others => '0');
			Ram2(13) <= (others => '0');
			Ram2(14) <= (others => '0');
			Ram2(15) <= (others => '0');
			Ram2(16) <= (others => '0');
			Ram2(17) <= (others => '0');
			Ram2(18) <= (others => '0');
			Ram2(19) <= (others => '0');
			Ram2(20) <= (others => '0');
			Ram2(21) <= (others => '0');
			Ram2(22) <= (others => '0');
			Ram2(23) <= (others => '0');
			Ram2(24) <= (others => '0');
			Ram2(25) <= (others => '0');
			Ram2(26) <= (others => '0');
			Ram2(27) <= (others => '0');
			Ram2(28) <= (others => '0');
			Ram2(29) <= (others => '0');
			Ram2(30) <= (others => '0');
			Ram2(31) <= (others => '0');
			Ram1(0) <= (others => '0');
			Ram1(1) <= (others => '0');
			Ram1(2) <= (others => '0');
			Ram1(3) <= (others => '0');
			Ram1(4) <= (others => '0');
			Ram1(5) <= (others => '0');
			Ram1(6) <= (others => '0');
			Ram1(7) <= (others => '0');
			Ram1(8) <= (others => '0');
			Ram1(9) <= (others => '0');
			Ram1(10) <= (others => '0');
			Ram1(11) <= (others => '0');
			Ram1(12) <= (others => '0');
			Ram1(13) <= (others => '0');
			Ram1(14) <= (others => '0');
			Ram1(15) <= (others => '0');
			Ram1(16) <= (others => '0');
			Ram1(17) <= (others => '0');
			Ram1(18) <= (others => '0');
			Ram1(19) <= (others => '0');
			Ram1(20) <= (others => '0');
			Ram1(21) <= (others => '0');
			Ram1(22) <= (others => '0');
			Ram1(23) <= (others => '0');
			Ram1(24) <= (others => '0');
			Ram1(25) <= (others => '0');
			Ram1(26) <= (others => '0');
			Ram1(27) <= (others => '0');
			Ram1(28) <= (others => '0');
			Ram1(29) <= (others => '0');
			Ram1(30) <= (others => '0');
			Ram1(31) <= (others => '0');
		elsif (clk_scan'event and clk_scan = '1' and startedCache = '1') then
			if (triggercache /= (LFlag & SFlag & Address & DataS & InstructionAddress)) then
				triggerCache <= LFlag & SFlag & Address & DataS & InstructionAddress;
				if (((LFlag or SFlag) = '1') and Address < x"8000") then
					if (LFlag = '1') then
						Result <= Ram2(conv_integer(Address(4 downto 0)));
						Result_L <= Ram2(conv_integer(Address(4 downto 0)));
						Result_L_pointer <= '1';
					else
						Ram2(conv_integer(Address(4 downto 0))) <= DataS;
						Result <= (others => '0');
						Result_L <= (others => '0');
						Result_L_pointer <= '0';
					end if;
					InstructionResult <= (others => '0');
				else
					InstructionResult <= Ram2(conv_integer(InstructionAddress(4 downto 0)));
					if (LFlag = '1') then
						Result <= Ram1(conv_integer(Address(4 downto 0)));
						Result_L <= Ram1(conv_integer(Address(4 downto 0)));
						Result_L_pointer <= '1';
					elsif (SFlag = '1') then
						Ram1(conv_integer(Address(4 downto 0))) <= DataS;
						Result <= (others => '0');
						Result_L <= (others => '0');
						Result_L_pointer <= '1';
					else
						Result <= Address;
						Result_L <= Address;
						Result_L_pointer <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
end bhv;
