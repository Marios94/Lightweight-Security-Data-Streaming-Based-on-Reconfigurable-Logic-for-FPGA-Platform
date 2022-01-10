library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Turing_top is
    Port ( 

        clk                     : in STD_LOGIC;

        init_mux_0_sel          : in std_logic; --Init MUXES ctrl signals
        init_mux_1_sel          : in std_logic; --Init MUXES ctrl signals

        initvector_mux_0_sel0   : in std_logic; --Init vector MUXES ctrl signals
        initvector_mux_0_sel1   : in std_logic; --Init vector MUXES ctrl signals
        initvector_mux_1_sel0   : in std_logic; --Init vector MUXES ctrl signals
        initvector_mux_1_sel1   : in std_logic; --Init vector MUXES ctrl signals
        initvector_mux_1_sel2   : in std_logic; --Init vector MUXES ctrl signals

        mux_sel_PHT_in          : in std_logic; --Mux  2x1 ctrl signals

        mux_init_sel0           : in std_logic; --Mux  6x1 ctrl signals
        mux_init_sel1           : in std_logic; --Mux  6x1 ctrl signals
        mux_init_sel2           : in std_logic; --Mux  6x1 ctrl signals

        key_reg_ce              : in std_logic; --Key_Register ctrl signals

        LFSR_set                : in STD_LOGIC; --LFSR ctrl signals
        LFSR_ce                 : in STD_LOGIC; --LFSR ctrl signals
        LFSR_rst                : in STD_LOGIC; --LFSR ctrl signals

        Step_op_ce              : in std_logic; --Step Op ctrl signals

        mux_sel_pht             : in std_logic; --PHT_5 control signals
        mux_init_pht_sel        : in std_logic; --PHT_5 control signals
        mux_init_pht_val_sel    : in std_logic; --PHT_5 control signals
        reg_enable_pht          : in std_logic; --PHT_5 control signals
        reg5_enable_pht         : in std_logic; --PHT_5 control signals

        mux_sel_SBox_key_0      : in std_logic; --SBOX key input mux select
        mux_sel_SBox_key_1      : in std_logic; --SBOX key input mux select
        mux_sel_SBox_key_2      : in std_logic; --SBOX key input mux select
        Sbox_ce                 : in std_logic; --SBOXes control signals
        mux_sel_sbox0           : in std_logic; --SBOXes control signals
        mux_sel_sbox1           : in std_logic; --SBOXes control signals
        mux_sel_sbox2           : in std_logic; --SBOXes control signals
        mux_sbox_init_sel       : in std_logic; --| 0 NORMAL OP MODE, 1 INIT MODE |--
        sbox_regA_ce            : in std_logic; --SBOXes control signals
        sbox_regB_ce            : in std_logic; --SBOXes control signals
        sbox_regC_ce            : in std_logic; --SBOXes control signals
        sbox_regD_ce            : in std_logic; --SBOXes control signals
        sbox_regE_ce            : in std_logic; --SBOXes control signals

        Init_REG_0_ce           : in std_logic; --Init Reg ctrl signals
        Init_REG_1_ce           : in std_logic; --Init Reg ctrl signals
        Init_REG_2_ce           : in std_logic; --Init Reg ctrl signals
        Init_REG_3_ce           : in std_logic; --Init Reg ctrl signals
        
        init_adder_mux_sel0     : in std_logic; -- Init Reg MUXES ctrl signals
        init_adder_mux_sel1     : in std_logic; -- Init Reg MUXES ctrl signals

        blck_add_en             : in std_logic; --Block Add ctrl signals

        IV_OrKey_DefVal             : in unsigned ( 31 downto 0);
        text_message                : in unsigned ( 159 downto 0);

        ciphertext                  : out unsigned (159 downto 0)
        );
end Turing_top;

architecture Behavioral of Turing_top is

    component XOR_32
        port (
        a_in    : in unsigned (31 downto 0);
        b_in    : in unsigned (31 downto 0);
        c_out   : out unsigned (31 downto 0)
        );
    end component XOR_32;

    component MUX_2x1
        port(
            A_in    : in unsigned   (31 downto 0);  --|<-- CONTROL UNIT
            B_in    : in unsigned   (31 downto 0);  --|<-- Step Op.
            sel     : in std_logic;
            C_out   : out unsigned  (31 downto 0)   --|--> LFSR
            );
    end component MUX_2x1;

    component MUX_4x1 is
        Port (
            A_in    : in unsigned  (31 downto 0);
            B_in    : in unsigned  (31 downto 0);
            C_in    : in unsigned  (31 downto 0);
            D_in    : in unsigned  (31 downto 0);
            E_out   : out unsigned (31 downto 0);
            sel_0   : in STD_LOGIC;
            sel_1   : in STD_LOGIC
            );
    end component MUX_4x1;

    component MUX_6x1 is
    Port (
        A_in    : in unsigned  (31 downto 0);
        B_in    : in unsigned  (31 downto 0);
        C_in    : in unsigned  (31 downto 0);
        D_in    : in unsigned  (31 downto 0);
        E_in    : in unsigned  (31 downto 0);
        F_in    : in unsigned  (31 downto 0);
        G_out   : out unsigned (31 downto 0);
        sel_0   : in STD_LOGIC;
        sel_1   : in STD_LOGIC;
        sel_2   : in STD_LOGIC
        );
end component MUX_6x1;

    component Adder_mod2_32
        port(
            a_in : in unsigned  (31 downto 0);
            b_in : in unsigned  (31 downto 0);
            sum  : out unsigned (31 downto 0)
            );
    end component Adder_mod2_32; 

    component Parallel_Register 
        port (
            clk     : in STD_LOGIC;
            set     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            ce      : in STD_LOGIC;
            par_in  : in  unsigned (31 downto 0);
            par_out : out unsigned (31 downto 0)
            );
        end component Parallel_Register;

    component Parallel_Register_160_bit
        port(
            clk         : in STD_LOGIC;
            set         : in STD_LOGIC;
            rst         : in STD_LOGIC;
            ce          : in STD_LOGIC;
            wire_0      : out unsigned (31 downto 0);
            wire_1      : out unsigned (31 downto 0);
            wire_2      : out unsigned (31 downto 0);
            wire_3      : out unsigned (31 downto 0);
            wire_4      : out unsigned (31 downto 0);
            par_4_in    : in  unsigned (31 downto 0);
            par_0_out   : out unsigned (31 downto 0)
            );
    end component Parallel_Register_160_bit;

    component LFSR_Turing
        port(
        clk         : in STD_LOGIC;
        set         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        ce          : in STD_LOGIC;

        R_16_in     : in unsigned (31 downto 0);    -- Step. Op.

        R_0_out     : out unsigned (31 downto 0);   -- initialization mode / Step. Op / NLF /Block Add
        R_1_out     : out unsigned (31 downto 0);   -- initialization mode / NLF / Block Add
        R_2_out     : out unsigned (31 downto 0);   -- initialization mode
        R_3_out     : out unsigned (31 downto 0);   -- initialization mode
        R_4_out     : out unsigned (31 downto 0);   -- initialization mode / Step. Op
        R_5_out     : out unsigned (31 downto 0);   -- initialization mode
        R_6_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_7_out     : out unsigned (31 downto 0);   -- initialization mode
        R_8_out     : out unsigned (31 downto 0);   -- initialization mode / Block Add
        R_9_out     : out unsigned (31 downto 0);   -- initialization mode
        R_10_out    : out unsigned (31 downto 0);   -- initialization mode
        R_11_out    : out unsigned (31 downto 0);   -- initialization mode
        R_12_out    : out unsigned (31 downto 0);   -- initialization mode / Block Add
        R_13_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_14_out    : out unsigned (31 downto 0);   -- initialization mode / Block Add
        R_15_out    : out unsigned (31 downto 0);   -- initialization mode / Step. Op.
        R_16_out    : out unsigned (31 downto 0)    -- initialization mode / NLF

            );
    end component LFSR_Turing;

    component Step_Operation_Turing
        port(
        R0_in    : in unsigned  (31 downto 0);
        R4_in    : in unsigned  (31 downto 0);
        R15_in   : in unsigned  (31 downto 0);

        R16_out  : out unsigned (31 downto 0);

        clk      : in std_logic;
        ce       : in std_logic
            );
    end component Step_Operation_Turing;

    component PHT_5
        port(
        A           : in unsigned (31 downto 0);   --R16
        B           : in unsigned (31 downto 0);   --R13
        C           : in unsigned (31 downto 0);   --R6
        D           : in unsigned (31 downto 0);   --R1
        E           : in unsigned (31 downto 0);   --R0
        E_new       : in unsigned (31 downto 0);   --Init_REG_3

        sel_mux     : in std_logic;
        sel_init_mux: in std_logic;
        mux_in_sel  : in std_logic;

        reg_set     : in std_logic;
        reg_rst     : in std_logic;
        clk         : in std_logic;
        reg_enable  : in std_logic;
        reg5_enable : in std_logic;

        TA          : out unsigned (31 downto 0);
        TB          : out unsigned (31 downto 0);
        TC          : out unsigned (31 downto 0);
        TD          : out unsigned (31 downto 0);
        TE          : out unsigned (31 downto 0)
           );
    end component PHT_5;

    component S_Boxes
        port(
        clk             : in STD_LOGIC;
        ce              : in STD_LOGIC;

        mux_in_sel0     : in std_logic;
        mux_in_sel1     : in std_logic;
        mux_in_sel2     : in std_logic;

        A_IN            : in unsigned (31 downto 0);
        B_IN            : in unsigned (31 downto 0);
        C_IN            : in unsigned (31 downto 0);
        D_IN            : in unsigned (31 downto 0);
        E_IN            : in unsigned (31 downto 0);

        key_i           : in unsigned (31 downto 0);

        mux2x1_sel      : in std_logic;

        regA_ce         : in STD_LOGIC;
        regA_set        : in STD_LOGIC;
        regA_rst        : in STD_LOGIC;

        regB_ce         : in STD_LOGIC;
        regB_set        : in STD_LOGIC;
        regB_rst        : in STD_LOGIC;

        regC_ce         : in STD_LOGIC;
        regC_set        : in STD_LOGIC;
        regC_rst        : in STD_LOGIC;

        regD_ce         : in STD_LOGIC;
        regD_set        : in STD_LOGIC;
        regD_rst        : in STD_LOGIC;

        regE_ce         : in STD_LOGIC;
        regE_set        : in STD_LOGIC;
        regE_rst        : in STD_LOGIC;

        XA              : out unsigned (31 downto 0);
        XB              : out unsigned (31 downto 0);
        XC              : out unsigned (31 downto 0);
        XD              : out unsigned (31 downto 0);
        XE              : out unsigned (31 downto 0);

        mixed_key_o     : out unsigned (31 downto 0)
            );
    end component S_Boxes;

    component Block_Add
        port(
        enable : in std_logic;
        clk    : in std_logic;

        YA : in unsigned (31 downto 0);   -- 5_PHT_A
        YB : in unsigned (31 downto 0);   -- 5_PHT_B
        YC : in unsigned (31 downto 0);   -- 5_PHT_C
        YD : in unsigned (31 downto 0);   -- 5_PHT_D
        YE : in unsigned (31 downto 0);   -- 5_PHT_E

        WA : in unsigned (31 downto 0);   -- R14
        WB : in unsigned (31 downto 0);   -- R12
        WC : in unsigned (31 downto 0);   -- R8
        WD : in unsigned (31 downto 0);   -- R1
        WE : in unsigned (31 downto 0);   -- R0

        ZA : out unsigned (31 downto 0);  -- Vt_out
        ZB : out unsigned (31 downto 0);  -- Vt_out
        ZC : out unsigned (31 downto 0);  -- Vt_out
        ZD : out unsigned (31 downto 0);  -- Vt_out
        ZE : out unsigned (31 downto 0)   -- Vt_out
            );
    end component Block_Add;

    signal empty                : unsigned (31 downto 0) := X"00000000"; --| for MUX  6x1 |-- 

    signal wire_0               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_1               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_2               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_3               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_4               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_5               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_6               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_7               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_8               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_9               : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_10              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_11              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_12              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_13              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_14              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_15              : unsigned (31 downto 0); --| LFSR outputs |--
    signal wire_16              : unsigned (31 downto 0); --| LFSR outputs |--

    signal key_reg_S0           : unsigned (31 downto 0); --| Init Reg out |--
    signal key_reg_S1           : unsigned (31 downto 0); --| Init Reg out |--
    signal key_reg_S2           : unsigned (31 downto 0); --| Init Reg out |--
    signal key_reg_S3           : unsigned (31 downto 0); --| Init Reg out |--
    signal key_reg_S4           : unsigned (31 downto 0); --| Init Reg out |--

    signal mux_A_out            : unsigned (31 downto 0); --| MUXA to MUX1 |--
    signal mux_B_out            : unsigned (31 downto 0); --| MUXB to MUX2 |--
    signal mux_C_out            : unsigned (31 downto 0); --| MUXC to MUX3 |--
    signal mux_D_out            : unsigned (31 downto 0); --| MUXD to MUX4 |--
    signal mux_E_out            : unsigned (31 downto 0); --| MUXD to MUX4 |--

    signal mux1_out             : unsigned (31 downto 0); --|MUX 2x1 to PHT|--
    signal mux2_out             : unsigned (31 downto 0); --|MUX 2x1 to PHT|--
    signal mux3_out             : unsigned (31 downto 0); --|MUX 2x1 to PHT|--
    signal mux4_out             : unsigned (31 downto 0); --|MUX 2x1 to PHT|--
    signal mux5_out             : unsigned (31 downto 0); --|MUX 2x1 to PHT|--

    signal initvector_mux_0_out : unsigned (31 downto 0); --| Invector sgn |--
    signal initvector_mux_1_out : unsigned (31 downto 0); --| Invector sgn |--

    signal init_adder_mux_0_out : unsigned (31 downto 0); --| Init Add MUX |--
    signal init_adder_mux_1_out : unsigned (31 downto 0); --| Init Add MUX |--
    signal init_adder_out       : unsigned (31 downto 0); --| Init Add MUX |--

    signal Init_REG_0_in        : unsigned (31 downto 0); --| Init Reg sgn |--
    signal Init_REG_1_in        : unsigned (31 downto 0); --| Init Reg sgn |--
    signal Init_REG_2_in        : unsigned (31 downto 0); --| Init Reg sgn |--

    signal Init_REG_0_out       : unsigned (31 downto 0); --| Init Reg sgn |--
    signal Init_REG_1_out       : unsigned (31 downto 0); --| Init Reg sgn |--
    signal Init_REG_2_out       : unsigned (31 downto 0); --| Init Reg sgn |--
    signal Init_REG_3_out       : unsigned (31 downto 0); --| Init Reg sgn |--

    signal init_mux_0_out       : unsigned (31 downto 0); --| Init MUX sgn |--
    signal init_mux_1_out       : unsigned (31 downto 0); --| Init MUX sgn |--

    signal step_op_out          : unsigned (31 downto 0); --| Step Op. out |--

    signal key_reg_mux_out      : unsigned (31 downto 0); --| Key Register |--
    signal S_box_mixed_key      : unsigned (31 downto 0); --| Key Register |--
    signal key_reg_out          : unsigned (31 downto 0); --| Key Register |--
    signal mux_SBox_key_out     : unsigned (31 downto 0); --| SBox key_in  |--
    
    signal PHT_out_A            : unsigned (31 downto 0); --| 5PHT outputs |--
    signal PHT_out_B            : unsigned (31 downto 0); --| 5PHT outputs |--
    signal PHT_out_C            : unsigned (31 downto 0); --| 5PHT outputs |--
    signal PHT_out_D            : unsigned (31 downto 0); --| 5PHT outputs |--
    signal PHT_out_E            : unsigned (31 downto 0); --| 5PHT outputs |--

    signal PHT_shift8           : unsigned (31 downto 0); --| PHTout shift |--
    signal PHT_shift16          : unsigned (31 downto 0); --| PHTout shift |--
    signal PHT_shift24          : unsigned (31 downto 0); --| PHTout shift |--

    signal S_Boxes_out_A        : unsigned (31 downto 0); --| SBox outputs |--
    signal S_Boxes_out_B        : unsigned (31 downto 0); --| SBox outputs |--
    signal S_Boxes_out_C        : unsigned (31 downto 0); --| SBox outputs |--
    signal S_Boxes_out_D        : unsigned (31 downto 0); --| SBox outputs |--
    signal S_Boxes_out_E        : unsigned (31 downto 0); --| SBox outputs |--

    signal Vt                   : unsigned (159 downto 0);

begin

    Init_mux_0 : component MUX_2x1
        port map(
                A_in    => step_op_out,
                B_in    => init_mux_1_out,
                sel     => init_mux_0_sel,
                C_out   => init_mux_0_out
                 );

    Init_mux_1 : component MUX_2x1
        port map(
                A_in    => initvector_mux_0_out,
                B_in    => initvector_mux_1_out,
                sel     => init_mux_1_sel,
                C_out   => init_mux_1_out
                 );

    Init_vector_mux_0 : component MUX_4x1
        port map(
                A_in    => IV_OrKey_DefVal,
                B_in    => S_box_mixed_key,
                C_in    => initvector_mux_1_out,
                D_in    => key_reg_out,
                E_out   => initvector_mux_0_out,
                sel_0   => initvector_mux_0_sel0,
                sel_1   => initvector_mux_0_sel1
                );

    Init_vector_mux_1 : component MUX_6x1
        port map(
                A_in    => PHT_out_A,
                B_in    => PHT_out_B,
                C_in    => PHT_out_C,
                D_in    => PHT_out_D,
                E_in    => PHT_out_E,
                F_in    => Init_REG_3_out,
                G_out   => initvector_mux_1_out,
                sel_0   => initvector_mux_1_sel0,
                sel_1   => initvector_mux_1_sel1,
                sel_2   => initvector_mux_1_sel2
                );

    LFSR1 : component LFSR_Turing
        port map(
                clk         => clk,
                set         => LFSR_set,
                rst         => LFSR_rst,
                ce          => LFSR_ce,
                R_16_in     => init_mux_0_out,
                R_0_out     => wire_0,
                R_1_out     => wire_1,
                R_2_out     => wire_2,
                R_3_out     => wire_3,
                R_4_out     => wire_4,
                R_5_out     => wire_5,
                R_6_out     => wire_6,
                R_7_out     => wire_7,
                R_8_out     => wire_8,
                R_9_out     => wire_9,
                R_10_out    => wire_10,
                R_11_out    => wire_11,
                R_12_out    => wire_12,
                R_13_out    => wire_13,
                R_14_out    => wire_14,
                R_15_out    => wire_15,
                R_16_out    => wire_16
                );

    Step_Op : component Step_Operation_Turing
        port map(
        R0_in           => wire_0,
        R4_in           => wire_4,
        R15_in          => wire_15,
        R16_out         => step_op_out,
        clk             => clk,
        ce              => Step_op_ce
                );

    MUX_A : component MUX_6x1
        port map (
                A_in    => wire_16,
                B_in    => wire_1,
                C_in    => wire_6,
                D_in    => wire_11,
                E_in    => wire_0,
                F_in    => key_reg_S0,
                G_out   => mux_A_out,
                sel_0   => mux_init_sel0,
                sel_1   => mux_init_sel1,
                sel_2   => mux_init_sel2
                );

    MUX_B : component MUX_6x1
        port map (
                A_in    => wire_13,
                B_in    => wire_2,
                C_in    => wire_7,
                D_in    => wire_12,
                E_in    => wire_1,
                F_in    => key_reg_S1,
                G_out   => mux_B_out,
                sel_0   => mux_init_sel0,
                sel_1   => mux_init_sel1,
                sel_2   => mux_init_sel2
                );

    MUX_C : component MUX_6x1
        port map (
                A_in    => wire_6,
                B_in    => wire_3,
                C_in    => wire_8,
                D_in    => wire_13,
                E_in    => wire_2,
                F_in    => key_reg_S2,
                G_out   => mux_C_out,
                sel_0   => mux_init_sel0,
                sel_1   => mux_init_sel1,
                sel_2   => mux_init_sel2
                );

    MUX_D : component MUX_6x1
        port map (
                A_in    => wire_1,
                B_in    => wire_4,
                C_in    => wire_9,
                D_in    => wire_14,
                E_in    => wire_3,
                F_in    => key_reg_S3,
                G_out   => mux_D_out,
                sel_0   => mux_init_sel0,
                sel_1   => mux_init_sel1,
                sel_2   => mux_init_sel2
                );    

    MUX_E : component MUX_6x1
        port map (
                A_in    => wire_0,
                B_in    => wire_0,
                C_in    => wire_5,
                D_in    => wire_10,
                E_in    => wire_0,
                F_in    => key_reg_S4,
                G_out   => mux_E_out,
                sel_0   => mux_init_sel0,
                sel_1   => mux_init_sel1,
                sel_2   => mux_init_sel2
                );

    Mux_0 : component MUX_2x1
        port map(
                A_in    => mux_A_out,
                B_in    => S_Boxes_out_A,
                sel     => mux_sel_PHT_in,
                C_out   => mux1_out
                 );

    Mux_1 : component MUX_2x1
        port map(
                A_in    => mux_B_out,
                B_in    => S_Boxes_out_B,
                sel     => mux_sel_PHT_in,
                C_out   => mux2_out
                 );

    Mux_2 : component MUX_2x1
        port map(
                A_in    => mux_C_out,
                B_in    => S_Boxes_out_C,
                sel     => mux_sel_PHT_in,
                C_out   => mux3_out
                );

    Mux_3 : component MUX_2x1
        port map(
                A_in    => mux_D_out,
                B_in    => S_Boxes_out_D,
                sel     => mux_sel_PHT_in,
                C_out   => mux4_out
                 );

    Mux_4 : component MUX_2x1
        port map(
                A_in    => mux_E_out,
                B_in    => S_Boxes_out_E,
                sel     => mux_sel_PHT_in,
                C_out   => mux5_out
                );

    PHT5 : component PHT_5
        port map(
                A           => mux1_out,
                B           => mux2_out,
                C           => mux3_out,
                D           => mux4_out,
                E           => mux5_out,
                E_new       => Init_REG_3_out,
                sel_init_mux=> mux_init_pht_sel,
                sel_mux     => mux_sel_pht,
                mux_in_sel  => mux_init_pht_val_sel,
                reg_set     => '0',
                reg_rst     => '0',
                clk         => clk,
                reg_enable  => reg_enable_pht,
                reg5_enable => reg5_enable_pht,
                TA          => PHT_out_A,
                TB          => PHT_out_B,
                TC          => PHT_out_C,
                TD          => PHT_out_D,
                TE          => PHT_out_E
                );

    PHT_shift8  (31 downto  8)  <= PHT_out_B (23 downto  0);
    PHT_shift8  ( 7 downto  0)  <= PHT_out_B (31 downto 24);
    PHT_shift16 (31 downto 16)  <= PHT_out_C (15 downto  0);
    PHT_shift16 (15 downto  0)  <= PHT_out_C (31 downto 16);
    PHT_shift24 (31 downto 24)  <= PHT_out_D ( 7 downto  0);
    PHT_shift24 (23 downto  0)  <= PHT_out_D (31 downto  8);

    Key_Register_LFSR_S : component Parallel_Register_160_bit
        port map(
                clk         => clk,
                set         => '0',
                rst         => '0',
                ce          => key_reg_ce,
                wire_0      => key_reg_S0,
                wire_1      => key_reg_S1,
                wire_2      => key_reg_S2,
                wire_3      => key_reg_S3,
                wire_4      => key_reg_S4,
                par_4_in    => initvector_mux_0_out,
                par_0_out   => key_reg_out
                );

    Mux_SBox_key : component MUX_6x1
        port map (
                A_in    => key_reg_S0,
                B_in    => key_reg_S1,
                C_in    => key_reg_S2,
                D_in    => key_reg_S3,
                E_in    => key_reg_S4,
                F_in    => PHT_out_A,
                G_out   => mux_SBox_key_out,
                sel_0   => mux_sel_SBox_key_0,
                sel_1   => mux_sel_SBox_key_1,
                sel_2   => mux_sel_SBox_key_2
                );

    SBOXES : component S_Boxes
        port map(
        clk             => clk,
        ce              => Sbox_ce,
        mux_in_sel0     => mux_sel_sbox0,
        mux_in_sel1     => mux_sel_sbox1,
        mux_in_sel2     => mux_sel_sbox2,
        A_IN            => PHT_out_A,
        B_IN            => PHT_shift8,
        C_IN            => PHT_shift16,
        D_IN            => PHT_shift24,
        E_IN            => PHT_out_E,
        key_i           => mux_SBox_key_out,
        mux2x1_sel      => mux_sbox_init_sel,
        regA_ce         => sbox_regA_ce,
        regA_set        => '0',
        regA_rst        => '0',
        regB_ce         => sbox_regB_ce,
        regB_set        => '0',
        regB_rst        => '0',
        regC_ce         => sbox_regC_ce,
        regC_set        => '0',
        regC_rst        => '0',
        regD_ce         => sbox_regD_ce,
        regD_set        => '0',
        regD_rst        => '0',
        regE_ce         => sbox_regE_ce,
        regE_set        => '0',
        regE_rst        => '0',
        XA              => S_Boxes_out_A,
        XB              => S_Boxes_out_B,
        XC              => S_Boxes_out_C,
        XD              => S_Boxes_out_D,
        XE              => S_Boxes_out_E,
        mixed_key_o     => S_box_mixed_key
        );

    Init_REG_0_in <= PHT_out_E;
    Init_REG_1_in <= PHT_out_E;
    Init_REG_2_in <= PHT_out_E;

    Init_REG_0 : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => Init_REG_0_ce,
                par_in  => Init_REG_0_in,
                par_out => Init_REG_0_out
                );

    Init_REG_1 : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => Init_REG_1_ce,
                par_in  => Init_REG_1_in,
                par_out => Init_REG_1_out
                );

    Init_REG_2 : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => Init_REG_2_ce,
                par_in  => Init_REG_2_in,
                par_out => Init_REG_2_out
                );

    Init_REG_3 : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => Init_REG_3_ce,
                par_in  => init_adder_out,
                par_out => Init_REG_3_out
                );

    Init_add_mux_0 : component MUX_4x1
        port map(
                A_in    => Init_REG_0_out,
                B_in    => Init_REG_3_out,
                C_in    => Init_REG_3_out,
                D_in    => Init_REG_3_out,
                E_out   => init_adder_mux_0_out,
                sel_0   => init_adder_mux_sel0,
                sel_1   => init_adder_mux_sel1
                );

    Init_add_mux_1 : component MUX_4x1
        port map(
                A_in    => Init_REG_1_out,
                B_in    => Init_REG_2_out,
                C_in    => wire_15,
                D_in    => wire_16,
                E_out   => init_adder_mux_1_out,
                sel_0   => init_adder_mux_sel0,
                sel_1   => init_adder_mux_sel1
                );

    Init_Adder : component Adder_mod2_32
        port map(
                a_in    => init_adder_mux_0_out,
                b_in    => init_adder_mux_1_out,
                sum     => init_adder_out
                );

    BLCK_ADDER : component Block_Add
        port map (
            enable  => blck_add_en,
            clk     => clk,
            YA      => PHT_out_A,
            YB      => PHT_out_B,
            YC      => PHT_out_C,
            YD      => PHT_out_D,
            YE      => PHT_out_E,
            WA      => wire_14,
            WB      => wire_12,
            WC      => wire_8,
            WD      => wire_1,
            WE      => wire_0,
            ZA      => Vt (159 downto 128),
            ZB      => Vt (127 downto  96),
            ZC      => Vt ( 95 downto  64),
            ZD      => Vt ( 63 downto  32),
            ZE      => Vt ( 31 downto   0)
            );

    XorA : component XOR_32
        port map(
            a_in    => Vt           (31 downto   0),
            b_in    => text_message (31 downto   0),
            c_out   => ciphertext   (31 downto   0)
                );

    XorB : component XOR_32
        port map(
            a_in    => Vt           (63 downto  32),
            b_in    => text_message (63 downto  32),
            c_out   => ciphertext   (63 downto  32)
                );

    XorC : component XOR_32
        port map(
            a_in    => Vt           (95 downto  64),
            b_in    => text_message (95 downto  64),
            c_out   => ciphertext   (95 downto  64)
                );

    XorD : component XOR_32
        port map(
            a_in    => Vt           (127 downto  96),
            b_in    => text_message (127 downto  96),
            c_out   => ciphertext   (127 downto  96)
                );

    XorE : component XOR_32
        port map(
            a_in    => Vt           (159 downto 128),
            b_in    => text_message (159 downto 128),
            c_out   => ciphertext   (159 downto 128)
                );

end Behavioral;