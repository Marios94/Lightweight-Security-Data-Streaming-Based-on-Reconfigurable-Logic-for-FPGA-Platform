	--|----- 32-bit 8-to-1 MUX -----|--
	--|-----------------------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity MUX_8x1 is
	Port (
		A_in	: in	unsigned (31 downto 0);
		B_in	: in	unsigned (31 downto 0);
		C_in	: in	unsigned (31 downto 0);
		D_in	: in	unsigned (31 downto 0);
		E_in	: in	unsigned (31 downto 0);
		F_in	: in	unsigned (31 downto 0);
		G_in	: in	unsigned (31 downto 0);
		H_in	: in	unsigned (31 downto 0);
		I_out	: out	unsigned (31 downto 0);
		sel		: in	unsigned ( 2 downto 0)
		);
end MUX_8x1;

architecture Behavioral of MUX_8x1 is

begin
	process (A_in, B_in, C_in, D_in, E_in, F_in, G_in, H_in, sel) is
	begin
		if (sel = "000") then
			I_out <= A_in;
		elsif (sel = "001") then
			I_out <= B_in;
		elsif (sel = "010") then
			I_out <= C_in;
		elsif (sel = "011") then
			I_out <= D_in;
		elsif (sel = "100") then
			I_out <= E_in;
		elsif (sel = "101") then
			I_out <= F_in;
		elsif (sel = "110") then
			I_out <= G_in;
		elsif (sel = "111") then
			I_out <= H_in;
		end if ;
	end process;

end Behavioral;