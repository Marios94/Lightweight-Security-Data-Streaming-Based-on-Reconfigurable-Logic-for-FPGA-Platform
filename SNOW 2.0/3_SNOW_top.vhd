    --|--------Linear Feedback shift Register------|--
    --|------- Finite State Machine ---------------|--
    --|------- Step Operation ---------------------|--
    --|------- 2-to-1 LFSR input MUX --------------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;



entity SNOW_top is
    Port (

        --|------ Control Signals ------|--
        --|-----------------------------|--

        clk                     : in std_logic;
        LFSR_set                : in std_logic;    --| LFSR |--
        LFSR_rst                : in std_logic;    --| LFSR |--
        LFSR_input_mux_sel      : in std_logic;    --| LFSR |--
        LFSR_ce                 : in std_logic;    --| LFSR |--
        FSM_set                 : in std_logic;    --| FSM  |--
        FSM_rst                 : in std_logic;    --| FSM  |--
        FSM_ce                  : in std_logic;    --| FSM  |--
        St_Op_mux_sel           : in std_logic;    --| Step |--
        St_Op_ce                : in std_logic;    --| Step |--

        --|------ Input signals ------|--
        --|---------------------------|--

        init                    : in unsigned (31 downto 0);
        plaintext               : in unsigned (31 downto 0);
        
        --|------ Test Out Sgnls ------|--
        --|----------------------------|--

          --test_0_LFSR         : out unsigned (31 downto 0);
          --test_1_LFSR         : out unsigned (31 downto 0);
          --test_2_LFSR         : out unsigned (31 downto 0);
          --test_3_LFSR         : out unsigned (31 downto 0);
          --test_4_LFSR         : out unsigned (31 downto 0);
          --test_5_LFSR         : out unsigned (31 downto 0);
          --test_6_LFSR         : out unsigned (31 downto 0);
          --test_7_LFSR         : out unsigned (31 downto 0);
          --test_8_LFSR         : out unsigned (31 downto 0);
          --test_9_LFSR         : out unsigned (31 downto 0);
          --test_10_LFSR        : out unsigned (31 downto 0);
          --test_11_LFSR        : out unsigned (31 downto 0);
          --test_12_LFSR        : out unsigned (31 downto 0);
          --test_13_LFSR        : out unsigned (31 downto 0);
          --test_14_LFSR        : out unsigned (31 downto 0);
          --test_15_LFSR        : out unsigned (31 downto 0);

          --test_R1_FSM         : out unsigned (31 downto 0);
          --test_R2_FSM         : out unsigned (31 downto 0);
          --test_add1out_FSM    : out unsigned (31 downto 0);
          --test_add2out_FSM    : out unsigned (31 downto 0);

        --test_T0               : out unsigned (31 downto 0);
        --test_T1               : out unsigned (31 downto 0);
        --test_T2               : out unsigned (31 downto 0);
        --test_T3               : out unsigned (31 downto 0);

        --test_FSM_out          : out unsigned (31 downto 0);

        --test_Step_mula        : out unsigned (31 downto 0);
        --test_Step_mulainv     : out unsigned (31 downto 0);
        --test_R2_Step_op       : out unsigned (31 downto 0);
        --test_Step_out_Reg     : out unsigned (31 downto 0);
        --test_mux_fsm_Step_op  : out unsigned (31 downto 0);
        --test_Step_op_xor1     : out unsigned (31 downto 0);
        --test_Step_op_xor2     : out unsigned (31 downto 0);
        --test_Step_op_xor3     : out unsigned (31 downto 0);
        --test_Step_out         : out unsigned (31 downto 0);

        --test_wire0_out        : out unsigned (31 downto 0);
        --test_wire2_out        : out unsigned (31 downto 0);
        --test_wire5_out        : out unsigned (31 downto 0);
        --test_wire11_out       : out unsigned (31 downto 0);
        --test_wire15_out       : out unsigned (31 downto 0);
        --test_wire15_in        : out unsigned (31 downto 0);

        --test_keystream        : out unsigned (31 downto 0);

        --|------ Output signals ------|--
        --|----------------------------|--

        ciphertext          : out unsigned (31 downto 0)

         );
end SNOW_top;

architecture Behavioral of SNOW_top is

    component LFSR
        port(
        clk                     : in STD_LOGIC;
        set                     : in STD_LOGIC;
        rst                     : in STD_LOGIC;
        ce                      : in STD_LOGIC;

    --|------ Testing signals out ------|--
    --|---------------------------------|--

        wire0                   : out unsigned (31 downto 0);
        wire1                   : out unsigned (31 downto 0);
        wire2                   : out unsigned (31 downto 0);
        wire3                   : out unsigned (31 downto 0);
        wire4                   : out unsigned (31 downto 0);
        wire5                   : out unsigned (31 downto 0);
        wire6                   : out unsigned (31 downto 0);
        wire7                   : out unsigned (31 downto 0);
        wire8                   : out unsigned (31 downto 0);
        wire9                   : out unsigned (31 downto 0);
        wire10                  : out unsigned (31 downto 0);
        wire11                  : out unsigned (31 downto 0);
        wire12                  : out unsigned (31 downto 0);
        wire13                  : out unsigned (31 downto 0);
        wire14                  : out unsigned (31 downto 0);
        wire15                  : out unsigned (31 downto 0);

    --|-- Inputs from Step. Op. , NLF --|--
    --|---------------------------------|--

        R_15_in                 : in unsigned (31 downto 0);    -- Step. Op.

    --|-- Outputs to Step. Op. , NLF, PFF --|--
    --|-------------------------------------|--

        R_0_out                 : out unsigned (31 downto 0);  -- Step. Op
        R_2_out                 : out unsigned (31 downto 0);  -- Step. Op
        R_11_out                : out unsigned (31 downto 0);  -- Step. Op
        R_5_out                 : out unsigned (31 downto 0);  -- FSM
        R_15_out                : out unsigned (31 downto 0)   -- FSM
            );
    end component LFSR;
    
    component FSM
        port(
        clk             : in std_logic;
        set             : in std_logic;
        rst             : in std_logic;
        ce              : in std_logic;

        --|---------- test pins ----------|--
        --|-------------------------------|--

        test_add1_out   : out unsigned (31 downto 0);
        test_add2_out   : out unsigned (31 downto 0);
        test_r1         : out unsigned (31 downto 0);
        test_r2         : out unsigned (31 downto 0);
        test_sbox_out   : out unsigned (31 downto 0);
        test_S0_out     : out unsigned (31 downto 0);
        test_S1_out     : out unsigned (31 downto 0);
        test_S2_out     : out unsigned (31 downto 0);
        test_S3_out     : out unsigned (31 downto 0);

        --|---------- I/O pins -----------|--
        --|-------------------------------|--

        R15_in          : in  unsigned (31 downto 0);
        R5_in           : in  unsigned (31 downto 0);
        FSM_out         : out unsigned (31 downto 0)
            );
    end component FSM;
    
    component Step_Operation
        port(
        clk                 : in std_logic;
        ce                  : in std_logic;
        mux_sel             : in std_logic;

        --|---------- test pins ----------|--
        --|-------------------------------|--

        test_mula           : out unsigned (31 downto 0);
        test_mulainv        : out unsigned (31 downto 0);
        test_mula_xor       : out unsigned (31 downto 0);
        test_mulainv_xor    : out unsigned (31 downto 0);
        test_Del_Reg        : out unsigned (31 downto 0);
        test_Step_op_out_Reg: out unsigned (31 downto 0);
        test_mux_fsm        : out unsigned (31 downto 0);
        test_xor1           : out unsigned (31 downto 0);
        test_xor2           : out unsigned (31 downto 0);
        test_xor3           : out unsigned (31 downto 0);

        --|---------- I/O pins -----------|--
        --|-------------------------------|--

        FSM_o               : in unsigned (31 downto 0);
        R0_in               : in unsigned (31 downto 0);
        R2_in               : in unsigned (31 downto 0);
        R11_in              : in unsigned (31 downto 0);
        R15_out             : out unsigned (31 downto 0)
            );
    end component Step_Operation;

    component MUX_2x1
        port(
        A_in    : in unsigned (31 downto 0);
        B_in    : in unsigned (31 downto 0);
        sel     : in std_logic;
        C_out   : out unsigned (31 downto 0)
        );
    end component MUX_2x1;

    component XOR_32
        port (
        a_in    : in unsigned (31 downto 0);
        b_in    : in unsigned (31 downto 0);
        c_out   : out unsigned (31 downto 0)
        );
    end component XOR_32;

    signal wire_0       : unsigned (31 downto 0);
    signal wire_2       : unsigned (31 downto 0);
    signal wire_5       : unsigned (31 downto 0);
    signal wire_11      : unsigned (31 downto 0);
    signal wire_15      : unsigned (31 downto 0);
    signal wire_step_op : unsigned (31 downto 0);
    signal wire15_in    : unsigned (31 downto 0);
    signal wire_FSM     : unsigned (31 downto 0);
    signal Running_key  : unsigned (31 downto 0);

begin

    MUX : component MUX_2x1
        port map(
            A_in    => init,                --|-- mux_sel = '0' => c_out = init
            B_in    => wire_step_op,        --|-- mux_sel = '1' => c_out = wire_step_op
            sel     => LFSR_input_mux_sel,
            C_out   => wire15_in
            );

    LFSR1: component LFSR
        port map(
            clk                     => clk,
            set                     => LFSR_set,
            rst                     => LFSR_rst,
            ce                      => LFSR_ce,
            --wire0                   => test_0_LFSR,
            --wire1                   => test_1_LFSR,
            --wire2                   => test_2_LFSR,
            --wire3                   => test_3_LFSR,
            --wire4                   => test_4_LFSR,
            --wire5                   => test_5_LFSR,
            --wire6                   => test_6_LFSR,
            --wire7                   => test_7_LFSR,
            --wire8                   => test_8_LFSR,
            --wire9                   => test_9_LFSR,
            --wire10                  => test_10_LFSR,
            --wire11                  => test_11_LFSR,
            --wire12                  => test_12_LFSR,
            --wire13                  => test_13_LFSR,
            --wire14                  => test_14_LFSR,
            --wire15                  => test_15_LFSR,

            R_15_in                 => wire15_in,
            R_0_out                 => wire_0,
            R_2_out                 => wire_2,
            R_11_out                => wire_11,
            R_5_out                 => wire_5,
            R_15_out                => wire_15
            );

     Steppin_Op : component Step_Operation
        port map(
            clk                     => clk,
            mux_sel                 => St_Op_mux_sel,
            ce                      => St_Op_ce,
            R0_in                   => wire_0,
            R2_in                   => wire_2,
            R11_in                  => wire_11,
            --test_mula               => test_Step_mula,
            --test_mulainv            => test_Step_mulainv,
            --test_Del_Reg            => test_R2_Step_op,
            --test_Step_op_out_Reg    => test_Step_out_Reg,
            --test_mux_fsm            => test_mux_fsm_Step_op,
            --test_xor1               => test_Step_op_xor1,
            --test_xor2               => test_Step_op_xor2,
            --test_xor3               => test_Step_op_xor3,
            FSM_o                   => wire_FSM,
            R15_out                 => wire_step_op  --|--> LFSR
            );

    F_S_M : component FSM
        port map(
            clk             => clk,
            set             => FSM_set,
            rst             => FSM_rst,
            ce              => FSM_ce,
            --test_r1         => test_R1_FSM,
            --test_r2         => test_R2_FSM,
            --test_add1_out   => test_add1out_FSM,
            --test_add2_out   => test_add2out_FSM,
            --test_S0_out     => test_T0,
            --test_S1_out     => test_T1,
            --test_S2_out     => test_T2,
            --test_S3_out     => test_T3,
            R15_in          => wire_15,
            R5_in           => wire_5,
            FSM_out         => wire_FSM
            );

    XOR1 : component XOR_32
        port map(
            a_in    => wire_0,
            b_in    => wire_FSM,
            c_out   => Running_key
            );

    XOR2 : component XOR_32
        port map(
            a_in    => plaintext,
            b_in    => Running_key,
            c_out   => ciphertext
            );

    --test_FSM_out    <= wire_FSM;
    --test_Step_out   <= wire_step_op;
    --test_keystream  <= Running_key;

    --test_wire0_out  <= wire_0;
    --test_wire2_out  <= wire_2;
    --test_wire5_out  <= wire_5;
    --test_wire11_out <= wire_11;
    --test_wire15_out <= wire_15;
    --test_wire15_in  <= wire15_in;

end Behavioral;
