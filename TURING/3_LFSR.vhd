    --|--------Linear Feedback shift Register------|--
    --|--------17 32-bit Parallel Registers--------|--
    --|--------w/ chip enable, sync set/reset------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity LFSR is
    Port ( 
        clk         : in STD_LOGIC;
        set         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        ce          : in STD_LOGIC;

    --|-- Inputs from Steo. Op. , NLF --|--
    --|---------------------------------|--

        R_16_in     : in unsigned (31 downto 0); -- Step. Op.

    --|-- Outputs to Step. Op. , NLF, PFF --|--
    --|-------------------------------------|--

        R_0_out     : out unsigned (31 downto 0);   -- initialization mode / Step. Op & NLF
        R_1_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_2_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_3_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_4_out     : out unsigned (31 downto 0);   -- initialization mode / Step. Op & PFF
        R_5_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_6_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_7_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_8_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_9_out     : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_10_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_11_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_12_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_13_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_14_out    : out unsigned (31 downto 0);   -- initialization mode / NLF
        R_15_out    : out unsigned (31 downto 0);   -- initialization mode / Step. Op.
        R_16_out    : out unsigned (31 downto 0)    -- initialization mode / NLF
        );
end LFSR;

architecture Behavioral of LFSR is

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
    --|----------------------------------|--
    --|-----Parallel Registers-----------|--
    --|----------------------------------|--

    R_pi(16) <= R_16_in;

    PAR_REG16: component Parallel_Register
        port map(
            clk     => clk,
            set     => set,
            rst     => rst,
            ce      => ce,
            par_in  => R_pi(16),
            par_out => R_po(16)
         );


     PAR_REGX : for i in 0 to 15 generate
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

    R_0_out     <= R_po(0);
    R_1_out     <= R_po(1);
    R_2_out     <= R_po(2);
    R_3_out     <= R_po(3);
    R_4_out     <= R_po(4);
    R_5_out     <= R_po(5);
    R_6_out     <= R_po(6);
    R_7_out     <= R_po(7);
    R_8_out     <= R_po(8);
    R_9_out     <= R_po(9);
    R_10_out    <= R_po(10);
    R_11_out    <= R_po(11);
    R_12_out    <= R_po(12);
    R_13_out    <= R_po(13);
    R_14_out    <= R_po(14);
    R_15_out    <= R_po(15);
    R_16_out    <= R_po(16);

end architecture;
