library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity TriMode_Stream_Cipher is
	Port (
		--|--GLOBAL CLOCK--|--
		clk 				: in std_logic;
		--|--INIT MUX CONTROL SIGNALS--|--
		init_mux_sel0		: in std_logic;
		init_mux_sel1		: in std_logic;
		--|--STEP MUX CONTROL SIGNALS--|--
		step_mux_sel		: in std_logic;
		--|--LFSR CONTROL SIGNALS--|--
		LFSR_set			: in std_logic;
		LFSR_rst			: in std_logic;
		LFSR_ce				: in std_logic;
		LFSR_R4_ce			: in std_logic;
		LFSR_R15_ce			: in std_logic;
		LFSR_mux_15_sel		: in std_logic;
		LFSR_mux_4_sel0		: in std_logic;
		--|--SOBER MUXES CONTROL SIGNALS--|--
		sober_mux_sel0		: in std_logic;
		sober_mux_sel1		: in std_logic;
		sober_konst_mux_sel : in std_logic;
		--|--TURING MUXES CONTROL SIGNALS--|--
		turing_muxA_E_sel	: in unsigned (2 downto 0);
		--|--ADDERS INPUT MUXES CONTROL SIGNALS--|--
		muxA_E_sel0			: in std_logic;
		muxA_E_sel1			: in std_logic;
		--|--ADDERS INPUT MUXES CONTROL SIGNALS--|--
		side_mux_sel0		: in std_logic;
		side_mux_sel1		: in std_logic;
		side_mux_Enew_sel0	: in std_logic;
		side_mux_Enew_sel1	: in std_logic;
		--|--ADDERS MUXES CONTROL SIGNALS--|--
		add_block_mux_in_sel: in std_logic;
		add_block_mux_sel	: in unsigned (2 downto 0);
		--|--REGISTER FILE MUXES_IN SIGNALS--|--
		reg_file_mux_sel	: in std_logic;
		--|--REGISTER FILE CONTROL SIGNALS--|--
		snow_R1_rst		: in std_logic;
		snow_R2_rst		: in std_logic;
		RF0_ce				: in std_logic;
		RF1_ce				: in std_logic;
		RF2_ce				: in std_logic;
		RF3_ce				: in std_logic;
		RF4_ce				: in std_logic;
		RF5_ce				: in std_logic;
		RF6_ce				: in std_logic;
		RF7_ce				: in std_logic;
		RF8_ce				: in std_logic;
		RF9_ce				: in std_logic;
		RF10_ce				: in std_logic;
		RF11_ce				: in std_logic;
		RF12_ce				: in std_logic;
		RF13_ce				: in std_logic;
		RF14_ce				: in std_logic;
		--|--TURING SBOX MUXES CONTROL SIGNALS--|--
		turing_sbox_mux_sel 			: in unsigned (2 downto 0);	--pht A to E select
		turing_sbox_pht_val_mux_sel		: in std_logic;				--pht normal or shifted
		turing_sbox_key_val_mux_sel		: in std_logic;				--key original or mixed
		turing_sbox_mux_init_key_sel	: in std_logic;				--word_out or mixed_key
		--|--LFSR FEEDBACK MUX CONTROL SIGNALS--|--
		lfsr_feedback_mux_sel			: in unsigned (2 downto 0);
		--|--STEP OP MUX CONTROL SIGNALS--|--
		fsm_mux_step_op_sel				: in std_logic;
		--|--MULTAB MUX CONTROL SIGNALS--|--
		multab_mux_sel					: in std_logic;

		snow_ciphertext		: out 	unsigned (31 downto 0);

		sober_konst			: in 	unsigned (31 downto 0);
		IV_in				: in 	unsigned (31 downto 0);
		sober_Vt_out		: out 	unsigned (31 downto 0);
		sober_ciphertext	: out 	unsigned (31 downto 0);
		sober_key_in		: in 	unsigned (31 downto 0);

		turing_ciphertext	: out 	unsigned (159 downto 0);

		plaintext_in		: in 	unsigned (31 downto 0);
		turing_plaintext_in	: in 	unsigned (159 downto 0)
		);
end TriMode_Stream_Cipher;

architecture Behavioral of TriMode_Stream_Cipher is

component XOR_32 is
	Port (
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

component LFSR is
	Port (
		--|-------- Control signals --------|--
		clk			: in STD_LOGIC;
		set			: in STD_LOGIC;
		rst			: in STD_LOGIC;
		ce			: in STD_LOGIC;
		reg4_ce		: in STD_LOGIC;
		reg15_ce	: in STD_LOGIC;
		mux_15_sel	: in STD_LOGIC; 					--  0 -> Step /  1 -> Include
		mux_4_sel0	: in STD_LOGIC; 					-- 00 -> Step / 01 -> Diffuse / 10 -> MAC Accumulation
		--|--Inputs from Step Op, Reg_File--|--
		R16_in  		: in unsigned (31 downto 0); 	-- Step Operations
		Include_in  	: in unsigned (31 downto 0); 	-- Sober128 Include Step
		Diffuse_in 		: in unsigned (31 downto 0); 	-- Sober128 Diffuse Step
		--|-- Outputs to Step. Op. , NLF, PFF --|--
		R0_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R0 Step Op/NLF 	//
		R1_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R1 NLF 			// SNOW 2.0 S0 Step Op
		R2_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R3_out 			: out unsigned (31 downto 0);	-- SNOW 2.0 S2 Step Op 				//
		R4_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R4 Step Op/PFF 	//
		R5_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R6_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R6 NLF/PFF		// SNOW 2.0 S5 FSM
		R7_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R8_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R9_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R10_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R11_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R12_out 		: out unsigned (31 downto 0);	--									// SNOW 2.0 S11 Step Op
		R13_out 		: out unsigned (31 downto 0);	--(Sober128/Turing) R13 NLF 		//
		R14_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R15_out 		: out unsigned (31 downto 0);	--(Sober128/Turing) R15 Step Op/Incl//
		R16_out 		: out unsigned (31 downto 0)	--(Sober128/Turing) R16 NLF 		
		);
end component LFSR;

component ROMs is
	Port (
		clk 					: in	std_logic;
		Turing_SBox_mux_sel 	: in 	std_logic;					--0 for mixed key 		1 for original key
		--|-- Step Op pins --|--
		multab_input			: in	unsigned ( 7 downto 0); 	--(Sober128, Turing) 	Step Operation
		S0_in					: in	unsigned ( 7 downto 0); 	--SNOW 2.0 				Step Operation
		S11_in					: in	unsigned ( 7 downto 0); 	--SNOW 2.0 				Step Operation
		--|--- SBox pins ----|--
		f_function_in 			: in	unsigned ( 7 downto 0);		--Sober128	SBox address
		Turing_SBox_in			: in	unsigned (31 downto 0);		--Turing 	SBox address
		Turind_key_in 			: in	unsigned (31 downto 0);		--Turing 	key value
		Snow_SBox_in 			: in	unsigned (31 downto 0);		--SNOW 2.0 	SBox address
		--|-- Step OP out ---|--
		Sober_multab_out		: out 	unsigned (31 downto 0); 	--Sober128 	Step Operation output
		MUL_A_out				: out 	unsigned (31 downto 0); 	--SNOW 2.0 	Step Operation output
		MUL_AINV_out			: out 	unsigned (31 downto 0); 	--SNOW 2.0 	Step Operation output
		--|--- SBoxes out ---|--
		f_function_out			: out 	unsigned (31 downto 0); 	--Sober128 	SBox output
		Turing_SBox_out			: out 	unsigned (31 downto 0); 	--Turing 	SBox output
		Turing_mixed_key_out	: out 	unsigned (31 downto 0); 	--Turing 	mixed key
		Snow_SBox_T0_out		: out 	unsigned (31 downto 0);		--SNOW 2.0 	SBox output
		Snow_SBox_T1_out		: out 	unsigned (31 downto 0);		--SNOW 2.0 	SBox output
		Snow_SBox_T2_out		: out 	unsigned (31 downto 0);		--SNOW 2.0 	SBox output
		Snow_SBox_T3_out		: out 	unsigned (31 downto 0) 		--SNOW 2.0 	SBox output
		);
end component ROMs;

component SBox_xoring is
	Port (
		Sober_sbox_out 		: in	unsigned (31 downto 0);
		Sober_f_in			: in	unsigned (31 downto 0);

		Snow_T0_out			: in	unsigned (31 downto 0);
		Snow_T1_out			: in	unsigned (31 downto 0);
		Snow_T2_out			: in	unsigned (31 downto 0);
		Snow_T3_out			: in	unsigned (31 downto 0);

		Sober_f_out			: out	unsigned (31 downto 0);
		Sober_shift8_out	: out 	unsigned (31 downto 0);
		Snow_sbox_out 		: out 	unsigned (31 downto 0)
		);
end component SBox_xoring;

component Step_Operations is
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
end component Step_Operations;

component ADDERS is
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
end component ADDERS;

component REGISTER_FILE is
	Port (
		clk			: in	std_logic;

		REG1_rst	: in	std_logic;
		REG2_rst	: in	std_logic;

		REG0_ce		: in	std_logic;
		REG1_ce		: in	std_logic;
		REG2_ce		: in	std_logic;
		REG3_ce		: in	std_logic;
		REG4_ce		: in	std_logic;
		REG5_ce		: in	std_logic;
		REG6_ce		: in	std_logic;
		REG7_ce		: in	std_logic;
		REG8_ce		: in	std_logic;
		REG9_ce		: in	std_logic;
		REG10_ce	: in	std_logic;
		REG11_ce	: in	std_logic;
		REG12_ce	: in	std_logic;
		REG13_ce	: in	std_logic;
		REG14_ce	: in	std_logic;

		REG0_in		: in	unsigned (31 downto 0);
		REG1_in		: in	unsigned (31 downto 0);
		REG2_in		: in	unsigned (31 downto 0);
		REG3_in		: in	unsigned (31 downto 0);
		REG4_in		: in	unsigned (31 downto 0);
		REG5_in		: in	unsigned (31 downto 0);
		REG6_in		: in	unsigned (31 downto 0);
		REG7_in		: in	unsigned (31 downto 0);
		REG8_in		: in	unsigned (31 downto 0);
		REG9_in		: in	unsigned (31 downto 0);
		REG10_in	: in	unsigned (31 downto 0);
		REG11_in	: in	unsigned (31 downto 0);
		REG12_in	: in	unsigned (31 downto 0);
		REG13_in	: in	unsigned (31 downto 0);
		REG14_in	: in	unsigned (31 downto 0);

		REG0_out	: out	unsigned (31 downto 0);
		REG1_out	: out	unsigned (31 downto 0);
		REG2_out	: out	unsigned (31 downto 0);
		REG3_out	: out	unsigned (31 downto 0);
		REG4_out	: out	unsigned (31 downto 0);
		REG5_out	: out	unsigned (31 downto 0);
		REG6_out	: out	unsigned (31 downto 0);
		REG7_out	: out	unsigned (31 downto 0);
		REG8_out	: out	unsigned (31 downto 0);
		REG9_out	: out	unsigned (31 downto 0);
		REG10_out	: out	unsigned (31 downto 0);
		REG11_out	: out	unsigned (31 downto 0);
		REG12_out	: out	unsigned (31 downto 0);
		REG13_out	: out	unsigned (31 downto 0);
		REG14_out	: out	unsigned (31 downto 0)
		);
end component REGISTER_FILE;

signal empty					: unsigned (31 downto 0) := X"00000000";

signal init_mux_out				: unsigned (31 downto 0);
signal step_mux_out				: unsigned (31 downto 0);

signal lfsr_feedback_mux1_out	: unsigned (31 downto 0);
signal lfsr_feedback_mux2_out	: unsigned (31 downto 0);

signal wire0					: unsigned (31 downto 0);
signal wire1					: unsigned (31 downto 0);
signal wire2					: unsigned (31 downto 0);
signal wire3					: unsigned (31 downto 0);
signal wire4					: unsigned (31 downto 0);
signal wire5					: unsigned (31 downto 0);
signal wire6					: unsigned (31 downto 0);
signal wire7					: unsigned (31 downto 0);
signal wire8					: unsigned (31 downto 0);
signal wire9					: unsigned (31 downto 0);
signal wire10					: unsigned (31 downto 0);
signal wire11					: unsigned (31 downto 0);
signal wire12					: unsigned (31 downto 0);
signal wire13					: unsigned (31 downto 0);
signal wire14					: unsigned (31 downto 0);
signal wire15					: unsigned (31 downto 0);
signal wire16					: unsigned (31 downto 0);
signal wire16_bypass			: unsigned (31 downto 0);

signal sober_muxA_out			: unsigned (31 downto 0);
signal sober_muxB_out			: unsigned (31 downto 0);

signal turing_mux1_out			: unsigned (31 downto 0);
signal turing_mux2_out			: unsigned (31 downto 0);
signal turing_mux3_out			: unsigned (31 downto 0);
signal turing_muxA_out			: unsigned (31 downto 0);
signal turing_muxB_out			: unsigned (31 downto 0);
signal turing_muxC_out			: unsigned (31 downto 0);
signal turing_muxD_out			: unsigned (31 downto 0);
signal turing_muxE_out			: unsigned (31 downto 0);

signal side_mux_1_out			: unsigned (31 downto 0);
signal side_mux_2_out			: unsigned (31 downto 0);
signal side_mux_Enew_out		: unsigned (31 downto 0);

signal mux_A_out				: unsigned (31 downto 0);
signal mux_B_out				: unsigned (31 downto 0);
signal mux_C_out				: unsigned (31 downto 0);
signal mux_D_out				: unsigned (31 downto 0);

signal adders_out_A				: unsigned (31 downto 0);
signal adders_out_B				: unsigned (31 downto 0);
signal adders_out_C				: unsigned (31 downto 0);
signal adders_out_D				: unsigned (31 downto 0);
signal adders_out_E				: unsigned (31 downto 0);

signal reg_mux0_out				: unsigned (31 downto 0);
signal reg_mux1_out				: unsigned (31 downto 0);
signal reg_mux2_out				: unsigned (31 downto 0);
signal reg_mux3_out				: unsigned (31 downto 0);
signal reg_mux4_out				: unsigned (31 downto 0);
signal reg_mux5_out				: unsigned (31 downto 0);
signal reg_mux6_out				: unsigned (31 downto 0);
signal reg_mux7_out				: unsigned (31 downto 0);
signal reg_mux8_out				: unsigned (31 downto 0);
signal reg_mux9_out				: unsigned (31 downto 0);
signal reg_mux10_out			: unsigned (31 downto 0);
signal reg_mux11_out			: unsigned (31 downto 0);
signal reg_mux12_out			: unsigned (31 downto 0);
signal reg_mux13_out			: unsigned (31 downto 0);
signal reg_mux14_out			: unsigned (31 downto 0);

signal RF_0_out					: unsigned (31 downto 0);
signal RF_1_out					: unsigned (31 downto 0);
signal RF_2_out					: unsigned (31 downto 0);
signal RF_3_out					: unsigned (31 downto 0);
signal RF_4_out					: unsigned (31 downto 0);
signal RF_5_out					: unsigned (31 downto 0);
signal RF_6_out					: unsigned (31 downto 0);
signal RF_7_out					: unsigned (31 downto 0);
signal RF_8_out					: unsigned (31 downto 0);
signal RF_9_out					: unsigned (31 downto 0);
signal RF_10_out				: unsigned (31 downto 0);
signal RF_11_out				: unsigned (31 downto 0);
signal RF_12_out				: unsigned (31 downto 0);
signal RF_13_out				: unsigned (31 downto 0);
signal RF_14_out				: unsigned (31 downto 0);
signal RF_15_out				: unsigned (31 downto 0);

signal word_in_pht				: unsigned (31 downto 0);
signal word_in_pht_shift		: unsigned (31 downto 0);
signal word_in					: unsigned (31 downto 0);
signal turing_pht_out_shift8	: unsigned (31 downto 0);
signal turing_pht_out_shift16	: unsigned (31 downto 0);
signal turing_pht_out_shift24	: unsigned (31 downto 0);
signal or_key_in				: unsigned (31 downto 0);
signal mix_key_in				: unsigned (31 downto 0);
signal key_in					: unsigned (31 downto 0);

signal multab_in				: unsigned ( 7 downto 0);
signal turing_mul_out			: unsigned (31 downto 0);
signal sober_mul_out			: unsigned (31 downto 0);
signal mux_multab_out			: unsigned (31 downto 0);
signal sober_konst_mux_out		: unsigned (31 downto 0);
signal mul_a_out				: unsigned (31 downto 0);
signal mul_ainv_out				: unsigned (31 downto 0);
signal step_sober_turing_out	: unsigned (31 downto 0);
signal step_snow_out			: unsigned (31 downto 0);
signal sober_sbox_out			: unsigned (31 downto 0);
signal turing_sbox_word_out		: unsigned (31 downto 0);
signal turing_sbox_key_out		: unsigned (31 downto 0);
signal turing_sbox_out			: unsigned (31 downto 0);
signal snow_sbox0_out			: unsigned (31 downto 0);
signal snow_sbox1_out			: unsigned (31 downto 0);
signal snow_sbox2_out			: unsigned (31 downto 0);
signal snow_sbox3_out			: unsigned (31 downto 0);
signal sober_f_func_out			: unsigned (31 downto 0);
signal sober_nlf_shift8			: unsigned (31 downto 0);
signal sober_xor_konst_out		: unsigned (31 downto 0);
signal snow_sbox_out			: unsigned (31 downto 0);

signal diffuse_wire				: unsigned (31 downto 0);
signal fsm_wire					: unsigned (31 downto 0);
signal snow_keystream 			: unsigned (31 downto 0);

begin

	--|*************************|--
	--|********INIT MUX*********|--
	--|*************************|--

	init_Mux : component MUX_4x1
		port map(
			A_in	=> IV_in,
			B_in	=> step_mux_out,
			C_in	=> lfsr_feedback_mux1_out,
			D_in	=> lfsr_feedback_mux2_out,
			sel_0	=> init_mux_sel0,
			sel_1	=> init_mux_sel1,
			E_out	=> init_mux_out
				);

	--|*************************|--
	--|********STEP MUX*********|--
	--|*************************|--

	Step_Mux : component MUX_2x1
		port map(
			A_in	=> step_sober_turing_out,
			B_in	=> step_snow_out,
			sel		=> step_mux_sel,
			C_out	=> step_mux_out
				);

	--|*************************|--
	--|**********LFSR***********|--
	--|*************************|--

	LFSR1: component LFSR
		port map(
		clk				=> clk,
		set				=> LFSR_set,
		rst				=> LFSR_rst,
		ce				=> LFSR_ce,
		reg4_ce			=> LFSR_R4_ce,
		reg15_ce		=> LFSR_R15_ce,
		mux_15_sel		=> LFSR_mux_15_sel,
		mux_4_sel0		=> LFSR_mux_4_sel0,
		R16_in			=> init_mux_out,
		Include_in		=> RF_1_out,
		Diffuse_in		=> diffuse_wire,
		R0_out			=> wire0,
		R1_out			=> wire1,
		R2_out			=> wire2,
		R3_out			=> wire3,
		R4_out			=> wire4,
		R5_out			=> wire5,
		R6_out			=> wire6,
		R7_out			=> wire7,
		R8_out			=> wire8,
		R9_out			=> wire9,
		R10_out			=> wire10,
		R11_out			=> wire11,
		R12_out			=> wire12,
		R13_out			=> wire13,
		R14_out			=> wire14,
		R15_out			=> wire15,
		R16_out			=> wire16
				);

	--|*************************|--
	--|*******SOBER MUXES*******|--
	--|*************************|--

	S_MUX_A : component MUX_4x1
		port map(
			A_in	=> wire16,
			B_in	=> RF_2_out,
			C_in	=> RF_3_out,
			D_in	=> RF_4_out,
			sel_0	=> sober_mux_sel0,
			sel_1	=> sober_mux_sel1,
			E_out	=> sober_muxA_out
				);

	S_MUX_B : component MUX_4x1
		port map(
			A_in	=> wire0,
			B_in	=> wire1,
			C_in	=> wire6,
			D_in	=> wire13,
			sel_0	=> sober_mux_sel0,
			sel_1	=> sober_mux_sel1,
			E_out	=> sober_muxB_out
				);

	--|*************************|--
	--|******TURING MUXES*******|--
	--|*************************|--

	MUXA : component MUX_8x1
		port map(
			A_in	=> wire16,
			B_in	=> RF_5_out,
			C_in	=> wire0,
			D_in	=> wire5,
			E_in	=> wire10,
			F_in	=> RF_10_out,
			G_in	=> RF_5_out,
			H_in	=> wire0,
			I_out	=> turing_muxA_out,
			sel		=> turing_muxA_E_sel
				);

	MUXB : component MUX_8x1
		port map(
			A_in	=> wire13,
			B_in	=> RF_6_out,
			C_in	=> wire1,
			D_in	=> wire6,
			E_in	=> wire11,
			F_in	=> RF_11_out,
			G_in	=> RF_6_out,
			H_in	=> wire1,
			I_out	=> turing_muxB_out,
			sel		=> turing_muxA_E_sel
				);

	MUXC : component MUX_8x1
		port map(
			A_in	=> wire6,
			B_in	=> RF_7_out,
			C_in	=> wire2,
			D_in	=> wire7,
			E_in	=> wire12,
			F_in	=> RF_12_out,
			G_in	=> RF_7_out,
			H_in	=> wire2,
			I_out	=> turing_muxC_out,
			sel		=> turing_muxA_E_sel
				);

	MUXD : component MUX_8x1
		port map(
			A_in	=> wire1,
			B_in	=> RF_8_out,
			C_in	=> wire3,
			D_in	=> wire8,
			E_in	=> wire13,
			F_in	=> RF_13_out,
			G_in	=> wire15,
			H_in	=> wire3,
			I_out	=> turing_muxD_out,
			sel		=> turing_muxA_E_sel
				);

	MUXE : component MUX_8x1
		port map(
			A_in	=> wire0,
			B_in	=> RF_9_out,
			C_in	=> wire4,
			D_in	=> wire9,
			E_in	=> wire14,
			F_in	=> RF_14_out,
			G_in	=> wire16,
			H_in	=> RF_9_out,
			I_out	=> turing_muxE_out,
			sel		=> turing_muxA_E_sel
				);

	--|*************************|--
	--|*****ADDERS_IN MUXES*****|--
	--|*************************|--

	MUX_A : component MUX_2x1
		port map(
			A_in	=> turing_muxA_out,
			B_in	=> sober_muxA_out,
			sel		=> muxA_E_sel1,
			C_out	=> mux_A_out
				);

	MUX_B : component MUX_2x1
		port map(
			A_in	=> turing_muxB_out,
			B_in	=> sober_muxB_out,
			sel		=> muxA_E_sel1,
			C_out	=> mux_B_out
				);

	MUX_C : component MUX_2x1
		port map(
			A_in	=> turing_muxC_out,
			B_in	=> wire15,
			sel		=> muxA_E_sel1,
			C_out	=> mux_C_out
				);

	--|*************************|--
	--|*******SIDE MUXES********|--
	--|*************************|--

	Side_MUX_1 : component MUX_4x1
		port map(
			A_in	=> wire14,
			B_in	=> sober_key_in,
			C_in	=> RF_12_out,
			D_in	=> empty,
			sel_0	=> side_mux_sel0,
			sel_1	=> side_mux_sel1,
			E_out	=> side_mux_1_out
				);

	Side_MUX_2 : component MUX_2x1
		port map(
			A_in	=> wire12,
			B_in	=> RF_8_out,
			sel		=> side_mux_sel1,
			C_out	=> side_mux_2_out
				);

	Side_MUX_Enew : component MUX_4x1
		port map(
			A_in	=> RF_4_out,
			B_in	=> RF_9_out,
			C_in	=> RF_10_out,
			D_in	=> RF_14_out,
			sel_0	=> side_mux_Enew_sel0,
			sel_1	=> side_mux_Enew_sel1,
			E_out	=> side_mux_Enew_out
				);

	--|*************************|--
	--|*********ADDERS**********|--
	--|*************************|--

	ADD_BLOCK : component ADDERS
		port map(
			clk			=> clk,
			mux_in_sel	=> add_block_mux_in_sel,
			mux_sel		=> add_block_mux_sel,
			A_input		=> mux_A_out,
			B_input		=> mux_B_out,
			C_input		=> mux_C_out,
			D_input		=> turing_muxD_out,
			E_input		=> turing_muxE_out,
			S1			=> side_mux_1_out,
			S2			=> side_mux_2_out,
			S3			=> wire8,
			S4			=> wire1,
			S5			=> wire0,
			E_new		=> side_mux_Enew_out,
			A_out		=> adders_out_A,
			B_out		=> adders_out_B,
			C_out		=> adders_out_C,
			D_out		=> adders_out_D,
			E_out		=> adders_out_E
				);

	--|*************************|--
	--|***REGISTER FILE MUXES***|--
	--|*************************|--

	RegFile_mux0 : component MUX_2x1
		port map(
			A_in	=> adders_out_A,
			B_in	=> sober_konst,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux0_out
				);

	RegFile_mux2 : component MUX_2x1
		port map(
			A_in	=> adders_out_C,
			B_in	=> sober_nlf_shift8,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux2_out
				);

	RegFile_mux3 : component MUX_2x1
		port map(
			A_in	=> adders_out_D,
			B_in	=> sober_xor_konst_out,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux3_out
				);

	RegFile_mux4 : component MUX_2x1
		port map(
			A_in	=> adders_out_E,
			B_in	=> sober_f_func_out,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux4_out
				);

	RegFile_mux5 : component MUX_2x1
		port map(
			A_in	=> turing_sbox_out,
			B_in	=> adders_out_E,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux5_out
				);

	RegFile_mux6 : component MUX_2x1
		port map(
			A_in	=> turing_sbox_out,
			B_in	=> adders_out_E,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux6_out
				);

	RegFile_mux7 : component MUX_2x1
		port map(
			A_in	=> turing_sbox_out,
			B_in	=> adders_out_E,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux7_out
				);

	RegFile_mux8 : component MUX_2x1
		port map(
			A_in	=> turing_sbox_out,
			B_in	=> snow_sbox_out,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux8_out
				);

	RegFile_mux9 : component MUX_2x1
		port map(
			A_in	=> turing_sbox_out,
			B_in	=> adders_out_E,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux9_out
				);

	RegFile_mux10 : component MUX_2x1
		port map(
			A_in	=> IV_in,
			B_in	=> adders_out_A,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux10_out
				);

	RegFile_mux11 : component MUX_2x1
		port map(
			A_in	=> IV_in,
			B_in	=> adders_out_B,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux11_out
				);

	RegFile_mux12 : component MUX_2x1
		port map(
			A_in	=> IV_in,
			B_in	=> adders_out_C,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux12_out
				);

	RegFile_mux13 : component MUX_2x1
		port map(
			A_in	=> IV_in,
			B_in	=> adders_out_D,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux13_out
				);

	RegFile_mux14 : component MUX_2x1
		port map(
			A_in	=> IV_in,
			B_in	=> adders_out_E,
			sel		=> reg_file_mux_sel,
			C_out	=> reg_mux14_out
				);

	--|*************************|--
	--|******REGISTER FILE******|--
	--|*************************|--

	REG_FILE : component REGISTER_FILE
		port map(
			clk			=> clk,
			REG1_rst	=> snow_R1_rst,
			REG2_rst	=> snow_R2_rst,
			REG0_ce		=> RF0_ce,
			REG1_ce		=> RF1_ce,
			REG2_ce		=> RF2_ce,
			REG3_ce		=> RF3_ce,
			REG4_ce		=> RF4_ce,
			REG5_ce		=> RF5_ce,
			REG6_ce		=> RF6_ce,
			REG7_ce		=> RF7_ce,
			REG8_ce		=> RF8_ce,
			REG9_ce		=> RF9_ce,
			REG10_ce	=> RF10_ce,
			REG11_ce	=> RF11_ce,
			REG12_ce	=> RF12_ce,
			REG13_ce	=> RF13_ce,
			REG14_ce	=> RF14_ce,
			REG0_in		=> reg_mux0_out,
			REG1_in		=> adders_out_B,
			REG2_in		=> reg_mux2_out,
			REG3_in		=> reg_mux3_out,
			REG4_in		=> reg_mux4_out,
			REG5_in		=> reg_mux5_out,
			REG6_in		=> reg_mux6_out,
			REG7_in		=> reg_mux7_out,
			REG8_in		=> reg_mux8_out,
			REG9_in		=> reg_mux9_out,
			REG10_in	=> reg_mux10_out,
			REG11_in	=> reg_mux11_out,
			REG12_in	=> reg_mux12_out,
			REG13_in	=> reg_mux13_out,
			REG14_in	=> reg_mux14_out,
			REG0_out	=> RF_0_out,
			REG1_out	=> RF_1_out,
			REG2_out	=> RF_2_out,
			REG3_out	=> RF_3_out,
			REG4_out	=> RF_4_out,
			REG5_out	=> RF_5_out,
			REG6_out	=> RF_6_out,
			REG7_out	=> RF_7_out,
			REG8_out	=> RF_8_out,
			REG9_out	=> RF_9_out,
			REG10_out	=> RF_10_out,
			REG11_out	=> RF_11_out,
			REG12_out	=> RF_12_out,
			REG13_out	=> RF_13_out,
			REG14_out	=> RF_14_out
				);

	--|*************************|--
	--|***LFSR FEEDBACK MUXES***|--
	--|*************************|--

	LFSR_feedback_mux1 : component MUX_8x1
		port map(
			A_in	=> RF_10_out,
			B_in	=> RF_11_out,
			C_in	=> RF_12_out,
			D_in	=> RF_13_out,
			E_in	=> RF_14_out,
			F_in	=> RF_9_out,
			G_in	=> empty,
			H_in	=> empty,
			sel		=> lfsr_feedback_mux_sel,
			I_out	=> lfsr_feedback_mux1_out
				);

	LFSR_feedback_mux2 : component MUX_8x1
		port map(
			A_in	=> RF_0_out,
			B_in	=> RF_1_out,
			C_in	=> RF_2_out,
			D_in	=> RF_3_out,
			E_in	=> RF_4_out,
			F_in	=> turing_sbox_out,
			G_in	=> empty,
			H_in	=> empty,
			sel		=> lfsr_feedback_mux_sel,
			I_out	=> lfsr_feedback_mux2_out
				);

	--|*************************|--
	--|***TURING S_BOX MUXES****|--
	--|*************************|--

	turing_pht_out_shift8	(31 downto  8) <= RF_11_out (23 downto  0);
	turing_pht_out_shift8	( 7 downto  0) <= RF_11_out (31 downto 24);
	turing_pht_out_shift16	(31 downto 16) <= RF_12_out (15 downto  0);
	turing_pht_out_shift16	(15 downto  0) <= RF_12_out (31 downto 16);
	turing_pht_out_shift24	(31 downto 24) <= RF_13_out ( 7 downto  0);
	turing_pht_out_shift24	(23 downto  0) <= RF_13_out (31 downto  8);

	Turing_Sbox_mux_word_in_pht_shifted : component MUX_8x1
		port map(
			A_in	=> RF_10_out,
			B_in	=> turing_pht_out_shift8,
			C_in	=> turing_pht_out_shift16,
			D_in	=> turing_pht_out_shift24,
			E_in	=> RF_14_out,
			F_in	=> empty,
			G_in	=> empty,
			H_in	=> empty,
			I_out	=> word_in,
			sel		=> turing_sbox_mux_sel
				);

	Turing_Sbox_mux_mix_key_in : component MUX_8x1
		port map(
			A_in	=> RF_0_out,
			B_in	=> RF_1_out,
			C_in	=> RF_2_out,
			D_in	=> RF_3_out,
			E_in	=> RF_4_out,
			F_in	=> empty,
			G_in	=> empty,
			H_in	=> empty,
			I_out	=> mix_key_in,
			sel		=> turing_sbox_mux_sel
				);

	Turing_Sbox_mux_or_key_in : component MUX_8x1
		port map(
			A_in	=> RF_10_out,
			B_in	=> RF_11_out,
			C_in	=> RF_12_out,
			D_in	=> RF_13_out,
			E_in	=> RF_14_out,
			F_in	=> empty,
			G_in	=> empty,
			H_in	=> empty,
			I_out	=> or_key_in,
			sel		=> turing_sbox_mux_sel
				);

	Turing_Sbox_key_in : component MUX_2x1
		port map(
			A_in	=> or_key_in,
			B_in	=> mix_key_in,
			sel		=> turing_sbox_key_val_mux_sel,
			C_out	=> key_in
				);

	--|*************************|--
	--|*****STEP OPERATIONS*****|--
	--|*************************|--

	StepOp : component Step_Operations
		port map(
			clk					=> clk,
			fsm_mux_sel			=> fsm_mux_step_op_sel,
			R0_in				=> wire0,
			R4_in				=> wire4,
			R15_in				=> wire15,
			multab_input		=> multab_in,
			S0_in				=> wire1,
			S2_in				=> wire3,
			S11_in				=> wire12,
			multab_output		=> sober_mul_out,--mux_multab_out,
			FSM_out				=> fsm_wire,
			mul_a_output		=> mul_a_out,
			mul_ainv_output		=> mul_ainv_out,
			step_sober_turing	=> step_sober_turing_out,
			step_snow			=> step_snow_out
				);

	--|*************************|--
	--|**********ROMs***********|--
	--|*************************|--

	ROM_MEMO : component ROMs
		port map(
			clk						=> clk,
			Turing_SBox_mux_sel		=> turing_sbox_mux_init_key_sel,
			multab_input			=> multab_in,
			S0_in					=> wire1		( 7 downto  0),
			S11_in					=> wire12		(31 downto 24),
			f_function_in			=> adders_out_A (31 downto 24),
			Turing_SBox_in			=> word_in,
			Turind_key_in			=> key_in,
			Snow_SBox_in			=> RF_12_out,
			Sober_multab_out		=> sober_mul_out,
			MUL_A_out				=> mul_a_out,
			MUL_AINV_out			=> mul_ainv_out,
			f_function_out			=> sober_sbox_out,
			Turing_SBox_out			=> turing_sbox_word_out,
			Turing_mixed_key_out	=> turing_sbox_key_out,
			Snow_SBox_T0_out		=> snow_sbox0_out,
			Snow_SBox_T1_out		=> snow_sbox1_out,
			Snow_SBox_T2_out		=> snow_sbox2_out,
			Snow_SBox_T3_out		=> snow_sbox3_out
				);

	--|*************************|--
	--|****TURING SBOX MUX******|--
	--|*************************|--

	Turing_Sbox_mux_word_out : component MUX_2x1
		port map(
			A_in	=> turing_sbox_word_out,
			B_in	=> turing_sbox_key_out,
			sel		=> turing_sbox_mux_init_key_sel,
			C_out	=> turing_sbox_out
				);

	--|*************************|--
	--|******SBOXES XORING******|--
	--|*************************|--

	SBoxes_xoring : component SBox_xoring
		port map(
			Sober_sbox_out		=> sober_sbox_out,
			Sober_f_in			=> adders_out_A,
			Snow_T0_out			=> snow_sbox0_out,
			Snow_T1_out			=> snow_sbox1_out,
			Snow_T2_out			=> snow_sbox2_out,
			Snow_T3_out			=> snow_sbox3_out,
			Sober_f_out			=> sober_f_func_out,
			Sober_shift8_out	=> sober_nlf_shift8,
			Snow_sbox_out		=> snow_sbox_out
				);

	--|*************************|--
	--|*****SOBER NLF XOR*******|--
	--|*************************|--

	Sober_konst_MUX : component MUX_2x1
		port map(
			A_in	=> RF_0_out,
			B_in	=> RF_10_out,
			sel		=> sober_konst_mux_sel,
			C_out	=> sober_konst_mux_out
				);

	Sober_NLF_xor_konst: component XOR_32
		port map(
				a_in	=> adders_out_A,
				b_in	=> sober_konst_mux_out,	--Sober_konst
				c_out	=> sober_xor_konst_out
				);

	Sober_Diffuse_xor: component XOR_32
		port map(
				a_in	=> wire4,
				b_in	=> RF_10_out,		--NLF output
				c_out	=> diffuse_wire
				);

	Sober_Encrypt_xor: component XOR_32
		port map(
				a_in	=> plaintext_in,
				b_in	=> reg_mux10_out,	--NLF output
				c_out	=> sober_ciphertext
				);

	--|*************************|--
	--|****SNOW 2.0 NLF XOR*****|--
	--|*************************|--

	Snow_xor_fsm_out: component XOR_32
		port map(
				a_in	=> adders_out_A,--adders_out_B,
				b_in	=> RF_8_out,
				c_out	=> fsm_wire
				);

	Snow_xor_keystream_out: component XOR_32
		port map(
				a_in	=> fsm_wire,
				b_in	=> wire1,
				c_out	=> snow_keystream
				);

	Snow_xor_ciphertext_out: component XOR_32
		port map(
				a_in	=> snow_keystream,
				b_in	=> plaintext_in,
				c_out	=> snow_ciphertext
				);

	--|*************************|--
	--|*****TURING NLF XOR******|--
	--|*************************|--

	Turing_xor_out1: component XOR_32
		port map(
				a_in	=> RF_10_out,
				b_in	=> turing_plaintext_in	(159 downto 128),
				c_out	=> turing_ciphertext	(159 downto 128)
				);

	Turing_xor_out2: component XOR_32
		port map(
				a_in	=> RF_11_out,
				b_in	=> turing_plaintext_in	(127 downto  96),
				c_out	=> turing_ciphertext	(127 downto  96)
				);

	Turing_xor_out3: component XOR_32
		port map(
				a_in	=> RF_12_out,
				b_in	=> turing_plaintext_in	( 95 downto  64),
				c_out	=> turing_ciphertext	( 95 downto  64)
				);

	Turing_xor_out4: component XOR_32
		port map(
				a_in	=> RF_13_out,
				b_in	=> turing_plaintext_in	( 63 downto  32),
				c_out	=> turing_ciphertext	( 63 downto  32)
				);

	Turing_xor_out5: component XOR_32
		port map(
				a_in	=> RF_14_out,
				b_in	=> turing_plaintext_in	( 31 downto   0),
				c_out	=> turing_ciphertext	( 31 downto   0)
				);

	sober_Vt_out		<= RF_10_out;

	--|*************************|--
	--|******TEST SIGNALS*******|--
	--|*************************|--

end Behavioral;