    --|--------QBox LUT--------------------|--
    --|--------8-bit address, 8-bit data---|--
    --|--------ROM of 256------------------|--
    --|--------w/ chip enable, sync--------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Sbox_8_to_8 is
    Port ( 
           address  : in unsigned  (7 downto 0);
           ce       : in STD_LOGIC;
           clk      : in STD_LOGIC;
           data_out : out unsigned (7 downto 0)
        );
end Sbox_8_to_8;

architecture Behavioral of Sbox_8_to_8 is

type ROM_type is array (0 to 255) of unsigned (7 downto 0);

constant ROM : ROM_type := 
(
x"61", x"51", x"eb", x"19", x"b9", x"5d", x"60", x"38", --0
x"7c", x"b2", x"06", x"12", x"c4", x"5b", x"16", x"3b", --1
x"2b", x"18", x"83", x"b0", x"7f", x"75", x"fa", x"a0", --2
x"e9", x"dd", x"6d", x"7a", x"6b", x"68", x"2d", x"49", --3
x"b5", x"1c", x"90", x"f7", x"ed", x"9f", x"e8", x"ce", --4
x"ae", x"77", x"c2", x"13", x"fd", x"cd", x"3e", x"cf", --5
x"37", x"6a", x"d4", x"db", x"8e", x"65", x"1f", x"1a", --6
x"87", x"cb", x"40", x"15", x"88", x"0d", x"35", x"b3", --7
x"11", x"0f", x"d0", x"30", x"48", x"f9", x"a8", x"ac", --8
x"85", x"27", x"0e", x"8a", x"e0", x"50", x"64", x"a7", --9
x"cc", x"e4", x"f1", x"98", x"ff", x"a1", x"04", x"da", --10
x"d5", x"bc", x"1b", x"bb", x"d1", x"fe", x"31", x"ca", --11
x"ba", x"d9", x"2e", x"f3", x"1d", x"47", x"4a", x"3d", --12
x"71", x"4c", x"ab", x"7d", x"8d", x"c7", x"59", x"b8", --13
x"c1", x"96", x"1e", x"fc", x"44", x"c8", x"7b", x"dc", --14
x"5c", x"78", x"2a", x"9d", x"a5", x"f0", x"73", x"22", --15
x"89", x"05", x"f4", x"07", x"21", x"52", x"a6", x"28", --16
x"9a", x"92", x"69", x"8f", x"c5", x"c3", x"f5", x"e1", --17
x"de", x"ec", x"09", x"f2", x"d3", x"af", x"34", x"23", --18
x"aa", x"df", x"7e", x"82", x"29", x"c0", x"24", x"14", --19
x"03", x"32", x"4e", x"39", x"6f", x"c6", x"b1", x"9b", --20
x"ea", x"72", x"79", x"41", x"d8", x"26", x"6c", x"5e", --21
x"2c", x"b4", x"a2", x"53", x"57", x"e2", x"9c", x"86", --22
x"54", x"95", x"b6", x"80", x"8c", x"36", x"67", x"bd", --23
x"08", x"93", x"2f", x"99", x"5a", x"f8", x"3a", x"d7", --24
x"56", x"84", x"d2", x"01", x"f6", x"66", x"4d", x"55", --25
x"8b", x"0c", x"0b", x"46", x"b7", x"3c", x"45", x"91", --26
x"a4", x"e3", x"70", x"d6", x"fb", x"e6", x"10", x"a9", --27
x"c9", x"00", x"9e", x"e7", x"4f", x"76", x"25", x"3f", --28
x"5f", x"a3", x"33", x"20", x"02", x"ef", x"62", x"74", --29
x"ee", x"17", x"81", x"42", x"58", x"0a", x"4b", x"63", --30
x"e5", x"be", x"6e", x"ad", x"bf", x"43", x"94", x"97"  --31
);

begin
Sbox8_8 : process(clk, address)
    begin
        if (clk = '1') then
            if (ce = '1') then
                data_out <= ROM (to_integer(unsigned(address)));
            end if;
        end if;
    end process;
end Behavioral;
