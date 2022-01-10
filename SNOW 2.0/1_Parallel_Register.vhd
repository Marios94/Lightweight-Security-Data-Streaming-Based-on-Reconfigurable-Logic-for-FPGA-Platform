    --|--------Parallel I/O 32-bit Register--------|--
    --|--------Synchronous set/reset---------------|--
    --|--------w/ chip enable----------------------|--
    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Parallel_Register is
    Port ( 
           clk      : in STD_LOGIC;
           set      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           ce       : in STD_LOGIC;
           par_in   : in  unsigned (31 downto 0);
           par_out  : out unsigned (31 downto 0));
end Parallel_Register;

architecture Structural of Parallel_Register is

    component D_FF
        port(
            clk : in std_logic;
            set : in std_logic;
            rst : in std_logic;
            ce  : in std_logic;
            D   : in std_logic;
            Q   : out std_logic); 
    end component D_FF;
    
begin
    D_FFs : for i in 0 to 31 generate
        D_FFX : component D_FF
            port map(
                clk => clk,
                set => set,
                rst => rst,
                ce  => ce,
                D   => par_in(i),
                Q   => par_out(i)
                );
    end generate D_FFs;                

end architecture ;
