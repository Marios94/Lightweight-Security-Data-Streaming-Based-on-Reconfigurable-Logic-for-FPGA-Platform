library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Block_Add is
    Port ( 

        enable : in std_logic;
        clk    : in std_logic;

        YA : in unsigned (31 downto 0);   -- 5_PHT_A
        YB : in unsigned (31 downto 0);   -- 5_PHT_B
        YC : in unsigned (31 downto 0);   -- 5_PHT_C
        YD : in unsigned (31 downto 0);   -- 5_PHT_D
        YE : in unsigned (31 downto 0);   -- 5_PHT_E

        WA : in unsigned (31 downto 0);   --R14
        WB : in unsigned (31 downto 0);   --R12
        WC : in unsigned (31 downto 0);   --R8
        WD : in unsigned (31 downto 0);   --R1
        WE : in unsigned (31 downto 0);   --R0

        --|--5-PHT outputs--|--

        ZA : out unsigned (31 downto 0);  --Vt_out
        ZB : out unsigned (31 downto 0);  --Vt_out
        ZC : out unsigned (31 downto 0);  --Vt_out
        ZD : out unsigned (31 downto 0);  --Vt_out
        ZE : out unsigned (31 downto 0)   --Vt_out
        );

end Block_Add;

architecture Behavioral of Block_Add is

    component Adder_mod2_32
        port(
               a_in : in unsigned  (31 downto 0);
               b_in : in unsigned  (31 downto 0);
               sum  : out unsigned (31 downto 0)
            );
    end component Adder_mod2_32;

signal A : unsigned (31 downto 0);
signal B : unsigned (31 downto 0);
signal C : unsigned (31 downto 0);
signal D : unsigned (31 downto 0);
signal E : unsigned (31 downto 0);

begin
    process (enable) is
    begin
        if (enable = '1') then
            ZA <= A;
            ZB <= B;
            ZC <= C;
            ZD <= D;
            ZE <= E;
        elsif (enable = '0') then
            ZA <= X"00000000";
            ZB <= X"00000000";
            ZC <= X"00000000";
            ZD <= X"00000000";
            ZE <= X"00000000";
        end if;
    end process;

    --|-----Adders 2**32-----|--
    --|----------------------|--

    Adder1 : component Adder_mod2_32
        port map(
                a_in => YA,
                b_in => WA,
                sum  => A
                );

    Adder2 : component Adder_mod2_32
        port map(
                a_in => YB,
                b_in => WB,
                sum  => B
                );

    Adder3 : component Adder_mod2_32
        port map(
                a_in => YC,
                b_in => WC,
                sum  => C
                );

    Adder4 : component Adder_mod2_32
        port map(
                a_in => YD,
                b_in => WD,
                sum  => D
                );

    Adder5 : component Adder_mod2_32
        port map(
                a_in => YE,
                b_in => WE,
                sum  => E
                );

end Behavioral;