    --|----- 32-bit 6-to-1 MUX -----|--
    --|-----------------------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity MUX_6x1 is
    Port (
        A_in    : in unsigned  (31 downto 0);
        B_in    : in unsigned  (31 downto 0);
        C_in    : in unsigned  (31 downto 0);
        D_in    : in unsigned  (31 downto 0);
        E_in    : in unsigned  (31 downto 0);
        F_in    : in unsigned  (31 downto 0);
        G_out   : out unsigned (31 downto 0);
        sel_0   : in STD_LOGIC;
        sel_1   : in STD_LOGIC;
        sel_2   : in STD_LOGIC
        );
end MUX_6x1;

architecture Behavioral of MUX_6x1 is

begin
  process (A_in, B_in, C_in, D_in, E_in, F_in, sel_0, sel_1, sel_2) is
  begin
    if    (sel_2 = '0' and sel_1 = '0' and sel_0 = '0') then
            G_out <= A_in;
    elsif (sel_2 = '0' and sel_1 = '0' and sel_0 = '1') then
            G_out <= B_in;
    elsif (sel_2 = '0' and sel_1 = '1' and sel_0 = '0') then
            G_out <= C_in;
    elsif (sel_2 = '0' and sel_1 = '1' and sel_0 = '1') then
            G_out <= D_in;
    elsif (sel_2 = '1' and sel_1 = '0' and sel_0 = '0') then
            G_out <= E_in;
    elsif (sel_2 = '1' and sel_1 = '0' and sel_0 = '1') then
            G_out <= F_in;
    end if ;
  end process;

end Behavioral;
