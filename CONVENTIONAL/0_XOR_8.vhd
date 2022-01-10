    --|-------- 8-bit XOR gate----------|--
    
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity XOR_8 is
    Port ( 
           A    : in  unsigned (7 downto 0);
           B    : in  unsigned (7 downto 0);
           C    : out unsigned (7 downto 0)
           );
end XOR_8;

architecture Behavioral of XOR_8 is

    signal temp : std_logic_vector (7 downto 0);
begin
    xor_8: for i in 0 to 7 generate
        temp(i) <= A(i) xor B(i);
    end generate xor_8;

    C <= unsigned (temp);
    
end Behavioral;