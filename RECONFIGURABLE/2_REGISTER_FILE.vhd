	--|-----REGISTER FILE------------|--
	--|-----11 32-bit Registers------|--
	--|-----parallel in/out----------|--
	--|-----sync w/ set reset--------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity REGISTER_FILE is
	Port (
		clk			: in	std_logic;

		REG1_rst	: in	std_logic;
		REG2_rst	: in	std_logic;

		REG0_ce		: in	std_logic;
		REG1_ce		: in	std_logic;
		REG2_ce		: in	std_logic;
		REG3_ce		: in	std_logic;
		REG4_ce		: in	std_logic;
		REG5_ce		: in	std_logic;
		REG6_ce		: in	std_logic;
		REG7_ce		: in	std_logic;
		REG8_ce		: in	std_logic;
		REG9_ce		: in	std_logic;
		REG10_ce	: in	std_logic;
		REG11_ce	: in	std_logic;
		REG12_ce	: in	std_logic;
		REG13_ce	: in	std_logic;
		REG14_ce	: in	std_logic;

		REG0_in		: in	unsigned (31 downto 0);
		REG1_in		: in	unsigned (31 downto 0);
		REG2_in		: in	unsigned (31 downto 0);
		REG3_in		: in	unsigned (31 downto 0);
		REG4_in		: in	unsigned (31 downto 0);
		REG5_in		: in	unsigned (31 downto 0);
		REG6_in		: in	unsigned (31 downto 0);
		REG7_in		: in	unsigned (31 downto 0);
		REG8_in		: in	unsigned (31 downto 0);
		REG9_in		: in	unsigned (31 downto 0);
		REG10_in	: in	unsigned (31 downto 0);
		REG11_in	: in	unsigned (31 downto 0);
		REG12_in	: in	unsigned (31 downto 0);
		REG13_in	: in	unsigned (31 downto 0);
		REG14_in	: in	unsigned (31 downto 0);

		REG0_out	: out	unsigned (31 downto 0);
		REG1_out	: out	unsigned (31 downto 0);
		REG2_out	: out	unsigned (31 downto 0);
		REG3_out	: out	unsigned (31 downto 0);
		REG4_out	: out	unsigned (31 downto 0);
		REG5_out	: out	unsigned (31 downto 0);
		REG6_out	: out	unsigned (31 downto 0);
		REG7_out	: out	unsigned (31 downto 0);
		REG8_out	: out	unsigned (31 downto 0);
		REG9_out	: out	unsigned (31 downto 0);
		REG10_out	: out	unsigned (31 downto 0);
		REG11_out	: out	unsigned (31 downto 0);
		REG12_out	: out	unsigned (31 downto 0);
		REG13_out	: out	unsigned (31 downto 0);
		REG14_out	: out	unsigned (31 downto 0)
		);
end REGISTER_FILE;

architecture Behavioral of REGISTER_FILE is

	component Parallel_Register 
		port (
			clk		: in	STD_LOGIC;
			set		: in	STD_LOGIC;
			rst		: in	STD_LOGIC;
			ce		: in	STD_LOGIC;
			par_in	: in	unsigned (31 downto 0);
			par_out : out	unsigned (31 downto 0)
			);
	end component Parallel_Register;

	signal R_pi		: unsigned_matrix 	(14 downto 0) := (OTHERS => (OTHERS => '1'));
	signal R_po		: unsigned_matrix 	(14 downto 0) := (OTHERS => (OTHERS => '1'));
	signal R_ce		: unsigned_bit		(14 downto 0) := (OTHERS => std_logic ' ('1'));
	signal R_rst	: unsigned_bit		(14 downto 0) := (OTHERS => std_logic ' ('1'));

begin

	REGFILE : for i in 0 to 14 generate
		PAR_REG: component Parallel_Register
			port map(
					clk		=> clk,
					ce		=> R_ce(i),
					set		=> '0',
					rst		=> R_rst(i),
					par_in	=> R_pi(i),
					par_out	=> R_po(i)
					);
	end generate REGFILE;

	R_ce(0)		<= REG0_ce;
	R_ce(1)		<= REG1_ce;
	R_ce(2)		<= REG2_ce;
	R_ce(3)		<= REG3_ce;
	R_ce(4)		<= REG4_ce;
	R_ce(5)		<= REG5_ce;
	R_ce(6)		<= REG6_ce;
	R_ce(7)		<= REG7_ce;
	R_ce(8)		<= REG8_ce;
	R_ce(9)		<= REG9_ce;
	R_ce(10)	<= REG10_ce;
	R_ce(11)	<= REG11_ce;
	R_ce(12)	<= REG12_ce;
	R_ce(13)	<= REG13_ce;
	R_ce(14)	<= REG14_ce;

	R_rst(0)	<= '0';
	R_rst(1)	<= '0';
	R_rst(2)	<= '0';
	R_rst(3)	<= '0';
	R_rst(4)	<= '0';
	R_rst(5)	<= '0';
	R_rst(6)	<= '0';
	R_rst(7)	<= '0';
	R_rst(8)	<= REG2_rst;
	R_rst(9)	<= '0';
	R_rst(10)	<= '0';
	R_rst(11)	<= '0';
	R_rst(12)	<= REG1_rst;
	R_rst(13)	<= '0';
	R_rst(14)	<= '0';

	R_pi(0)		<= REG0_in;
	R_pi(1)		<= REG1_in;
	R_pi(2)		<= REG2_in;
	R_pi(3)		<= REG3_in;
	R_pi(4)		<= REG4_in;
	R_pi(5)		<= REG5_in;
	R_pi(6)		<= REG6_in;
	R_pi(7)		<= REG7_in;
	R_pi(8)		<= REG8_in;
	R_pi(9)		<= REG9_in;
	R_pi(10)	<= REG10_in;
	R_pi(11)	<= REG11_in;
	R_pi(12)	<= REG12_in;
	R_pi(13)	<= REG13_in;
	R_pi(14)	<= REG14_in;

	REG0_out	<= R_po(0);
	REG1_out	<= R_po(1);
	REG2_out	<= R_po(2);
	REG3_out	<= R_po(3);
	REG4_out	<= R_po(4);
	REG5_out	<= R_po(5);
	REG6_out	<= R_po(6);
	REG7_out	<= R_po(7);
	REG8_out	<= R_po(8);
	REG9_out	<= R_po(9);
	REG10_out	<= R_po(10);
	REG11_out	<= R_po(11);
	REG12_out	<= R_po(12);
	REG13_out	<= R_po(13);
	REG14_out	<= R_po(14);

end Behavioral;