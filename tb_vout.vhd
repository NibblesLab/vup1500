library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vout is
end tb_vout;

architecture test_bench of tb_vout is

component videoout
	Port (
		RST    : in std_logic;		-- Reset
		PCGSW  : in std_logic;		-- PCG Mode
		-- Clocks
		CK50M  : in std_logic;		-- Master Clock(50MHz)
		CK57M  : out std_logic;		-- NTSC Base Clock(57MHz)
		CK7M16 : out std_logic;		-- 15.6kHz Dot Clock(8MHz)
		CK3125 : out std_logic;		-- Music Base Clock(31.25kHz)
		ZCLK   : in std_logic;		-- Z80 Clock
		-- CPU Signals
		A      : in std_logic_vector(12 downto 0);	-- CPU Address Bus
		CSD_x  : in std_logic;								-- CPU Memory Request(VRAM)
		CSE_x  : in std_logic;								-- CPU Memory Request(Control)
		CSG_x  : in std_logic;								-- CPU Memory Request(GRAM)
		CSF0_x : in std_logic;								-- Priority Register Access
		CSF1_x : in std_logic;								-- Palet Register Access
		GBANK  : in std_logic_vector(1 downto 0);		-- CGROM/PCG Bank Select
		RD_x   : in std_logic;								-- CPU Read Signal
		WR_x   : in std_logic;								-- CPU Write Signal
		MREQ_x : in std_logic;								-- CPU Memory Request
		WAIT_x : out std_logic;								-- CPU Wait Request
		DI     : in std_logic_vector(7 downto 0);		-- CPU Data Bus(in)
		DO     : out std_logic_vector(7 downto 0);	-- CPU Data Bus(out)
		-- Video Signals
		HSI_x  : in std_logic;		-- Horizontal Sync(from MZ-700)
		VSI_x  : in std_logic;		-- Vertical Sync(from MZ-700)
		BLNK   : out std_logic;		-- Horizontal Blanking(15.7kHz)
		LOAD_x : out std_logic;		-- Stretched Load Pulse(895kHz)
 		HSYNC  : out std_logic;		-- Horizontal Sync
--		VSYNC  : out std_logic;		-- Vertical Sync
		ROUT   : out std_logic;		-- Red Output
		GOUT   : out std_logic;		-- Green Output
		BOUT   : out std_logic		-- Blue Output
	);
end component;

signal RST : std_logic;		-- Reset
signal PCGSW : std_logic;		-- PCG Mode
signal CK50M : std_logic := '0';	-- Master Clock(50MHz)
signal CK57M : std_logic;		-- NTSC Base Clock(57MHz)
signal CK7M16 : std_logic;		-- 15.6kHz Dot Clock(8MHz)
signal CK3125 : std_logic;		-- Music Base Clock(31.25kHz)
signal ZCLK : std_logic := '0';		-- Z80 Clock
signal A : std_logic_vector(12 downto 0);	-- CPU Address Bus
signal CSD_x : std_logic;								-- CPU Memory Request(VRAM)
signal CSE_x : std_logic;								-- CPU Memory Request(Control)
signal CSG_x : std_logic;								-- CPU Memory Request(GRAM)
signal CSF0_x : std_logic;								-- Priority Register Access
signal CSF1_x : std_logic;								-- Palet Register Access
signal GBANK : std_logic_vector(1 downto 0);		-- CGROM/PCG Bank Select
signal RD_x : std_logic;								-- CPU Read Signal
signal WR_x : std_logic;								-- CPU Write Signal
signal MREQ_x : std_logic;								-- CPU Memory Request
signal WAIT_x : std_logic;								-- CPU Wait Request
signal DI : std_logic_vector(7 downto 0);		-- CPU Data Bus(in)
signal DO : std_logic_vector(7 downto 0);	-- CPU Data Bus(out)
signal HSI_x : std_logic := '1';		-- Horizontal Sync(from MZ-700)
signal VSI_x : std_logic;		-- Vertical Sync(from MZ-700)
signal BLNK : std_logic;		-- Horizontal Blanking(15.7kHz)
signal LOAD_x : std_logic;		-- Stretched Load Pulse(895kHz)
signal HSYNC : std_logic;		-- Horizontal Sync
signal ROUT : std_logic;		-- Red Output
signal GOUT : std_logic;		-- Green Output
signal BOUT : std_logic;		-- Blue Output

begin

	module : videoout Port map(
		RST => RST,		-- Reset
		PCGSW => PCGSW,		-- PCG Mode
		-- Clocks
		CK50M => CK50M,		-- Master Clock(50MHz)
		CK57M => CK57M,		-- NTSC Base Clock(57MHz)
		CK7M16 => CK7M16,		-- 15.6kHz Dot Clock(8MHz)
		CK3125 => CK3125,		-- Music Base Clock(31.25kHz)
		ZCLK => ZCLK,		-- Z80 Clock
		-- CPU Signals
		A => A,	-- CPU Address Bus
		CSD_x => CSD_x,								-- CPU Memory Request(VRAM)
		CSE_x => CSE_x,								-- CPU Memory Request(Control)
		CSG_x => CSG_x,								-- CPU Memory Request(GRAM)
		CSF0_x => CSF0_x,								-- Priority Register Access
		CSF1_x => CSF1_x,								-- Palet Register Access
		GBANK => GBANK,		-- CGROM/PCG Bank Select
		RD_x => RD_x,								-- CPU Read Signal
		WR_x => WR_x,								-- CPU Write Signal
		MREQ_x => MREQ_x,								-- CPU Memory Request
		WAIT_x => WAIT_x,								-- CPU Wait Request
		DI => DI,		-- CPU Data Bus(in)
		DO => DO,	-- CPU Data Bus(out)
		-- Video Signals
		HSI_x => HSI_x,		-- Horizontal Sync(from MZ-700)
		VSI_x => VSI_x,		-- Vertical Sync(from MZ-700)
		BLNK => BLNK,		-- Horizontal Blanking(15.7kHz)
		LOAD_x => LOAD_x,		-- Stretched Load Pulse(895kHz)
		HSYNC => HSYNC,		-- Horizontal Sync
--		VSYNC  : out std_logic;		-- Vertical Sync
		ROUT => ROUT,		-- Red Output
		GOUT => GOUT,		-- Green Output
		BOUT => BOUT		-- Blue Output
	);

	--
	-- Signals
	--
	RST<='0', '1' after 100 ns;
	CK50M<=not CK50M after 10 ns;
	ZCLK<=not ZCLK after 139.7 ns;
	PCGSW<='0';
	A<="0000000000000";
	CSD_x<='1';
	CSE_x<='1';
	CSG_x<='1';
	CSF0_x<='1';
	CSF1_x<='1';
	GBANK<="01";
	RD_x<='1';
	WR_x<='1';
	MREQ_x<='1';
	DI<="00000000";
	VSI_x<='1';
	process begin
		wait for 59155.6 ns; HSI_x<='0';
		wait for 4539.7 ns; HSI_x<='1';
	end process;
end;
