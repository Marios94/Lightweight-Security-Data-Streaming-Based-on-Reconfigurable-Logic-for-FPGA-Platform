library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity SBox_xoring is
	Port (
		Sober_sbox_out 		: in	unsigned (31 downto 0);
		Sober_f_in			: in	unsigned (31 downto 0);

		Snow_T0_out			: in	unsigned (31 downto 0);
		Snow_T1_out			: in	unsigned (31 downto 0);
		Snow_T2_out			: in	unsigned (31 downto 0);
		Snow_T3_out			: in	unsigned (31 downto 0);

		Sober_f_out			: out	unsigned (31 downto 0);
		Sober_shift8_out	: out 	unsigned (31 downto 0);
		Snow_sbox_out 		: out 	unsigned (31 downto 0)
		);
end SBox_xoring;

architecture Behavioral of SBox_xoring is

component XOR_32 is
	Port (
		a_in	: in	unsigned (31 downto 0);
		b_in	: in	unsigned (31 downto 0);
		c_out	: out	unsigned (31 downto 0)
		);
end component XOR_32;

signal snow_xor1_out	: unsigned (31 downto 0);
signal snow_xor2_out	: unsigned (31 downto 0);
signal sober_xor_out	: unsigned (31 downto 0);
signal sober_shift		: unsigned (31 downto 0);

begin

	Snow_xor1: component XOR_32
		port map(
				a_in	=> Snow_T0_out,
				b_in	=> Snow_T1_out,
				c_out	=> snow_xor1_out
				);

	Snow_xor2: component XOR_32
		port map(
				a_in	=> Snow_T2_out,
				b_in	=> Snow_T3_out,
				c_out	=> snow_xor2_out
				);

	Snow_xor3: component XOR_32
		port map(
				a_in	=> snow_xor1_out,
				b_in	=> snow_xor2_out,
				c_out	=> Snow_sbox_out
				);

	Sober_xor: component XOR_32
		port map(
				a_in	=> X"00" & Sober_f_in		(23 downto 0),
				b_in	=> X"00" & Sober_sbox_out	(23 downto 0),
				c_out	=> sober_xor_out
				);

Sober_f_out (31 downto 24)	<= Sober_sbox_out	(31 downto 24);
Sober_f_out (23 downto  0)	<= sober_xor_out	(23 downto  0);

sober_shift (31 downto 24)	<= Sober_sbox_out	(31 downto 24);
sober_shift (23 downto  0)	<= sober_xor_out	(23 downto  0);

Sober_shift8_out (23 downto  0) <= sober_shift (31 downto 8);
Sober_shift8_out (31 downto 24) <= sober_shift ( 7 downto 0);

end Behavioral;