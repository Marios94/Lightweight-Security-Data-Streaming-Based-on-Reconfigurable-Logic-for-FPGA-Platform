library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_vars is
    type unsigned_matrix is array (integer range <>) of unsigned(31 downto 0);
    type unsigned_matrix_8 is array (integer range <>) of unsigned(7 downto 0);
	type unsigned_logic is array (integer range <>) of unsigned (1 downto 0);
end package my_vars;
