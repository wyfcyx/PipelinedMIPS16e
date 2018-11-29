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
		started : in std_logic;
		clk_scan : in std_logic;

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
		Ram2OE, Ram2WE, Ram2EN : out std_logic
	);
end memory;

-- no comm, no write instruction mem now
architecture bhv of memory is
begin
	process (LFlag, SFlag, started)
	begin
		if (started = '1') then
			-- fetch instruction
			Ram2WE <= '1';
			Ram2OE <= '0';
			Ram2EN <= '0';
			Ram2Data <= (others => 'Z');
			Ram2Addr <= InstructionAddress;
			InstructionResult <= Ram2Data;	
			if (LFlag = '1') then
				Ram1WE <= '1';
				Ram1OE <= '0';
				Ram1EN <= '0';
				Ram1Data <= (others => 'Z');
				Ram1Addr <= Address;
				Result <= Ram1Data;
			elsif (SFlag = '1') then
				Ram1WE <= '0';
				Ram1OE <= '1';
				Ram1EN <= '0';
				Ram1Data <= DataS;
				Ram1Addr <= Address;
				Result <= (others => '0');
			else
				Result <= (others => '0');
			end if;
		else
			InstructionResult <= (others => '0');
			Result <= (others => '0');
		end if;
	end process;
end bhv;
