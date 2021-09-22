library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX_2x1 is
    Port (
           A_in     : in  unsigned (31 downto 0);
           B_in     : in  unsigned (31 downto 0);
           sel      : in STD_LOGIC;
           C_out    : out unsigned (31 downto 0)
        );
end MUX_2x1;

architecture Behavioral of MUX_2x1 is

begin
    process (A_in, B_in, sel) is
        begin
        if (sel = '0') then 
            C_out <= A_in;
        else 
            C_out <= B_in;
        end if;
    end process;

end Behavioral;