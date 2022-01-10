    --|---------- Step Operation -------------------|--
    --|---------- 2 x async LUTs -------------------|--
    --|---------- 31-bit output Register -----------|--
    --|---------- w/ chip enable, sync set/reset ---|--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity Step_Operation_SNOW is
    Port ( 
        clk                 : in std_logic;
        ce                  : in std_logic;
        mux_sel             : in std_logic;
    
        FSM_o               : in unsigned (31 downto 0);
        R0_in               : in unsigned (31 downto 0);
        R2_in               : in unsigned (31 downto 0);
        R11_in              : in unsigned (31 downto 0);
        R15_out             : out unsigned (31 downto 0)
        );
end Step_Operation_SNOW;

architecture Behavioral of Step_Operation_SNOW is

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

    MUX_FSM : component MUX_2x1
        port map (
            A_in    => FSM_o,
            B_in    => "00000000000000000000000000000000",
            sel     => mux_sel,
            C_out   => mux_fsm_out
        );

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

    Step_op_out_Reg: component Parallel_Register
        port map(
            clk     => clk,
            set     => '0',
            rst     => '0',
            ce      => ce,
            par_in  => xor3,
            par_out => R15_out
            );

end Behavioral;