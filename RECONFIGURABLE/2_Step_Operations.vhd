    --|--------LFSR Stepping Operation-----------|--
    --|--------32-bit AND, 32-bit XOR------------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Step_Operations is
	Port (
		clk					: in	std_logic;
		fsm_mux_sel			: in 	std_logic;

		R0_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for Sober128/Turing
		R4_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for Sober128/Turing
		R15_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for Sober128/Turing
		multab_output		: in	unsigned (31 downto 0); 	-- Input from ROMs for Sober128/Turing

		S0_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0
		S2_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0
		S11_in				: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0
		FSM_out				: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0
		mul_a_output		: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0
		mul_ainv_output		: in	unsigned (31 downto 0); 	-- Input from ROMs for SNOW 2.0

		test_mula			: out	unsigned (31 downto 0);
		test_mulainv		: out	unsigned (31 downto 0);
		test_fsm_mux		: out	unsigned (31 downto 0);
		test_xor1_snow		: out	unsigned (31 downto 0);
		test_xor2_snow		: out	unsigned (31 downto 0);
		multab_input		: out	unsigned ( 7 downto 0); 	-- Input to ROMs for Sober128/Turing
		step_sober_turing	: out	unsigned (31 downto 0);		-- Output for Sober128/Turing
		step_snow			: out	unsigned (31 downto 0)		-- Output for SNOW 2.0
		);
end Step_Operations;

architecture Behavioral of Step_Operations is

	component AND32
		port(
			a_in	: in	unsigned ( 7 downto 0);
			c_out	: out	unsigned ( 7 downto 0)
			);
	end component AND32;

	component XOR_32
		port(
			a_in	: in	unsigned (31 downto 0);
			b_in	: in	unsigned (31 downto 0);
			c_out	: out	unsigned (31 downto 0)
			);
	end component XOR_32;

component MUX_2x1 is
	Port (
		A_in	: in	unsigned (31 downto 0);
		B_in	: in	unsigned (31 downto 0);
		sel		: in	STD_LOGIC;
		C_out	: out	unsigned (31 downto 0)
		);
end component MUX_2x1;

	signal mux_fsm_out			: unsigned (31 downto 0);

	signal sober_turing_xor1 	: unsigned (31 downto 0);
	signal sober_turing_xor2 	: unsigned (31 downto 0);

	signal R0_r_shift8			: unsigned (31 downto 0);
	signal R11_l_shift8			: unsigned (31 downto 0);
	signal snow_a1				: unsigned (31 downto 0);
	signal snow_a2				: unsigned (31 downto 0);
	signal snow_xor1			: unsigned (31 downto 0);
	signal snow_xor2			: unsigned (31 downto 0);

begin

	--|****************************|--
	--|****SOBER/TURING STEP OP****|--
	--|****************************|--

	AND_32: component AND32
		port map(
				a_in	=> R0_in (31 downto 24),
				c_out	=> multab_input				--MULTAB address for Sober128/Turing
				);

	XOR32_A: component XOR_32
		port map(
				a_in	=> R4_in,
				b_in	=> R15_in,
				c_out	=> sober_turing_xor1
				);

	XOR32_B: component XOR_32
		port map(
				a_in	=> R0_in (23 downto  0) & X"00",
				b_in	=> sober_turing_xor1,
				c_out	=> sober_turing_xor2
				);

	XOR32_C: component XOR_32
		port map(
				a_in	=> multab_output,
				b_in	=> sober_turing_xor2,
				c_out	=> step_sober_turing
				);

	--|****************************|--
	--|******SNOW 2.0 STEP OP******|--
	--|****************************|--

	R0_r_shift8		(23 downto  0) <= S0_in  (31 downto  8);
	R0_r_shift8		(31 downto 24) <= "00000000";
	R11_l_shift8	(31 downto  8) <= S11_in (23 downto  0);
	R11_l_shift8	( 7 downto  0) <= "00000000";

	XOR_MULA: component XOR_32
		port map(
				a_in	=> mul_a_output,
				b_in	=> R0_r_shift8,
				c_out	=> snow_a1
				);

	XOR_MULAINV: component XOR_32
		port map(
				a_in	=> mul_ainv_output,
				b_in	=> R11_l_shift8,
				c_out	=> snow_a2
				);

	MUX_FSM : component MUX_2x1
		port map (
			A_in    => FSM_out,
			B_in    => X"00000000",
			sel     => fsm_mux_sel,
			C_out   => mux_fsm_out
		);

	XOR32_1: component XOR_32
		port map(
				a_in	=> snow_a1,
				b_in	=> mux_fsm_out,
				c_out	=> snow_xor1
				);

	XOR32_2: component XOR_32
		port map(
				a_in	=> snow_xor1,
				b_in	=> S2_in,
				c_out	=> snow_xor2
				);

	XOR32_3: component XOR_32
		port map(
				a_in	=> snow_xor2,
				b_in	=> snow_a2,
				c_out	=> step_snow
				);

	test_mula		<= snow_a1;
	test_mulainv	<= snow_a2;
	test_fsm_mux	<= mux_fsm_out;
	test_xor1_snow	<= snow_xor1;
	test_xor2_snow	<= snow_xor2;

end Behavioral;