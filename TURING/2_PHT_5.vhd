library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity PHT_5 is
    Port (
        A           : in unsigned (31 downto 0);   --R16
        B           : in unsigned (31 downto 0);   --R13
        C           : in unsigned (31 downto 0);   --R6
        D           : in unsigned (31 downto 0);   --R1
        E           : in unsigned (31 downto 0);   --R0
        E_new       : in unsigned (31 downto 0);   --Init_REG_3

        --|--Mux control signals--|--
        sel_init_mux: in std_logic;
        sel_mux     : in std_logic;
        mux_in_sel  : in std_logic;

          --|--Register control signals--|--

        reg_set     : in std_logic;
        reg_rst     : in std_logic;
        clk         : in std_logic;
        reg_enable  : in std_logic;
        reg5_enable : in std_logic;

        --|--5-PHT outputs--|--

        test_muxa   : out unsigned (31 downto 0);
        test_muxb   : out unsigned (31 downto 0);
        test_muxc1  : out unsigned (31 downto 0);
        test_muxc2  : out unsigned (31 downto 0);
        test_muxd1  : out unsigned (31 downto 0);
        test_muxd2  : out unsigned (31 downto 0);
        test_add1   : out unsigned (31 downto 0);
        test_add2   : out unsigned (31 downto 0);
        test_add3   : out unsigned (31 downto 0);
        test_add4   : out unsigned (31 downto 0);

        TA          : out unsigned (31 downto 0);
        TB          : out unsigned (31 downto 0);
        TC          : out unsigned (31 downto 0);
        TD          : out unsigned (31 downto 0);
        TE          : out unsigned (31 downto 0)
           );
end PHT_5;

architecture Behavioral of PHT_5 is

    component Adder_mod2_32
        port(
            a_in : in unsigned  (31 downto 0);
            b_in : in unsigned  (31 downto 0);
            sum  : out unsigned (31 downto 0)
            );
    end component Adder_mod2_32;

    component MUX_2x1
        port(
            A_in    : in unsigned  (31 downto 0);
            B_in    : in unsigned  (31 downto 0);
            sel     : in std_logic;
            C_out   : out unsigned (31 downto 0)
            );
    end component MUX_2x1;

    component Parallel_Register
         port (
            clk        : in STD_LOGIC;
            set        : in STD_LOGIC;
            rst        : in STD_LOGIC;
            ce         : in STD_LOGIC;
            par_in     : in unsigned  (31 downto 0);
            par_out    : out unsigned (31 downto 0)
             );
         end component Parallel_Register;

    signal muxa_out     : unsigned (31 downto 0);
    signal muxain_out   : unsigned (31 downto 0);
    signal muxb1_out    : unsigned (31 downto 0);
    signal muxb2_out    : unsigned (31 downto 0);
    signal muxc1_out    : unsigned (31 downto 0);
    signal muxc2_out    : unsigned (31 downto 0);
    signal muxd1_out    : unsigned (31 downto 0);
    signal muxd2_out    : unsigned (31 downto 0);

    signal Ad1_out      : unsigned (31 downto 0);
    signal Ad2_out      : unsigned (31 downto 0);
    signal Ad3_out      : unsigned (31 downto 0);
    signal Ad4_out      : unsigned (31 downto 0);

    signal R5_out       : unsigned (31 downto 0);

    signal mux_init_r_o : unsigned (31 downto 0);

    signal AB           : unsigned (31 downto 0);
    signal CD           : unsigned (31 downto 0);
    signal ABCD         : unsigned (31 downto 0);

begin

    --|-----MUXES 2x1-----|--
    --|-------------------|--

    Mux_A : component MUX_2x1
        port map(
                A_in    => B,
                B_in    => mux_init_r_o,
                sel     => sel_mux,
                C_out   => muxa_out
                );

    MUXAin : component MUX_2x1
        port map(
            A_in    => muxa_out,
            B_in    => C,
            sel     => mux_in_sel,
            C_out   => muxain_out
                );

    Mux_B : component MUX_2x1
        port map(
                A_in    => D,
                B_in    => mux_init_r_o,
                sel     => sel_mux,
                C_out   => muxb2_out
                );

    Mux_C1 : component MUX_2x1
        port map(
                A_in    => Ad1_out,
                B_in    => B,
                sel     => sel_mux,
                C_out   => muxc1_out
                );

    Mux_C2 : component MUX_2x1
        port map(
                A_in    => Ad2_out,
                B_in    => mux_init_r_o,
                sel     => sel_mux,
                C_out   => muxc2_out
                );

    Mux_D1 : component MUX_2x1
        port map(
                A_in    => E,
                B_in    => D,
                sel     => sel_mux,
                C_out   => muxd1_out
                );

    Mux_D2 : component MUX_2x1
        port map(
                A_in    => Ad3_out,
                B_in    => mux_init_r_o,
                sel     => sel_mux,
                C_out   => muxd2_out
                );

    Mux_Init_REG : component MUX_2x1
        port map(
                A_in    => R5_out,
                B_in    => E_new,
                sel     => sel_init_mux,
                C_out   => mux_init_r_o
                );

    --|-----Adder 2**32-----|--
    --|---------------------|--

    Adder1 : component Adder_mod2_32
        port map(
                a_in    => A,
                b_in    => muxain_out,
                sum     => Ad1_out
                );

    Adder2 : component Adder_mod2_32
        port map(
                a_in    => C,
                b_in    => muxb2_out,
                sum     => Ad2_out
                );

    Adder3 : component Adder_mod2_32
        port map(
                a_in    => muxc1_out,
                b_in    => muxc2_out,
                sum     => Ad3_out
                );

    Adder4 : component Adder_mod2_32
        port map(
                a_in    => muxd1_out,
                b_in    => muxd2_out,
                sum     => Ad4_out
                );

    REG1 : component Parallel_Register
        port map(
                clk     => clk,
                set     => reg_set,
                rst     => reg_rst,
                ce      => reg_enable,
                par_in  => Ad1_out,
                par_out => TA
                );

    REG2 : component Parallel_Register
        port map(
                clk     => clk,
                set     => reg_set,
                rst     => reg_rst,
                ce      => reg_enable,
                par_in  => Ad3_out,
                par_out => TB
                );

    REG3 : component Parallel_Register
        port map(
                clk     => clk,
                set     => reg_set,
                rst     => reg_rst,
                ce      => reg_enable,
                par_in  => Ad2_out,
                par_out => TC
                );

    REG4 : component Parallel_Register
        port map(
                clk     => clk,
                set     => reg_set,
                rst     => reg_rst,
                ce      => reg_enable,
                par_in  => Ad4_out,
                par_out => TD
                );

    REG5 : component Parallel_Register
        port map(
                clk     => clk,
                set     => reg_set,
                rst     => reg_rst,
                ce      => reg5_enable,
                par_in  => Ad4_out,
                par_out => R5_out
                );

    TE <= R5_out;

    test_muxa   <= muxain_out;
    test_muxb   <= muxb2_out;
    test_muxc1  <= muxc1_out;
    test_muxc2  <= muxc2_out;
    test_muxd1  <= muxd1_out;
    test_muxd2  <= muxd2_out;
    test_add1   <= Ad1_out;
    test_add2   <= Ad2_out;
    test_add3   <= Ad3_out;
    test_add4   <= Ad4_out;

end Behavioral;
