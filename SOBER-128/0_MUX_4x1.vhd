library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX_4x1 is
    Port ( 
           A_in     : in  unsigned (31 downto 0);
           B_in     : in  unsigned (31 downto 0);
           C_in     : in  unsigned (31 downto 0);
           D_in     : in  unsigned (31 downto 0);
           sel_0    : in STD_LOGIC;
           sel_1    : in STD_LOGIC;
           E_out    : out unsigned (31 downto 0)
           );
end MUX_4x1;

architecture Behavioral of MUX_4x1 is

begin
  process (A_in, B_in, C_in, D_in, sel_0, sel_1) is
  begin
    if (sel_1 = '0' and sel_0 = '0') then
      E_out <= A_in;
    elsif (sel_1 = '0' and sel_0 = '1') then
      E_out <= B_in;
    elsif (sel_1 = '1' and sel_0 = '0') then
      E_out <= C_in;
    elsif (sel_1 = '1' and sel_0 = '1') then
      E_out <= D_in;
    end if ;
  end process;

end Behavioral;