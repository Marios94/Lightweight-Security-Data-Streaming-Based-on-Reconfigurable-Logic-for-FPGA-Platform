library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity TURING_CONTROL_UNIT is
	Port (
			clk								: in STD_LOGIC;

			--tst_0_LFSR						: out unsigned (31 downto 0);
			--tst_1_LFSR						: out unsigned (31 downto 0);
			--tst_2_LFSR						: out unsigned (31 downto 0);
			--tst_3_LFSR						: out unsigned (31 downto 0);
			--tst_4_LFSR						: out unsigned (31 downto 0);
			--tst_5_LFSR						: out unsigned (31 downto 0);
			--tst_6_LFSR						: out unsigned (31 downto 0);
			--tst_7_LFSR						: out unsigned (31 downto 0);
			--tst_8_LFSR						: out unsigned (31 downto 0);
			--tst_9_LFSR						: out unsigned (31 downto 0);
			--tst_10_LFSR						: out unsigned (31 downto 0);
			--tst_11_LFSR						: out unsigned (31 downto 0);
			--tst_12_LFSR						: out unsigned (31 downto 0);
			--tst_13_LFSR						: out unsigned (31 downto 0);
			--tst_14_LFSR						: out unsigned (31 downto 0);
			--tst_15_LFSR						: out unsigned (31 downto 0);
			--tst_16_LFSR						: out unsigned (31 downto 0);

			--tst_0_LFSR_init					: out unsigned (31 downto 0);
			--tst_1_LFSR_init					: out unsigned (31 downto 0);
			--tst_2_LFSR_init					: out unsigned (31 downto 0);
			--tst_3_LFSR_init					: out unsigned (31 downto 0);
			--tst_4_LFSR_init					: out unsigned (31 downto 0);

			--tst_mux_A_out					: out unsigned (31 downto 0);
			--tst_mux_B_out					: out unsigned (31 downto 0);
			--tst_mux_C_out					: out unsigned (31 downto 0);
			--tst_mux_D_out					: out unsigned (31 downto 0);
			--tst_mux_E_out					: out unsigned (31 downto 0);
			--tst_mux1_out					: out unsigned (31 downto 0);
			--tst_mux2_out					: out unsigned (31 downto 0);
			--tst_mux3_out					: out unsigned (31 downto 0);
			--tst_mux4_out					: out unsigned (31 downto 0);
			--tst_mux5_out					: out unsigned (31 downto 0);
			--tst_initvector_mux_0_out		: out unsigned (31 downto 0);
			--tst_initvector_mux_1_out		: out unsigned (31 downto 0);
			--tst_init_adder_mux_0_out		: out unsigned (31 downto 0);
			--tst_init_adder_mux_1_out		: out unsigned (31 downto 0);
			--tst_init_adder_out				: out unsigned (31 downto 0);
			--tst_Init_REG_0_in				: out unsigned (31 downto 0);
			--tst_Init_REG_1_in				: out unsigned (31 downto 0);
			--tst_Init_REG_2_in				: out unsigned (31 downto 0);
			--tst_Init_REG_3_out				: out unsigned (31 downto 0);
			--tst_init_mux_0_out				: out unsigned (31 downto 0);
			--tst_init_mux_1_out				: out unsigned (31 downto 0);
			--tst_step_op_out					: out unsigned (31 downto 0);
			--tst_key_reg_mux_out				: out unsigned (31 downto 0);
			--tst_S_box_mixed_key				: out unsigned (31 downto 0);
			--tst_key_reg_out					: out unsigned (31 downto 0);

			--tst_PHT_muxa					: out unsigned (31 downto 0);
			--tst_PHT_muxb					: out unsigned (31 downto 0);
			--tst_PHT_muxc1					: out unsigned (31 downto 0);
			--tst_PHT_muxc2					: out unsigned (31 downto 0);
			--tst_PHT_muxd1					: out unsigned (31 downto 0);
			--tst_PHT_muxd2					: out unsigned (31 downto 0);
			--tst_PHT_out_A					: out unsigned (31 downto 0);
			--tst_PHT_out_B					: out unsigned (31 downto 0);
			--tst_PHT_out_C					: out unsigned (31 downto 0);
			--tst_PHT_out_D					: out unsigned (31 downto 0);
			--tst_PHT_out_E					: out unsigned (31 downto 0);
			--tst_PHT_shift8					: out unsigned (31 downto 0);
			--tst_PHT_shift16					: out unsigned (31 downto 0);
			--tst_PHT_shift24					: out unsigned (31 downto 0);

			--tst_S_Boxes_out_A				: out unsigned (31 downto 0);
			--tst_S_Boxes_out_B				: out unsigned (31 downto 0);
			--tst_S_Boxes_out_C				: out unsigned (31 downto 0);
			--tst_S_Boxes_out_D				: out unsigned (31 downto 0);
			--tst_S_Boxes_out_E				: out unsigned (31 downto 0);


			--tst_Step_R0_shift8				: out unsigned(31 downto 0);
			--tst_Step_R0_shift24				: out unsigned( 7 downto 0);
			--tst_Step_and_out				: out unsigned( 7 downto 0);
			--tst_Step_xor1					: out unsigned(31 downto 0);
			--tst_Step_xor2					: out unsigned(31 downto 0);
			--tst_Step_xor3					: out unsigned (31 downto 0);
			--tst_Step_multab_out				: out unsigned (31 downto 0);

			--tst_Sbox_word_in				: out unsigned (31 downto 0);
			--tst_Sbox_k0						: out unsigned ( 7 downto 0);
			--tst_Sbox_k1						: out unsigned ( 7 downto 0);
			--tst_Sbox_k2						: out unsigned ( 7 downto 0);
			--tst_Sbox_k3						: out unsigned ( 7 downto 0);
			--tst_Sbox_wordout				: out unsigned (31 downto 0);
			--tst_sbox_mixed_key				: out unsigned (31 downto 0);

			--tst_init_muxes_ctrl_signals		: out unsigned (11 downto 0);
			--tst_init_chip_en_ctrl_signals	: out unsigned ( 4 downto 0);
			--tst_Norm_op_mux_ctrl_signals	: out unsigned (10 downto 0);
			--tst_norm_op_chip_en_ctrl_signals: out unsigned (12 downto 0);
			--test_count						: out integer range 0 to 100;
			--tst_Keystream 					: out unsigned (159 downto 0);
			--tst_ciphertext_in 				: out unsigned (159 downto 0);
			ciphertext 						: out unsigned (159 downto 0);

			iv_key_text						: in  unsigned ( 31 downto 0);
			text_msg 	 					: in  unsigned (159 downto 0)
					);
end TURING_CONTROL_UNIT;

architecture Behavioral of TURING_CONTROL_UNIT is
	component Turing_top is
	    Port (

			clk						: in STD_LOGIC;

			init_mux_0_sel			: in std_logic; --Init MUXES ctrl signals
			init_mux_1_sel			: in std_logic; --Init MUXES ctrl signals

			initvector_mux_0_sel0	: in std_logic; --Init vector MUXES ctrl signals
			initvector_mux_0_sel1	: in std_logic; --Init vector MUXES ctrl signals
			initvector_mux_1_sel0	: in std_logic; --Init vector MUXES ctrl signals
			initvector_mux_1_sel1	: in std_logic; --Init vector MUXES ctrl signals
			initvector_mux_1_sel2	: in std_logic; --Init vector MUXES ctrl signals

			Init_REG_0_ce			: in std_logic; --Init Reg ctrl signals
			Init_REG_1_ce			: in std_logic; --Init Reg ctrl signals
			Init_REG_2_ce			: in std_logic; --Init Reg ctrl signals
			Init_REG_3_ce			: in std_logic; --Init Reg ctrl signals

			init_adder_mux_sel0		: in std_logic; -- Init Reg MUXES ctrl signals
			init_adder_mux_sel1		: in std_logic; -- Init Reg MUXES ctrl signals

			mux_sel_PHT_in			: in std_logic; --Mux  2x1 ctrl signals

			mux_init_sel0			: in std_logic; --Mux  6x1 ctrl signals
			mux_init_sel1			: in std_logic; --Mux  6x1 ctrl signals
			mux_init_sel2			: in std_logic; --Mux  6x1 ctrl signals

			key_reg_ce				: in std_logic; --Key_Register ctrl signals

			LFSR_set				: in STD_LOGIC; --LFSR ctrl signals
			LFSR_ce					: in STD_LOGIC; --LFSR ctrl signals
			LFSR_rst				: in STD_LOGIC; --LFSR ctrl signals

			Step_op_ce				: in std_logic; --Step Op ctrl signals

			mux_sel_pht				: in std_logic; --PHT_5 control signals
			mux_init_pht_sel		: in std_logic; --PHT_5 control signals
			mux_init_pht_val_sel	: in std_logic; --PHT_5 control signals
			reg_enable_pht			: in std_logic; --PHT_5 control signals
			reg5_enable_pht			: in std_logic; --PHT_5 control signals

			mux_sel_SBox_key_0		: in std_logic; --SBOX key input mux select
			mux_sel_SBox_key_1		: in std_logic; --SBOX key input mux select
			mux_sel_SBox_key_2		: in std_logic; --SBOX key input mux select
			Sbox_ce					: in std_logic; --SBOXes control signals
			mux_sel_sbox0			: in std_logic; --SBOXes control signals
			mux_sel_sbox1			: in std_logic; --SBOXes control signals
			mux_sel_sbox2			: in std_logic; --SBOXes control signals
			mux_sbox_init_sel		: in std_logic; --| 0 NORMAL OP MODE, 1 INIT MODE |--
			sbox_regA_ce			: in std_logic; --SBOXes control signals
			sbox_regB_ce			: in std_logic; --SBOXes control signals
			sbox_regC_ce			: in std_logic; --SBOXes control signals
			sbox_regD_ce			: in std_logic; --SBOXes control signals
			sbox_regE_ce			: in std_logic; --SBOXes control signals



			blck_add_en				: in std_logic; --Block Add ctrl signals

			--|-------test signals-------|--

			--test_0_LFSR					: out unsigned (31 downto 0);
			--test_1_LFSR					: out unsigned (31 downto 0);
			--test_2_LFSR					: out unsigned (31 downto 0);
			--test_3_LFSR					: out unsigned (31 downto 0);
			--test_4_LFSR					: out unsigned (31 downto 0);
			--test_5_LFSR					: out unsigned (31 downto 0);
			--test_6_LFSR					: out unsigned (31 downto 0);
			--test_7_LFSR					: out unsigned (31 downto 0);
			--test_8_LFSR					: out unsigned (31 downto 0);
			--test_9_LFSR					: out unsigned (31 downto 0);
			--test_10_LFSR				: out unsigned (31 downto 0);
			--test_11_LFSR				: out unsigned (31 downto 0);
			--test_12_LFSR				: out unsigned (31 downto 0);
			--test_13_LFSR				: out unsigned (31 downto 0);
			--test_14_LFSR				: out unsigned (31 downto 0);
			--test_15_LFSR				: out unsigned (31 downto 0);
			--test_16_LFSR				: out unsigned (31 downto 0);

			--test_0_LFSR_init			: out unsigned (31 downto 0);
			--test_1_LFSR_init			: out unsigned (31 downto 0);
			--test_2_LFSR_init			: out unsigned (31 downto 0);
			--test_3_LFSR_init			: out unsigned (31 downto 0);
			--test_4_LFSR_init			: out unsigned (31 downto 0);

			--test_mux_A_out				: out unsigned (31 downto 0);
			--test_mux_B_out				: out unsigned (31 downto 0);
			--test_mux_C_out				: out unsigned (31 downto 0);
			--test_mux_D_out				: out unsigned (31 downto 0);
			--test_mux_E_out				: out unsigned (31 downto 0);
			--test_mux1_out				: out unsigned (31 downto 0);
			--test_mux2_out				: out unsigned (31 downto 0);
			--test_mux3_out				: out unsigned (31 downto 0);
			--test_mux4_out				: out unsigned (31 downto 0);
			--test_mux5_out				: out unsigned (31 downto 0);
			--test_initvector_mux_0_out	: out unsigned (31 downto 0);
			--test_initvector_mux_1_out	: out unsigned (31 downto 0);
			--test_init_adder_mux_0_out	: out unsigned (31 downto 0);
			--test_init_adder_mux_1_out	: out unsigned (31 downto 0);
			--test_init_adder_out			: out unsigned (31 downto 0);
			--test_Init_REG_0_in			: out unsigned (31 downto 0);
			--test_Init_REG_1_in			: out unsigned (31 downto 0);
			--test_Init_REG_2_in			: out unsigned (31 downto 0);
			--test_Init_REG_3_out			: out unsigned (31 downto 0);
			--test_init_mux_0_out			: out unsigned (31 downto 0);
			--test_init_mux_1_out			: out unsigned (31 downto 0);
			--test_step_op_out			: out unsigned (31 downto 0);
			--test_key_reg_mux_out		: out unsigned (31 downto 0);
			--test_S_box_mixed_key		: out unsigned (31 downto 0);
			--test_key_reg_out			: out unsigned (31 downto 0);

			--test_PHT_muxa				: out unsigned (31 downto 0);
			--test_PHT_muxb				: out unsigned (31 downto 0);
			--test_PHT_muxc1				: out unsigned (31 downto 0);
			--test_PHT_muxc2				: out unsigned (31 downto 0);
			--test_PHT_muxd1				: out unsigned (31 downto 0);
			--test_PHT_muxd2				: out unsigned (31 downto 0);
			--test_PHT_out_A				: out unsigned (31 downto 0);
			--test_PHT_out_B				: out unsigned (31 downto 0);
			--test_PHT_out_C				: out unsigned (31 downto 0);
			--test_PHT_out_D				: out unsigned (31 downto 0);
			--test_PHT_out_E				: out unsigned (31 downto 0);
			--test_PHT_shift8				: out unsigned (31 downto 0);
			--test_PHT_shift16			: out unsigned (31 downto 0);
			--test_PHT_shift24			: out unsigned (31 downto 0);

			--test_S_Boxes_out_A			: out unsigned (31 downto 0);
			--test_S_Boxes_out_B			: out unsigned (31 downto 0);
			--test_S_Boxes_out_C			: out unsigned (31 downto 0);
			--test_S_Boxes_out_D			: out unsigned (31 downto 0);
			--test_S_Boxes_out_E			: out unsigned (31 downto 0);

			--test_Step_R0_shift8			: out unsigned (31 downto 0);
			--test_Step_R0_shift24		: out unsigned ( 7 downto 0);
			--test_Step_and_out			: out unsigned ( 7 downto 0);
			--test_Step_xor1				: out unsigned (31 downto 0);
			--test_Step_xor2				: out unsigned (31 downto 0);

			--test_Step_xor3				: out unsigned (31 downto 0);
			--test_Step_multab_out		: out unsigned (31 downto 0);

			--test_Sbox_word_in			: out unsigned (31 downto 0);
			--test_Sbox_k0				: out unsigned ( 7 downto 0);
			--test_Sbox_k1				: out unsigned ( 7 downto 0);
			--test_Sbox_k2				: out unsigned ( 7 downto 0);
			--test_Sbox_k3				: out unsigned ( 7 downto 0);
			--test_Sbox_wordout			: out unsigned (31 downto 0);
			--test_sbox_mixed_key			: out unsigned (31 downto 0);
			--test_Keystream				: out unsigned (159 downto 0);
			--|---Control Unti inputs---|--
			IV_OrKey_DefVal					: in unsigned ( 31 downto 0);
			text_message					: in unsigned (159 downto 0);
			--|----Keystream output-----|--
			ciphertext						: out unsigned (159 downto 0)
			);
	end component Turing_top;

	signal Init_muxes_ctrl_signals 		: unsigned (11 downto 0);
	signal Init_chip_en_ctrl_signals	: unsigned ( 4 downto 0);
	signal Norm_op_mux_ctrl_signals		: unsigned (10 downto 0);
	signal Norm_op_chip_en_ctrl_signals	: unsigned (12 downto 0);
	signal Norm_oper_ctrl_signals		: unsigned (29 downto 0);
	signal ciphertext_in				: unsigned (159 downto 0);
	signal ciphertext_out				: unsigned (159 downto 0);
	signal cnt 							: integer range 0 to 100;
	signal valid_out 					: unsigned (159 downto 0);

begin

	TURINGTOP: component Turing_top
		port map(
			clk						=> clk,

			mux_init_pht_val_sel	=> Init_muxes_ctrl_signals(11),
			mux_init_pht_sel		=> Init_muxes_ctrl_signals(10),
			mux_sbox_init_sel		=> Init_muxes_ctrl_signals(9),
			initvector_mux_1_sel2	=> Init_muxes_ctrl_signals(8),
			initvector_mux_1_sel1	=> Init_muxes_ctrl_signals(7),
			initvector_mux_1_sel0	=> Init_muxes_ctrl_signals(6),
			initvector_mux_0_sel1	=> Init_muxes_ctrl_signals(5),
			initvector_mux_0_sel0	=> Init_muxes_ctrl_signals(4),
			init_adder_mux_sel1		=> Init_muxes_ctrl_signals(3),
			init_adder_mux_sel0		=> Init_muxes_ctrl_signals(2),
			init_mux_1_sel			=> Init_muxes_ctrl_signals(1),
			init_mux_0_sel			=> Init_muxes_ctrl_signals(0),

			Init_REG_3_ce 			=> Init_chip_en_ctrl_signals(4),
			Init_REG_2_ce 			=> Init_chip_en_ctrl_signals(3),
			Init_REG_1_ce 			=> Init_chip_en_ctrl_signals(2),
			Init_REG_0_ce 			=> Init_chip_en_ctrl_signals(1),
			key_reg_ce 				=> Init_chip_en_ctrl_signals(0),

			mux_sel_SBox_key_2 		=> Norm_op_mux_ctrl_signals(10),
			mux_sel_SBox_key_1 		=> Norm_op_mux_ctrl_signals(9),
			mux_sel_SBox_key_0 		=> Norm_op_mux_ctrl_signals(8),
			mux_sel_sbox2 			=> Norm_op_mux_ctrl_signals(7),
			mux_sel_sbox1 			=> Norm_op_mux_ctrl_signals(6),
			mux_sel_sbox0 			=> Norm_op_mux_ctrl_signals(5),
			mux_sel_pht 			=> Norm_op_mux_ctrl_signals(4),
			mux_sel_PHT_in 			=> Norm_op_mux_ctrl_signals(3),	--| MUXES 1-5 |--
			mux_init_sel2 			=> Norm_op_mux_ctrl_signals(2),	--| MUXES A-E |--
			mux_init_sel1 			=> Norm_op_mux_ctrl_signals(1),	--| MUXES A-E |--
			mux_init_sel0 			=> Norm_op_mux_ctrl_signals(0),	--| MUXES A-E |--

			blck_add_en 			=> Norm_op_chip_en_ctrl_signals(12),
			sbox_regE_ce			=> Norm_op_chip_en_ctrl_signals(11),
			sbox_regD_ce			=> Norm_op_chip_en_ctrl_signals(10),
			sbox_regC_ce			=> Norm_op_chip_en_ctrl_signals(9),
			sbox_regB_ce			=> Norm_op_chip_en_ctrl_signals(8),
			sbox_regA_ce			=> Norm_op_chip_en_ctrl_signals(7),
			Sbox_ce 				=> Norm_op_chip_en_ctrl_signals(6),
			reg_enable_pht 			=> Norm_op_chip_en_ctrl_signals(5),
			reg5_enable_pht 		=> Norm_op_chip_en_ctrl_signals(4),
			Step_op_ce 				=> Norm_op_chip_en_ctrl_signals(3),
			LFSR_rst 				=> Norm_op_chip_en_ctrl_signals(2),
			LFSR_set 				=> Norm_op_chip_en_ctrl_signals(1),
			LFSR_ce 				=> Norm_op_chip_en_ctrl_signals(0),

			--|-------test signals-------|--

			--test_0_LFSR 				=> tst_0_LFSR,
			--test_1_LFSR 				=> tst_1_LFSR,
			--test_2_LFSR 				=> tst_2_LFSR,
			--test_3_LFSR 				=> tst_3_LFSR,
			--test_4_LFSR 				=> tst_4_LFSR,
			--test_5_LFSR 				=> tst_5_LFSR,
			--test_6_LFSR 				=> tst_6_LFSR,
			--test_7_LFSR 				=> tst_7_LFSR,
			--test_8_LFSR 				=> tst_8_LFSR,
			--test_9_LFSR 				=> tst_9_LFSR,
			--test_10_LFSR 				=> tst_10_LFSR,
			--test_11_LFSR 				=> tst_11_LFSR,
			--test_12_LFSR 				=> tst_12_LFSR,
			--test_13_LFSR 				=> tst_13_LFSR,
			--test_14_LFSR 				=> tst_14_LFSR,
			--test_15_LFSR 				=> tst_15_LFSR,
			--test_16_LFSR 				=> tst_16_LFSR,
		
			--test_Step_R0_shift8			=> tst_Step_R0_shift8,
			--test_Step_R0_shift24		=> tst_Step_R0_shift24,
			--test_Step_and_out			=> tst_Step_and_out,
			--test_Step_xor1				=> tst_Step_xor1,
			--test_Step_xor2				=> tst_Step_xor2,

			--test_Step_xor3				=> tst_Step_xor3,
			--test_Step_multab_out		=> tst_Step_multab_out,
			--test_step_op_out			=> tst_step_op_out,
			--test_mux_A_out				=> tst_mux_A_out,
			--test_mux_B_out				=> tst_mux_B_out,
			--test_mux_C_out				=> tst_mux_C_out,
			--test_mux_D_out				=> tst_mux_D_out,
			--test_mux_E_out				=> tst_mux_E_out,
			--test_mux1_out				=> tst_mux1_out,
			--test_mux2_out				=> tst_mux2_out,
			--test_mux3_out				=> tst_mux3_out,
			--test_mux4_out				=> tst_mux4_out,
			--test_mux5_out				=> tst_mux5_out,
			--test_PHT_muxa				=> tst_PHT_muxa,
			--test_PHT_muxb				=> tst_PHT_muxb,
			--test_PHT_muxc1				=> tst_PHT_muxc1,
			--test_PHT_muxc2				=> tst_PHT_muxc2,
			--test_PHT_muxd1				=> tst_PHT_muxd1,
			--test_PHT_muxd2				=> tst_PHT_muxd2,
			--test_PHT_out_A				=> tst_PHT_out_A,
			--test_PHT_out_B				=> tst_PHT_out_B,
			--test_PHT_out_C				=> tst_PHT_out_C,
			--test_PHT_out_D				=> tst_PHT_out_D,
			--test_PHT_out_E				=> tst_PHT_out_E,
			--test_PHT_shift8				=> tst_PHT_shift8,
			--test_PHT_shift16			=> tst_PHT_shift16,
			--test_PHT_shift24			=> tst_PHT_shift24,
			--test_S_Boxes_out_A			=> tst_S_Boxes_out_A,
			--test_S_Boxes_out_B			=> tst_S_Boxes_out_B,
			--test_S_Boxes_out_C			=> tst_S_Boxes_out_C,
			--test_S_Boxes_out_D			=> tst_S_Boxes_out_D,
			--test_S_Boxes_out_E			=> tst_S_Boxes_out_E,
			--test_0_LFSR_init			=> tst_0_LFSR_init,
			--test_1_LFSR_init			=> tst_1_LFSR_init,
			--test_2_LFSR_init			=> tst_2_LFSR_init,
			--test_3_LFSR_init			=> tst_3_LFSR_init,
			--test_4_LFSR_init			=> tst_4_LFSR_init,
			--test_initvector_mux_0_out	=> tst_initvector_mux_0_out,
			--test_initvector_mux_1_out	=> tst_initvector_mux_1_out,
			--test_init_adder_mux_0_out	=> tst_init_adder_mux_0_out,
			--test_init_adder_mux_1_out	=> tst_init_adder_mux_1_out,
			--test_init_adder_out			=> tst_init_adder_out,
			--test_Init_REG_0_in			=> tst_Init_REG_0_in,
			--test_Init_REG_1_in			=> tst_Init_REG_1_in,
			--test_Init_REG_2_in			=> tst_Init_REG_2_in,
			--test_Init_REG_3_out			=> tst_Init_REG_3_out,
			--test_init_mux_0_out			=> tst_init_mux_0_out,
			--test_init_mux_1_out			=> tst_init_mux_1_out,
			--test_key_reg_mux_out		=> tst_key_reg_mux_out,
			--test_S_box_mixed_key		=> tst_S_box_mixed_key,
			--test_key_reg_out			=> tst_key_reg_out,
			--test_Sbox_word_in			=> tst_Sbox_word_in,
			--test_Sbox_k0				=> tst_Sbox_k0,
			--test_Sbox_k1				=> tst_Sbox_k1,
			--test_Sbox_k2				=> tst_Sbox_k2,
			--test_Sbox_k3				=> tst_Sbox_k3,
			--test_Sbox_wordout			=> tst_Sbox_wordout,
			--test_sbox_mixed_key			=> tst_sbox_mixed_key,
			--test_Keystream				=> tst_Keystream,

			--|---Control Unti inputs---|--
			IV_OrKey_DefVal				=> iv_key_text,
			text_message				=> text_msg,
			--|----Keystream output-----|--
			ciphertext					=> ciphertext_in
				);

	--tst_init_muxes_ctrl_signals		<= Init_muxes_ctrl_signals;
	--tst_init_chip_en_ctrl_signals 	<= Init_chip_en_ctrl_signals;
	--tst_Norm_op_mux_ctrl_signals	<= Norm_op_mux_ctrl_signals;
	--tst_norm_op_chip_en_ctrl_signals<= Norm_op_chip_en_ctrl_signals;
	--test_count 						<= cnt;
	--tst_ciphertext_in				<= ciphertext_in;
	ciphertext 					<= ciphertext_out;

		--|----------------------------------|--
		--|----------- COUNTER --------------|--
		--|----------------------------------|--

	count : process(clk) is
	begin

		if rising_edge(clk) then
			if cnt < 100 then
				cnt <= cnt + 1;
			end if;
		end if;

	end process;

	ciphertext_out <= ciphertext_in and valid_out;


	cntrl_unt : process(cnt) is
	begin
			case cnt is

						--|*******************************|--
						--|  INITIALIZATION MODE BEGIN    |--
						--|*******************************|--

				when 0  =>

								--|*** Initialization Vector Loading ***|--
				when 1  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
				when 2  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
				when 3  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
				when 4  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
				when 5  =>
					Init_muxes_ctrl_signals		<= "001000000000";
					Init_chip_en_ctrl_signals	<= "00001";

								--|*** IV Mixing, Key Register Loading, LFSR IV Loadin ***|--
				when 6  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 7  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 8  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 9  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 10  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";

								--|*** Original Key Loading ***|--
				when 11  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
				when 12  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
				when 13  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
				when 14  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
				when 15  =>
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";

								--|*** Mixed Key Generated, Init Reg Loading ***|--
				when 16  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";
				when 17  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";
				when 18  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";
				when 19  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";
				when 20  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_chip_en_ctrl_signals<= "0000001000000";
				when 21  =>						--|*** PHT_5 calc, mixed_keyword denoted E calculated ***|--
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000101";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";--
				when 22  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated ***|--
					Init_muxes_ctrl_signals		<= "001000100001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 23  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated, Key_reg/LFSR Loading w/A ***|--
					Init_muxes_ctrl_signals		<= "001000100011";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 24  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated, Key_reg/LFSR Loading w/B ***|--
					Init_muxes_ctrl_signals		<= "001001100011";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 25  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated, Key_reg/LFSR Loading w/C ***|--
					Init_muxes_ctrl_signals		<= "001010100011";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 26  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated, Key_reg/LFSR Loading w/D ***|--
					Init_muxes_ctrl_signals		<= "001011100011";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 27  =>						--|*** PHT_5 calc, mixed_keywords A-D calculated, Key_reg/LFSR Loading w/E ***|--
					Init_muxes_ctrl_signals		<= "000100100011";
					Init_chip_en_ctrl_signals	<= "00001";
					Norm_op_mux_ctrl_signals 	<= "00000010101";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";

								--|*** Default Value Loaded, Additional values calculated, LFSR Loading ***|--
				when 28  =>						--|*** LFSR Loading w/default value ***|--
					Init_muxes_ctrl_signals		<= "000000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 29  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 30  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 31  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 32  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 33  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 34  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 35  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 36  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 37  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 38  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";
				when 39  =>						--|*** new value calculated through PHT ***|--
					Init_muxes_ctrl_signals		<= "101000000001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000001100000";
				when 40  =>
					Init_muxes_ctrl_signals		<= "001000010001";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10100010000";
					Norm_op_chip_en_ctrl_signals<= "0000001000001";

								--|*** PHT_17 calculated ***|--
				when 41  => 					--|*** PHT_5 calc, R0+R1+R2+R3+R4 ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000001";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 42  => 					--|*** PHT_5 calc, R5+R6+R7+R8+R9, INIT_REG0 Loaded ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00010";
					Norm_op_mux_ctrl_signals 	<= "00000000010";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 43  => 					--|*** PHT_5 calc, R10+R11+R12+R13+R14, INIT_REG1 Loaded ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00100";
					Norm_op_mux_ctrl_signals 	<= "00000000011";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 44  => 					--|*** INIT_REG0 + INIT_REG1, InitREG2/InitREG3 Loaded ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "11000";
					Norm_op_mux_ctrl_signals 	<= "00000000011";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 45  => 					--|*** INIT_REG3 + INIT_REG2, InitREG3 Loaded ***|--
					Init_muxes_ctrl_signals		<= "000000000101";
					Init_chip_en_ctrl_signals	<= "10000";
					Norm_op_mux_ctrl_signals 	<= "00000000011";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 46  => 					--|*** INIT_REG3 + R15, InitREG3 Loaded ***|--
					Init_muxes_ctrl_signals		<= "000000001001";
					Init_chip_en_ctrl_signals	<= "10000";
					Norm_op_mux_ctrl_signals 	<= "00000000011";
					Norm_op_chip_en_ctrl_signals<= "0000001010000";
				when 47  => 					--|*** INIT_REG3 + R16, InitREG3 Loaded ***|--
					Init_muxes_ctrl_signals		<= "010000001101";
					Init_chip_en_ctrl_signals	<= "10000";
					Norm_op_mux_ctrl_signals 	<= "00000010001";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";

				when 48  => 					--|*** R0/R1/R2/R3 + R16_new ***|--
					Init_muxes_ctrl_signals		<= "010000000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";
				when 49  => 					--|*** LFSR Loaded w/R0_new ***|--
					Init_muxes_ctrl_signals		<= "010000000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 50  => 					--|*** LFSR Loaded w/R1_new ***|--
					Init_muxes_ctrl_signals		<= "010001000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 51  => 					--|*** LFSR Loaded w/R2_new ***|--
					Init_muxes_ctrl_signals		<= "010010000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 52  => 					--|*** LFSR Loaded w/R3_new ***|--
					Init_muxes_ctrl_signals		<= "010011000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";

				when 53  => 					--|*** R4/R5/R6/R7 + R16_new ***|--
					Init_muxes_ctrl_signals		<= "010100000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";
				when 54  => 					--|*** LFSR Loaded w/R4_new ***|--
					Init_muxes_ctrl_signals		<= "010000000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 55  => 					--|*** LFSR Loaded w/R5_new ***|--
					Init_muxes_ctrl_signals		<= "010001000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 56  => 					--|*** LFSR Loaded w/R6_new ***|--
					Init_muxes_ctrl_signals		<= "010010000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 57  => 					--|*** LFSR Loaded w/R7_new ***|--
					Init_muxes_ctrl_signals		<= "010011000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";

				when 58  => 					--|*** R8/R9/R10/R11 + R16_new ***|--
					Init_muxes_ctrl_signals		<= "010100000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";
				when 59  => 					--|*** LFSR Loaded w/R8_new ***|--
					Init_muxes_ctrl_signals		<= "010000000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 60  => 					--|*** LFSR Loaded w/R9_new ***|--
					Init_muxes_ctrl_signals		<= "010001000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 61  => 					--|*** LFSR Loaded w/R10_new ***|--
					Init_muxes_ctrl_signals		<= "010010000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 62  => 					--|*** LFSR Loaded w/R11_new ***|--
					Init_muxes_ctrl_signals		<= "010011000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";

				when 63  => 					--|*** R12/R13/R14/R15 + R16_new ***|--
					Init_muxes_ctrl_signals		<= "010100000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";
				when 64  => 					--|*** LFSR Loaded w/R12_new ***|--
					Init_muxes_ctrl_signals		<= "010000000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 65  => 					--|*** LFSR Loaded w/R13_new ***|--
					Init_muxes_ctrl_signals		<= "010001000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 66  => 					--|*** LFSR Loaded w/R14_new ***|--
					Init_muxes_ctrl_signals		<= "010010000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 67  => 					--|*** LFSR Loaded w/R15_new ***|--
					Init_muxes_ctrl_signals		<= "010011000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 68  => 					--|*** LFSR Loaded w/R16_new  ***|--
					Init_muxes_ctrl_signals		<= "010101000011";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010100";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";

						--|*******************************|--
						--|  INITIALIZATION MODE END      |--
						--|*******************************|--


						--|*******************************|--
						--|  NORMAL OPERATION MODE BEGIN  |--
						--|*******************************|--

				when 69  => 					--|*** Step Operation output calc ***|--
					Init_muxes_ctrl_signals		<= "000101000010";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000000001000";
				when 70  => 					--|*** LFSR Loaded w/Step Operation output ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000000000001";
				when 71  => 					--|*** E_new calculated ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000000010000";
				when 72  => 					--|*** A/B/C/D_new calculated ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000010000";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";
				when 73  => 					--|*** SBox shuffle A_new, Step Operation out ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000011001000";
				when 74  => 					--|*** SBox shuffle B_new, LFSR Stepped once ***|--
					Init_muxes_ctrl_signals		<= "000000110000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00100100000";
					Norm_op_chip_en_ctrl_signals<= "0000101000001";
				when 75  => 					--|*** SBox shuffle C_new, Step Operation out ***|--
					Init_muxes_ctrl_signals		<= "010000110000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "01001000000";
					Norm_op_chip_en_ctrl_signals<= "0001001001000";
				when 76  => 					--|*** SBox shuffle D_new, LFSR Stepped once ***|--
					Init_muxes_ctrl_signals		<= "010000110000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "01101100000";
					Norm_op_chip_en_ctrl_signals<= "0010001000001";
				when 77  => 					--|*** SBox shuffle E_new, Step Operation out ***|--
					Init_muxes_ctrl_signals		<= "100000110000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "10010000000";
					Norm_op_chip_en_ctrl_signals<= "0100001001000";
				when 78  => 					--|*** PHT_5 mixing, E_new calc, LFSR Stepped once ***|--
					Init_muxes_ctrl_signals		<= "000101000010";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000001000";
					Norm_op_chip_en_ctrl_signals<= "0000000010001";
				when 79  => 					--|*** PHT_5 mixing, A/B/C/D_new calculated ***|--
					Init_muxes_ctrl_signals		<= "000101000010";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000011000";
					Norm_op_chip_en_ctrl_signals<= "0000000100000";

				when 80  => 					--|*** NOP ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
				when 81  => 					--|*** Keystream calculated ***|--
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "1000000000000";
					valid_out 					<= x"ffffffffffffffffffffffffffffffffffffffff";

						--|*******************************|--
						--|  NORMAL OPERATION MODE BEGIN  |--
						--|*******************************|--

				when others => 
					Init_muxes_ctrl_signals		<= "000000000000";
					Init_chip_en_ctrl_signals	<= "00000";
					Norm_op_mux_ctrl_signals 	<= "00000000000";
					Norm_op_chip_en_ctrl_signals<= "0000000000000";
					valid_out 					<= x"0000000000000000000000000000000000000000";
			end case;
	end process;

end Behavioral;