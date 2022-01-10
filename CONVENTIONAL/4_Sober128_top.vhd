library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Sober128_top is
    Port (
        clk              : in STD_LOGIC;
        init_mux_sel     : in STD_LOGIC;

        LFSR_set        : in std_logic;
        LFSR_rst        : in std_logic;
        LFSR_ce         : in std_logic;
        LFSR_reg15_ce   : in std_logic;
        LFSR_reg4_ce    : in std_logic;
        LFSR_mux_15_sel : in std_logic;
        LFSR_mux_4_sel1 : in std_logic;
        LFSR_mux_4_sel0 : in std_logic;
        include_reg_ce  : in std_logic;
        diffuse_reg_ce  : in std_logic;
        Konst_REG_ce    : in std_logic;
        Konst_mux_sel   : in std_logic;

        StepOp_ce       : in std_logic;

        PFF_ce          : in std_logic;
        PFF_mux_sel     : in std_logic;
        Pff_mux_p_sel   : in std_logic;

        NLF_mux_sel_0   : in std_logic;
        NLF_mux_sel_1   : in std_logic;
        NLF_mux_H_sel_0 : in std_logic;
        NLF_mux_H_sel_1 : in std_logic;
        NLF_REG_V_ce    : in std_logic;
        NLF_REG_H_ce    : in std_logic;

        IV              : in unsigned (31 downto 0);        --|<-- SYSTEM IN
        plaintext       : in unsigned (31 downto 0);        --|<-- SYSTEM IN
        initkonst       : in unsigned (31 downto 0);        --|<-- SYSTEM IN
        x_in            : in unsigned (31 downto 0);

        Vt              : out unsigned (31 downto 0);        --|--> SYSTEM OUT
        ciphertext      : out unsigned (31 downto 0)
        );
end Sober128_top;

architecture Behavioral of Sober128_top is

    component XOR_32
        port(
            a_in  : in unsigned     (31 downto 0);
            b_in  : in unsigned     (31 downto 0);
            c_out : out unsigned    (31 downto 0)        
            );
    end component XOR_32; 
 
    component MUX_2x1
        port(
            A_in    : in unsigned (31 downto 0);    --|<-- SYSTEM IN
            B_in    : in unsigned (31 downto 0);    --|<-- Step. Op.
            sel     : in std_logic;
            C_out   : out unsigned (31 downto 0)     --|--> LFSR
            );
    end component MUX_2x1;

    component Adder_mod2_32
        port(
            a_in    : in unsigned  (31 downto 0);
            b_in    : in unsigned  (31 downto 0);
            sum     : out unsigned (31 downto 0)
            );
    end component Adder_mod2_32;

    component Parallel_Register 
        port (
            clk     : in STD_LOGIC;
            set     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            ce      : in STD_LOGIC;
            par_in  : in unsigned     (31 downto 0);
            par_out : out unsigned    (31 downto 0));
        end component Parallel_Register;

    component LFSR_Sober
        port(
        --|-------- Control signals --------|--
        clk          : in STD_LOGIC;
        set          : in STD_LOGIC;
        rst          : in STD_LOGIC;
        ce           : in STD_LOGIC;
        reg15_ce     : in STD_LOGIC;
        reg4_ce      : in STD_LOGIC;
        mux_15_sel   : in STD_LOGIC; --  0 -> Step /  1 -> Include
        mux_4_sel0   : in STD_LOGIC; -- 00 -> Step / 01 -> Diffuse / 10 -> MAC Accumulation
        mux_4_sel1   : in STD_LOGIC;

        R_16_in  : in unsigned (31 downto 0);  -- Step. Op.
        R_15_in  : in unsigned (31 downto 0);  -- Sober Top
        R_4_in   : in unsigned (31 downto 0);  -- Diffuse
        pff_in   : in unsigned (31 downto 0);  -- PFF

        R_0_out  : out unsigned (31 downto 0);   -- Step. Op & NLF
        R_1_out  : out unsigned (31 downto 0);   -- NLF
        R_4_out  : out unsigned (31 downto 0);   -- Step. Op & PFF
        R_6_out  : out unsigned (31 downto 0);   -- NLF
        R_13_out : out unsigned (31 downto 0);   -- NLF
        R_15_out : out unsigned (31 downto 0);   -- Step. Op.
        R_16_out : out unsigned (31 downto 0)    -- NLF
            );
    end component LFSR_Sober;

    component Step_Operation_Sober
        port(

        R0_in           : in unsigned (31 downto 0);
        R4_in           : in unsigned (31 downto 0);
        R15_in          : in unsigned (31 downto 0);

        R16_out         : out unsigned (31 downto 0);

        clk         : in std_logic;
        ce          : in std_logic
            );
    end component Step_Operation_Sober;

    component NLF
        port(
        R0_in        : in unsigned (31 downto 0);
        R1_in        : in unsigned (31 downto 0);
        R6_in        : in unsigned (31 downto 0);
        R13_in       : in unsigned (31 downto 0);
        R16_in       : in unsigned (31 downto 0);
        konst        : in unsigned (31 downto 0);

        clk          : in STD_LOGIC;
        mux_sel_0    : in STD_LOGIC;
        mux_sel_1    : in STD_LOGIC;
        muxH_sel_0   : in STD_LOGIC;
        muxH_sel_1   : in STD_LOGIC;
        regV_ce      : in STD_LOGIC;
        regMUX_ce    : in STD_LOGIC;

        Vt            : out unsigned (31 downto 0)
            );
        end component NLF;

    signal wire0        : unsigned (31 downto 0);
    signal wire1        : unsigned (31 downto 0);
    signal wire4        : unsigned (31 downto 0);
    signal wire6        : unsigned (31 downto 0);
    signal wire13       : unsigned (31 downto 0);
    signal wire15       : unsigned (31 downto 0);
    signal wire_R4_in   : unsigned (31 downto 0);
    signal wire_R15_in  : unsigned (31 downto 0);
    signal wire16       : unsigned (31 downto 0);
    signal init_mux_out : unsigned (31 downto 0);

    signal xor_out      : unsigned (31 downto 0);
    signal add_3_out    : unsigned (31 downto 0);
    signal wire_step_op : unsigned (31 downto 0);
    signal wire_pff     : unsigned (31 downto 0);
    signal Vt_out       : unsigned (31 downto 0);
    signal mux_konst_out: unsigned (31 downto 0);
    signal wire_konst   : unsigned (31 downto 0);
    signal all_zeros    : std_logic;

begin

    MUX : component MUX_2x1
        port map(
            A_in  => IV,            --|-- mux_sel = '0' => c_out = init
            B_in  => wire_step_op,  --|-- mux_sel = '1' => c_out = wire_step_op
            sel   => init_mux_sel,
            C_out => init_mux_out
                );

    Adder_3 : component Adder_mod2_32
        port map(
            a_in    => wire15,
            b_in    => x_in,
            sum     => add_3_out
                );

    Include_REG : component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => include_reg_ce,
            par_in  => add_3_out,
            par_out => wire_R15_in
                );

    Diffuse_REG : component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => diffuse_reg_ce,
            par_in  => xor_out,
            par_out => wire_R4_in
                );

    LFSR_1 : component LFSR_Sober
        port map(
        clk         => clk,
        set         => LFSR_set,
        rst         => LFSR_rst,
        ce          => LFSR_ce,
        reg15_ce    => LFSR_reg15_ce,
        reg4_ce     => LFSR_reg4_ce,
        mux_15_sel  => LFSR_mux_15_sel,
        mux_4_sel1  => LFSR_mux_4_sel1,
        mux_4_sel0  => LFSR_mux_4_sel0,
        R_16_in     => init_mux_out,
        R_15_in     => wire_R15_in,
        R_4_in      => wire_R4_in,
        pff_in      => wire_pff,
        R_0_out     => wire0,
        R_1_out     => wire1,
        R_4_out     => wire4,
        R_6_out     => wire6,
        R_13_out    => wire13,
        R_15_out    => wire15,
        R_16_out    => wire16
                );

     Steppin_Op : component Step_Operation_Sober
        port map(
        R0_in               => wire0, 
        R4_in               => wire4,
        R15_in              => wire15,
        R16_out             => wire_step_op,
        clk                 => clk,
        ce                  => StepOp_ce
        );

    MUX_konst : component MUX_2x1
        port map(
            A_in  => initkonst,   --|-- mux_sel = '1' => c_out = initkonst
            B_in  => Vt_out,      --|-- mux_sel = '0' => c_out = konst
            sel   => Konst_mux_sel,
            C_out => mux_konst_out
                );

    Konst_REG : component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => Konst_REG_ce,
            par_in  => mux_konst_out,
            par_out => wire_konst
                );

    N_L_F : component NLF
        port map(
            R0_in           => wire0,
            R1_in           => wire1,
            R6_in           => wire6,
            R13_in          => wire13,
            R16_in          => wire16,
            konst           => wire_konst,
            clk             => clk,
            mux_sel_0       => NLF_mux_sel_0,
            mux_sel_1       => NLF_mux_sel_1,
            muxH_sel_0      => NLF_mux_H_sel_0,
            muxH_sel_1      => NLF_mux_H_sel_1,
            regV_ce         => NLF_REG_V_ce,
            regMUX_ce       => NLF_REG_H_ce,
            Vt              => Vt_out
            );          

    XOR_4 : component XOR_32
        port map(
            a_in    => Vt_out,
            b_in    => wire4,
            c_out   => xor_out
                );

    XOR_ciphertext : component XOR_32
        port map(
            a_in    => Vt_out,
            b_in    => plaintext,
            c_out   => ciphertext
                );

    Vt                  <= Vt_out;

end Behavioral;