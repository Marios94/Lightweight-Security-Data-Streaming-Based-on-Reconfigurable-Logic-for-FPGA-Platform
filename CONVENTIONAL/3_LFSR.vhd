    --|--------Linear Feedback shift Register------|--
    --|--------16 32-bit Parallel Registers--------|--
    --|--------w/ chip enable, sync set/reset------|--
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity LFSR_SNOW is
    Port ( 
        clk                  : in STD_LOGIC;
        set                  : in STD_LOGIC;
        rst                  : in STD_LOGIC;
        ce                   : in STD_LOGIC;

        wire0               : out unsigned (31 downto 0);
        wire1               : out unsigned (31 downto 0);
        wire2               : out unsigned (31 downto 0);
        wire3               : out unsigned (31 downto 0);
        wire4               : out unsigned (31 downto 0);
        wire5               : out unsigned (31 downto 0);
        wire6               : out unsigned (31 downto 0);
        wire7               : out unsigned (31 downto 0);
        wire8               : out unsigned (31 downto 0);
        wire9               : out unsigned (31 downto 0);
        wire10              : out unsigned (31 downto 0);
        wire11              : out unsigned (31 downto 0);
        wire12              : out unsigned (31 downto 0);
        wire13              : out unsigned (31 downto 0);
        wire14              : out unsigned (31 downto 0);
        wire15              : out unsigned (31 downto 0);

        R_15_in             : in unsigned (31 downto 0);    -- Step. Op.

        R_0_out             : out unsigned (31 downto 0);  -- Step. Op 
        R_2_out             : out unsigned (31 downto 0);  -- Step. Op 
        R_11_out            : out unsigned (31 downto 0);  -- Step. Op 
        R_5_out             : out unsigned (31 downto 0);  -- FSM
        R_15_out            : out unsigned (31 downto 0)   -- FSM
           );
end LFSR_SNOW;

architecture Behavioral of LFSR_SNOW is

    component Parallel_Register 
        port (
            clk     : in STD_LOGIC;
            set     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            ce      : in STD_LOGIC;
            par_in  : in unsigned (31 downto 0);
            par_out : out unsigned (31 downto 0)
            );
        end component Parallel_Register;

    signal R_pi     : unsigned_matrix(15 downto 0) := (OTHERS => (OTHERS => '1'));
    signal R_po     : unsigned_matrix(15 downto 0) := (OTHERS => (OTHERS => '1'));

begin
    
    R_pi(15)    <= R_15_in;

    PAR_REG15: component Parallel_Register
        port map
        (
            clk     => clk,
            set     => set,
            rst     => rst,
            ce      => ce,
            par_in  => R_pi(15),
            par_out => R_po(15)
        );

     PAR_REGX : for i in 0 to 14 generate
        R_pi(i) <= R_po(i + 1);
        PAR_REG: component Parallel_Register
            port map
            (
                clk     => clk,
                set     => set,
                rst     => rst,
                ce      => ce,
                par_in  => R_pi(i),
                par_out => R_po(i)
            );
      end generate PAR_REGX;

    R_0_out     <= R_pi(0);
    R_2_out     <= R_pi(2);
    R_11_out    <= R_pi(11);
    R_5_out     <= R_pi(5);
    R_15_out    <= R_pi(15);

    wire0       <=  R_pi(0);      --|test pins out|--
    wire1       <=  R_pi(1);      --|test pins out|--
    wire2       <=  R_pi(2);      --|test pins out|--
    wire3       <=  R_pi(3);      --|test pins out|--
    wire4       <=  R_pi(4);      --|test pins out|--
    wire5       <=  R_pi(5);      --|test pins out|--
    wire6       <=  R_pi(6);      --|test pins out|--
    wire7       <=  R_pi(7);      --|test pins out|--
    wire8       <=  R_pi(8);      --|test pins out|--
    wire9       <=  R_pi(9);      --|test pins out|--
    wire10      <=  R_pi(10);     --|test pins out|--
    wire11      <=  R_pi(11);     --|test pins out|--
    wire12      <=  R_pi(12);     --|test pins out|--
    wire13      <=  R_pi(13);     --|test pins out|--
    wire14      <=  R_pi(14);     --|test pins out|--
    wire15      <=  R_pi(15);     --|test pins out|--

end architecture;
