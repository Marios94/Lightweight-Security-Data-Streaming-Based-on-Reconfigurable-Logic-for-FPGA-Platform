	--|--------Block Of 4 32-bit Adders------|--
	--|--------4 32-bit mod 2^32 Adders------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity ADDERS is
	Port (
		clk			: in	std_logic;
		mux_in_sel	: in	std_logic;
		mux_sel		: in	unsigned ( 2 downto 0);

		A_input		: in	unsigned (31 downto 0);
		B_input		: in	unsigned (31 downto 0);
		C_input		: in	unsigned (31 downto 0);
		D_input		: in	unsigned (31 downto 0);
		E_input		: in	unsigned (31 downto 0);
		E_new		: in	unsigned (31 downto 0);

		S1			: in	unsigned (31 downto 0);
		S2			: in	unsigned (31 downto 0);
		S3			: in	unsigned (31 downto 0);
		S4			: in	unsigned (31 downto 0);
		S5			: in	unsigned (31 downto 0);

		A_out		: out	unsigned (31 downto 0);
		B_out		: out	unsigned (31 downto 0);
		C_out		: out	unsigned (31 downto 0);
		D_out		: out	unsigned (31 downto 0);
		E_out		: out	unsigned (31 downto 0)

		);
end ADDERS;

architecture Behavioral of ADDERS is

	component MUX_4x1 is
		Port (
			A_in	: in	unsigned (31 downto 0);
			B_in	: in	unsigned (31 downto 0);
			C_in	: in	unsigned (31 downto 0);
			D_in	: in	unsigned (31 downto 0);
			sel_0	: in	STD_LOGIC;
			sel_1	: in	STD_LOGIC;
			E_out	: out	unsigned (31 downto 0)
			);
	end component MUX_4x1;

	component MUX_2x1
		port(
			A_in	: in	unsigned (31 downto 0);
			B_in	: in	unsigned (31 downto 0);
			sel		: in	std_logic;
			C_out	: out	unsigned (31 downto 0)
			);
	end component MUX_2x1;

	component MUX_8x1 is
		Port (
			A_in	: in	unsigned (31 downto 0);
			B_in	: in	unsigned (31 downto 0);
			C_in	: in	unsigned (31 downto 0);
			D_in	: in	unsigned (31 downto 0);
			E_in	: in	unsigned (31 downto 0);
			F_in	: in	unsigned (31 downto 0);
			G_in	: in	unsigned (31 downto 0);
			H_in	: in	unsigned (31 downto 0);
			I_out	: out	unsigned (31 downto 0);
			sel		: in	unsigned ( 2 downto 0)
			);
	end component MUX_8x1;

	component Adder_mod2_32
		port(
			a_in : in unsigned  (31 downto 0);
			b_in : in unsigned  (31 downto 0);
			sum  : out unsigned (31 downto 0)
			);
	end component Adder_mod2_32; 

signal muxa_out 	: unsigned (31 downto 0);
signal muxain_out 	: unsigned (31 downto 0);
signal muxb1_out 	: unsigned (31 downto 0);
signal muxb2_out 	: unsigned (31 downto 0);
signal muxc1_out 	: unsigned (31 downto 0);
signal muxc2_out 	: unsigned (31 downto 0);
signal muxd1_out 	: unsigned (31 downto 0);
signal muxd2_out 	: unsigned (31 downto 0);

signal empty 		: unsigned (31 downto 0) := X"00000000";

signal add1_out		: unsigned (31 downto 0);
signal add2_out		: unsigned (31 downto 0);
signal add3_out		: unsigned (31 downto 0);
signal add4_out		: unsigned (31 downto 0);

begin

	--|****************************|--
	--|         MODE MUXES         |--
	--|****************************|--

	MUXAin : component MUX_2x1
		port map(
			A_in	=> muxa_out,
			B_in	=> C_input,
			sel		=> mux_in_sel,
			C_out	=> muxain_out
				);

	MUXA : component MUX_4x1
		port map(
			A_in	=> B_input,
			B_in	=> E_new,
			C_in	=> S1,
			D_in	=> S1,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxa_out
				);
	MUXB1 : component MUX_4x1
		port map(
			A_in	=> C_input,
			B_in	=> B_input,
			C_in	=> B_input,
			D_in	=> C_input,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxb1_out
				);
	MUXB2 : component MUX_4x1
		port map(
			A_in	=> D_input,
			B_in	=> E_new,
			C_in	=> S2,
			D_in	=> S1,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxb2_out
				);
	MUXC1 : component MUX_4x1
		port map(
			A_in	=> add1_out,
			B_in	=> C_input,
			C_in	=> C_input,
			D_in	=> C_input,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxc1_out
				);
	MUXC2 : component MUX_4x1
		port map(
			A_in	=> add2_out,
			B_in	=> E_new,
			C_in	=> S3,
			D_in	=> S2,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxc2_out
				);
	MUXD1 : component MUX_4x1
		port map(
			A_in	=> add3_out,
			B_in	=> D_input,
			C_in	=> D_input,
			D_in	=> E_input,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxd1_out
				);
	MUXD2 : component MUX_4x1
		port map(
			A_in	=> E_input,
			B_in	=> E_new,
			C_in	=> S4,
			D_in	=> S5,
			sel_0	=> mux_sel(0),
			sel_1	=> mux_sel(1),
			E_out	=> muxd2_out
				);

	--|****************************|--
	--|           ADDERS           |--
	--|****************************|--

	Adder1 : component Adder_mod2_32
		port map(
				a_in	=> A_input,
				b_in	=> muxain_out,
				sum		=> add1_out
				);

	Adder2 : component Adder_mod2_32
		port map(
				a_in	=> muxb1_out,
				b_in	=> muxb2_out,
				sum		=> add2_out
				);

	Adder3 : component Adder_mod2_32
		port map(
				a_in	=> muxc1_out,
				b_in	=> muxc2_out,
				sum		=> add3_out
				);

	Adder4 : component Adder_mod2_32
		port map(
				a_in	=> muxd1_out,
				b_in	=> muxd2_out,
				sum		=> add4_out
				);

	A_out <= add1_out;
	B_out <= add2_out;
	C_out <= add3_out;
	D_out <= add4_out;
	E_out <= add4_out;

end Behavioral;