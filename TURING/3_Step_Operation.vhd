    --|--------LFSR Stepping Operation-----------|--
    --|--------4*32-bit inputs, 1*32-bit output--|--
    --|--------32-bit AND, 32-bit XOR------------|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Step_Operation is
    Port ( 
        --|---- input ----|--
        --|---------------|--
        R0_in    : in unsigned  (31 downto 0);
        R4_in    : in unsigned  (31 downto 0);
        R15_in   : in unsigned  (31 downto 0);

        --|---- output ---|--
        --|---------------|--
        R16_out  : out unsigned (31 downto 0);

        --|-- test pins --|--
        --|---------------|--
        test_R0_shift8  : out unsigned (31 downto 0);
        test_R0_shift24 : out unsigned ( 7 downto 0);
        test_and_out    : out unsigned ( 7 downto 0);
        test_xor1       : out unsigned (31 downto 0);
        test_xor2       : out unsigned (31 downto 0);
        test_xor3       : out unsigned (31 downto 0);
        test_multab_out : out unsigned (31 downto 0);

        --|-ctrl  signals-|--
        --|---------------|--
        clk      : in std_logic;
        ce       : in std_logic
           );
end Step_Operation;

architecture Behavioral of Step_Operation is

    component AND32
        port(
            a_in    : in unsigned  (7 downto 0);
            c_out   : out unsigned (7 downto 0)
            );
    end component AND32;

    component XOR_32
        port(
            a_in    : in unsigned  (31 downto 0);
            b_in    : in unsigned  (31 downto 0);
            c_out   : out unsigned (31 downto 0)
            );
    end component XOR_32;

    component Multab_ROM
        port(
            clk         : in STD_LOGIC;
            ce          : in std_logic;
            address     : in unsigned  (7 downto  0);
            data_out    : out unsigned (31 downto 0)
            );
    end component Multab_ROM;

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

    signal R0           : unsigned (31 downto 0);
    signal multab_in    : unsigned ( 7 downto 0);
    signal multab_out   : unsigned (31 downto 0);
    signal R0_24rs      : unsigned ( 7 downto 0);
    signal R0_8ls       : unsigned (31 downto 0);
    signal wire4        : unsigned (31 downto 0);
    signal wire15       : unsigned (31 downto 0);
    signal xor1         : unsigned (31 downto 0);
    signal xor2         : unsigned (31 downto 0);
    signal xor3         : unsigned (31 downto 0);

begin

    --|-------- shifting inputs --------|--
    --|---------------------------------|--

    R0                      <= R0_in;
    R0_8ls (31 downto 0)    <= R0 (23 downto  0) & X"00";   -- R0<<8
    R0_24rs                 <= R0 (31 downto 24);           -- R0>>24
    wire4                   <= R4_in;
    wire15                  <= R15_in;

    --|----- calculate LUT address -----|--
    --|---------------------------------|--

    AND_32: component AND32
        port map(
            a_in    => R0_24rs,
            c_out   => multab_in    -- LUT address
                );

    --|------- get value from LUT ------|--
    --|---------------------------------|--

    MULTAB : component Multab_ROM
        port map(
            address     => multab_in,
            clk         => clk,
            ce          => '1',
            data_out    => multab_out
                );

    --|----------- XORing --------------|--
    --|---------------------------------|--

    XOR32_1: component XOR_32
        port map(
            a_in    => wire4,
            b_in    => wire15,
            c_out   => xor1
                );

    XOR32_2: component XOR_32
        port map(
            a_in    => R0_8ls,
            b_in    => xor1,
            c_out   => xor2
                );

    XOR32_3: component XOR_32
        port map(
            a_in    => multab_out,
            b_in    => xor2,
            c_out   => xor3         --LFSR R[16] input
                );

    Step_Op_REG : component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => ce,
            par_in  => xor3,
            par_out => R16_out
                );

    test_R0_shift8  <= R0_8ls;
    test_R0_shift24 <= R0_24rs;
    test_and_out    <= multab_in;
    test_xor1       <= xor1;
    test_xor2       <= xor2;
    test_xor3       <= xor3;
    test_multab_out <= multab_out;

end Behavioral;
