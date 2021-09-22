    --|--------Multab LUT Sober-128--------|--
    --|--------8-bit address, 32-bit data--|--
    --|--------ROM of 256------------------|--
    --|--------w/ chip enable, async-------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Multab_ROM is
    Port (
           address  : in unsigned (7 downto 0);
           clk      : in STD_LOGIC;
           ce       : in std_logic;
           data_out : out unsigned (31 downto 0)
        );
end Multab_ROM;

architecture Behavioral of Multab_ROM is

    type ROM_type is array (0 to 255) of unsigned (31 downto 0);

    constant ROM : ROM_type :=
    (
    X"00000000", X"d02b4367", X"ed5686ce", X"3d7dc5a9", --0
    X"97ac41d1", X"478702b6", X"7afac71f", X"aad18478", --1
    X"631582ef", X"b33ec188", X"8e430421", X"5e684746", --2
    X"f4b9c33e", X"24928059", X"19ef45f0", X"c9c40697", --3
    X"c62a4993", X"16010af4", X"2b7ccf5d", X"fb578c3a", --4
    X"51860842", X"81ad4b25", X"bcd08e8c", X"6cfbcdeb", --5
    X"a53fcb7c", X"7514881b", X"48694db2", X"98420ed5", --6
    X"32938aad", X"e2b8c9ca", X"dfc50c63", X"0fee4f04", --7
    X"c154926b", X"117fd10c", X"2c0214a5", X"fc2957c2", --8
    X"56f8d3ba", X"86d390dd", X"bbae5574", X"6b851613", --9
    X"a2411084", X"726a53e3", X"4f17964a", X"9f3cd52d", --10
    X"35ed5155", X"e5c61232", X"d8bbd79b", X"089094fc", --11
    X"077edbf8", X"d755989f", X"ea285d36", X"3a031e51", --12
    X"90d29a29", X"40f9d94e", X"7d841ce7", X"adaf5f80", --13
    X"646b5917", X"b4401a70", X"893ddfd9", X"59169cbe", --14
    X"f3c718c6", X"23ec5ba1", X"1e919e08", X"cebadd6f", --15
    X"cfa869d6", X"1f832ab1", X"22feef18", X"f2d5ac7f", --16
    X"58042807", X"882f6b60", X"b552aec9", X"6579edae", --17
    X"acbdeb39", X"7c96a85e", X"41eb6df7", X"91c02e90", --18
    X"3b11aae8", X"eb3ae98f", X"d6472c26", X"066c6f41", --19
    X"09822045", X"d9a96322", X"e4d4a68b", X"34ffe5ec", --20
    X"9e2e6194", X"4e0522f3", X"7378e75a", X"a353a43d", --21
    X"6a97a2aa", X"babce1cd", X"87c12464", X"57ea6703", --22
    X"fd3be37b", X"2d10a01c", X"106d65b5", X"c04626d2", --23
    X"0efcfbbd", X"ded7b8da", X"e3aa7d73", X"33813e14", --24
    X"9950ba6c", X"497bf90b", X"74063ca2", X"a42d7fc5", --25
    X"6de97952", X"bdc23a35", X"80bfff9c", X"5094bcfb", --26
    X"fa453883", X"2a6e7be4", X"1713be4d", X"c738fd2a", --27
    X"c8d6b22e", X"18fdf149", X"258034e0", X"f5ab7787", --28
    X"5f7af3ff", X"8f51b098", X"b22c7531", X"62073656", --29
    X"abc330c1", X"7be873a6", X"4695b60f", X"96bef568", --30
    X"3c6f7110", X"ec443277", X"d139f7de", X"0112b4b9", --31
    X"d31dd2e1", X"03369186", X"3e4b542f", X"ee601748", --32
    X"44b19330", X"949ad057", X"a9e715fe", X"79cc5699", --33
    X"b008500e", X"60231369", X"5d5ed6c0", X"8d7595a7", --34
    X"27a411df", X"f78f52b8", X"caf29711", X"1ad9d476", --35
    X"15379b72", X"c51cd815", X"f8611dbc", X"284a5edb", --36
    X"829bdaa3", X"52b099c4", X"6fcd5c6d", X"bfe61f0a", --37
    X"7622199d", X"a6095afa", X"9b749f53", X"4b5fdc34", --38
    X"e18e584c", X"31a51b2b", X"0cd8de82", X"dcf39de5", --39
    X"1249408a", X"c26203ed", X"ff1fc644", X"2f348523", --40
    X"85e5015b", X"55ce423c", X"68b38795", X"b898c4f2", --41
    X"715cc265", X"a1778102", X"9c0a44ab", X"4c2107cc", --42
    X"e6f083b4", X"36dbc0d3", X"0ba6057a", X"db8d461d", --43
    X"d4630919", X"04484a7e", X"39358fd7", X"e91eccb0", --44
    X"43cf48c8", X"93e40baf", X"ae99ce06", X"7eb28d61", --45
    X"b7768bf6", X"675dc891", X"5a200d38", X"8a0b4e5f", --46
    X"20daca27", X"f0f18940", X"cd8c4ce9", X"1da70f8e", --47
    X"1cb5bb37", X"cc9ef850", X"f1e33df9", X"21c87e9e", --48
    X"8b19fae6", X"5b32b981", X"664f7c28", X"b6643f4f", --49
    X"7fa039d8", X"af8b7abf", X"92f6bf16", X"42ddfc71", --50
    X"e80c7809", X"38273b6e", X"055afec7", X"d571bda0", --51
    X"da9ff2a4", X"0ab4b1c3", X"37c9746a", X"e7e2370d", --52
    X"4d33b375", X"9d18f012", X"a06535bb", X"704e76dc", --53
    X"b98a704b", X"69a1332c", X"54dcf685", X"84f7b5e2", --54
    X"2e26319a", X"fe0d72fd", X"c370b754", X"135bf433", --55
    X"dde1295c", X"0dca6a3b", X"30b7af92", X"e09cecf5", --56
    X"4a4d688d", X"9a662bea", X"a71bee43", X"7730ad24", --57
    X"bef4abb3", X"6edfe8d4", X"53a22d7d", X"83896e1a", --58
    X"2958ea62", X"f973a905", X"c40e6cac", X"14252fcb", --59
    X"1bcb60cf", X"cbe023a8", X"f69de601", X"26b6a566", --60
    X"8c67211e", X"5c4c6279", X"6131a7d0", X"b11ae4b7", --61
    X"78dee220", X"a8f5a147", X"958864ee", X"45a32789", --62
    X"ef72a3f1", X"3f59e096", X"0224253f", X"d20f6658"  --63
    );
begin
    MULTAB : process(clk, address)
        begin
            if (clk = '1') then
                if (ce = '1') then
                    data_out <= ROM (to_integer(unsigned(address)));
                end if;
            end if;
        end process;
end Behavioral;