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

        init                    : in unsigned (31 downto 0);
        plaintext               : in unsigned (31 downto 0);

        ciphertext          : out unsigned (31 downto 0)

         );
end SNOW_top;

architecture Behavioral of SNOW_top is

    component LFSR_SNOW
        port(
        clk                     : in STD_LOGIC;
        set                     : in STD_LOGIC;
        rst                     : in STD_LOGIC;
        ce                      : in STD_LOGIC;

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

        R_15_in                 : in unsigned (31 downto 0);    -- Step. Op.

        R_0_out                 : out unsigned (31 downto 0);  -- Step. Op
        R_2_out                 : out unsigned (31 downto 0);  -- Step. Op
        R_11_out                : out unsigned (31 downto 0);  -- Step. Op
        R_5_out                 : out unsigned (31 downto 0);  -- FSM
        R_15_out                : out unsigned (31 downto 0)   -- FSM
            );
    end component LFSR_SNOW;
    
    component FSM
        port(
        clk             : in std_logic;
        set             : in std_logic;
        rst             : in std_logic;
        ce              : in std_logic;

        R15_in          : in  unsigned (31 downto 0);
        R5_in           : in  unsigned (31 downto 0);
        FSM_out         : out unsigned (31 downto 0)
            );
    end component FSM;
    
    component Step_Operation_SNOW
        port(
        clk                 : in std_logic;
        ce                  : in std_logic;
        mux_sel             : in std_logic;

        FSM_o               : in unsigned (31 downto 0);
        R0_in               : in unsigned (31 downto 0);
        R2_in               : in unsigned (31 downto 0);
        R11_in              : in unsigned (31 downto 0);
        R15_out             : out unsigned (31 downto 0)
            );
    end component Step_Operation_SNOW;

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

    LFSR1: component LFSR_SNOW
        port map(
            clk                     => clk,
            set                     => LFSR_set,
            rst                     => LFSR_rst,
            ce                      => LFSR_ce,

            R_15_in                 => wire15_in,
            R_0_out                 => wire_0,
            R_2_out                 => wire_2,
            R_11_out                => wire_11,
            R_5_out                 => wire_5,
            R_15_out                => wire_15
            );

     Steppin_Op : component Step_Operation_SNOW
        port map(
            clk                     => clk,
            mux_sel                 => St_Op_mux_sel,
            ce                      => St_Op_ce,
            R0_in                   => wire_0,
            R2_in                   => wire_2,
            R11_in                  => wire_11,
            FSM_o                   => wire_FSM,
            R15_out                 => wire_step_op  --|--> LFSR
            );

    F_S_M : component FSM
        port map(
            clk             => clk,
            set             => FSM_set,
            rst             => FSM_rst,
            ce              => FSM_ce,
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

end Behavioral;