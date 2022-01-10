library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_vars is
    type unsigned_matrix 	is array (integer range <>) of unsigned(31 downto 0);
    type unsigned_bit 		is array (integer range <>) of std_logic;
end package my_vars;