    --|-------- 32-bit Adder------|--
    --|-------- w/ curry----------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Adder_32 is
    Port ( 
           a_in     : in unsigned (31 downto 0);
           b_in     : in unsigned (31 downto 0);
           curry    : out STD_LOGIC;
           c_out    : out unsigned (31 downto 0)
           );
end Adder_32;

architecture Behavioral of Adder_32 is

    signal temp : unsigned (32 downto 0);
    
begin
    temp <= ("0" & a_in) + ("0" & b_in);
    c_out <= temp(31 downto 0);
    curry <= temp(32);

end Behavioral;