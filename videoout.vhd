--
-- videoout.vhd
--
-- Video display signal generator
-- for MZ-1500 Version Up Adaptor
--
-- Nibbles Lab. 2012-2016
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity videoout is
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
end videoout;

architecture RTL of videoout is

--
-- Clocks
--
signal CLK_x   : std_logic;	-- /CLK (7.15909MHz)
signal CK57Mi   : std_logic;	-- 57MHz
--
-- Registers
--
signal P        : std_logic_vector(10 downto 0);	-- VRAM Address(selected)
signal Y        : std_logic_vector(13 downto 0);	-- GRAM Address(selected)
signal Q        : std_logic_vector(2 downto 0);		-- VRAM Raster Counter(in character)
signal VADR     : std_logic_vector(9 downto 0);		-- VRAM Address(counter)
signal ADCH     : std_logic;								-- VRAM Address(MSB)
signal GADR     : std_logic_vector(12 downto 0);	-- GRAM Address(latch)
signal SDAT     : std_logic_vector(7 downto 0);		-- Shift Register to Display(Text)
signal ADAT     : std_logic_vector(7 downto 0);		-- Color Attribute(B-in Color)
signal BDAT     : std_logic_vector(7 downto 0);		-- Shift Register to Display(GRAM:Blue)
signal RDAT     : std_logic_vector(7 downto 0);		-- Shift Register to Display(GRAM:Red)
signal GDAT     : std_logic_vector(7 downto 0);		-- Shift Register to Display(GRAM:Green)
signal ADATi    : std_logic_vector(7 downto 0);		-- Color Attribute(B-in Color, before confrict)
signal CNT57M   : std_logic_vector(11 downto 0);	-- Base Counter
signal SNSVSI   : std_logic_vector(7 downto 0);		-- Falling Edge Detect(V-Sync input)
signal SNSHSI   : std_logic_vector(7 downto 0);		-- Falling Edge Detect(H-Sync input)
signal CNTRAST  : std_logic_vector(8 downto 0);		-- VRAM Raster Counter(whole Display)
signal PALET0   : std_logic_vector(2 downto 0);		-- Palet Register 0
signal PALET1   : std_logic_vector(2 downto 0);		--                1
signal PALET2   : std_logic_vector(2 downto 0);		--                2
signal PALET3   : std_logic_vector(2 downto 0);		--                3
signal PALET4   : std_logic_vector(2 downto 0);		--                4
signal PALET5   : std_logic_vector(2 downto 0);		--                5
signal PALET6   : std_logic_vector(2 downto 0);		--                6
signal PALET7   : std_logic_vector(2 downto 0);		--                7
--
-- CPU Access
--
signal CSV_x    : std_logic;								-- Chip Select (VRAM)
signal CSA_x    : std_logic;								-- Chip Select (ARAM)
signal VWEN     : std_logic;								-- WR + MREQ (VRAM)
signal AWEN     : std_logic;								-- WR + MREQ (ARAM)
signal GWEN0    : std_logic;								-- WR + MREQ (GRAM:Blue)
signal GWEN1    : std_logic;								-- WR + MREQ (GRAM:Red)
signal GWEN2    : std_logic;								-- WR + MREQ (GRAM:Green)
signal WAITi_x  : std_logic;								-- Wait
--signal WAITii_x : std_logic;								-- Wait(delayed)
--
-- Internal Signals
--
signal DISPEN  : std_logic;							-- Display Enable
signal RGBOi	: std_logic_vector(2 downto 0);	-- Display Signal
signal VRAMDO  : std_logic_vector(7 downto 0);	-- Data Bus Output for VRAM
signal ARAMDO  : std_logic_vector(7 downto 0);	-- Data Bus Output for ARAM(muxed)
signal ARAMDOi : std_logic_vector(7 downto 0);	-- Data Bus Output for ARAM
signal GRAM0DO : std_logic_vector(7 downto 0);	-- Data Bus Output for GRAM(Blue)
signal GRAM1DO : std_logic_vector(7 downto 0);	-- Data Bus Output for GRAM(Red)
signal GRAM2DO : std_logic_vector(7 downto 0);	-- Data Bus Output for GRAM(Green)
signal DCODE   : std_logic_vector(7 downto 0);	-- Display Code, Read From VRAM
signal CGDAT   : std_logic_vector(7 downto 0);	-- Font Data To Display
signal SNSCSD  : std_logic_vector(1 downto 0);	-- CSD detect
signal SNSCSG  : std_logic;							-- CSG detect
signal S157SR  : std_logic_vector(2 downto 0);	-- Select signal(Text)
signal GSEL    : std_logic;							-- Select signal(GRAM)
signal PRIPCG  : std_logic;							-- Display Priolity
signal DENPCG  : std_logic;							-- PCG Display Enable(from Register)
signal ENPCGi  : std_logic;							-- PCG Display Enable(from Attribute, save)
signal ENPCG   : std_logic;							-- PCG Display Enable(from Attribute)
signal ROMA    : std_logic_vector(11 downto 0);
signal COLR    : std_logic;
--
-- M60719
--
signal HSY_x   : std_logic := '1';					-- Horizontal Sync
signal HBLK_x  : std_logic := '1';					-- Horizontal Blanking
signal VBLK_x  : std_logic := '1';					-- Vertical Blanking
signal BLNKi   : std_logic := '0';					-- Horizontal Blanking
signal pBLNK   : std_logic := '0';					-- Horizontal Blanking(GRAM)
signal SYN_x   : std_logic := '1';					-- Vertical Sync
signal S157    : std_logic := '1';					-- Bus Select

--
-- Components
--
component ram2k
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component ram8k
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

component pcg
	Port (
		RST_x  : in std_logic;
		-- CG-ROM I/F
		ROMA   : in std_logic_vector(11 downto 0);
		ROMD   : out std_logic_vector(7 downto 0);
		DCLK   : in std_logic;
		-- CPU Bus
		A      : in std_logic_vector(11 downto 0);
		DI     : in std_logic_vector(7 downto 0);
		CSE_x  : in std_logic;
		WR_x   : in std_logic;
		MCLK   : in std_logic;
		-- Settings
		PCGSW  : in std_logic
	);
end component;

component pll57
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC
	);
end component;

begin

	--
	-- Instantiation
	--
	VVRAM0 : ram2k PORT MAP (
		address	 => P,
		clock	 => CK57Mi,
		data	 => DI,
		wren	 => VWEN,
		q	 => VRAMDO
	);

	VARAM0 : ram2k PORT MAP (
		address	 => P,
		clock	 => CK57Mi,
		data	 => DI,
		wren	 => AWEN,
		q	 => ARAMDOi
	);

	VPCG0 : pcg PORT MAP (
		RST_x => RST,
		-- CG-ROM I/F
		ROMA => ROMA,
		ROMD => CGDAT,
		DCLK => CLK_x,
		-- CPU Bus
		A => A(11 downto 0),
		DI => DI,
		CSE_x => CSE_x,
		WR_x => WR_x,
		MCLK => ZCLK,
		-- Settings
		PCGSW => PCGSW
	);

	GRAM0 : ram8k PORT MAP (
		address	 => GADR,
		clock	 => CK57Mi,
		data	 => DI,
		wren	 => GWEN0,
		q	 => GRAM0DO
	);

	GRAM1 : ram8k PORT MAP (
		address	 => GADR,
		clock	 => CK57Mi,
		data	 => DI,
		wren	 => GWEN1,
		q	 => GRAM1DO
	);

	GRAM2 : ram8k PORT MAP (
		address	 => GADR,
		clock	 => CK57Mi,
		data	 => DI,
		wren	 => GWEN2,
		q	 => GRAM2DO
	);

	--
	-- Clock Generator
	--
	VCKGEN : pll57 PORT MAP (
		inclk0	 => CK50M,
		c0	 => CK57Mi,
		c1	 => CK3125
	);

	--
	-- Blank & Sync Generation
	--

-- Timing Chart
--                 1028                 3588 3647
--                   +--------------------+
-- HBLK_x -----------+                    +---
--          260  520
--        ---+   +----------------------------
-- HSY_x     +---+
--                904                    3588
--        ---------+                      +---
-- BLNK            +----------------------+
--        23      904
--         +-------+
-- pBLNK  -+       +--------------------------
--        0
--        +-----------------------------------
-- VBLK_x +-----------------------------------
--          48
--        --+---------------------------------
-- SYN_x  --+---------------------------------
--

	process( RST, CK57Mi ) begin
		if RST='0' then
			CNT57M<=(others=>'0');
			SNSVSI<=(others=>'0');
			SNSHSI<=(others=>'0');
			VADR<=(others=>'0');
			GADR<=(others=>'0');
			CNTRAST<=(others=>'0');
			HSY_x<='1';
			BLNKi<='0';
			pBLNK<='0';
			HBLK_x<='1';
			VBLK_x<='1';
			SYN_x<='1';
			--S157<='1';
			S157SR<=(others=>'1');
			SNSCSD<="11";
			ADCH<='0';
			VWEN<='0';
			AWEN<='0';
			GSEL<='0';
			GWEN0<='0';
			GWEN1<='0';
			GWEN2<='0';
			ENPCGi<='0';
			ENPCG<='0';
			SDAT<=(others=>'0');
			ADAT<=(others=>'0');
			BDAT<=(others=>'0');
			RDAT<=(others=>'0');
			GDAT<=(others=>'0');
		elsif CK57Mi'event and CK57Mi='1' then
			-- Sync with MZ-700
			SNSVSI<=SNSVSI(6 downto 0)&VSI_x;
			if SNSVSI="11110000" then
				CNTRAST<="011011101";
			end if;
			SNSHSI<=SNSHSI(6 downto 0)&HSI_x;
			if SNSHSI="11110000" then
				CNT57M<="000100001001";
			elsif CNT57M="111000111111" then
				CNT57M<=(others=>'0');
			else
				CNT57M<=CNT57M+'1';
			end if;

			if CNT57M="000100000011" then		-- 259
				HSY_x<='0';
			elsif CNT57M="001000000111" then	-- 519
				HSY_x<='1';
			end if;

			if CNT57M="001110000111" then		-- 903
				BLNKi<='0';
			elsif CNT57M="111000000011" then	-- 3587
				BLNKi<='1';
			end if;

			if CNT57M="000000010111" then	-- 23
				pBLNK<='1';
			elsif CNT57M="001110000111" then		-- 903
				pBLNK<='0';
			end if;

			if CNT57M="000000010111" then	-- 23
				GSEL<='1';
			elsif CNT57M="001111011011" then		-- 987
				GSEL<='0';
			end if;

			if CNT57M="010000000011" then		-- 1027
				HBLK_x<='1';
			elsif CNT57M="111000000011" then	-- 3587
				HBLK_x<='0';
			end if;

			-- Pattern load & shift
			if CNT57M(2 downto 0)="111" then
				if CNT57M(5 downto 3)="000" then
					SDAT<=CGDAT;
					ADAT<=ARAMDO;
					BDAT<=GRAM0DO;
					RDAT<=GRAM1DO;
					GDAT<=GRAM2DO;
					ENPCG<=ENPCGi;
				else
					SDAT<=SDAT(6 downto 0)&'0';
					BDAT<=BDAT(6 downto 0)&'0';
					RDAT<=RDAT(6 downto 0)&'0';
					GDAT<=GDAT(6 downto 0)&'0';
				end if;
			end if;

			-- Balanced-Duty LOAD pulse(not for display)
			if CNT57M(5 downto 0)="001111" then
				LOAD_x<='1';
			end if;
			if CNT57M(5 downto 0)="101111" then
				LOAD_x<='0';
			end if;

			-- V-RAM Address Counter
			if CNT57M(5 downto 0)="001011" and HBLK_x='1' and VBLK_x='1' then
				VADR<=VADR+'1';
			elsif CNT57M="111000000011" and VBLK_x='1' and (CNTRAST(2) and CNTRAST(1) and CNTRAST(0))='0' then	-- 3587
				VADR<=VADR-40;
			elsif CNT57M="111000000111" and CNTRAST="100000101" then	-- 3591
				VADR<=(others=>'0');
			end if;
			if CNT57M(5 downto 0)="001011" then
				ADCH<='1';
			elsif CNT57M(5 downto 0)="100111" then
				ADCH<='0';
			end if;

			if CNT57M="111000111111" then		-- 3647
				-- Raster Counter
				if CNTRAST="100000101" then
					CNTRAST<=(others=>'0');
				else
					CNTRAST<=CNTRAST+'1';
				end if;
				-- V-Blank
				if CNTRAST="100000101" then
					VBLK_x<='1';
				elsif CNTRAST="011000111" then
					VBLK_x<='0';
				end if;
			end if;

			if CNT57M="000000101111" then		-- 47
				-- V-Sync
				if CNTRAST="011011100" then
					SYN_x<='0';
				elsif CNTRAST="011011111" then
					SYN_x<='1';
				end if;
			end if;

			-- Address Latch for GRAM
			if CNT57M(2 downto 0)="101" then
				SNSCSG<=CSG_x or (not pBLNK);
			end if;
			if CNT57M(5 downto 0)="011111" or (SNSCSG='1' and CSG_x='0' and pBLNK='1') then
				GADR<=Y(13)&Y(11 downto 0);
			end if;
			if CNT57M(5 downto 0)="011111" then
				ENPCGi<=ARAMDO(3);
			end if;

			-- Bus Select Control
			if CNT57M(2 downto 0)="101" then
				SNSCSD<=SNSCSD(0)&(CSD_x or (not BLNKi));
			end if;
			if CNT57M(2 downto 0)="111" then
				if SNSCSD="10" then
					--S157SR<="10";
					S157SR<="100";
					--S157<='0';
				else
					--S157SR<=S157SR(0)&'1';
					S157SR<=S157SR(1 downto 0)&'1';
					--S157<='1';
				end if;
			end if;

			-- Write Enable
			if CNT57M(3 downto 0)="1010" and S157='0' and WR_x='0' then
				VWEN<=not CSV_x;
				AWEN<=not CSA_x;
			else
				VWEN<='0';
				AWEN<='0';
			end if;
			if CNT57M(3 downto 0)="1010" and WAITi_x='1' and WR_x='0' then
				GWEN0<=(not (CSG_x or GBANK(1))) and GBANK(0);
				GWEN1<=(not (CSG_x or GBANK(0))) and GBANK(1);
				GWEN2<=(not CSG_x) and (GBANK(0) and GBANK(1));
			else
				GWEN0<='0';
				GWEN1<='0';
				GWEN2<='0';
			end if;

			-- Visible Control
			if CNT57M(3 downto 0)="0111" then
				DISPEN<=HBLK_x and VBLK_x;
			end if;

		end if;
	end process;

--	LPHI<=CNT57M(1);			-- Φ (14.31818MHz)
	CLK_x<=not CNT57M(2);	-- /CLK (7.15909MHz)
	COLR<=CNT57M(3);			-- COLR (3.579545MHz)
	Q<=CNTRAST(2 downto 0);
	S157<=S157SR(2);
	ROMA<=Y(12)&Y(10 downto 0);

	--
	-- Timing Conditioning and Wait
	--
--	process( MREQ_x ) begin
--		if MREQ_x'event and MREQ_x='0' then
--			XBLNK<=BLNK;
--		end if;
--	end process;

	process( RST, pBLNK, CSG_x ) begin
		if RST='0' or pBLNK='1' then
			WAITi_x<='1';
		elsif CSG_x'event and CSG_x='0' then
			WAITi_x<=pBLNK;
		end if;
	end process;
--	WAITi_x<='0' when CSD_x='0' and XBLNK='0' and BLNK='0' and MZMODE(1)='1' else '1';
	WAIT_x<=WAITi_x;
--	WAIT_x<='1';

	--
	-- Registers
	--
	process( RST, ZCLK ) begin
		if RST='0' then
			DENPCG<='0';
			PRIPCG<='0';
			PALET0<="000";
			PALET1<="001";
			PALET2<="010";
			PALET3<="011";
			PALET4<="100";
			PALET5<="101";
			PALET6<="110";
			PALET7<="111";
		elsif ZCLK'event and ZCLK='1' then
			if WR_x='0' then
				if CSF0_x='0' then
					DENPCG<=DI(0);
					PRIPCG<=DI(1);
				end if;
				if CSF1_x='0' then
					case DI(6 downto 4) is
						when "000" => PALET0<=DI(2 downto 0);
						when "001" => PALET1<=DI(2 downto 0);
						when "010" => PALET2<=DI(2 downto 0);
						when "011" => PALET3<=DI(2 downto 0);
						when "100" => PALET4<=DI(2 downto 0);
						when "101" => PALET5<=DI(2 downto 0);
						when "110" => PALET6<=DI(2 downto 0);
						when others => PALET7<=DI(2 downto 0);
					end case;
				end if;
			end if;
		end if;
	end process;

	--
	-- Mask by Mode
	--
	CSV_x<='0' when CSD_x='0' and A(11)='0' else '1';
	CSA_x<='0' when CSD_x='0' and A(11)='1' else '1';

	--
	-- Bus Select
	--
	P<=A(10 downto 0) when CSD_x='0' and S157='0' else ADCH&VADR;
	Y<=(not A(12))&A(11)&A(11 downto 0) when CSG_x='0' and GSEL='1' else
		ARAMDO(7)&ARAMDO(7 downto 6)&VRAMDO&Q;
	DCODE<=DI when CSV_x='0' and S157='0' and WR_x='0' else VRAMDO;
	ARAMDO<=DI when CSA_x='0' and S157='0' and WR_x='0' else ARAMDOi;
	DO<=CGDAT   when RD_x='0' and CSG_x='0' and GBANK="00" else
		 GRAM0DO when RD_x='0' and CSG_x='0' and GBANK="01" else
		 GRAM1DO when RD_x='0' and CSG_x='0' and GBANK="10" else
		 GRAM2DO when RD_x='0' and CSG_x='0' and GBANK="11" else
		 (others=>'0');

	--
	-- Color Decode
	--
	-- Priolity
	process( ADAT(6 downto 4), ADAT(2 downto 0), SDAT(7), GDAT(7), RDAT(7), BDAT(7), PRIPCG, DENPCG, ENPCG ) begin
		if PRIPCG='0' then
			if SDAT(7)='1' then
				RGBOi<=ADAT(6 downto 4);
			elsif (GDAT(7)='1' or RDAT(7)='1' or BDAT(7)='1') and (DENPCG='1' and ENPCG='1') then
				RGBOi<=GDAT(7)&RDAT(7)&BDAT(7);
			else
				RGBOi<=ADAT(2 downto 0);
			end if;
		else
			if (GDAT(7)='1' or RDAT(7)='1' or BDAT(7)='1') and (DENPCG='1' and ENPCG='1') then
				RGBOi<=GDAT(7)&RDAT(7)&BDAT(7);
			elsif SDAT(7)='1' then
				RGBOi<=ADAT(6 downto 4);
			else
				RGBOi<=ADAT(2 downto 0);
			end if;
		end if;
	end process;
	-- Palet
	process( RGBOi, DISPEN ) begin
		if DISPEN='1' then
			case RGBOi is
				when "000" => GOUT<=PALET0(2); ROUT<=PALET0(1); BOUT<=PALET0(0);
				when "001" => GOUT<=PALET1(2); ROUT<=PALET1(1); BOUT<=PALET1(0);
				when "010" => GOUT<=PALET2(2); ROUT<=PALET2(1); BOUT<=PALET2(0);
				when "011" => GOUT<=PALET3(2); ROUT<=PALET3(1); BOUT<=PALET3(0);
				when "100" => GOUT<=PALET4(2); ROUT<=PALET4(1); BOUT<=PALET4(0);
				when "101" => GOUT<=PALET5(2); ROUT<=PALET5(1); BOUT<=PALET5(0);
				when "110" => GOUT<=PALET6(2); ROUT<=PALET6(1); BOUT<=PALET6(0);
				when others => GOUT<=PALET7(2); ROUT<=PALET7(1); BOUT<=PALET7(0);
			end case;
		else
			GOUT<='0';
			ROUT<='0';
			BOUT<='0';
		end if;
	end process;

	--
	-- Output
	--
	CK7M16<=CLK_x;
	HSYNC<=HSY_x;
	CK57M<=CK57Mi;
--	VBLANK<=VDISPEN;
	BLNK<=BLNKi;

end RTL;
