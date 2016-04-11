--
-- ScanConv.vhd
--
-- Up Scan Converter (15.6kHz->VGA)
-- for MZ-80C on FPGA
--
-- Nibbles Lab. 2012
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ScanConv is
	Port (
		CK57M  : in STD_LOGIC;		-- Base of MZ Dot Clock
		CK100M : in STD_LOGIC;		-- Base of VGA Dot Clock
		RI     : in STD_LOGIC;		-- Red Input
		GI     : in STD_LOGIC;		-- Green Input
		BI     : in STD_LOGIC;		-- Blue Input
		HSI    : in STD_LOGIC;		-- H-Sync Input(MZ,15.6kHz)
		RO     : out STD_LOGIC;		-- Red Output
		GO     : out STD_LOGIC;		-- Green Output
		BO     : out STD_LOGIC;		-- Blue Output
		HSO    : out STD_LOGIC);	-- H-Sync Output(VGA, 31kHz)
end ScanConv;

architecture RTL of ScanConv is

--
-- Signals
--
signal CTR100M : std_logic_vector(12 downto 0);		-- VGA Horizontal Counter
signal TS : std_logic_vector(11 downto 0);			-- Half of Horizontal
signal OCTR : std_logic_vector(11 downto 0);			-- Buffer Output Pointer
signal ICTR : std_logic_vector(11 downto 0);			-- Buffer Input Pointer
signal Hi : std_logic_vector(5 downto 0);				-- Shift Register for H-Sync Detect(VGA)
signal Si : std_logic_vector(5 downto 0);				-- Shift Register for H-Sync Detect(15.6kHz)
signal DO : std_logic_vector(2 downto 0);
signal WEA : std_logic;

--
-- Components
--
component linebuf
	PORT
	(
		data			: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		rdaddress	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdclock		: IN STD_LOGIC ;
		wraddress	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrclock		: IN STD_LOGIC  := '1';
		wren			: IN STD_LOGIC  := '0';
		q				: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
end component;

begin

	--
	-- Instantiation
	--
	SBUF : linebuf PORT MAP (
		data	 		=> RI&GI&BI,				-- Input RGB
		rdaddress	=> OCTR(11 downto 2),	-- Buffer Output Counter
		rdclock	 	=> CK100M,					-- Dot Clock(VGA)
		wraddress	=> ICTR(11 downto 2),	-- Buffer Input Counter
		wrclock	 	=> CK57M,					-- Dot Clock(15.6kHz)
		wren	 		=> WEA,						-- Write Enable
		q	 			=> DO							-- Output RGB
	);

	--
	-- Buffer Input
	--
	process( CK57M ) begin
		if CK57M'event and CK57M='1' then

			-- Filtering HSI
			Si<=Si(4 downto 0)&HSI;

			-- Counter start
			if Si="111000" then
				ICTR<="111101010000";	-- X"F50" (3D4*4);
			else
				ICTR<=ICTR+'1';
			end if;

			-- Write Enable for Scan Convert Memory
			if ICTR(1 downto 0)="01" then
				WEA<='1';
			else
				WEA<='0';
			end if;
		end if;
	end process;

	--
	-- Buffer and Signal Output
	--
	process( CK100M ) begin
		if CK100M'event and CK100M='1' then

			-- Filtering HSI
			Hi<=Hi(4 downto 0)&HSI;

			-- Counter start
			if Hi="111000" then
				CTR100M<=(others=>'0');
				TS<=CTR100M(12 downto 1);	-- Half of Horizontal
				OCTR<=(others=>'0');
			elsif OCTR=TS then
				OCTR<=(others=>'0');
				CTR100M<=CTR100M+'1';
			else
				CTR100M<=CTR100M+'1';
				OCTR<=OCTR+'1';
			end if;

			-- Horizontal Sync genarate
			if OCTR=0 then
				HSO<='0';
			elsif OCTR=384 then
				HSO<='1';
			end if;

		end if;
	end process;

	--
	-- Output
	--
	RO<=DO(2);
	GO<=DO(1);
	BO<=DO(0);

end RTL;

