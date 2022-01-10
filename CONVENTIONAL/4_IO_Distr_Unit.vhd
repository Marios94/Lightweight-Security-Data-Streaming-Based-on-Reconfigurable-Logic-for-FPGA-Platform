library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity IO_Distr_Unit is
	Port ( 
		clk						: in 	STD_LOGIC;
		CipherMode				: in 	integer 	range 0 to 2;
		IV_in					: in 	unsigned 	(127 downto 0);
		Key_in_and_plaintext	: in 	unsigned 	(159 downto 0);

		ciphertext 			: out 	unsigned 	(31 downto 0)
		);
end IO_Distr_Unit;

architecture Behavioral of IO_Distr_Unit is

component TURING_CONTROL_UNIT is
	Port (
		clk					: in	STD_LOGIC;
		ciphertext			: out	unsigned 	(159 downto 0);
		test_count			: out	integer range 0 to 100;
		iv_key_text			: in	unsigned 	( 31 downto 0);
		text_msg			: in	unsigned 	(159 downto 0)
					);
end component TURING_CONTROL_UNIT;

component SOBER_CONTROL_UNIT is
	Port ( 
		clk					: in 	STD_LOGIC;
		ciphertext_out		: out 	unsigned 	(31 downto 0);
		IV_in				: in 	unsigned 	(31 downto 0);
		Key_in				: in 	unsigned 	(31 downto 0);
		Konst				: in 	unsigned 	(31 downto 0);
		plaintext_in			: in 	unsigned 	(31 downto 0)
		);
end component SOBER_CONTROL_UNIT;

component SNOW_CONTROL_UNIT is
	Port (
		clk					: in 	std_logic;
		secret_key			: in 	unsigned 	(127 downto 0);
		init_vector			: in 	unsigned 	(127 downto 0);
		text_message		: in 	unsigned 	( 31 downto 0);
		cipher_text 		: out 	unsigned 	( 31 downto 0)
		);
end component SNOW_CONTROL_UNIT;

signal turing_wire			:	unsigned 	(159 downto 0);
signal ciphertext_turing	: 	unsigned 	( 31 downto 0);
signal ciphertext_sober		: 	unsigned 	( 31 downto 0);
signal ciphertext_SNOW		: 	unsigned 	( 31 downto 0);
signal tur_counter 			: 	integer range 0 to 100;
 
begin

TURING : component TURING_CONTROL_UNIT 
PORT MAP (
		clk 							=> clk,
		ciphertext   	                => turing_wire,
		iv_key_text						=> IV_in			(31 downto 0),
		test_count						=> tur_counter,
		text_msg 						=> Key_in_and_plaintext
		);

SOBER : component SOBER_CONTROL_UNIT 
PORT MAP (
		clk								=> clk,
		ciphertext_out					=> ciphertext_sober,
		IV_in							=> IV_in			(31 downto  0),
		Key_in							=> Key_in_and_plaintext(31 downto 0),
		Konst							=> IV_in			(63 downto 32),
		plaintext_in					=> Key_in_and_plaintext (31 downto 0)
		);

 SNOW : component SNOW_CONTROL_UNIT 
 PORT MAP (
		clk								=> clk,
		secret_key 						=> Key_in_and_plaintext(127 downto 0),
		init_vector						=> IV_in			(127 downto 0),
		text_message					=> Key_in_and_plaintext(31 downto 0),
		cipher_text 					=> ciphertext_SNOW
			);

	I_O_enable : process(clk) is
	begin
	if (CipherMode = 0) then
		if (tur_counter = 81) then
			ciphertext <= turing_wire(159 downto 128);
		end if;

		if (tur_counter = 82) then
			ciphertext <= turing_wire(127 downto 96);
		end if;

		if (tur_counter = 83) then
			ciphertext <= turing_wire(95 downto 64);
		end if;

		if (tur_counter = 84) then
			ciphertext <= turing_wire(63 downto 32);
		end if;

		if (tur_counter = 85) then
			ciphertext <= turing_wire(31 downto 0);
		end if;
    end if;

		if (CipherMode = 1) then
			ciphertext <= ciphertext_sober;
		end if;
			
		if (CipherMode = 2) then
			ciphertext <= ciphertext_SNOW;
		end if;
	end process;

end Behavioral;