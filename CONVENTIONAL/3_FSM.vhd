    --|-------- Finite State Machine -----------|--
    --|-------- 2 32-bit Parallel Registers-----|--
    --|-------- 4 x async SBoxes ---------------|--
    --|-------- w/ chip enable, sync set/reset -|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity FSM is
    Port (
        clk             : in std_logic;
        set             : in std_logic;
        rst             : in std_logic;
        ce              : in std_logic;

        R15_in          : in  unsigned (31 downto 0);
        R5_in           : in  unsigned (31 downto 0);
        FSM_out         : out unsigned (31 downto 0)
        );
end FSM;

architecture Behavioral of FSM is

    component Parallel_Register 
        port (
            clk     : in STD_LOGIC;
            set     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            ce      : in STD_LOGIC;
            par_in  : in unsigned  (31 downto 0);
            par_out : out unsigned (31 downto 0)
            );
        end component Parallel_Register;
        
    component Adder_mod2_32 
        port (
            a_in    : in  unsigned (31 downto 0);
            b_in    : in  unsigned (31 downto 0);
            sum     : out unsigned (31 downto 0)
            );
        end component Adder_mod2_32;

    component SBox
        port (
            clk         : in STD_LOGIC;
            ce          : in std_logic;
            address     : in unsigned (31 downto 0);
            data_out    : out unsigned (31 downto 0)
            );
         end component SBox;

    component XOR_32 
        port (
            a_in    : in unsigned (31 downto 0);
            b_in    : in unsigned (31 downto 0);
            c_out   : out unsigned (31 downto 0)
            );
    end component XOR_32;

    signal R1_out   : unsigned (31 downto 0);
    signal R2_out   : unsigned (31 downto 0);
    signal Ad1_out  : unsigned (31 downto 0);
    signal Ad2_out  : unsigned (31 downto 0);
    signal s_out    : unsigned (31 downto 0);

begin

    Adder1: component Adder_mod2_32
        port map(
            a_in    => R15_in,
            b_in    => R1_out,
            sum     => Ad1_out
            );

    Adder2: component Adder_mod2_32
                port map(
            a_in    => R5_in,
            b_in    => R2_out,
            sum     => Ad2_out
             );

    R1: component Parallel_Register
        port map(
            clk     => clk,
            set     => set,
            rst     => rst,
            ce      => ce,
            par_in  => Ad2_out,
            par_out => R1_out
            );

    R2: component Parallel_Register
        port map(
            clk     => clk,
            set     => set,
            rst     => rst,
            ce      => ce,
            par_in  => s_out,
            par_out => R2_out
            );
    XOR32: component XOR_32
        port map(
            a_in    => Ad1_out,
            b_in    => R2_out,
            c_out   => FSM_out
        );

    SBox1: component SBox
        port map(
            address     => R1_out,
            clk         => clk,
            ce          => '1',
            data_out    => s_out
        );

end Behavioral;