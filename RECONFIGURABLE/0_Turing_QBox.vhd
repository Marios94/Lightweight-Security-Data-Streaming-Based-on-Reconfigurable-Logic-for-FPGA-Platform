	--|--------QBox LUT--------------------|--
	--|--------8-bit address, 32-bit data--|--
	--|--------ROM of 256------------------|--
	--|--------w/ chip enable, sync--------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Turing_QBox is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	STD_LOGIC
		);
end Turing_QBox;

architecture Behavioral of Turing_QBox is

	type ROM_type is array (0 to 255) of unsigned (31 downto 0);

	constant ROM : ROM_type :=
	(
	x"1faa1887", x"4e5e435c", x"9165c042", x"250e6ef4", --0
	x"5957ee20", x"d484fed3", x"a666c502", x"7e54e8ae", --1
	x"d12ee9d9", x"fc1f38d4", x"49829b5d", x"1b5cdf3c", --2
	x"74864249", x"da2e3963", x"28f4429f", x"c8432c35", --3
	x"4af40325", x"9fc0dd70", x"d8973ded", x"1a02dc5e", --4
	x"cd175b42", x"f10012bf", x"6694d78c", x"acaab26b", --5
	x"4ec11b9a", x"3f168146", x"c0ea8ec5", x"b38ac28f", --6
	x"1fed5c0f", x"aab4101c", x"ea2db082", x"470929e1", --7
	x"e71843de", x"508299fc", x"e72fbc4b", x"2e3915dd", --8
	x"9fa803fa", x"9546b2de", x"3c233342", x"0fcee7c3", --9
	x"24d607ef", x"8f97ebab", x"f37f859b", x"cd1f2e2f", --10
	x"c25b71da", x"75e2269a", x"1e39c3d1", x"eda56b36", --11
	x"f8c9def2", x"46c9fc5f", x"1827b3a3", x"70a56ddf", --12
	x"0d25b510", x"000f85a7", x"b2e82e71", x"68cb8816", --13
	x"8f951e2a", x"72f5f6af", x"e4cbc2b3", x"d34ff55d", --14
	x"2e6b6214", x"220b83e3", x"d39ea6f5", x"6fe041af", --15
	x"6b2f1f17", x"ad3b99ee", x"16a65ec0", x"757016c6", --16
	x"ba7709a4", x"b0326e01", x"f4b280d9", x"4bfb1418", --17
	x"d6aff227", x"fd548203", x"f56b9d96", x"6717a8c0", --18
	x"00d5bf6e", x"10ee7888", x"edfcfe64", x"1ba193cd", --19
	x"4b0d0184", x"89ae4930", x"1c014f36", x"82a87088", --20
	x"5ead6c2a", x"ef22c678", x"31204de7", x"c9c2e759", --21
	x"d200248e", x"303b446b", x"b00d9fc2", x"9914a895", --22
	x"906cc3a1", x"54fef170", x"34c19155", x"e27b8a66", --23
	x"131b5e69", x"c3a8623e", x"27bdfa35", x"97f068cc", --24
	x"ca3a6acd", x"4b55e936", x"86602db9", x"51df13c1", --25
	x"390bb16d", x"5a80b83c", x"22b23763", x"39d8a911", --26
	x"2cb6bc13", x"bf5579d7", x"6c5c2fa8", x"a8f4196e", --27
	x"bcdb5476", x"6864a866", x"416e16ad", x"897fc515", --28
	x"956feb3c", x"f6c8a306", x"216799d9", x"171a9133", --29
	x"6c2466dd", x"75eb5dcd", x"df118f50", x"e4afb226", --30
	x"26b9cef3", x"adb36189", x"8a7a19b1", x"e2c73084", --31
	x"f77ded5c", x"8b8bc58f", x"06dde421", x"b41e47fb", --32
	x"b1cc715e", x"68c0ff99", x"5d122f0f", x"a4d25184", --33
	x"097a5e6c", x"0cbf18bc", x"c2d7c6e0", x"8bb7e420", --34
	x"a11f523f", x"35d9b8a2", x"03da1a6b", x"06888c02", --35
	x"7dd1e354", x"6bba7d79", x"32cc7753", x"e52d9655", --36
	x"a9829da1", x"301590a7", x"9bc1c149", x"13537f1c", --37
	x"d3779b69", x"2d71f2b7", x"183c58fa", x"acdc4418", --38
	x"8d8c8c76", x"2620d9f0", x"71a80d4d", x"7a74c473", --39
	x"449410e9", x"a20e4211", x"f9c8082b", x"0a6b334a", --40
	x"b5f68ed2", x"8243cc1b", x"453c0ff3", x"9be564a0", --41
	x"4ff55a4f", x"8740f8e7", x"cca7f15f", x"e300fe21", --42
	x"786d37d6", x"dfd506f1", x"8ee00973", x"17bbde36", --43
	x"7a670fa8", x"5c31ab9e", x"d4dab618", x"cc1f52f5", --44
	x"e358eb4f", x"19b9e343", x"3a8d77dd", x"cdb93da6", --45
	x"140fd52d", x"395412f8", x"2ba63360", x"37e53ad0", --46
	x"80700f1c", x"7624ed0b", x"703dc1ec", x"b7366795", --47
	x"d6549d15", x"66ce46d7", x"d17abe76", x"a448e0a0", --48
	x"28f07c02", x"c31249b7", x"6e9ed6ba", x"eaa47f78", --49
	x"bbcfffbd", x"c507ca84", x"e965f4da", x"8e9f35da", --50
	x"6ad2aa44", x"577452ac", x"b5d674a7", x"5461a46a", --51
	x"6763152a", x"9c12b7aa", x"12615927", x"7b4fb118", --52
	x"c351758d", x"7e81687b", x"5f52f0b3", x"2d4254ed", --53
	x"d4c77271", x"0431acab", x"bef94aec", x"fee994cd", --54
	x"9c4d9e81", x"ed623730", x"cf8a21e8", x"51917f0b", --55
	x"a7a9b5d6", x"b297adf8", x"eed30431", x"68cac921", --56
	x"f1b35d46", x"7a430a36", x"51194022", x"9abca65e", --57
	x"85ec70ba", x"39aea8cc", x"737bae8b", x"582924d5", --58
	x"03098a5a", x"92396b81", x"18de2522", x"745c1cb8", --59
	x"a1b8fe1d", x"5db3c697", x"29164f83", x"97c16376", --60
	x"8419224c", x"21203b35", x"833ac0fe", x"d966a19a", --61
	x"aaf0b24f", x"40fda998", x"e7d52d71", x"390896a8", --62
	x"cee6053f", x"d0b0d300", x"ff99cbcc", x"065e3d40"  --63
	);

begin
	Qbox : process(clk, address)
	begin
		if (clk = '1') then
			if (ce = '1') then
				data_out <= ROM (to_integer(unsigned(address)));
			end if;
		end if;
	end process;

end Behavioral;