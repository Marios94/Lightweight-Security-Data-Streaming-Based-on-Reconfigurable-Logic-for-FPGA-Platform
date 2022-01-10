    --|-------- 32-bit AND gate----------|--
    --|-------- AND w/ value 0xff--------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AND32 is
    Port ( 
        a_in    : in unsigned  (7 downto 0);
        c_out   : out unsigned (7 downto 0)
        );
end AND32;
    
architecture Behavioral of AND32 is

    signal temp : std_logic_vector(7 downto 0);
    signal b_in : unsigned (7 downto 0) := "11111111";
begin
    and_31 : for i in 0 to 7 generate
        temp(i) <= std_logic(a_in(i)) and b_in(i);
    end generate and_31;

    c_out <= unsigned(temp);

end Behavioral;
