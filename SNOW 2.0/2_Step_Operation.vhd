    --|---------- Step Operation -------------------|--
    --|---------- 2 x async LUTs -------------------|--
    --|---------- 31-bit output Register -----------|--
    --|---------- w/ chip enable, sync set/reset ---|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Step_Operation is
    Port ( 
        clk                 : in std_logic;
        ce                  : in std_logic;
        mux_sel             : in std_logic;

        --|-----------test pins-----------|--
        --|-------------------------------|--

        test_mula           : out unsigned (31 downto 0);
        test_mulainv        : out unsigned (31 downto 0);
        test_mula_xor       : out unsigned (31 downto 0);
        test_mulainv_xor    : out unsigned (31 downto 0);
        test_Del_Reg        : out unsigned (31 downto 0);
        test_Step_op_out_Reg: out unsigned (31 downto 0);
        test_mux_fsm        : out unsigned (31 downto 0);
        test_xor1           : out unsigned (31 downto 0);
        test_xor2           : out unsigned (31 downto 0);
        test_xor3           : out unsigned (31 downto 0);

        --|-----------I/O pins------------|--
        --|-------------------------------|--
    
        FSM_o               : in unsigned (31 downto 0);
        R0_in               : in unsigned (31 downto 0);
        R2_in               : in unsigned (31 downto 0);
        R11_in              : in unsigned (31 downto 0);
        R15_out             : out unsigned (31 downto 0)
        );
end Step_Operation;

architecture Behavioral of Step_Operation is

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

    component XOR_32 
        port (
            a_in    : in unsigned (31 downto 0);
            b_in    : in unsigned (31 downto 0);
            c_out   : out unsigned (31 downto 0)
            );
    end component XOR_32;

    component Alpha_MUL
        port ( 
            address  : in unsigned (7 downto 0);
            clk      : in STD_LOGIC;
            ce       : in std_logic;
            data_out : out unsigned (31 downto 0));
    end component Alpha_MUL;

    component Alphainv_MUL
        port ( 
            address  : in unsigned (7 downto 0);
            clk      : in STD_LOGIC;
            ce       : in std_logic;
            data_out : out unsigned (31 downto 0));
    end component Alphainv_MUL;

    component MUX_2x1
        port(
            A_in    : in unsigned (31 downto 0);
            B_in    : in unsigned (31 downto 0);
            sel     : in std_logic;
            C_out   : out unsigned (31 downto 0)
            );
    end component MUX_2x1;

    signal a_1              : unsigned (31 downto 0);
    signal a_2              : unsigned (31 downto 0);
    signal xor1             : unsigned (31 downto 0);
    signal xor2             : unsigned (31 downto 0);
    signal xor3             : unsigned (31 downto 0);

    signal Delay_Reg_out    : unsigned (31 downto 0);

    signal LUTa_out         : unsigned (31 downto 0);
    signal LUTainv_out      : unsigned (31 downto 0);
    signal mux_fsm_out      : unsigned (31 downto 0);

    signal R0_r_shift8      : unsigned (31 downto 0);
    signal R11_l_shift8     : unsigned (31 downto 0);

begin

    R0_r_shift8  (23 downto  0) <= R0_in  (31 downto  8);
    R0_r_shift8  (31 downto 24) <= "00000000";
    R11_l_shift8 (31 downto  8) <= R11_in (23 downto  0);
    R11_l_shift8 ( 7 downto  0) <= "00000000";

    --|-----------Alpha mul box------------|--
    --|------------------------------------|--

    AMUL: component Alpha_MUL
        port map(
            address  => R0_in (7 downto 0),
            clk      => clk,
            ce       => '1',
            data_out => LUTa_out
        );

    XOR_MULA: component XOR_32
        port map(
            a_in    => LUTa_out, 
            b_in    => R0_r_shift8,
            c_out   => a_1
        );


    --|-------Alpha_inv mul box------------|--
    --|------------------------------------|--

    AINVMUL: component Alphainv_MUL
        port map(
            address  => R11_in (31 downto 24),
            clk      => clk,
            ce       => '1',
            data_out => LUTainv_out
        );

    XOR_MULAINV: component XOR_32
        port map(
            a_in    => LUTainv_out,
            b_in    => R11_l_shift8,
            c_out   => a_2
        );

    --|---------Init_mode MUX----------|--
    --|--------------------------------|--

    MUX_FSM : component MUX_2x1
        port map (
            A_in    => FSM_o,
            B_in    => "00000000000000000000000000000000",
            sel     => mux_sel,
--            clk     => clk,
            C_out   => mux_fsm_out
        );

    --|-----------XOR gates------------|--
    --|--------------------------------|--

    XOR32_1: component XOR_32
        port map(
            a_in    => a_1,
            b_in    => mux_fsm_out,
            c_out   => xor1
        );
  
    XOR32_2: component XOR_32
        port map(
            a_in    => xor1,
            b_in    => R2_in,
            c_out   => xor2
        );
        
    XOR32_3: component XOR_32
            port map(
            a_in    => xor2,
            b_in    => a_2,
            c_out   => xor3
        );        

    --|------- Step Op output Reg ---------|--
    --|------------------------------------|--

    Step_op_out_Reg: component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => ce,
            par_in  => xor3,
            par_out => R15_out
            );

    test_mula               <= LUTa_out;
    test_mulainv            <= LUTainv_out;
    test_mula_xor           <= a_1;
    test_mulainv_xor        <= a_2;
    test_Del_Reg            <= R2_in;
--    test_Step_op_out_Reg    <= R15_out; 
    test_mux_fsm            <= mux_fsm_out;
    test_xor1               <= xor1;
    test_xor2               <= xor2;
    test_xor3               <= xor3;

end Behavioral;