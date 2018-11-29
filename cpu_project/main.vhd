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
		start : in std_logic;
		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;
		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		-- debug data output
		led : out std_logic_vector(15 downto 0)
	);
end main;

architecture bhv of main is
component cpu is
	port(
		-- pipeline clock
		clk : in std_logic;
		-- scan clock
		clk_scan : in std_logic;
		-- data mem
		Ram1Data : inout std_logic_vector(15 downto 0);
		Ram1Addr : out std_logic_vector(15 downto 0);
		Ram1OE, Ram1WE, Ram1EN : out std_logic;
		dataReady, rdn, wrn, tbre, tsre : inout std_logic;
		-- instruction mem
		Ram2Data : inout std_logic_vector(15 downto 0);
		Ram2Addr : out std_logic_vector(15 downto 0);
		Ram2OE, Ram2WE, Ram2EN : out std_logic;
		-- debug data output
		led : out std_logic_vector(15 downto 0)
	);
end component;
signal started : std_logic := '0';

begin
	process (start)
	begin
		if (start = '0') then
			started <= '1';
		end if;
	end process;
	cpu_instance : cpu port map(
		clk => clk and started,
		started => started,
		clk_scan => clk_scan,
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
		led => led
	);
end bhv;

