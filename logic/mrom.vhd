--
-- mrom.vhd
--
-- MZ-1500 Version Up Adaptor, 2nd monitor rom module
-- for MZ-700
--
-- Nibbles Lab. 2016
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mrom is
  port(
		ZCLK   : in std_logic;		-- Z80 Clock
		A      : in std_logic_vector(12 downto 0);	-- CPU Address Bus
		CS_x   : in std_logic;								-- CPU Memory Request(Control)
		DO     : out std_logic_vector(7 downto 0)		-- CPU Data Bus(out)
  );
end mrom;

architecture rtl of mrom is

signal D0 : std_logic_vector(7 downto 0);
signal D1 : std_logic_vector(7 downto 0);

component mrom2k
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component mrom4k
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

begin

	mrom0 : mrom2k PORT MAP (
		address	 => A(10 downto 0),
		clock	 => ZCLK,
		q	 => D0
	);

	mrom1 : mrom4k PORT MAP (
		address	 => A(11 downto 0),
		clock	 => ZCLK,
		q	 => D1
	);

	DO<=D0 when CS_x='0' and A(12 downto 11)="01" else
		 D1 when CS_x='0' and A(12)='1' else (others=>'0');

end rtl;
