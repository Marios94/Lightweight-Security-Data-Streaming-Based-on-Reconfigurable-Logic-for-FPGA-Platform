	--|--------SBox LUT--------------------|--
	--|--------8-bit address, 32-bit data--|--
	--|--------ROM of 256------------------|--
	--|--------w/ chip enable, async-------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity Sober_SBox is
	Port (
		address		: in	unsigned ( 7 downto 0);
		data_out	: out	unsigned (31 downto 0);
		clk			: in	STD_LOGIC;
		ce			: in	std_logic
		);
end Sober_SBox;

architecture Behavioral of Sober_SBox is

	type ROM_type is array (0 to 255) of unsigned (31 downto 0);

	constant ROM : ROM_type :=
	(
	X"a3aa1887", X"d65e435c", X"0b65c042", X"800e6ef4",   -- 0
	X"fc57ee20", X"4d84fed3", X"f066c502", X"f354e8ae",   -- 1
	X"bb2ee9d9", X"281f38d4", X"1f829b5d", X"735cdf3c",   -- 2
	X"95864249", X"bc2e3963", X"a1f4429f", X"f6432c35",   -- 3
	X"f7f40325", X"3cc0dd70", X"5f973ded", X"9902dc5e",   -- 4
	X"da175b42", X"590012bf", X"dc94d78c", X"39aab26b",   -- 5
	X"4ac11b9a", X"8c168146", X"c3ea8ec5", X"058ac28f",   -- 6
	X"52ed5c0f", X"25b4101c", X"5a2db082", X"370929e1",   -- 7
	X"2a1843de", X"fe8299fc", X"202fbc4b", X"833915dd",   -- 8
	X"33a803fa", X"d446b2de", X"46233342", X"4fcee7c3",   -- 9
	X"3ad607ef", X"9e97ebab", X"507f859b", X"e81f2e2f",   -- 10
	X"c55b71da", X"d7e2269a", X"1339c3d1", X"7ca56b36",   -- 11
	X"a6c9def2", X"b5c9fc5f", X"5927b3a3", X"89a56ddf",   -- 12
	X"c625b510", X"560f85a7", X"ace82e71", X"2ecb8816",   -- 13
	X"44951e2a", X"97f5f6af", X"dfcbc2b3", X"ce4ff55d",   -- 14
	X"cb6b6214", X"2b0b83e3", X"549ea6f5", X"9de041af",   -- 15
	X"792f1f17", X"f73b99ee", X"39a65ec0", X"4c7016c6",   -- 16
	X"857709a4", X"d6326e01", X"c7b280d9", X"5cfb1418",   -- 17
	X"a6aff227", X"fd548203", X"506b9d96", X"a117a8c0",   -- 18
	X"9cd5bf6e", X"dcee7888", X"61fcfe64", X"f7a193cd",   -- 19
	X"050d0184", X"e8ae4930", X"88014f36", X"d6a87088",   -- 20
	X"6bad6c2a", X"1422c678", X"e9204de7", X"b7c2e759",   -- 21
	X"0200248e", X"013b446b", X"da0d9fc2", X"0414a895",   -- 22
	X"3a6cc3a1", X"56fef170", X"86c19155", X"cf7b8a66",   -- 23
	X"551b5e69", X"b4a8623e", X"a2bdfa35", X"c4f068cc",   -- 24
	X"573a6acd", X"6355e936", X"03602db9", X"0edf13c1",   -- 25
	X"2d0bb16d", X"6980b83c", X"feb23763", X"3dd8a911",   -- 26
	X"01b6bc13", X"f55579d7", X"f55c2fa8", X"19f4196e",   -- 27
	X"e7db5476", X"8d64a866", X"c06e16ad", X"b17fc515",   -- 28
	X"c46feb3c", X"8bc8a306", X"ad6799d9", X"571a9133",   -- 29
	X"992466dd", X"92eb5dcd", X"ac118f50", X"9fafb226",   -- 30
	X"a1b9cef3", X"3ab36189", X"347a19b1", X"62c73084",   -- 31
	X"c27ded5c", X"6c8bc58f", X"1cdde421", X"ed1e47fb",   -- 32
	X"cdcc715e", X"b9c0ff99", X"4b122f0f", X"c4d25184",   -- 33
	X"af7a5e6c", X"5bbf18bc", X"8dd7c6e0", X"5fb7e420",   -- 34
	X"521f523f", X"4ad9b8a2", X"e9da1a6b", X"97888c02",   -- 35
	X"19d1e354", X"5aba7d79", X"a2cc7753", X"8c2d9655",   -- 36
	X"19829da1", X"531590a7", X"19c1c149", X"3d537f1c",   -- 37
	X"50779b69", X"ed71f2b7", X"463c58fa", X"52dc4418",   -- 38
	X"c18c8c76", X"c120d9f0", X"afa80d4d", X"3b74c473",   -- 39
	X"d09410e9", X"290e4211", X"c3c8082b", X"8f6b334a",   -- 40
	X"3bf68ed2", X"a843cc1b", X"8d3c0ff3", X"20e564a0",   -- 41
	X"f8f55a4f", X"2b40f8e7", X"fea7f15f", X"cf00fe21",   -- 42
	X"8a6d37d6", X"d0d506f1", X"ade00973", X"efbbde36",   -- 43
	X"84670fa8", X"fa31ab9e", X"aedab618", X"c01f52f5",   -- 44
	X"6558eb4f", X"71b9e343", X"4b8d77dd", X"8cb93da6",   -- 45
	X"740fd52d", X"425412f8", X"c5a63360", X"10e53ad0",   -- 46
	X"5a700f1c", X"8324ed0b", X"e53dc1ec", X"1a366795",   -- 47
	X"6d549d15", X"c5ce46d7", X"e17abe76", X"5f48e0a0",   -- 48
	X"d0f07c02", X"941249b7", X"e49ed6ba", X"37a47f78",   -- 49
	X"e1cfffbd", X"b007ca84", X"bb65f4da", X"b59f35da",   -- 50
	X"33d2aa44", X"417452ac", X"c0d674a7", X"2d61a46a",   -- 51
	X"dc63152a", X"3e12b7aa", X"6e615927", X"a14fb118",   -- 52
	X"a151758d", X"ba81687b", X"e152f0b3", X"764254ed",   -- 53
	X"34c77271", X"0a31acab", X"54f94aec", X"b9e994cd",   -- 54
	X"574d9e81", X"5b623730", X"ce8a21e8", X"37917f0b",   -- 55
	X"e8a9b5d6", X"9697adf8", X"f3d30431", X"5dcac921",   -- 56
	X"76b35d46", X"aa430a36", X"c2194022", X"22bca65e",   -- 57
	X"daec70ba", X"dfaea8cc", X"777bae8b", X"242924d5",   -- 58
	X"1f098a5a", X"4b396b81", X"55de2522", X"435c1cb8",   -- 59
	X"aeb8fe1d", X"9db3c697", X"5b164f83", X"e0c16376",   -- 60
	X"a319224c", X"d0203b35", X"433ac0fe", X"1466a19a",   -- 61
	X"45f0b24f", X"51fda998", X"c0d52d71", X"fa0896a8",   -- 62
	X"f9e6053f", X"a4b0d300", X"d499cbcc", X"b95e3d40"    -- 63
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