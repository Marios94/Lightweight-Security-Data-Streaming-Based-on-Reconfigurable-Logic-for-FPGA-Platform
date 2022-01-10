    --|---------NLF Non-Linear Filter------------|--
    --|--------6*32-bit inputs, 1*32-bit output--|--
    --|--------Mod2**32 Adder, F-function, XOR32-|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity NLF is
    Port (
 
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

        Vt          : out unsigned (31 downto 0)
           );
end NLF;

architecture Behavioral of NLF is

    component Adder_mod2_32
        port(
            a_in    : in unsigned  (31 downto 0);
            b_in    : in unsigned  (31 downto 0);
            sum     : out unsigned (31 downto 0)
            );
    end component Adder_mod2_32;

    component F_function
        port(
            f_in        : in unsigned  (31 downto 0);
            f_out       : out unsigned (31 downto 0);
            Sbox_out    : out unsigned (31 downto 0);
            ce          : in STD_LOGIC;
            clk         : in STD_LOGIC
            );
    end component F_function;

    component XOR_32
        port(
            a_in    : in unsigned  (31 downto 0);
            b_in    : in unsigned  (31 downto 0);
            c_out   : out unsigned (31 downto 0)
            );
    end component XOR_32;

    component MUX_4x1
        port(
            A_in    : in unsigned  (31 downto 0);
            B_in    : in unsigned  (31 downto 0);
            C_in    : in unsigned  (31 downto 0);
            D_in    : in unsigned  (31 downto 0);
            E_out   : out unsigned (31 downto 0);
            sel_0   : in STD_LOGIC;
            sel_1   : in STD_LOGIC
            );
    end component MUX_4x1;

    component MUX_2x1
        port(
            A_in  : in  unsigned (31 downto 0);
            B_in  : in  unsigned (31 downto 0);
            sel   : in  std_logic;
            C_out : out unsigned (31 downto 0)
            );
    end component MUX_2x1;

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

    signal mux_d_out            : unsigned (31 downto 0);      -- MUX_C --> Adder_1 portA
    signal mux_e_out            : unsigned (31 downto 0);      -- MUX_D --> Adder_1 portB
    signal mux_h_out            : unsigned (31 downto 0);      -- MUX_H --> Register_MUX
    signal reg_mux_out          : unsigned (31 downto 0);      -- Register_MUX --> MUX_D port C,D
    signal add_out              : unsigned (31 downto 0);      -- Adder_1 --> F_function
    signal xor_out              : unsigned (31 downto 0);      -- XOR --> MUX_C
    signal f_out                : unsigned (31 downto 0);      -- F_function --> MUX_c / Reg_V / Rotate Right 
    signal f_out_rotate_right   : unsigned (31 downto 0);      -- F_rotate --> MUX_C
    signal Sbox_o               : unsigned (31 downto 0);
    signal empty                : unsigned (31 downto 0) := x"00000000";

begin

    MUX_D : component MUX_4x1
        port map(
            A_in     => R16_in, 
            B_in     => reg_mux_out,
            C_in     => reg_mux_out,
            D_in     => reg_mux_out,
            E_out    => mux_d_out,
            sel_0    => mux_sel_0,
            sel_1    => mux_sel_1
                );

     MUX_E : component MUX_4x1
        port map(
            A_in     => R0_in, 
            B_in     => R1_in,
            C_in     => R6_in,
            D_in     => R13_in,
            E_out    => mux_e_out, 
            sel_0    => mux_sel_0,
            sel_1    => mux_sel_1
                );   

    ADDER1 : component Adder_mod2_32
        port map(
            a_in    => mux_d_out,
            b_in    => mux_e_out,
            sum     => add_out 
                );

    F1 : component F_function
        port map(
            f_in        => add_out,
            Sbox_out    => Sbox_o,
            ce          => '1',
            clk         => clk,
            f_out       => f_out
                );

    XOR1 : component XOR_32
        port map(
            a_in    => konst,
            b_in    => add_out,
            c_out   => xor_out
                );

    MUX_H : component MUX_4x1
        port map(
                A_in    => f_out_rotate_right,
                B_in    => xor_out,
                C_in    => f_out,
                D_in    => empty,
                E_out   => mux_h_out,
                sel_0   => muxH_sel_0,
                sel_1   => muxH_sel_1
                    );

    REG_MUX : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => regMUX_ce,
                par_in  => mux_h_out,
                par_out => reg_mux_out
         );

    f_out_rotate_right (23 downto  0)   <=  f_out (31 downto 8);
    f_out_rotate_right (31 downto 24)   <=  f_out ( 7 downto 0);

    REG_V : component Parallel_Register
        port map(
                clk     => clk,
                set     => '0',
                rst     => '0',
                ce      => regV_ce,
                par_in  => add_out,
                par_out => Vt
         );

end Behavioral;