library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity main is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- scan clock
		clk_scan : in std_logic;
		-- start button
		reset : in std_logic;
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
		-- debug data output
		led : out std_logic_vector(15 downto 0);
		started : out std_logic
	);
end main;

architecture bhv of main is
component cpu is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- scan clock
		clk_scan : in std_logic;
		reset : in std_logic;
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
		-- debug data output
		led : out std_logic_vector(15 downto 0);
		started : out std_logic
	);
end component;
signal led_cpu : std_logic_vector(15 downto 0);
signal gen_clk_scan : std_logic;
signal gen_scan_count : std_logic_vector(31 downto 0) := (others => '0');
begin
	led <= led_cpu;
	cpu_instance : cpu port map(
		clk => clk,
		clk_scan => clk_scan,
		reset => reset,
		Ram1Data => Ram1Data,
		Ram1Addr => Ram1Addr,
		Ram1WE => Ram1WE,
		Ram1OE => Ram1OE,
		Ram1EN => Ram1EN,
		dataReady => dataReady,
		rdn => rdn,
		wrn => wrn,
		tbre => tbre,
		tsre => tsre,
		Ram2Data => Ram2Data,
		Ram2Addr => Ram2Addr,
		Ram2WE => Ram2WE,
		Ram2OE => Ram2OE,
		Ram2EN => Ram2EN,
		flashByte => flashByte,
		flashVpen => flashVpen,
		flashCE => flashCE,
		flashOE => flashOE,
		flashWE => flashWE,
		flashRP => flashRP,
		flashAddr => flashAddr,
		flashData => flashData,
		led => led_cpu,
		started => started
	);
	process (clk_scan)
	begin
		if (clk_scan'event and clk_scan = '1') then
			if (gen_scan_count = 11000) then
				gen_scan_count <= (others => '0');
				gen_clk_scan <= not gen_clk_scan;
			else
				gen_scan_count <= gen_scan_count + 1;
			end if;
		end if;
	end process;
end bhv;

