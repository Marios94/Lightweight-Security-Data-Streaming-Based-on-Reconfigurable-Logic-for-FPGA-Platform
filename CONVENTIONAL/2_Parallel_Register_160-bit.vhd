    --|--------Linear Feedback shift Register------|--
    --|--------5  32-bit Parallel Registers--------|--
    --|--------w/ chip enable, sync set/reset------|--
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Parallel_Register_160_bit is
    Port ( 
            clk      	: in STD_LOGIC;
            set      	: in STD_LOGIC;
            rst      	: in STD_LOGIC;
            ce       	: in STD_LOGIC;
            wire_0      : out unsigned (31 downto 0);
            wire_1      : out unsigned (31 downto 0);
            wire_2      : out unsigned (31 downto 0);
            wire_3      : out unsigned (31 downto 0);
            wire_4      : out unsigned (31 downto 0);
            par_4_in    : in unsigned  (31 downto 0);
            par_0_out 	: out unsigned (31 downto 0)
        );
end Parallel_Register_160_bit;

architecture Structural of Parallel_Register_160_bit is

    component Parallel_Register 
        port (
            clk     : in STD_LOGIC;
            set     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            ce      : in STD_LOGIC;
            par_in  : in  unsigned (31 downto 0);
            par_out : out unsigned (31 downto 0)
            );
        end component Parallel_Register;

    signal R_pi     : unsigned_matrix(16 downto 0) := (OTHERS => (OTHERS => '1'));
    signal R_po     : unsigned_matrix(16 downto 0) := (OTHERS => (OTHERS => '1'));

begin

    R_pi(4) <= par_4_in;

    PAR_REG4: component Parallel_Register
        port map(
            clk     => clk,
            set     => set,
            rst     => rst,
            ce      => ce,
            par_in  => R_pi(4),
            par_out => R_po(4)
         );             

    PAR_REGX : for i in 0 to 3 generate
        R_pi(i) <= R_po(i + 1);
        PAR_REG: component Parallel_Register
            port map(
                    clk     => clk,
                    set     => set,
                    rst     => rst,
                    ce      => ce,
                    par_in  => R_pi(i),
                    par_out => R_po(i)
                    );
    end generate PAR_REGX;    

    par_0_out   <= R_po(0);
    wire_0      <= R_po(0);
    wire_1      <= R_po(1);
    wire_2      <= R_po(2);
    wire_3      <= R_po(3);
    wire_4      <= R_po(4);
end architecture ;
