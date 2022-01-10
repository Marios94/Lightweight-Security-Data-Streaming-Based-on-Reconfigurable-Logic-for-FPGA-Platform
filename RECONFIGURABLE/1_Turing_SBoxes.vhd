--|------- SBoxes LUT------------------|--
--|--------32-bit address, 32-bit data-|--
--|--------4 SBox ROM------------------|--
--|--------4 QBox ROM------------------|--
--|--------w/ chip enable, sync--------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Turing_SBoxes is
    Port (
		clk				: in 	STD_LOGIC;
		ce				: in 	STD_LOGIC;

		--|--- Turing Word In ---|--

		word_in			: in 	unsigned (31 downto 0);
		key_i			: in 	unsigned (31 downto 0);

		--|--Original/Mixed key-|--

		mux2x1_sel		: in 	std_logic;

		--|XA-XE output/Mixed Key|--

		word_out		: out 	unsigned  (31 downto 0);
		mixed_key_o		: out 	unsigned  (31 downto 0)

		);
end Turing_SBoxes;

architecture Behavioral of Turing_SBoxes is

	component MUX_2x1
		port(
			A_in    : in 	unsigned (31 downto 0);
			B_in    : in 	unsigned (31 downto 0);
			sel     : in 	std_logic;
			C_out   : out 	unsigned (31 downto 0)
			);
	end component MUX_2x1;

	component Turing_SBox
		port(
			ce       : in 	STD_LOGIC;
			clk      : in 	STD_LOGIC;
			address  : in 	unsigned (7 downto 0);
			data_out : out 	unsigned (7 downto 0)
			);
	end component Turing_SBox;

	component Turing_QBox
		port(
			ce			: in 	STD_LOGIC;
			clk			: in 	STD_LOGIC;
			address		: in 	unsigned ( 7 downto 0);
			data_out	: out 	unsigned (31 downto 0)
			);
	end component Turing_QBox; 

component XOR_32 is
    Port ( 
           a_in     : in unsigned (31 downto 0);
           b_in     : in unsigned (31 downto 0);
           c_out    : out unsigned (31 downto 0)
        );
end component XOR_32;

component XOR_8 is
    Port ( 
           a_in     : in unsigned  (7 downto 0);
           b_in     : in unsigned  (7 downto 0);
           c_out    : out unsigned (7 downto 0)
        );
end component XOR_8;

    --|---- word_in pins ----|--
signal b_word_in_0      : unsigned ( 7 downto 0); --> xor_8_0
signal b_word_in_1      : unsigned ( 7 downto 0); --> xor_8_1
signal b_word_in_2      : unsigned ( 7 downto 0); --> xor_8_2
signal b_word_in_3      : unsigned ( 7 downto 0); --> xor_8_3

    --|-- S_boxes in pins ---|--
signal k_0              : unsigned ( 7 downto 0); --> Sbox_0
signal k_1              : unsigned ( 7 downto 0); --> Sbox_1
signal k_2              : unsigned ( 7 downto 0); --> Sbox_2
signal k_3              : unsigned ( 7 downto 0); --> Sbox_3

    --|-- S_boxes out pins --|--
signal Sbox0_o          : unsigned ( 7 downto 0); --> xor_8_0, mux_0, Qbox_out merge
signal Sbox1_o          : unsigned ( 7 downto 0); --> xor_8_1, mux_1, Qbox_out merge
signal Sbox2_o          : unsigned ( 7 downto 0); --> xor_8_2, mux_2, Qbox_out merge
signal Sbox3_o          : unsigned ( 7 downto 0); --> xor_8_3, mux_3, Qbox_out merge

    --|--- xor_8 out pins ---|--
signal xor_8_out_0      : unsigned ( 7 downto 0); --> mux_0, Qbox_out merge
signal xor_8_out_1      : unsigned ( 7 downto 0); --> mux_1, Qbox_out merge
signal xor_8_out_2      : unsigned ( 7 downto 0); --> mux_2, Qbox_out merge
signal xor_8_out_3      : unsigned ( 7 downto 0); --> mux_3, Qbox_out merge

    --|-- mux_2x1 out pins --|--
signal Qbox0_i          : unsigned (31 downto 0); --> Qbox_0
signal Qbox1_i          : unsigned (31 downto 0); --> Qbox_1
signal Qbox2_i          : unsigned (31 downto 0); --> Qbox_2
signal Qbox3_i          : unsigned (31 downto 0); --> Qbox_3

    --|--- Qbox out pins ---|--
signal Qbox0_o          : unsigned (31 downto 0);
signal Qbox1_o          : unsigned (31 downto 0);
signal Qbox2_o          : unsigned (31 downto 0);
signal Qbox3_o          : unsigned (31 downto 0);


    --|Qbox shifted out pins|--
signal QBox1_shift8     : unsigned (31 downto 0); --> Qbox_out merge, xor1_32_in
signal QBox2_shift16    : unsigned (31 downto 0); --> Qbox_out merge, xor2_32_in
signal QBox3_shift24    : unsigned (31 downto 0); --> Qbox_out merge, xor3_32_in

    --|Qbox/word_in merged out pins|--
signal w0_out           : unsigned (31 downto 0);
signal w1_out           : unsigned (31 downto 0);
signal w2_out           : unsigned (31 downto 0);
signal w3_out           : unsigned (31 downto 0);

    --|-- xor_32 out pins --|--
signal xor_outA         : unsigned (31 downto 0);
signal xor_outB         : unsigned (31 downto 0);

    --|-- xor_32 out pins --|--
signal xor0_32_out      : unsigned (31 downto 0);
signal xor1_32_out      : unsigned (31 downto 0);
signal xor2_32_out      : unsigned (31 downto 0);
signal xor3_32_out      : unsigned (31 downto 0);

    --|xor_32 mixed key out pins|--
signal w0_xor_32        : unsigned (31 downto 0);
signal w1_xor_32        : unsigned (31 downto 0);
signal w2_xor_32        : unsigned (31 downto 0);
signal w3_xor_32        : unsigned (31 downto 0);

begin

    --|--------------------------------|--
    --|------- Mixed_key input --------|--
    --|--------------------------------|--

k_0             <= key_i   ( 7 downto  0);
k_1             <= key_i   (15 downto  8);
k_2             <= key_i   (23 downto 16);
k_3             <= key_i   (31 downto 24);

    --|*******************************|--
    --| Mixed Key In Operation BEGIN  |--
    --|*******************************|--

b_word_in_0     <= word_in ( 7 downto  0);
b_word_in_1     <= word_in (15 downto  8);
b_word_in_2     <= word_in (23 downto 16);
b_word_in_3     <= word_in (31 downto 24);

    --|------S_Boxes------|--
    --|-------------------|--
SBox0 : component Turing_SBox
    port map (
        address     => k_0,
        ce          => ce,
        clk         => clk,
        data_out    => Sbox0_o
    );

SBox1 : component Turing_SBox
    port map (
        address     => k_1,
        ce          => ce,
        clk         => clk,
        data_out    => Sbox1_o
    );

SBox2 : component Turing_SBox
    port map (
        address     => k_2,
        ce          => ce,
        clk         => clk,
        data_out    => Sbox2_o
    );

SBox3 : component Turing_SBox
    port map (
        address     => k_3,
        ce          => ce,
        clk         => clk,
        data_out    => Sbox3_o
    );

    --|--8-bit xor gates--|--
    --|-------------------|--
XOR8_0 : component XOR_8
    port map (
        a_in    => b_word_in_0,
        b_in    => Sbox0_o,
        c_out   => xor_8_out_0
    );

XOR8_1 : component XOR_8
    port map (
        a_in    => b_word_in_1,
        b_in    => Sbox1_o,
        c_out   => xor_8_out_1
    );

XOR8_2 : component XOR_8
    port map (
        a_in    => b_word_in_2,
        b_in    => Sbox2_o,
        c_out   => xor_8_out_2
    );

XOR8_3 : component XOR_8
    port map (
        a_in    => b_word_in_3,
        b_in    => Sbox3_o,
        c_out   => xor_8_out_3
    );

    --|------mux 2x1------|--
    --|-------------------|--
MUX_0   : component MUX_2x1
    port map(
            A_in    => xor_8_out_0  & X"000000",
            B_in    => Sbox0_o      & X"000000",
            sel     => mux2x1_sel,
            C_out   => Qbox0_i
            );

MUX_1   : component MUX_2x1
    port map(
            A_in    => xor_8_out_1  & X"000000",
            B_in    => Sbox1_o      & X"000000",
            sel     => mux2x1_sel,
            C_out   => Qbox1_i
            );

MUX_2   : component MUX_2x1
    port map(
            A_in    => xor_8_out_2  & X"000000",
            B_in    => Sbox2_o      & X"000000",
            sel     => mux2x1_sel,
            C_out   => Qbox2_i
            );

MUX_3   : component MUX_2x1
    port map(
            A_in    => xor_8_out_3  & X"000000",
            B_in    => Sbox3_o      & X"000000",
            sel     => mux2x1_sel,
            C_out   => Qbox3_i
            );

    --|------Q_Boxes------|--
    --|-------------------|--
QBox0 : component Turing_QBox
    port map (
        address     => Qbox0_i(31 downto 24),
        ce          => ce,
        clk         => clk,
        data_out    => Qbox0_o
    );

QBox1 : component Turing_QBox
    port map (
        address     => Qbox1_i(31 downto 24),
        ce          => ce,
        clk         => clk,
        data_out    => Qbox1_o
    );

QBox2 : component Turing_QBox
    port map (
        address     => Qbox2_i(31 downto 24),
        ce          => ce,
        clk         => clk,
        data_out    => Qbox2_o
    );

QBox3 : component Turing_QBox
    port map (
        address     => Qbox3_i(31 downto 24),
        ce          => ce,
        clk         => clk,
        data_out    => Qbox3_o
    );

    --|QBox out pins shift|--
    --|-------------------|--
QBox1_shift8  (31 downto  8) <= Qbox1_o(23 downto  0);
QBox1_shift8  ( 7 downto  0) <= Qbox1_o(31 downto 24);
QBox2_shift16 (31 downto 16) <= Qbox2_o(15 downto  0);
QBox2_shift16 (15 downto  0) <= Qbox2_o(31 downto 16);
QBox3_shift24 (31 downto 24) <= Qbox3_o( 7 downto  0);
QBox3_shift24 (23 downto  0) <= Qbox3_o(31 downto  8);

    --|-w0 w1 w2 w3 merge-|--
    --|-------------------|--
w0_out <= xor_8_out_0   (7 downto 0)    & Qbox0_o       (23 downto 0);
w1_out <= QBox1_shift8  (31 downto 24)  & xor_8_out_1   ( 7 downto 0)   & QBox1_shift8 (15 downto 0);
w2_out <= QBox2_shift16 (31 downto 16)  & xor_8_out_2   ( 7 downto 0)   & QBox2_shift16( 7 downto 0);
w3_out <= xor_8_out_3   (7 downto 0)    & QBox3_shift24 (23 downto 0);

    --|--32bit xor gates--|--
    --|-------------------|--

XOR_A : component XOR_32
    port map (
            a_in    => w0_out,
            b_in    => w1_out,
            c_out   => xor_outA
        );

XOR_B : component XOR_32
    port map (
            a_in    => w2_out,
            b_in    => w3_out,
            c_out   => xor_outB
        );

XOR_C : component XOR_32
    port map (
            a_in    => xor_outA,
            b_in    => xor_outB,
            c_out   => word_out
        );

    --|*******************************|--
    --|  Mixed Key In Operation END   |--
    --|*******************************|--


    --|*******************************|--
    --|Original Key In Operation BEGIN|--
    --|*******************************|--

XOR_0 : component XOR_32
    port map (
            a_in    => Qbox0_o,
            b_in    => key_i,
            c_out   => xor0_32_out
        );

w0_xor_32 <= Sbox0_o (7 downto 0) & xor0_32_out (23 downto 0);

XOR_1 : component XOR_32
    port map (
            a_in    => w0_xor_32,
            b_in    => QBox1_shift8,
            c_out   => xor1_32_out
        );

w1_xor_32 <= xor1_32_out (31 downto 24) & Sbox1_o (7 downto 0) & xor1_32_out (15 downto 0);

XOR_2 : component XOR_32
    port map (
            a_in    => w1_xor_32,
            b_in    => QBox2_shift16,
            c_out   => xor2_32_out
        );

w2_xor_32 <= xor2_32_out (31 downto 16) & Sbox2_o (7 downto 0) & xor2_32_out (7 downto 0);

XOR_3 : component XOR_32
    port map (
            a_in    => w2_xor_32,
            b_in    => QBox3_shift24,
            c_out   => xor3_32_out
        );

w3_xor_32   <= Sbox3_o (7 downto 0) & xor3_32_out (23 downto 0);
mixed_key_o <= w3_xor_32;

	--|*******************************|--
	--| Original Key In Operation END |--
	--|*******************************|--

end Behavioral;