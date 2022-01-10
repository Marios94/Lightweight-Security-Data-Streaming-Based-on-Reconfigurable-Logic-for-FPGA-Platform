    --|--------Multab LUT Turing-----------|--
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
           data_out : out unsigned (31 downto 0));
end Multab_ROM;

architecture Behavioral of Multab_ROM is

    type ROM_type is array (0 to 255) of unsigned (31 downto 0);

    constant ROM : ROM_type := 
    (
--    X"00000000", X"72C688E8", X"E4C15D9D", X"9607D575", --0
--    X"85CFBA77", X"F709329F", X"610EE7EA", X"13C86F02", --1
--    X"47D339EE", X"3515B106", X"A3126473", X"D1D4EC9B", --2
--    X"C21C8399", X"B0DA0B71", X"26DDDE04", X"541B56EC", --3
--    X"8EEB7291", X"FC2DFA79", X"6A2A2F0C", X"18ECA7E4", --4
--    X"0B24C8E6", X"79E2400E", X"EFE5957B", X"9D231D93", --5
--    X"C9384B7F", X"BBFEC397", X"2DF916E2", X"5F3F9E0A", --6
--    X"4CF7F108", X"3E3179E0", X"A836AC95", X"DAF0247D", --7
--    X"519BE46F", X"235D6C87", X"B55AB9F2", X"C79C311A", --8
--    X"D4545E18", X"A692D6F0", X"30950385", X"42538B6D", --9
--    X"1648DD81", X"648E5569", X"F289801C", X"804F08F4", --10
--    X"938767F6", X"E141EF1E", X"77463A6B", X"0580B283", --11
--    X"DF7096FE", X"ADB61E16", X"3BB1CB63", X"4977438B", --12
--    X"5ABF2C89", X"2879A461", X"BE7E7114", X"CCB8F9FC", --13
--    X"98A3AF10", X"EA6527F8", X"7C62F28D", X"0EA47A65", --14
--    X"1D6C1567", X"6FAA9D8F", X"F9AD48FA", X"8B6BC012", --15
--    X"A27B85DE", X"D0BD0D36", X"46BAD843", X"347C50AB", --16
--    X"27B43FA9", X"5572B741", X"C3756234", X"B1B3EADC", --17
--    X"E5A8BC30", X"976E34D8", X"0169E1AD", X"73AF6945", --18
--    X"60670647", X"12A18EAF", X"84A65BDA", X"F660D332", --19
--    X"2C90F74F", X"5E567FA7", X"C851AAD2", X"BA97223A", --20
--    X"A95F4D38", X"DB99C5D0", X"4D9E10A5", X"3F58984D", --21
--    X"6B43CEA1", X"19854649", X"8F82933C", X"FD441BD4", --22
--    X"EE8C74D6", X"9C4AFC3E", X"0A4D294B", X"788BA1A3", --23
--    X"F3E061B1", X"8126E959", X"17213C2C", X"65E7B4C4", --24
--    X"762FDBC6", X"04E9532E", X"92EE865B", X"E0280EB3", --25
--    X"B433585F", X"C6F5D0B7", X"50F205C2", X"22348D2A", --26
--    X"31FCE228", X"433A6AC0", X"D53DBFB5", X"A7FB375D", --27
--    X"7D0B1320", X"0FCD9BC8", X"99CA4EBD", X"EB0CC655", --28
--    X"F8C4A957", X"8A0221BF", X"1C05F4CA", X"6EC37C22", --29
--    X"3AD82ACE", X"481EA226", X"DE197753", X"ACDFFFBB", --30
--    X"BF1790B9", X"CDD11851", X"5BD6CD24", X"291045CC", --31
--    X"09F647F1", X"7B30CF19", X"ED371A6C", X"9FF19284", --32
--    X"8C39FD86", X"FEFF756E", X"68F8A01B", X"1A3E28F3", --33
--    X"4E257E1F", X"3CE3F6F7", X"AAE42382", X"D822AB6A", --34
--    X"CBEAC468", X"B92C4C80", X"2F2B99F5", X"5DED111D", --35
--    X"871D3560", X"F5DBBD88", X"63DC68FD", X"111AE015", --36
--    X"02D28F17", X"701407FF", X"E613D28A", X"94D55A62", --37
--    X"C0CE0C8E", X"B2088466", X"240F5113", X"56C9D9FB", --38
--    X"4501B6F9", X"37C73E11", X"A1C0EB64", X"D306638C", --39
--    X"586DA39E", X"2AAB2B76", X"BCACFE03", X"CE6A76EB", --40
--    X"DDA219E9", X"AF649101", X"39634474", X"4BA5CC9C", --41
--    X"1FBE9A70", X"6D781298", X"FB7FC7ED", X"89B94F05", --42
--    X"9A712007", X"E8B7A8EF", X"7EB07D9A", X"0C76F572", --43
--    X"D686D10F", X"A44059E7", X"32478C92", X"4081047A", --44
--    X"53496B78", X"218FE390", X"B78836E5", X"C54EBE0D", --45
--    X"9155E8E1", X"E3936009", X"7594B57C", X"07523D94", --46
--    X"149A5296", X"665CDA7E", X"F05B0F0B", X"829D87E3", --47
--    X"AB8DC22F", X"D94B4AC7", X"4F4C9FB2", X"3D8A175A", --48
--    X"2E427858", X"5C84F0B0", X"CA8325C5", X"B845AD2D", --49
--    X"EC5EFBC1", X"9E987329", X"089FA65C", X"7A592EB4", --50
--    X"699141B6", X"1B57C95E", X"8D501C2B", X"FF9694C3", --51
--    X"2566B0BE", X"57A03856", X"C1A7ED23", X"B36165CB", --52
--    X"A0A90AC9", X"D26F8221", X"44685754", X"36AEDFBC", --53
--    X"62B58950", X"107301B8", X"8674D4CD", X"F4B25C25", --54
--    X"E77A3327", X"95BCBBCF", X"03BB6EBA", X"717DE652", --55
--    X"FA162640", X"88D0AEA8", X"1ED77BDD", X"6C11F335", --56
--    X"7FD99C37", X"0D1F14DF", X"9B18C1AA", X"E9DE4942", --57
--    X"BDC51FAE", X"CF039746", X"59044233", X"2BC2CADB", --58
--    X"380AA5D9", X"4ACC2D31", X"DCCBF844", X"AE0D70AC", --59
--    X"74FD54D1", X"063BDC39", X"903C094C", X"E2FA81A4", --60
--    X"F132EEA6", X"83F4664E", X"15F3B33B", X"67353BD3", --61
--    X"332E6D3F", X"41E8E5D7", X"D7EF30A2", X"A529B84A", --62
--    X"B6E1D748", X"C4275FA0", X"52208AD5", X"20E6023D"  --63
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