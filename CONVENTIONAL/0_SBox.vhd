    --|-------SBox LUT_T-------------------|--
    --|-------32-bit address, 32-bit data--|--
    --|-------ROM of 4 x LUTs--------------|--
    --|-------w/ chip enable, async--------|--
    --|-------SNOW 2.0---------------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity SBox is
    Port ( 
        address : in unsigned (31 downto 0);
        clk     : in STD_LOGIC;
        ce      : in STD_LOGIC;
        data_out : out unsigned (31 downto 0)
           );
end SBox;

architecture Behavioral of SBox is

    component T_LUT
        port (
            address     : in unsigned (7 downto 0);
            clk         : in STD_LOGIC;
            ce          : in std_logic;
            data_out    : out unsigned (31 downto 0)
            );                 
         end component T_LUT;   

    component XOR_32
             port (
            a_in   : in unsigned (31 downto 0);
            b_in   : in unsigned (31 downto 0);
            c_out  : out unsigned (31 downto 0));
    end component XOR_32;
 
    signal T_0_in       : unsigned (7 downto 0);
    signal T_1_in       : unsigned (7 downto 0);
    signal T_2_in       : unsigned (7 downto 0);
    signal T_3_in       : unsigned (7 downto 0);

    signal T_0_out      : unsigned (31 downto 0);
    signal T_1_out      : unsigned (31 downto 0);
    signal T_2_out      : unsigned (31 downto 0);
    signal T_3_out      : unsigned (31 downto 0);

    signal T_1_shift8   : unsigned (31 downto 0);
    signal T_2_shift16  : unsigned (31 downto 0);
    signal T_3_shift24  : unsigned (31 downto 0);

    signal xor_out_1    : unsigned (31 downto 0);
    signal xor_out_2    : unsigned (31 downto 0);

begin
        
    T_0_in <= address (31 downto 24);
    T_1_in <= address (23 downto 16);
    T_2_in <= address (15 downto  8);
    T_3_in <= address ( 7 downto  0);
        
    T_0: component T_LUT
        port map(
            address     => T_0_in,
            clk         => clk,
            ce          => ce,
            data_out    => T_0_out
        );
        
    T_1: component T_LUT
        port map(
            address     => T_1_in,
            clk         => clk,
            ce          => ce,
            data_out    => T_1_out
        );
            
    T_2: component T_LUT
        port map(
            address     => T_2_in,
            clk         => clk,
            ce          => ce,
            data_out    => T_2_out
        );
                
    T_3: component T_LUT
        port map(
            address     => T_3_in,
            clk         => clk,
            ce          => ce,
            data_out    => T_3_out
        );

T_1_shift8  (31 downto  8) <= T_1_out (23 downto  0);
T_1_shift8  ( 7 downto  0) <= T_1_out (31 downto 24);
T_2_shift16 (31 downto 16) <= T_2_out (15 downto  0);
T_2_shift16 (15 downto  0) <= T_2_out (31 downto 16);
T_3_shift24 (31 downto 24) <= T_3_out ( 7 downto  0);
T_3_shift24 (23 downto  0) <= T_3_out (31 downto  8);

    XOR1 : component XOR_32
        port map(
            a_in    => T_0_out,
            b_in    => T_1_shift8,
            c_out   => xor_out_1
            );

    XOR2 : component XOR_32
        port map(
            a_in    => T_2_shift16,
            b_in    => T_3_shift24,
            c_out   => xor_out_2
            );

    XOR3 : component XOR_32
        port map(
            a_in    => xor_out_1,
            b_in    => xor_out_2,
            c_out   => data_out
            );

end Behavioral;