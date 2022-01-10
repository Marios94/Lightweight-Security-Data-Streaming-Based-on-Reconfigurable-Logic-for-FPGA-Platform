    --|-------- 32-bit XOR gate----------|--
    --|----------------------------------|--
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XOR_32 is
    Port ( 
           a_in     : in unsigned  (31 downto 0);
           b_in     : in unsigned  (31 downto 0);
           c_out    : out unsigned (31 downto 0)
           );
end XOR_32;

architecture Behavioral of XOR_32 is

    signal temp : std_logic_vector (31 downto 0);
begin
    xor_32: for i in 0 to 31 generate
        temp(i) <= a_in(i) xor b_in(i);
    end generate xor_32;

    c_out <= unsigned (temp);
    
end Behavioral;
