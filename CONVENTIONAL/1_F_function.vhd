    --|------Non-linearity function---------|--
    --|------2*32-bit input, 32-bit output--|--
    --|------256*32-bit  LUT----------------|--
    --|------w/ chip enable, sync-----------|--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity F_function is
    Port (
           f_in     : in  unsigned (31 downto 0);
           f_out    : out unsigned (31 downto 0);
           Sbox_out : out unsigned (31 downto 0);
           ce       : in STD_LOGIC;
           clk      : in STD_LOGIC
           );
end F_function;

architecture Behavioral of F_function is

    component S_Box_ROM 
        port(
            address     : in unsigned  ( 7 downto 0);
            clk         : in STD_LOGIC;
            ce          : in std_logic;
            data_out    : out unsigned (31 downto 0)
            );
    end component S_Box_ROM;

    component XOR_32
        port(
            a_in    : in  unsigned (31 downto 0);
            b_in    : in  unsigned (31 downto 0);
            c_out   : out unsigned (31 downto 0)
            );
    end component XOR_32;

    signal S_Box_out_1  : unsigned (31 downto 0);
    signal S_Box_out_2  : unsigned (31 downto 0);
    signal xor_out      : unsigned (31 downto 0);

begin

    S_Box : component S_Box_ROM
        port map(
                address     => f_in (31 downto 24),
                clk         => clk,
                ce          => '1',
                data_out    => S_Box_out_1
                );

    XOR1 : component XOR_32
        port map(
                a_in    => X"00" & S_Box_out_1  (23 downto 0),
                b_in    => X"00" & f_in         (23 downto 0),
                c_out   => xor_out
                );

    f_out (31 downto 24)    <= S_Box_out_1  (31 downto 24);
    f_out (23 downto  0)    <= xor_out      (23 downto  0);
    Sbox_out                <= S_Box_out_1;

end Behavioral;