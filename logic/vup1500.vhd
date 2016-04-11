--
-- vup1500.vhd
--
-- MZ-1500 Version Up Adaptor, main module
-- for MZ-700
--
-- Nibbles Lab. 2015-2016
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vup1500 is
  port(
	-- Analog input
	AIN           : in    std_logic_vector( 7 downto 0);
	-- D-A Converter
	AD5681R_LDACn : out   std_logic;
	AD5681R_RSTn  : out   std_logic;
	AD5681R_SCL   : out   std_logic;
	AD5681R_SDA   : out   std_logic;
	AD5681R_SYNCn : out   std_logic;
	-- Temperature Sensor
	ADT7420_CT    : in    std_logic;
	ADT7420_INT   : in    std_logic;
	ADT7420_SCL   : out   std_logic;
	ADT7420_SDA   : inout std_logic;
	-- 3-Axis Accelerometer
	ADXL362_CS    : out   std_logic;
	ADXL362_INT1  : in    std_logic;
	ADXL362_INT2  : in    std_logic;
	ADXL362_MISO  : in    std_logic;
	ADXL362_MOSI  : out   std_logic;
	ADXL362_SCLK  : out   std_logic;
	-- GPIO J4
	I2C_SCL       : inout std_logic;
	I2C_SDA       : inout std_logic;
	ZADDR         : in    std_logic_vector(15 downto 0);
	--GPIO_J4_06    : in    std_logic;
	--GPIO_J4_05    : in    std_logic;
	--GPIO_J4_12    : in    std_logic;
	--GPIO_J4_11    : in    std_logic;
	--GPIO_J4_14    : in    std_logic;
	--GPIO_J4_13    : in    std_logic;
	--GPIO_J4_16    : in    std_logic;
	--GPIO_J4_15    : in    std_logic;
	--GPIO_J4_20    : in    std_logic;
	--GPIO_J4_19    : in    std_logic;
	--GPIO_J4_22    : in    std_logic;
	--GPIO_J4_21    : in    std_logic;
	--GPIO_J4_24    : in    std_logic;
	--GPIO_J4_23    : in    std_logic;
	--GPIO_J4_28    : in    std_logic;
	--GPIO_J4_27    : in    std_logic;
	ZDDIR         : out   std_logic;		--GPIO_J4_29
	ZDOE          : out   std_logic;		--GPIO_J4_30
	ZCLK          : in    std_logic;		--GPIO_J4_31;
	PCGSW         : in    std_logic;		--GPIO_J4_32;
	MREQ_x        : in    std_logic;		--GPIO_J4_35;
	IORQ_x        : in    std_logic;		--GPIO_J4_36;
	RD_x          : in    std_logic;		--GPIO_J4_37;
	WR_x          : in    std_logic;		--GPIO_J4_38;
	M1_x          : in    std_logic;		--GPIO_J4_39;
	ZRST          : in    std_logic;		--GPIO_J4_40;
	-- GPIO J5
	AUDIO_L       : out std_logic;		--GPIO_J5_01
	AUDIO_R       : out std_logic;		--GPIO_J5_02
	GPIO_J5_03    : inout std_logic;
	GPIO_J5_04    : inout std_logic;
	QD_M1         : out std_logic;		--GPIO_J5_05
	QD_CLK        : out std_logic;		--GPIO_J5_06
	QD_RST        : out std_logic;		--GPIO_J5_07
	QD_S1         : out std_logic;		--GPIO_J5_08
	GPIO_J5_09    : inout std_logic;
	GPIO_J5_10    : inout std_logic;
	GPIO_J5_13    : inout std_logic;
	GPIO_J5_14    : inout std_logic;
	GPIO_J5_15    : inout std_logic;
	GPIO_J5_16    : inout std_logic;
	GPIO_J5_17    : inout std_logic;
	RGB_VSI       : in std_logic;			--GPIO_J5_18;
	GPIO_J5_19    : inout std_logic;
	RGB_HSI       : in std_logic;			--GPIO_J5_20;
	GPIO_J5_21    : inout std_logic;
	GPIO_J5_22    : inout std_logic;
	GPIO_J5_23    : inout std_logic;
	RGB_BI        : in std_logic;			--GPIO_J5_24;
	GPIO_J5_25    : inout std_logic;
	RGB_GI        : in std_logic;			--GPIO_J5_26;
	GPIO_J5_27    : inout std_logic;
	RGB_RI        : in std_logic;			--GPIO_J5_28;
	GPIO_J5_31    : inout std_logic;
	GPIO_J5_32    : inout std_logic;
	QD_RD         : out std_logic;		--GPIO_J5_33
	QD_IORQ       : out std_logic;		--GPIO_J5_34
	QD_CS         : out std_logic;		--GPIO_J5_35
	QD_S0         : out std_logic;		--GPIO_J5_36
	MONSEL        : in  std_logic_vector(1 downto 0);	--GPIO_J5_37/GPIO_J5_39
	VGA_VSO       : out std_logic;		--GPIO_J5_38
	VGA_HSO       : out std_logic;		--GPIO_J5_40
	-- Card Edge
	EG_P1         : inout std_logic;
	EG_P2         : inout std_logic;
	EG_P3         : inout std_logic;
	EG_P4         : inout std_logic;
	EG_P5         : inout std_logic;
	EG_P6         : inout std_logic;
	EG_P7         : inout std_logic;
	EG_P8         : inout std_logic;
	EG_P9         : inout std_logic;
	EG_P10        : inout std_logic;
	EG_P11        : inout std_logic;
	EG_P12        : inout std_logic;
	EG_P13        : inout std_logic;
	EG_P14        : inout std_logic;
	EG_P15        : inout std_logic;
	EG_P16        : inout std_logic;
	EG_P17        : inout std_logic;
	EG_P18        : inout std_logic;
	EG_P19        : inout std_logic;
	EG_P20        : inout std_logic;
	EG_P21        : inout std_logic;
	EG_P22        : inout std_logic;
	EG_P23        : inout std_logic;
	EG_P24        : inout std_logic;
	EG_P25        : inout std_logic;
	EG_P26        : inout std_logic;
	EG_P27        : inout std_logic;
	EG_P28        : inout std_logic;
	EG_P29        : inout std_logic;
	EG_P35        : inout std_logic;
	EG_P36        : inout std_logic;
	EG_P37        : inout std_logic;
	EG_P38        : inout std_logic;
	EG_P39        : inout std_logic;
	EG_P40        : inout std_logic;
	EG_P41        : inout std_logic;
	EG_P42        : inout std_logic;
	EG_P43        : inout std_logic;
	EG_P44        : inout std_logic;
	EG_P45        : inout std_logic;
	EG_P46        : inout std_logic;
	EG_P47        : inout std_logic;
	EG_P48        : inout std_logic;
	EG_P49        : inout std_logic;
	EG_P50        : inout std_logic;
	EG_P51        : inout std_logic;
	EG_P52        : inout std_logic;
	EG_P53        : inout std_logic;
	EG_P54        : inout std_logic;
	EG_P55        : inout std_logic;
	EG_P56        : inout std_logic;
	EG_P57        : inout std_logic;
	EG_P58        : inout std_logic;
	EG_P59        : inout std_logic;
	EG_P60        : inout std_logic;
	EXP_PRESENT   : inout std_logic;
	RESET_EXPn    : inout std_logic;
	-- Serial Flash
	SFLASH_ASDI   : out   std_logic;
	SFLASH_CSn    : out   std_logic;
	SFLASH_DATA   : in    std_logic;
	SFLASH_DCLK   : out   std_logic;
	-- Push Button
	PB            : in    std_logic_vector( 3 downto 0);
	-- Pmod
	INT_x         : out   std_logic;		--PMOD_A(3)
	ZWAIT_x       : out   std_logic;		--PMOD_A(2)
	DOPIO5        : out   std_logic;		--PMOD_A(1)
	DOPIO4        : out   std_logic;		--PMOD_A(0)
	DOEPIO        : out   std_logic;		--PMOD_B(3)
	VGA_BO        : out   std_logic;		--PMOD_B(2)
	VGA_GO        : out   std_logic;		--PMOD_B(1)
	VGA_RO        : out   std_logic;		--PMOD_B(0)
	ZDT           : inout std_logic_vector( 7 downto 0);		--PMOD_C,PMOD_D
	-- SDRAM
	SDRAM_A       : out   std_logic_vector(12 downto 0);
	SDRAM_BA      : out   std_logic_vector( 1 downto 0);
	SDRAM_CASn    : out   std_logic;
	SDRAM_CKE     : out   std_logic;
	SDRAM_CLK     : out   std_logic;
	SDRAM_CSn     : out   std_logic;
	SDRAM_DQMH    : out   std_logic;
	SDRAM_DQML    : out   std_logic;
	SDRAM_DQ      : inout std_logic_vector(15 downto 0);
	SDRAM_RASn    : out   std_logic;
	SDRAM_WEn     : out   std_logic;
	-- Misc.
	SYS_CLK       : in    std_logic;
	USER_CLK      : in    std_logic;
	USER_LED      : out   std_logic_vector( 7 downto 0)
  );
end vup1500;

architecture rtl of vup1500 is
--
-- MZ-700 System Bus
--
signal ZRST_x : std_logic;
signal ZDTO : std_logic_vector(7 downto 0);
signal ZDTI : std_logic_vector(7 downto 0);
signal ZDDIRi : std_logic;
signal CSD_x : std_logic;
signal CSE_x : std_logic;
signal CSG_x : std_logic;
signal CSF0_x : std_logic;
signal CSF1_x : std_logic;
signal CSBANK : std_logic;
signal ENROM : std_logic;
signal ENPCG : std_logic;
signal GBANK : std_logic_vector(1 downto 0);
--
-- Clocks
--
signal CK57M : std_logic;
signal CK7M16 : std_logic;
signal CK100M : std_logic;
signal CK3125 : std_logic;
signal CK28M : std_logic;
--
-- Monitor ROM
--
signal CSE8_x : std_logic;
signal DOMROM : std_logic_vector(7 downto 0);
--
-- PPI
--
signal CSE0_x : std_logic;
signal PPIPA : std_logic_vector(7 downto 0);
signal PPIPB : std_logic_vector(7 downto 0);
signal PPIPC : std_logic_vector(7 downto 0);
--
-- PIT
--
signal CSE1_x : std_logic;
signal CASCADE12 : std_logic;
signal INT0MASK : std_logic;
signal INTT0 : std_logic;
signal INTT1 : std_logic;
signal SOUND : std_logic;
--
-- PIO
--
signal CSPIO_x : std_logic;
signal DOPIO : std_logic_vector(7 downto 0);
signal PIOPA : std_logic_vector(7 downto 0);
signal PIOPB : std_logic_vector(7 downto 0);
--
-- Video
--
signal VIDDO : std_logic_vector(7 downto 0);
signal HSYNCi : std_logic;
signal Bi : std_logic;
signal Gi : std_logic;
signal Ri : std_logic;
signal BLNK : std_logic;
signal LOAD_x : std_logic;
signal VWAIT : std_logic;
--
-- Miscellaneous
--
signal CSE2_x : std_logic;
signal CSVOICE_x : std_logic;
--
-- Quick Disk
--
signal CSSIO_x : std_logic;
--
-- PSG
--
signal CSF2_x : std_logic;
signal CSF3_x : std_logic;
signal SWAIT0 : std_logic;
signal SWAIT1 : std_logic;
--
-- SDRAM
--
signal MCS_x : std_logic;
signal MADR : std_logic_vector(22 downto 0);
signal DORAM : std_logic_vector(7 downto 0);
signal DORAM0 : std_logic_vector(7 downto 0);
signal SDRAMDO : std_logic_vector(15 downto 0);
signal SDRAMDOE : std_logic;
--
-- RAM File
--
signal CSEA_x : std_logic;
signal CSEB_x : std_logic;
signal SNSCSR : std_logic;
signal RFADR : std_logic_vector(15 downto 0);
--
-- EMM
--
signal CS00_x : std_logic;
signal CS01_x : std_logic;
signal CS02_x : std_logic;
signal CS03_x : std_logic;
signal SNSCSM : std_logic;
signal EMMADR : std_logic_vector(18 downto 0);
--
-- KANJI/JISHO ROM
--
signal CSB8_x : std_logic;
signal CSB9_x : std_logic;
signal SNS_B9 : std_logic_vector(6 downto 0);
signal KANJI : std_logic;
signal ENDIAN : std_logic;
signal BANK : std_logic_vector(1 downto 0);
signal SNSCSK : std_logic;
signal FADR : std_logic_vector(15 downto 0);
signal FCNT : std_logic_vector(5 downto 0);
signal BITCNT : std_logic_vector(5 downto 0);
signal FCS : std_logic;
signal SR_TX : std_logic_vector(31 downto 0);
signal SR_RX : std_logic_vector(7 downto 0);
signal KDAT : std_logic_vector(7 downto 0);

--
-- Components
--
component mrom
	port(
		ZCLK   : in std_logic;		-- Z80 Clock
		A      : in std_logic_vector(12 downto 0);	-- CPU Address Bus
		CS_x   : in std_logic;								-- CPU Memory Request(Control)
		DO     : out std_logic_vector(7 downto 0)		-- CPU Data Bus(out)
);
end component;

component i8255
	Port (
		RST	 : in std_logic;
		CLK	 : in std_logic;
		A		 : in std_logic_vector(1 downto 0);
		CS		 : in std_logic;
		RD		 : in std_logic;
		WR		 : in std_logic;
		DI		 : in std_logic_vector(7 downto 0);
		DO		 : out std_logic_vector(7 downto 0);
		-- Port
		PA		 : out std_logic_vector(7 downto 0);
		PB		 : in std_logic_vector(7 downto 0);
		PC		 : out std_logic_vector(7 downto 0);
		-- Mode
		MZMODE : in std_logic;								-- Hardware Mode
		-- for Debug
		LDDAT  : out std_logic_vector(7 downto 0)
--		LDDAT2 : out std_logic;
--		LDSNS  : out std_logic;
	);
end component;

component i8253
   Port (
		RST : in std_logic;
		CLK : in std_logic;
		A : in std_logic_vector(1 downto 0);
		DI : in std_logic_vector(7 downto 0);
		DO : out std_logic_vector(7 downto 0);
		CS : in std_logic;
		WR : in std_logic;
		RD : in std_logic;
		CLK0 : in std_logic;
		GATE0 : in std_logic;
		OUT0 : out std_logic;
		CLK1 : in std_logic;
		GATE1 : in std_logic;
		OUT1 : out std_logic;
		CLK2 : in std_logic;
		GATE2 : in std_logic;
		OUT2 : out std_logic
	);
end component;

component z8420
	Port (
		-- System
		RST	 : in std_logic;								-- Only Power On Reset
		-- Z80 Bus Signals
		CLK	 : in std_logic;
		BASEL	 : in std_logic;
		CDSEL	 : in std_logic;
		CE		 : in std_logic;
		RD_x	 : in std_logic;
		WR_x	 : in std_logic;
		IORQ_x : in std_logic;
		M1_x	 : in std_logic;
		DI     : in std_logic_vector(7 downto 0);
		DO     : out std_logic_vector(7 downto 0);
		IEI	 : in std_logic;
		IEO	 : out std_logic;
		INT_x	 : out std_logic;
		-- Port
		AI		 : in std_logic_vector(7 downto 0);
		AO		 : out std_logic_vector(7 downto 0);
		BI		 : in std_logic_vector(7 downto 0);
		BO		 : out std_logic_vector(7 downto 0);
		-- for Debug
		LDDAT  : out std_logic_vector(7 downto 0)
--		LDDAT2 : out std_logic;
--		LDSNS  : out std_logic;
	);
end component;

component psg
	port (RST_n : in  STD_LOGIC;
			clk	: in  STD_LOGIC;
			CE_n	: in  STD_LOGIC;
			WR_n	: in  STD_LOGIC;
			D_in	: in  STD_LOGIC_VECTOR (7 downto 0);
			daclk	: in  STD_LOGIC;
			ready : out STD_LOGIC;
			input : in  STD_LOGIC;
			output: out STD_LOGIC);
end component;

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

component ScanConv
	Port (
		CK57M  : in STD_LOGIC;		-- MZ Dot Clock
		CK100M : in STD_LOGIC;		-- VGA Dot Clock
		RI     : in STD_LOGIC;		-- Red Input
		GI     : in STD_LOGIC;		-- Green Input
		BI     : in STD_LOGIC;		-- Blue Input
		HSI    : in STD_LOGIC;		-- H-Sync Input(MZ,15.6kHz)
		RO     : out STD_LOGIC;		-- Red Output
		GO     : out STD_LOGIC;		-- Green Output
		BO     : out STD_LOGIC;		-- Blue Output
		HSO    : out STD_LOGIC		-- H-Sync Output(VGA, 31kHz)
	);
end component;

component pll100
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC 
	);
end component;

component sdram
	port (
		reset			: in std_logic;								-- Reset
		RSTOUT		: out std_logic;								-- Reset After Init. SDRAM
		MEMCLK		: in std_logic;								-- Fast Clock(100MHz)
		SCLK			: in std_logic;								-- Slow Clock (31.25kHz)
		-- RAM access(port-A:Z80 bus)
		AA				: in std_logic_vector(22 downto 0);		-- Address
		DAI			: in std_logic_vector(7 downto 0);		-- Data Input(16bit)
		DAO			: out std_logic_vector(7 downto 0);		-- Data Output(16bit)
		CSA			: in std_logic;								-- Chip Select
		WEA			: in std_logic;								-- Write Enable
		PGA			: in std_logic;								-- Purge Cache
		-- RAM access(port-B:Avalon bus bridge)
		AB				: in std_logic_vector(20 downto 0);		-- Address
		DBI			: in std_logic_vector(31 downto 0);		-- Data Input(32bit)
		DBO			: out std_logic_vector(31 downto 0);	-- Data Output(32bit)
		CSB			: in std_logic;								-- Chip Select
		WEB			: in std_logic;								-- Write Enable
		BEB			: in std_logic_vector(3 downto 0);		-- Byte Enable
		WQB			: out std_logic;								-- CPU Wait
		-- RAM access(port-C:Reserve)
		AC				: in std_logic_vector(21 downto 0);		-- Address
		DCI			: in std_logic_vector(15 downto 0);		-- Data Input(16bit)
		DCO			: out std_logic_vector(15 downto 0);	-- Data Output(16bit)
		CSC			: in std_logic;								-- Chip Select
		WEC			: in std_logic;								-- Write Enable
		BEC			: in std_logic_vector(1 downto 0);		-- Byte Enable
		-- RAM access(port-D:FD Buffer Access port)
		AD				: in std_logic_vector(22 downto 0);		-- Address
		DDI			: in std_logic_vector(7 downto 0);		-- Data Input(16bit)
		DDO			: out std_logic_vector(7 downto 0);		-- Data Output(16bit)
		CSD			: in std_logic;								-- Chip Select
		WED			: in std_logic;								-- Write Enable
		--BED			: in std_logic_vector(1 downto 0);		-- Byte Enable
		-- RAM access(port-E:Graphics Video Memory)
		AE				: in std_logic_vector(20 downto 0);		-- Address
		DEI			: in std_logic_vector(31 downto 0);		-- Data Input(32bit)
		DEO			: out std_logic_vector(31 downto 0);	-- Data Output(32bit)
		CSE			: in std_logic;								-- Chip Select
		WEE			: in std_logic;								-- Write Enable
		BEE			: in std_logic_vector(3 downto 0);		-- Byte Enable
		-- SDRAM signal
		MA				: out std_logic_vector(11 downto 0);	-- Address
		MBA0			: out std_logic;								-- Bank Address 0
		MBA1			: out std_logic;								-- Bank Address 1
		MDI			: in std_logic_vector(15 downto 0);		-- Data Input(16bit)
		MDO			: out std_logic_vector(15 downto 0);	-- Data Output(16bit)
		MDOE			: out std_logic;								-- Data Output Enable
		MLDQ			: out std_logic;								-- Lower Data Mask
		MUDQ			: out std_logic;								-- Upper Data Mask
		MCAS			: out std_logic;								-- Column Address Strobe
		MRAS			: out std_logic;								-- Raw Address Strobe
		MCS			: out std_logic;								-- Chip Select
		MWE			: out std_logic;								-- Write Enable
		MCKE			: out std_logic								-- Clock Enable
	);
end component;

begin

	--
	-- Instantiation
	--
	MROM0 : mrom port map (
		ZCLK => SYS_CLK,				-- Clock
		A => ZADDR(12 downto 0),	-- CPU Address Bus
		CS_x => CSE8_x,				-- CPU Memory Request(Control)
		DO => DOMROM					-- CPU Data Bus(out)
	);

	PPI0 : i8255 port map (
		RST => ZRST_x,
		CLK => ZCLK,
		A => ZADDR(1 downto 0),
		CS => CSE0_x,
		RD	=> RD_x,
		WR => WR_x,
		DI => ZDTI,
		DO => open,
		-- Port
		PA => PPIPA,
		PB => PPIPB,
		PC => PPIPC,
		-- Mode
		MZMODE => '1',			-- Hardware Mode
		-- for Debug
		LDDAT => open
--		LDDAT2 => LD(5),
--		LDSNS => LD(6),
	);

	PIT0 : i8253 port map (
		RST => ZRST_x,
		CLK => ZCLK,
		A => ZADDR(1 downto 0),
		DI => ZDTI,
		DO => open,
		CS => CSE1_x,
		WR => WR_x,
		RD => RD_x,
		CLK0 => LOAD_x,
		GATE0 => INT0MASK,
		OUT0 => INTT0,
		CLK1 => BLNK,
		GATE1 => '1',
		OUT1 => CASCADE12,
		CLK2 => CASCADE12,
		GATE2 => '1',
		OUT2 => INTT1
	);

	PIO0 : z8420 port map (
		-- System
		RST => ZRST_x,						-- Only Power On Reset
		-- Z80 Bus Signals
		CLK => ZCLK,
		BASEL => ZADDR(0),
		CDSEL => not ZADDR(1),
		CE => CSPIO_x,
		RD_x => RD_x,
		WR_x => WR_x,
		IORQ_x => IORQ_x,
		M1_x => M1_x,
		DI => ZDTI,
		DO => DOPIO,
		IEI => '1',
		IEO => open,
		INT_x => INT_x,
		-- Port
		AI => PIOPA,
		AO => open,
		BI => PIOPB,
		BO => open,
		-- for Debug
		LDDAT => open
--		LDDAT2 : out std_logic;
--		LDSNS  : out std_logic;
	);

	PSG0 : psg port map (
		RST_n => ZRST_x,
		clk => ZCLK,
		CE_n => CSF2_x,
		WR_n => WR_x,
		D_in => ZDTI,
		daclk	=> SYS_CLK,
		ready => SWAIT0,
		input => SOUND,
		output => AUDIO_L
	);

	PSG1 : psg port map (
		RST_n => ZRST_x,
		clk => ZCLK,
		CE_n => CSF3_x,
		WR_n => WR_x,
		D_in => ZDTI,
		daclk	=> SYS_CLK,
		ready => SWAIT1,
		input => '0',
		output => AUDIO_R
	);

	VIDEO0 : videoout Port map (
		RST => ZRST_x,					-- Reset
		PCGSW => PCGSW,				-- PCG Mode
		-- Clocks
		CK50M => SYS_CLK,				-- Master Clock(50MHz)
		CK57M => CK57M,				-- NTSC Base Clock(57MHz)
		CK7M16 => CK7M16,				-- 15.6kHz Dot Clock(8MHz)
		CK3125 => CK3125,				-- Music Base Clock(31.25kHz)
		ZCLK => ZCLK,					-- Z80 Clock
		-- CPU Signals
		A => ZADDR(12 downto 0),	-- CPU Address Bus
		CSD_x => CSD_x,				-- CPU Memory Request(VRAM)
		CSE_x => CSE_x,				-- CPU Memory Request(Control)
		CSG_x => CSG_x,				-- CPU Memory Request(GRAM)
		CSF0_x => CSF0_x,				-- Priority Register Access
		CSF1_x => CSF1_x,				-- Palet Register Access
		GBANK => GBANK,				-- CGROM/PCG Bank Select
		RD_x => RD_x,					-- CPU Read Signal
		WR_x => WR_x,					-- CPU Write Signal
		MREQ_x => MREQ_x,				-- CPU Memory Request
		WAIT_x => VWAIT,				-- CPU Wait Request
		DI => ZDTI,						-- CPU Data Bus(in)
		DO => VIDDO,					-- CPU Data Bus(out)
		-- Video Signals
		HSI_x => RGB_HSI,				-- Horizontal Sync(from MZ-700)
		VSI_x => RGB_VSI,				-- Vertical Sync(from MZ-700)
		BLNK => BLNK,					-- Horizontal Blanking(15.7kHz)
		LOAD_x => LOAD_x,				-- Stretched Load Pulse(895kHz)
		HSYNC => HSYNCi,				-- Horizontal Sync
--		VSYNC => open,					-- Vertical Sync
		ROUT => Ri,						-- Red Output
		GOUT => Gi,						-- Green Output
		BOUT => Bi						-- Blue Output
	);

	SCONV0 : ScanConv Port map (
		CK57M => CK57M,		-- MZ Dot Clock
		CK100M => CK100M,		-- VGA Dot Clock
		RI => Ri,				-- Red Input
		GI => Gi,				-- Green Input
		BI => Bi,				-- Blue Input
		HSI => HSYNCi,			-- H-Sync Input(MZ,15.6kHz)
		RO => VGA_RO,			-- Red Output
		GO => VGA_GO,			-- Green Output
		BO => VGA_BO,			-- Blue Output
		HSO => VGA_HSO			-- H-Sync Output(VGA, 31kHz)
	);

	CKGEN0 : pll100 PORT MAP (
		inclk0	 => SYS_CLK,
		c0	 => CK100M,
		c1	 => SDRAM_CLK
	);

	DRAM0 : sdram port map (
		reset => ZRST_x,						-- Reset
		RSTOUT => open,						-- Reset After Init. SDRAM
		MEMCLK => CK100M,						-- Fast Clock(100MHz)
		SCLK => CK3125,						-- Slow Clock (31.25kHz)
		-- RAM access(port-A:Z80 Memory Bus)
		AA => MADR,								-- Address
		DAI => ZDTI,							-- Data Input(16bit)
		DAO => DORAM0,							-- Data Output(16bit)
		CSA => MCS_x,							-- Chip Select
		WEA => WR_x,							-- Write Enable
		PGA => ZRST_x,							-- Purge Cache
		-- RAM access(port-B:Avalon Bus)
		AB => (others=>'1'),					-- Address
		DBI => (others=>'0'),				-- Data Input(32bit)
		DBO => open,							-- Data Output(32bit)
		CSB => '1',								-- Chip Select
		WEB => '1',								-- Write Enable
		BEB => "1111",							-- Byte Enable
		WQB => open,							-- CPU Wait
		-- RAM access(port-C:Reserve)
		AC => (others=>'1'),					-- Address
		DCI => (others=>'0'),				-- Data Input(16bit)
		DCO => open,							-- Data Output(16bit)
		CSC => '1',								-- Chip Select
		WEC => '1',								-- Write Enable
		BEC => "11",							-- Byte Enable
		-- RAM access(port-D:FD Buffer)
		AD => (others=>'1'),					-- Address
		DDI => (others=>'0'),				-- Data Input(16bit)
		DDO => open,							-- Data Output(16bit)
		CSD => '1',								-- Chip Select
		WED => '1',								-- Write Enable
		--BED => "00",							-- Byte Enable
		-- RAM access(port-E:Graphics Video Memory)
		AE => (others=>'1'),					-- Address
		DEI => (others=>'0'),				-- Data Input(32bit)
		DEO => open,							-- Data Output(32bit)
		CSE => '1',								-- Chip Select
		WEE => '1',								-- Write Enable
		BEE => "1111",							-- Byte Enable
		-- SDRAM signal
		MA => SDRAM_A(11 downto 0),		-- Address
		MBA0 => SDRAM_BA(0),					-- Bank Address 0
		MBA1 => SDRAM_BA(1),					-- Bank Address 1
		MDI => SDRAM_DQ,						-- Data Input(16bit)
		MDO => SDRAMDO,						-- Data Output(16bit)
		MDOE => SDRAMDOE,						-- Data Output Enable
		MLDQ => SDRAM_DQML,					-- Lower Data Mask
		MUDQ => SDRAM_DQMH,					-- Upper Data Mask
		MCAS => SDRAM_CASn,					-- Column Address Strobe
		MRAS => SDRAM_RASn,					-- Raw Address Strobe
		MCS => SDRAM_CSn,						-- Chip Select
		MWE => SDRAM_WEn,						-- Write Enable
		MCKE => SDRAM_CKE						-- Clock Enable
	);

	--
	-- Chip Select
	--
	CSE_x <='0' when ZADDR(15 downto 11)="11100" and MREQ_x='0' and ENROM='1' and ENPCG='0' else '1';
	CSD_x <='0' when ZADDR(15 downto 12)="1101" and MREQ_x='0' and ENROM='1' and ENPCG='0' else '1';
	CSE0_x<='0' when CSE_x='0' and ZADDR(3 downto 2)="00" else '1';
	CSE1_x<='0' when CSE_x='0' and ZADDR(3 downto 2)="01" else '1';
	CSE2_x<='0' when CSE_x='0' and ZADDR(3 downto 2)="10" else '1';
	CSE8_x<='0' when (ZADDR(15 downto 11)="11101" or ZADDR(15 downto 12)="1111")
							and MREQ_x='0' and ENROM='1' and ENPCG='0' else '1';
	CSG_x <='0' when (ZADDR(15 downto 12)="1101" or ZADDR(15 downto 12)="1110")
							and MREQ_x='0' and ENPCG='1' else '1';
	CSF0_x<='0' when ZADDR(7 downto 0)=X"F0" and IORQ_x='0' else '1';
	CSF1_x<='0' when ZADDR(7 downto 0)=X"F1" and IORQ_x='0' else '1';
	CSF2_x<='0' when (ZADDR(7 downto 0)=X"F2" or ZADDR(7 downto 0)=X"E9") and IORQ_x='0' else '1';
	CSF3_x<='0' when (ZADDR(7 downto 0)=X"F3" or ZADDR(7 downto 0)=X"E9") and IORQ_x='0' else '1';
	CSBANK<='1' when ZADDR(7 downto 3)="11100" and IORQ_x='0' else '0';
	CSSIO_x<='0' when ZADDR(7 downto 2)="111101" and IORQ_x='0' else '1';
	CSPIO_x<='0' when ZADDR(7 downto 2)="111111" and IORQ_x='0' else '1';
	CSVOICE_x<='0' when ZADDR(7 downto 0)=X"E8" and IORQ_x='0' else '1';
	CSEA_x<='0' when ZADDR(7 downto 0)=X"EA" and IORQ_x='0' else '1';
	CSEB_x<='0' when ZADDR(7 downto 0)=X"EB" and IORQ_x='0' else '1';
	CS00_x<='0' when ZADDR(7 downto 0)=X"00" and IORQ_x='0' else '1';
	CS01_x<='0' when ZADDR(7 downto 0)=X"01" and IORQ_x='0' else '1';
	CS02_x<='0' when ZADDR(7 downto 0)=X"02" and IORQ_x='0' else '1';
	CS03_x<='0' when ZADDR(7 downto 0)=X"03" and IORQ_x='0' else '1';
	CSB8_x<='0' when ZADDR(7 downto 0)=X"B8" and IORQ_x='0' else '1';
	CSB9_x<='0' when ZADDR(7 downto 0)=X"B9" and IORQ_x='0' else '1';
	MCS_x<=CSEA_x and CS03_x;

	--
	-- Registers
	--
	process( ZRST_x, ZCLK ) begin
		if ZRST_x='0' then
			ENROM<='1';
			ENPCG<='0';
			INT0MASK<='0';
			GBANK<=(others=>'0');
			FCNT<=(others=>'0');
		elsif ZCLK'event and ZCLK='1' then
			if WR_x='0' then
				if CSBANK='1' then
					case ZADDR(2 downto 0) is
						when "001" => ENROM<='0';
						when "011" => ENROM<='1';
						when "100" => ENROM<='1'; ENPCG<='0';
						when "101" => ENPCG<='1'; GBANK<=ZDTI(1 downto 0);
						when "110" => ENPCG<='0';
						when others => ENROM<=ENROM; ENPCG<=ENPCG;
					end case;
				end if;
				if CSE2_x='0' then
					INT0MASK<=ZDTI(0);
				end if;
				if CSEB_x='0' then
					RFADR(7 downto 0)<=ZDTI(7 downto 0);
					RFADR(15 downto 8)<=ZADDR(15 downto 8);
				end if;
				if CS00_x='0' then
					EMMADR(7 downto 0)<=ZDTI;
				end if;
				if CS01_x='0' then
					EMMADR(15 downto 8)<=ZDTI;
				end if;
				if CS02_x='0' then
					EMMADR(18 downto 16)<=ZDTI(2 downto 0);
				end if;
				if CSB8_x='0' then
					KANJI<=ZDTI(7);
					ENDIAN<=ZDTI(6);
					BANK<=ZDTI(1 downto 0);
					FCNT<=(others=>'0');
				end if;
				if CSB9_x='0' then
					FADR<=ZADDR(15 downto 8)&ZDTI;
				end if;
			end if;
			SNSCSR<=CSEA_x;
			if SNSCSR='0' and CSEA_x='1' then
				RFADR<=RFADR+'1';
			end if;
			SNSCSM<=CS03_x;
			if SNSCSM='0' and CS03_x='1' then
				EMMADR<=EMMADR+'1';
			end if;
			SNSCSK<=CSB9_x or RD_x;
			if SNSCSK='0' and CSB9_x='1' then
				if KANJI='1' then
					if FCNT(5)='0' then
						FCNT<=FCNT+'1';
					end if;
				else
					FADR<=FADR+'1';
				end if;
			end if;
		end if;
	end process;

	--
	-- SROM Access
	--
	process( ZRST, CK57M ) begin
		if ZRST_x='0' then
			CK28M<='1';
			FCS<='1';
			BITCNT<=(others=>'0');
			SR_TX<=(others=>'1');
			SR_RX<=(others=>'1');
		elsif CK57M'event and CK57M='1' then
			SNS_B9<=SNS_B9(5 downto 0)&(CSB9_x or RD_x);
			if FCS='1' then
				if SNS_B9="1000000" and CSB9_x='0' and RD_x='0' then
					FCS<='0';
					BITCNT<="100111";
					if KANJI='1' then
						SR_TX<="00000011"&"0000000"&FADR(11 downto 0)&FCNT(4 downto 0);
					else
						SR_TX<="00000011"&"000001"&BANK&FADR;
					end if;
					CK28M<='0';
				end if;
			else
				if CK28M='0' then
					CK28M<='1';
				else
					SR_TX<=SR_TX(30 downto 0)&'0';
					if ENDIAN='0' then
						SR_RX<=SR_RX(6 downto 0)&SFLASH_DATA;
					else
						SR_RX<=SFLASH_DATA&SR_RX(7 downto 1);
					end if;
					if BITCNT="000000" then
						FCS<='1';
					else
						BITCNT<=BITCNT-'1';
						CK28M<='0';
					end if;
				end if;
			end if;
		end if;
	end process;

	KDAT<=SR_RX when RD_x='0' and CSB9_x='0' else (others=>'0');

	--
	-- Data Bus
	--
	ZDTO<=DOMROM or DOPIO or VIDDO or DORAM or KDAT;
	ZDDIRi<='1' when (RD_x='0' and (CSE8_x='0' or CSG_x='0' or CSVOICE_x='0' or CSEA_x='0' or CS03_x='0' or CSB9_x='0')) or (IORQ_x='0' and M1_x='0') else '0';
	DOEPIO<='0' when CSPIO_x='0' and ZADDR(1 downto 0)="10" and RD_x='0' else '1';

	--
	-- SDRAM
	--
	MADR<="0000000"&RFADR when CSEA_x='0' else
			"0001"&EMMADR   when CS03_x='0' else (others=>'0');
	DORAM<=DORAM0 when ((CSEA_x='0' or CS03_x='0') and RD_x='0') else (others=>'0');
	SDRAM_DQ<=SDRAMDO when SDRAMDOE='1' else (others=>'Z');

	--
	-- Signals
	--
	PIOPA(4)<=INTT0;
	PIOPA(5)<=INTT1;
	SOUND<=not (INTT0 and PPIPC(0));
	ZWAIT_x<=VWAIT and SWAIT0 and SWAIT1 and FCS;

	--
	-- Input Ports
	--
	ZDTI<=ZDT;
	ZRST_x<=not ZRST;

	--
	-- Output Ports
	--
	ZDOE<='0';
	DOPIO4<=DOPIO(4);	-- ZDTO(4)
	DOPIO5<=DOPIO(5);	-- ZDTO(5)
	ZDT<=ZDTO when ZDDIRi='1' else (others=>'Z');
	ZDDIR<=ZDDIRi;
	VGA_VSO<=RGB_VSI;
	QD_RST<=ZRST_x;
	QD_S0<=ZADDR(0);
	QD_S1<=ZADDR(1);
	QD_M1<=M1_x;
	QD_IORQ<=IORQ_x;
	QD_RD<=RD_x;
	QD_CS<=CSSIO_x;
	QD_CLK<=ZCLK;
	SFLASH_ASDI<=SR_TX(31);
	SFLASH_CSn<=FCS;
	SFLASH_DCLK<=CK28M;

	--
	-- Unused Outputs
	--
	USER_LED<=(others=>'1');

end rtl;
