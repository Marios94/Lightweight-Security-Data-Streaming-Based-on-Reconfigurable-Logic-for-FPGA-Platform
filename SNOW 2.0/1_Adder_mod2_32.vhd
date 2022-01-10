    --|--------Modulo 2**32 Adder-----------|--
    --|--------32-bit input, 32-bit output--|--
    --|--------Uses 2 32-bit adders---------|--
    --|--------w/ chip enable---------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity Adder_mod2_32 is
    Port (
           a_in : in unsigned (31 downto 0);
           b_in : in unsigned (31 downto 0);
           sum : out unsigned (31 downto 0)
           );
end Adder_mod2_32;

architecture Behavioral of Adder_mod2_32 is
    
    component Adder_32
    port(
        a_in : in unsigned (31 downto 0);
        b_in : in unsigned (31 downto 0);
        curry : out STD_LOGIC;
        c_out : out unsigned (31 downto 0)           
         );
     end component Adder_32;
     
     signal adder_out : unsigned (31 downto 0);
     signal curry_out : std_logic;
     signal curry_in : unsigned (31 downto 0);
     
begin

    --|--------First Adder-----------|--
    --|--------Checking for curry----|--

    Adder_1: component Adder_32
        port map(
                a_in => a_in,
                b_in => b_in,
                curry => curry_out,
                c_out => adder_out
                );

    curry_in <= (0 => curry_out, others => '0');    --zero pudding

    --|--------Second Adder-----------|--
    --|--------Adding with curry------|--
    
    Adder_2: component Adder_32
        port map(
                a_in => adder_out,
                b_in => curry_in,
                c_out => sum
                );
    
    
end Behavioral;
