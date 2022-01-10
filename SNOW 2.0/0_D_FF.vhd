    --|------Pos-edge-Triggered D Flip Flop----|--
    --|------Synchronous set,reset-------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
    
entity D_FF is
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;  --reset
           set  : in STD_LOGIC;  --set
           ce   : in STD_LOGIC;   --chip enable
           D    : in STD_LOGIC;    
           Q    : out STD_LOGIC);
end D_FF;

architecture Behavioral of D_FF is
begin
    process (clk) is
    begin
    if (rising_edge (clk)) then
        if (ce = '1') then
            if (rst = '1') then
                Q <= '0';
            elsif (set = '1') then 
                Q <= '1';
            else 
                Q <= D;
            end if;
        end if;
    end if;
    end process;
end architecture Behavioral;
