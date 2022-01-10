library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity ROMs is
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
end ROMs;

architecture Behavioral of ROMs is

component Sober_MULTAB is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		ce			: in	std_logic;
		clk			: in	STD_LOGIC
		);
end component Sober_MULTAB;

component Alpha_MUL is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	std_logic
		);
end component Alpha_MUL;

component Alphainv_MUL is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	std_logic
		);
end component Alphainv_MUL;

component Sober_SBox is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	std_logic
		);
end component Sober_SBox;

component Turing_SBoxes is
	Port (
		clk				: in 	STD_LOGIC;
		ce				: in 	STD_LOGIC;

		--|--- Turing Word In ---|--
		--| Original/Mixed key in|--

		word_in			: in 	unsigned (31 downto 0);
		key_i			: in 	unsigned (31 downto 0);

		--|--Original/Mixed key-|--
		--|---------------------|--

		mux2x1_sel		: in 	std_logic; 	-- 0 for mixed key // 1 for original key

		--|XA-XE output/Mixed Key|--
		--|----------------------|--

		word_out		: out 	unsigned  (31 downto 0);
		mixed_key_o		: out 	unsigned  (31 downto 0)
        );
end component Turing_SBoxes;

component T_LUT is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	STD_LOGIC
		);
end component T_LUT;

	signal T_1_out 	: unsigned (31 downto 0);
	signal T_2_out 	: unsigned (31 downto 0);
	signal T_3_out 	: unsigned (31 downto 0);

begin

	--|****************************|--
	--|***STEP OPERATION MULTABS***|--
	--|****************************|--

	Sober128_MUL : component Sober_MULTAB
		port map(
				address		=> multab_input,
				data_out	=> Sober_multab_out,
				ce			=> '1',
				clk			=> clk
				);

	SNOW_MUL_A : component Alpha_MUL
		port map(
				address		=> S0_in,
				data_out	=> MUL_A_out,
				clk			=> clk,
				ce			=> '1'
				);

	SNOW_MUL_AINV : component Alphainv_MUL
		port map(
				address		=> S11_in,
				data_out	=> MUL_AINV_out,
				clk			=> clk,
				ce			=> '1'
				);

	--|****************************|--
	--|*********SBOX LUTs**********|--
	--|****************************|--

	Sober_Ffunc_SBox : component Sober_SBox
		port map(
				address		=> f_function_in,
				data_out	=> f_function_out,
				clk			=> clk,
				ce			=> '1'
				);

	Turing_SBox : component Turing_SBoxes
		port map(
				clk				=> clk,
				ce				=> '1',
				word_in			=> Turing_SBox_in,
				key_i			=> Turind_key_in,
				mux2x1_sel		=> Turing_SBox_mux_sel,
				word_out		=> Turing_SBox_out,
				mixed_key_o		=> Turing_mixed_key_out
				);


	T_0: component T_LUT
		port map(
				address		=> Snow_SBox_in (31 downto 24),
				clk			=> clk,
				ce			=> '1',
				data_out	=> Snow_SBox_T0_out
				);

	T_1: component T_LUT
		port map(
				address		=> Snow_SBox_in (23 downto 16),
				clk			=> clk,
				ce			=> '1',
				data_out	=> T_1_out
				);

	T_2: component T_LUT
		port map(
				address		=> Snow_SBox_in (15 downto  8),
				clk			=> clk,
				ce			=> '1',
				data_out	=> T_2_out
				);

	T_3: component T_LUT
		port map(
				address		=> Snow_SBox_in ( 7 downto  0),
				clk			=> clk,
				ce			=> '1',
				data_out	=> T_3_out
				);
 				
Snow_SBox_T1_out (31 downto  8) <= T_1_out (23 downto  0); 	--T1 out 8-bit shift
Snow_SBox_T1_out ( 7 downto  0) <= T_1_out (31 downto 24); 	--T1 out 8-bit shift
Snow_SBox_T2_out (31 downto 16) <= T_2_out (15 downto  0);	--T2 out 16-bit shift
Snow_SBox_T2_out (15 downto  0) <= T_2_out (31 downto 16);	--T2 out 16-bit shift
Snow_SBox_T3_out (31 downto 24) <= T_3_out ( 7 downto  0);	--T3 out 24-bit shift
Snow_SBox_T3_out (23 downto  0) <= T_3_out (31 downto  8);	--T3 out 24-bit shift

end Behavioral;