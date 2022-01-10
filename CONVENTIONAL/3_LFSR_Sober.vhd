    --|--------Linear Feedback shift Register------|--
--|--------17 32-bit Parallel Registers--------|--
--|--------w/ chip enable, sync set/reset------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_vars.all;

entity LFSR_Sober is
Port ( 

    clk          : in STD_LOGIC;
    set          : in STD_LOGIC;
    rst          : in STD_LOGIC;
    ce           : in STD_LOGIC;
    reg15_ce      : in STD_LOGIC;
    reg4_ce      : in STD_LOGIC;
    mux_15_sel   : in STD_LOGIC; --  0 -> Step /  1 -> Include
    mux_4_sel0   : in STD_LOGIC; -- 00 -> Step / 01 -> Diffuse / 10 -> MAC Accumulation
    mux_4_sel1   : in STD_LOGIC;

    R_16_in  : in unsigned (31 downto 0);  -- Step. Op.
    R_15_in  : in unsigned (31 downto 0);  -- Sober Top
    R_4_in   : in unsigned (31 downto 0);  -- Diffuse
    pff_in   : in unsigned (31 downto 0);  -- PFF

    R_0_out  : out unsigned (31 downto 0);   -- Step. Op & NLF
    R_1_out  : out unsigned (31 downto 0);   -- NLF
    R_4_out  : out unsigned (31 downto 0);   -- Step. Op & PFF
    R_6_out  : out unsigned (31 downto 0);   -- NLF
    R_13_out : out unsigned (31 downto 0);   -- NLF
    R_15_out : out unsigned (31 downto 0);   -- Step. Op.
    R_16_out : out unsigned (31 downto 0)    -- NLF
       );
end LFSR_Sober;

architecture Behavioral of LFSR_Sober is

component Parallel_Register 
    port (
        clk     : in STD_LOGIC;
        set     : in STD_LOGIC;
        rst     : in STD_LOGIC;
        ce      : in STD_LOGIC;
        par_in  : in unsigned     (31 downto 0);
        par_out : out unsigned    (31 downto 0));
    end component Parallel_Register;

component MUX_2x1
    port(
        A_in  : in  unsigned    (31 downto 0);
        B_in  : in  unsigned    (31 downto 0);
        sel   : in  std_logic;
        C_out : out unsigned    (31 downto 0)
        );
end component MUX_2x1;

component MUX_4x1
    port(
        A_in :    in unsigned     (31 downto 0);
        B_in :    in unsigned     (31 downto 0);
        C_in :    in unsigned     (31 downto 0);
        D_in :    in unsigned     (31 downto 0);
        E_out:    out unsigned    (31 downto 0);
       sel_0 :    in STD_LOGIC;
       sel_1 :    in STD_LOGIC
        );
end component MUX_4x1;           

signal R_pi       : unsigned_matrix (16 downto 0) := (OTHERS => (OTHERS => '1'));
signal R_po       : unsigned_matrix (16 downto 0) := (OTHERS => (OTHERS => '1'));
signal xor5_out   : unsigned        (31 downto 0);

begin

R_pi(16)  <= R_16_in;

PAR_REG16: component Parallel_Register
    port map(
        clk     =>  clk,
        set     =>  set,
        rst     =>  rst,
        ce      =>  ce,
        par_in  =>  R_pi(16),
        par_out =>  R_po(16)
     );

PAR_REG15: component Parallel_Register
         port map(
             clk      =>  clk,
             set      =>  set,
             rst      =>  rst,
             ce       =>  reg15_ce,
             par_in   =>  R_pi(15),
             par_out  =>  R_po(15)
          );     
     
PAR_REG4: component Parallel_Register
         port map(
             clk      => clk,
             set      => set,
             rst      => rst,
             ce       => reg4_ce,
             par_in   => R_pi(4),
             par_out  => R_po(4)
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
  
PAR_REGY : for i in 5 to 14 generate
     R_pi(i) <= R_po(i + 1);
     PAR_REG: component Parallel_Register
         port map(
             clk      =>  clk,
             set      =>  set,
             rst      =>  rst,
             ce       =>  ce,
             par_in   =>  R_pi(i),
             par_out  =>  R_po(i)
        );
   end generate PAR_REGY;      

MUX_15 : component MUX_2x1
    port map(
            A_in  =>  R_po(16),
            B_in  =>  R_15_in,
            sel   =>  mux_15_sel,
            C_out =>  R_pi(15)
                );

MUX_4 : component MUX_4x1
    port map(
        A_in      => R_po(5), 
        B_in      => R_4_in,
        C_in      => pff_in,
        D_in      => "00000000000000000000000000000000",
        E_out     => R_pi(4), 
        sel_0     => mux_4_sel0,
        sel_1     => mux_4_sel1
            );

R_0_out     <=      R_po(0);
R_1_out     <=      R_po(1);
R_4_out     <=      R_po(4);
R_6_out     <=      R_po(6);
R_13_out    <=      R_po(13);
R_15_out    <=      R_po(15);
R_16_out    <=      R_po(16);

end architecture;