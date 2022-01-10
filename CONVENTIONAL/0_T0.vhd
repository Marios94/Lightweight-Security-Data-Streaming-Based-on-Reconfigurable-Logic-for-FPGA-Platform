    --|--------SBox LUT_T------------------|--
    --|--------8-bit address, 32-bit data--|--
    --|--------ROM of 256------------------|--
    --|--------w/ chip enable, async-------|--
    --|--------SNOW 2.0--------------------|--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity T_LUT is
Port (
       clk      : in  STD_LOGIC;
       ce       : in  STD_LOGIC;
       address  : in  unsigned ( 7 downto 0);
       data_out : out unsigned (31 downto 0)
       );
end T_LUT;

architecture Behavioral of T_LUT is

type ROM_type is array (0 to 255) of unsigned (31 downto 0);

constant ROM : ROM_type := 
(
x"a56363c6", x"847c7cf8", x"997777ee", x"8d7b7bf6", x"0df2f2ff", x"bd6b6bd6", x"b16f6fde", x"54c5c591", --0
x"50303060", x"03010102", x"a96767ce", x"7d2b2b56", x"19fefee7", x"62d7d7b5", x"e6abab4d", x"9a7676ec", --1
x"45caca8f", x"9d82821f", x"40c9c989", x"877d7dfa", x"15fafaef", x"eb5959b2", x"c947478e", x"0bf0f0fb", --2
x"ecadad41", x"67d4d4b3", x"fda2a25f", x"eaafaf45", x"bf9c9c23", x"f7a4a453", x"967272e4", x"5bc0c09b", --3
x"c2b7b775", x"1cfdfde1", x"ae93933d", x"6a26264c", x"5a36366c", x"413f3f7e", x"02f7f7f5", x"4fcccc83", --4
x"5c343468", x"f4a5a551", x"34e5e5d1", x"08f1f1f9", x"937171e2", x"73d8d8ab", x"53313162", x"3f15152a", --5
x"0c040408", x"52c7c795", x"65232346", x"5ec3c39d", x"28181830", x"a1969637", x"0f05050a", x"b59a9a2f", --6
x"0907070e", x"36121224", x"9b80801b", x"3de2e2df", x"26ebebcd", x"6927274e", x"cdb2b27f", x"9f7575ea", --7
x"1b090912", x"9e83831d", x"742c2c58", x"2e1a1a34", x"2d1b1b36", x"b26e6edc", x"ee5a5ab4", x"fba0a05b", --8
x"f65252a4", x"4d3b3b76", x"61d6d6b7", x"ceb3b37d", x"7b292952", x"3ee3e3dd", x"712f2f5e", x"97848413", --9
x"f55353a6", x"68d1d1b9", x"00000000", x"2cededc1", x"60202040", x"1ffcfce3", x"c8b1b179", x"ed5b5bb6", --10
x"be6a6ad4", x"46cbcb8d", x"d9bebe67", x"4b393972", x"de4a4a94", x"d44c4c98", x"e85858b0", x"4acfcf85", --11
x"6bd0d0bb", x"2aefefc5", x"e5aaaa4f", x"16fbfbed", x"c5434386", x"d74d4d9a", x"55333366", x"94858511", --12
x"cf45458a", x"10f9f9e9", x"06020204", x"817f7ffe", x"f05050a0", x"443c3c78", x"ba9f9f25", x"e3a8a84b", --13
x"f35151a2", x"fea3a35d", x"c0404080", x"8a8f8f05", x"ad92923f", x"bc9d9d21", x"48383870", x"04f5f5f1", --14
x"dfbcbc63", x"c1b6b677", x"75dadaaf", x"63212142", x"30101020", x"1affffe5", x"0ef3f3fd", x"6dd2d2bf", --15
x"4ccdcd81", x"140c0c18", x"35131326", x"2fececc3", x"e15f5fbe", x"a2979735", x"cc444488", x"3917172e", --16
x"57c4c493", x"f2a7a755", x"827e7efc", x"473d3d7a", x"ac6464c8", x"e75d5dba", x"2b191932", x"957373e6", --17
x"a06060c0", x"98818119", x"d14f4f9e", x"7fdcdca3", x"66222244", x"7e2a2a54", x"ab90903b", x"8388880b", --18
x"ca46468c", x"29eeeec7", x"d3b8b86b", x"3c141428", x"79dedea7", x"e25e5ebc", x"1d0b0b16", x"76dbdbad", --19
x"3be0e0db", x"56323264", x"4e3a3a74", x"1e0a0a14", x"db494992", x"0a06060c", x"6c242448", x"e45c5cb8", --20
x"5dc2c29f", x"6ed3d3bd", x"efacac43", x"a66262c4", x"a8919139", x"a4959531", x"37e4e4d3", x"8b7979f2", --21
x"32e7e7d5", x"43c8c88b", x"5937376e", x"b76d6dda", x"8c8d8d01", x"64d5d5b1", x"d24e4e9c", x"e0a9a949", --22
x"b46c6cd8", x"fa5656ac", x"07f4f4f3", x"25eaeacf", x"af6565ca", x"8e7a7af4", x"e9aeae47", x"18080810", --23
x"d5baba6f", x"887878f0", x"6f25254a", x"722e2e5c", x"241c1c38", x"f1a6a657", x"c7b4b473", x"51c6c697", --24
x"23e8e8cb", x"7cdddda1", x"9c7474e8", x"211f1f3e", x"dd4b4b96", x"dcbdbd61", x"868b8b0d", x"858a8a0f", --25
x"907070e0", x"423e3e7c", x"c4b5b571", x"aa6666cc", x"d8484890", x"05030306", x"01f6f6f7", x"120e0e1c", --26
x"a36161c2", x"5f35356a", x"f95757ae", x"d0b9b969", x"91868617", x"58c1c199", x"271d1d3a", x"b99e9e27", --27
x"38e1e1d9", x"13f8f8eb", x"b398982b", x"33111122", x"bb6969d2", x"70d9d9a9", x"898e8e07", x"a7949433", --28
x"b69b9b2d", x"221e1e3c", x"92878715", x"20e9e9c9", x"49cece87", x"ff5555aa", x"78282850", x"7adfdfa5", --29
x"8f8c8c03", x"f8a1a159", x"80898909", x"170d0d1a", x"dabfbf65", x"31e6e6d7", x"c6424284", x"b86868d0", --30
x"c3414182", x"b0999929", x"772d2d5a", x"110f0f1e", x"cbb0b07b", x"fc5454a8", x"d6bbbb6d", x"3a16162c"  --31
);

begin
MULTAB : process(clk,address)
    begin
        if (clk='1') then
            if (ce = '1') then
                data_out <= ROM (to_integer(unsigned(address)));
            end if;
        end if;
    end process;
end Behavioral;
