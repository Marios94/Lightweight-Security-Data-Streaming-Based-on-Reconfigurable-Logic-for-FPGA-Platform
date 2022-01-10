    --|--------Alpha LUT-------------------|--
    --|--------8-bit address, 32-bit data--|--
    --|--------ROM of 256------------------|--
    --|--------w/ chip enable, async-------|--
    --|--------SNOW 2.0--------------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Alpha_MUL is
Port ( 
       address 	: in unsigned (7 downto 0);
       clk 		: in STD_LOGIC;
       ce 		: in std_logic;
       data_out : out unsigned (31 downto 0));
end Alpha_MUL;

architecture Behavioral of Alpha_MUL is

type ROM_type is array (0 to 255) of unsigned (31 downto 0);

constant ROM : ROM_type := 
(
x"00000000", x"E19FCF13", x"6B973726", x"8A08F835", x"D6876E4C", x"3718A15F", x"BD10596A", x"5C8F9679", --0
x"05A7DC98", x"E438138B", x"6E30EBBE", x"8FAF24AD", x"D320B2D4", x"32BF7DC7", x"B8B785F2", x"59284AE1", --1
x"0AE71199", x"EB78DE8A", x"617026BF", x"80EFE9AC", x"DC607FD5", x"3DFFB0C6", x"B7F748F3", x"566887E0", --2
x"0F40CD01", x"EEDF0212", x"64D7FA27", x"85483534", x"D9C7A34D", x"38586C5E", x"B250946B", x"53CF5B78", --3
x"1467229B", x"F5F8ED88", x"7FF015BD", x"9E6FDAAE", x"C2E04CD7", x"237F83C4", x"A9777BF1", x"48E8B4E2", --4
x"11C0FE03", x"F05F3110", x"7A57C925", x"9BC80636", x"C747904F", x"26D85F5C", x"ACD0A769", x"4D4F687A", --5
x"1E803302", x"FF1FFC11", x"75170424", x"9488CB37", x"C8075D4E", x"2998925D", x"A3906A68", x"420FA57B", --6
x"1B27EF9A", x"FAB82089", x"70B0D8BC", x"912F17AF", x"CDA081D6", x"2C3F4EC5", x"A637B6F0", x"47A879E3", --7
x"28CE449F", x"C9518B8C", x"435973B9", x"A2C6BCAA", x"FE492AD3", x"1FD6E5C0", x"95DE1DF5", x"7441D2E6", --8
x"2D699807", x"CCF65714", x"46FEAF21", x"A7616032", x"FBEEF64B", x"1A713958", x"9079C16D", x"71E60E7E", --9
x"22295506", x"C3B69A15", x"49BE6220", x"A821AD33", x"F4AE3B4A", x"1531F459", x"9F390C6C", x"7EA6C37F", --10
x"278E899E", x"C611468D", x"4C19BEB8", x"AD8671AB", x"F109E7D2", x"109628C1", x"9A9ED0F4", x"7B011FE7", --11
x"3CA96604", x"DD36A917", x"573E5122", x"B6A19E31", x"EA2E0848", x"0BB1C75B", x"81B93F6E", x"6026F07D", --12
x"390EBA9C", x"D891758F", x"52998DBA", x"B30642A9", x"EF89D4D0", x"0E161BC3", x"841EE3F6", x"65812CE5", --13
x"364E779D", x"D7D1B88E", x"5DD940BB", x"BC468FA8", x"E0C919D1", x"0156D6C2", x"8B5E2EF7", x"6AC1E1E4", --14
x"33E9AB05", x"D2766416", x"587E9C23", x"B9E15330", x"E56EC549", x"04F10A5A", x"8EF9F26F", x"6F663D7C", --15
x"50358897", x"B1AA4784", x"3BA2BFB1", x"DA3D70A2", x"86B2E6DB", x"672D29C8", x"ED25D1FD", x"0CBA1EEE", --16
x"5592540F", x"B40D9B1C", x"3E056329", x"DF9AAC3A", x"83153A43", x"628AF550", x"E8820D65", x"091DC276", --17
x"5AD2990E", x"BB4D561D", x"3145AE28", x"D0DA613B", x"8C55F742", x"6DCA3851", x"E7C2C064", x"065D0F77", --18
x"5F754596", x"BEEA8A85", x"34E272B0", x"D57DBDA3", x"89F22BDA", x"686DE4C9", x"E2651CFC", x"03FAD3EF", --19
x"4452AA0C", x"A5CD651F", x"2FC59D2A", x"CE5A5239", x"92D5C440", x"734A0B53", x"F942F366", x"18DD3C75", --20
x"41F57694", x"A06AB987", x"2A6241B2", x"CBFD8EA1", x"977218D8", x"76EDD7CB", x"FCE52FFE", x"1D7AE0ED", --21
x"4EB5BB95", x"AF2A7486", x"25228CB3", x"C4BD43A0", x"9832D5D9", x"79AD1ACA", x"F3A5E2FF", x"123A2DEC", --22
x"4B12670D", x"AA8DA81E", x"2085502B", x"C11A9F38", x"9D950941", x"7C0AC652", x"F6023E67", x"179DF174", --23
x"78FBCC08", x"9964031B", x"136CFB2E", x"F2F3343D", x"AE7CA244", x"4FE36D57", x"C5EB9562", x"24745A71", --24
x"7D5C1090", x"9CC3DF83", x"16CB27B6", x"F754E8A5", x"ABDB7EDC", x"4A44B1CF", x"C04C49FA", x"21D386E9", --25
x"721CDD91", x"93831282", x"198BEAB7", x"F81425A4", x"A49BB3DD", x"45047CCE", x"CF0C84FB", x"2E934BE8", --26
x"77BB0109", x"9624CE1A", x"1C2C362F", x"FDB3F93C", x"A13C6F45", x"40A3A056", x"CAAB5863", x"2B349770", --27
x"6C9CEE93", x"8D032180", x"070BD9B5", x"E69416A6", x"BA1B80DF", x"5B844FCC", x"D18CB7F9", x"301378EA", --28
x"693B320B", x"88A4FD18", x"02AC052D", x"E333CA3E", x"BFBC5C47", x"5E239354", x"D42B6B61", x"35B4A472", --29
x"667BFF0A", x"87E43019", x"0DECC82C", x"EC73073F", x"B0FC9146", x"51635E55", x"DB6BA660", x"3AF46973", --30
x"63DC2392", x"8243EC81", x"084B14B4", x"E9D4DBA7", x"B55B4DDE", x"54C482CD", x"DECC7AF8", x"3F53B5EB"  --31
);

begin
MULTAB : process(clk, address)
    begin
        if (clk='1') then
            if (ce = '1') then
                data_out <= ROM (to_integer(unsigned(address)));
            end if;
        end if;
    end process;
end Behavioral;