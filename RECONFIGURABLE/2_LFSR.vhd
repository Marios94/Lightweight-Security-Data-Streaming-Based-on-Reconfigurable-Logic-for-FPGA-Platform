	--|--------Linear Feedback shift Register------|--
	--|--------17 32-bit Parallel Registers--------|--
	--|--------w/ chip enable, sync set/reset------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity LFSR is
	Port (
		--|---------------------------------|--
		--|-------- Control signals --------|--
		--|---------------------------------|--

		clk			: in STD_LOGIC;
		set			: in STD_LOGIC;
		rst			: in STD_LOGIC;
		ce			: in STD_LOGIC;
		reg4_ce		: in STD_LOGIC;
		reg15_ce	: in STD_LOGIC;
		mux_15_sel	: in STD_LOGIC; 					--  0 -> Step /  1 -> Include
		mux_4_sel0	: in STD_LOGIC; 					-- 00 -> Step / 01 -> Diffuse / 10 -> MAC Accumulation

		--|---------------------------------|--
		--|--Inputs from Step Op, Reg_File--|--
		--|---------------------------------|--

		R16_in  		: in unsigned (31 downto 0); 	-- Step Operations
		Include_in  	: in unsigned (31 downto 0); 	-- Sober128 Include Step
		Diffuse_in 		: in unsigned (31 downto 0); 	-- Sober128 Diffuse Step

		--|-------------------------------------|--
		--|-- Outputs to Step. Op. , NLF, PFF --|--
		--|-------------------------------------|--

		R0_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R0 Step Op/NLF 	//
		R1_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R1 NLF 			// SNOW 2.0 S0 Step Op
		R2_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R3_out 			: out unsigned (31 downto 0);	-- SNOW 2.0 S2 Step Op 				//
		R4_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R4 Step Op/PFF 	//
		R5_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R6_out 			: out unsigned (31 downto 0);	--(Sober128/Turing) R6 NLF/PFF		// SNOW 2.0 S5 FSM
		R7_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R8_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R9_out 			: out unsigned (31 downto 0);	--Turing 17-PHT
		R10_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R11_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R12_out 		: out unsigned (31 downto 0);	--									// SNOW 2.0 S11 Step Op
		R13_out 		: out unsigned (31 downto 0);	--(Sober128/Turing) R13 NLF 		//
		R14_out			: out unsigned (31 downto 0);	--Turing 17-PHT
		R15_out 		: out unsigned (31 downto 0);	--(Sober128/Turing) R15 Step Op/Incl
		R16_out 		: out unsigned (31 downto 0)	--(Sober128/Turing) R16 NLF 		

		);
end LFSR;

architecture Behavioral of LFSR is

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

	component MUX_2x1
		port(
			A_in	: in	unsigned (31 downto 0);
			B_in	: in	unsigned (31 downto 0);
			C_out	: out	unsigned (31 downto 0);
			sel		: in	std_logic
			);
	end component MUX_2x1;

	signal R_pi	: unsigned_matrix (16 downto 0) := (OTHERS => (OTHERS => '1'));
	signal R_po	: unsigned_matrix (16 downto 0) := (OTHERS => (OTHERS => '1'));

begin

	R_pi(16)  <= R16_in;

	--|----------------------------------|--
	--|------------- MUXES --------------|--
	--|----------------------------------|--

	MUX_15 : component MUX_2x1
		port map(
				A_in	=> R_po(16),
				B_in	=> Include_in,
				sel		=> mux_15_sel,
				C_out	=> R_pi(15)
				);

	MUX_4 : component MUX_2x1
		port map(
				A_in	=> R_po(5),
				B_in	=> Diffuse_in,
				sel		=> mux_4_sel0,
				C_out	=> R_pi(4)
				);

	--|----------------------------------|--
	--|----------- REGISTERS ------------|--
	--|----------------------------------|--


	PAR_REG16: component Parallel_Register
		port map(
				clk		=> clk,
				set		=> set,
				rst		=> rst,
				ce		=> ce,
				par_in	=> R_pi(16),
				par_out	=> R_po(16)
				);

	PAR_REG15: component Parallel_Register
		port map(
				clk		=> clk,
				set		=> set,
				rst		=> rst,
				ce		=> reg15_ce,
				par_in	=> R_pi(15),
				par_out	=> R_po(15)
				);

	PAR_REGY : for i in 5 to 14 generate
		R_pi(i) <= R_po(i + 1);
		PAR_REG: component Parallel_Register
			port map(
					clk		=> clk,
					set		=> set,
					rst		=> rst,
					ce		=> ce,
					par_in	=> R_pi(i),
					par_out	=> R_po(i)
					);
	end generate PAR_REGY;

	PAR_REG4: component Parallel_Register
		port map(
				clk		=> clk,
				set		=> set,
				rst		=> rst,
				ce		=> reg4_ce,
				par_in	=> R_pi(4),
				par_out	=> R_po(4)
				);

	PAR_REGX : for i in 0 to 3 generate
		R_pi(i) <= R_po(i + 1);
		PAR_REG: component Parallel_Register
			port map(
					clk		=> clk,
					set		=> set,
					rst		=> rst,
					ce		=> ce,
					par_in	=> R_pi(i),
					par_out	=> R_po(i)
					);
	end generate PAR_REGX;

	R0_out			<= R_po(0);
	R1_out			<= R_po(1);
	R2_out			<= R_po(2);
	R3_out			<= R_po(3);
	R4_out			<= R_po(4);
	R5_out			<= R_po(5);
	R6_out			<= R_po(6);
	R7_out			<= R_po(7);
	R8_out			<= R_po(8);
	R9_out			<= R_po(9);
	R10_out			<= R_po(10);
	R11_out			<= R_po(11);
	R12_out			<= R_po(12);
	R13_out			<= R_po(13);
	R14_out			<= R_po(14);
	R15_out			<= R_po(15);
	R16_out			<= R_po(16);

end Behavioral;