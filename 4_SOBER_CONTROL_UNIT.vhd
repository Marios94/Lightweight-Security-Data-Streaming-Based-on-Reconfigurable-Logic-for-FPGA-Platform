library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_vars.all;

entity SOBER_CONTROL_UNIT is
    Port ( 
        clk                     : in STD_LOGIC;

  --      tst_LFSR0               : out unsigned (31 downto 0);
  --      tst_LFSR1               : out unsigned (31 downto 0);
  --      tst_LFSR2               : out unsigned (31 downto 0);
  --      tst_LFSR3               : out unsigned (31 downto 0);
  --      tst_LFSR4               : out unsigned (31 downto 0);
  --      tst_LFSR5               : out unsigned (31 downto 0);
  --      tst_LFSR6               : out unsigned (31 downto 0);
  --      tst_LFSR7               : out unsigned (31 downto 0);
  --      tst_LFSR8               : out unsigned (31 downto 0);
  --      tst_LFSR9               : out unsigned (31 downto 0);
  --      tst_LFSR10              : out unsigned (31 downto 0);
  --      tst_LFSR11              : out unsigned (31 downto 0);
  --      tst_LFSR12              : out unsigned (31 downto 0);
  --      tst_LFSR13              : out unsigned (31 downto 0);
  --      tst_LFSR14              : out unsigned (31 downto 0);
  --      tst_LFSR15              : out unsigned (31 downto 0);
  --      tst_LFSR16              : out unsigned (31 downto 0);
  --      tst_Step_xor1_out       : out unsigned (31 downto 0);
  --      tst_Step_xor2_out       : out unsigned (31 downto 0);
  --      tst_Step_shift8         : out unsigned (31 downto 0);
  --      tst_Step_shift24        : out unsigned ( 7 downto 0);
  --      tst_Step_multab         : out unsigned (31 downto 0);
  --      tst_Step_and            : out unsigned ( 7 downto 0);
  --      tst_PFF_muxF            : out unsigned (31 downto 0);
  --      tst_PFF_muxG            : out unsigned (31 downto 0);
  --      tst_PFF_ADDER3          : out unsigned (31 downto 0);
  --      Sox_PFF_test            : out unsigned (31 downto 0);
  --      tst_PFF_muxp_out        : out unsigned (31 downto 0);
  --      tst_REG_konst           : out unsigned (31 downto 0);
  --      tst_mux_konst_out       : out unsigned (31 downto 0);
  --      tst_NLF_muxD            : out unsigned (31 downto 0);
  --      tst_NLF_muxE            : out unsigned (31 downto 0);
  --      tst_NLF_ADDER2          : out unsigned (31 downto 0);
  --      tst_NLF_XOR             : out unsigned (31 downto 0);
  --      tst_NLF_F1              : out unsigned (31 downto 0);
  --      tst_NLF5_SHIFT8         : out unsigned (31 downto 0);
  --      Sox_NLF_test            : out unsigned (31 downto 0);
  --      tst_NLF_muxH            : out unsigned (31 downto 0);
  --      tst_NLF_REGMUX          : out unsigned (31 downto 0);
  --      tst_Step_op_out         : out unsigned (31 downto 0);
  --      tst_NLF_out             : out unsigned (31 downto 0);
  --      tst_PFF_out             : out unsigned (31 downto 0);
  --      tst_wire0               : out unsigned (31 downto 0);
  --      tst_wire1               : out unsigned (31 downto 0);
  --      tst_wire4               : out unsigned (31 downto 0);
  --      tst_wire6               : out unsigned (31 downto 0);
  --      tst_wire13              : out unsigned (31 downto 0);
  --      tst_wire15              : out unsigned (31 downto 0);
  --      tst_wire_R4_in          : out unsigned (31 downto 0);
  --      tst_wire_R15_in         : out unsigned (31 downto 0);
  --      tst_wire16              : out unsigned (31 downto 0);
  --      tst_xor4_out            : out unsigned (31 downto 0);
		--tst_muxes_ctrl_signals	: out unsigned ( 9 downto 0);
		--tst_chip_en_ctrl_signals: out unsigned (11 downto 0);
  --      test_count1              : out integer range 0 to 300;
  --      test_count2              : out integer range 0 to 300;
  --      test_count3              : out integer range 0 to 300;
  --      test_diffuse_count      : out integer range 0 to 17;
  --      tst_all_zero            : out std_logic;

        ciphertext_out          : out unsigned (31 downto 0);

        IV_in                   : in unsigned (31 downto 0);
        Key_in                  : in unsigned (31 downto 0);
        Konst                   : in unsigned (31 downto 0);
        plaintext_in            : in unsigned (31 downto 0)
					);
end SOBER_CONTROL_UNIT;

architecture Behavioral of SOBER_CONTROL_UNIT is
	component Sober128_top is
	    Port (
        --|-----GLOBAL CLOCK-----|--
        clk              : in STD_LOGIC;
        init_mux_sel     : in STD_LOGIC;
        --|----------------------|--
        --|-LFSR CONTROL SYGNALS-|--
        --|----------------------|--
        LFSR_set        : in std_logic;
        LFSR_rst        : in std_logic;
        LFSR_ce         : in std_logic;
        LFSR_reg15_ce   : in std_logic;
        LFSR_reg4_ce    : in std_logic;
        LFSR_mux_15_sel : in std_logic;
        LFSR_mux_4_sel1 : in std_logic;
        LFSR_mux_4_sel0 : in std_logic;
        include_reg_ce  : in std_logic;
        diffuse_reg_ce  : in std_logic;
        Konst_REG_ce    : in std_logic;
        Konst_mux_sel   : in std_logic;
        --|----------------------|--
        --|STEPOP CONTROL SYGNALS|--
        --|----------------------|--
        StepOp_ce       : in std_logic;
        --|----------------------|--
        --|--PFF CONTROL SYGNALS-|--
        --|----------------------|--
        PFF_ce          : in std_logic;
        PFF_mux_sel     : in std_logic;
        Pff_mux_p_sel   : in std_logic;
        --|----------------------|--
        --|--NLF CONTROL SYGNALS-|--
        --|----------------------|--
        NLF_mux_sel_0   : in std_logic;
        NLF_mux_sel_1   : in std_logic;
        NLF_mux_H_sel_0 : in std_logic;
        NLF_mux_H_sel_1 : in std_logic;
        NLF_REG_V_ce    : in std_logic;
        NLF_REG_H_ce    : in std_logic;
        --test--
  --      test_LFSR0          : out unsigned (31 downto 0);
  --      test_LFSR1          : out unsigned (31 downto 0);
  --      test_LFSR2          : out unsigned (31 downto 0);
  --      test_LFSR3          : out unsigned (31 downto 0);
  --      test_LFSR4          : out unsigned (31 downto 0);
  --      test_LFSR5          : out unsigned (31 downto 0);
  --      test_LFSR6          : out unsigned (31 downto 0);
  --      test_LFSR7          : out unsigned (31 downto 0);
  --      test_LFSR8          : out unsigned (31 downto 0);
  --      test_LFSR9          : out unsigned (31 downto 0);
  --      test_LFSR10         : out unsigned (31 downto 0);
  --      test_LFSR11         : out unsigned (31 downto 0);
  --      test_LFSR12         : out unsigned (31 downto 0);
  --      test_LFSR13         : out unsigned (31 downto 0);
  --      test_LFSR14         : out unsigned (31 downto 0);
  --      test_LFSR15         : out unsigned (31 downto 0);
  --      test_LFSR16         : out unsigned (31 downto 0);

  --      test_Step_xor1_out  : out unsigned (31 downto 0);
  --      test_Step_xor2_out  : out unsigned (31 downto 0);
  --      test_Step_shift8    : out unsigned (31 downto 0);
  --      test_Step_shift24   : out unsigned ( 7 downto 0);
  --      test_Step_multab    : out unsigned (31 downto 0);
  --      test_Step_and       : out unsigned ( 7 downto 0);

  --      test_PFF_muxF       : out unsigned (31 downto 0);
  --      test_PFF_muxG       : out unsigned (31 downto 0);
  --      test_PFF_ADDER3     : out unsigned (31 downto 0);
  --      SBox_PFF_test       : out unsigned (31 downto 0);
  --      test_PFF_muxp_out   : out unsigned (31 downto 0);  

  --      test_mux_konst_out  : out unsigned (31 downto 0);
  --      test_REG_konst      : out unsigned (31 downto 0);
  --      test_NLF_muxD       : out unsigned (31 downto 0);
  --      test_NLF_muxE       : out unsigned (31 downto 0);
  --      test_NLF_ADDER2     : out unsigned (31 downto 0);
  --      test_NLF_XOR        : out unsigned (31 downto 0);
  --      test_NLF_F1         : out unsigned (31 downto 0);
  --      test_NLF5_SHIFT8    : out unsigned (31 downto 0);
  --      SBox_NLF_test       : out unsigned (31 downto 0);
  --      test_NLF_muxH       : out unsigned (31 downto 0);
  --      test_NLF_REGMUX     : out unsigned (31 downto 0);
		--test_Step_op_out    : out unsigned (31 downto 0);
  --      test_NLF_out        : out unsigned (31 downto 0);
  --      test_PFF_out        : out unsigned (31 downto 0);

  --      test_wire0          : out unsigned (31 downto 0);
  --      test_wire1          : out unsigned (31 downto 0);
  --      test_wire4          : out unsigned (31 downto 0);
  --      test_wire6          : out unsigned (31 downto 0);
  --      test_wire13         : out unsigned (31 downto 0);
  --      test_wire15         : out unsigned (31 downto 0);
  --      test_wire_R4_in    	: out unsigned (31 downto 0);
  --      test_wire_R15_in    : out unsigned (31 downto 0);
  --      test_wire16         : out unsigned (31 downto 0);
  --      test_xor4_out       : out unsigned (31 downto 0);
        --|----------------------|--
        --|-----INPUT SYGNALS----|--
        --|----------------------|--
        IV              : in unsigned (31 downto 0);        --|<-- SYSTEM IN
        plaintext       : in unsigned (31 downto 0);        --|<-- SYSTEM IN
        initkonst       : in unsigned (31 downto 0);        --|<-- SYSTEM IN
		x_in            : in unsigned (31 downto 0);

        --|--output signals--|--
        Vt              : out unsigned (31 downto 0);        --|--> SYSTEM OUT
        ciphertext      : out unsigned (31 downto 0)
        	);
	end component Sober128_top;

    signal konst_calc           : std_logic := '0';
    signal norm_op              : std_logic := '0';
	signal muxes_ctrl_signals 	: unsigned ( 9 downto 0);
	signal chip_en_ctrl_signals	: unsigned (11 downto 0);
    signal cnt1                 : integer range 0 to 175;
    signal cnt2                 : integer range 0 to 10;
    signal cnt3                 : integer range 0 to 300;
    signal diffuse_count        : integer range 0 to 16;
    signal encrypt_count        : integer range 0 to 4;
    signal empty                : std_logic := '0'; 
    signal ciphertext_in        : unsigned (31 downto 0);
	signal valid_out			: unsigned (31 downto 0);
    signal konst_in_sel         : std_logic := '0';
    signal Vt_out               : unsigned (31 downto 0);
begin

	SOBERTOP: component Sober128_top
		port map(
	        clk                     => clk,

			NLF_mux_H_sel_1 		=> muxes_ctrl_signals(9),
			NLF_mux_H_sel_0 		=> muxes_ctrl_signals(8),
			NLF_mux_sel_1 			=> muxes_ctrl_signals(7),
			NLF_mux_sel_0 			=> muxes_ctrl_signals(6),
			Pff_mux_p_sel 			=> muxes_ctrl_signals(5),
			PFF_mux_sel 			=> muxes_ctrl_signals(4),
			LFSR_mux_4_sel1 		=> muxes_ctrl_signals(3),
			LFSR_mux_4_sel0 		=> muxes_ctrl_signals(2),
			LFSR_mux_15_sel 		=> muxes_ctrl_signals(1),
			init_mux_sel 			=> muxes_ctrl_signals(0),

            Konst_REG_ce            => chip_en_ctrl_signals(11),
			include_reg_ce			=> chip_en_ctrl_signals(10),
			diffuse_reg_ce			=> chip_en_ctrl_signals(9),
			NLF_REG_V_ce 			=> chip_en_ctrl_signals(8),
			NLF_REG_H_ce 			=> chip_en_ctrl_signals(7),
			PFF_ce 					=> chip_en_ctrl_signals(6),
			StepOp_ce				=> chip_en_ctrl_signals(5),
			LFSR_reg4_ce 			=> chip_en_ctrl_signals(4),
			LFSR_reg15_ce 			=> chip_en_ctrl_signals(3),
			LFSR_set 				=> chip_en_ctrl_signals(2),
			LFSR_rst 				=> chip_en_ctrl_signals(1),
			LFSR_ce 				=> chip_en_ctrl_signals(0),

            Konst_mux_sel           => konst_in_sel,
	        --|-------test signals-------|--
   --     	test_LFSR0          => tst_LFSR0,
   --     	test_LFSR1          => tst_LFSR1,
   --     	test_LFSR2          => tst_LFSR2,
   --     	test_LFSR3          => tst_LFSR3,
   --     	test_LFSR4          => tst_LFSR4,
   --     	test_LFSR5          => tst_LFSR5,
   --     	test_LFSR6          => tst_LFSR6,
   --     	test_LFSR7          => tst_LFSR7,
   --     	test_LFSR8          => tst_LFSR8,
   --     	test_LFSR9          => tst_LFSR9,
   --     	test_LFSR10         => tst_LFSR10,
   --     	test_LFSR11         => tst_LFSR11,
   --     	test_LFSR12         => tst_LFSR12,
   --     	test_LFSR13         => tst_LFSR13,
   --     	test_LFSR14         => tst_LFSR14,
   --     	test_LFSR15         => tst_LFSR15,
   --     	test_LFSR16         => tst_LFSR16,
   --     	test_Step_xor1_out  => tst_Step_xor1_out,
   --     	test_Step_xor2_out  => tst_Step_xor2_out,
   --     	test_Step_shift8    => tst_Step_shift8,
   --     	test_Step_shift24	=> tst_Step_shift24,
   --     	test_Step_multab    => tst_Step_multab,
   --     	test_Step_and       => tst_Step_and,
   --     	test_PFF_muxF       => tst_PFF_muxF,
   --     	test_PFF_muxG       => tst_PFF_muxG,
   --     	test_PFF_ADDER3     => tst_PFF_ADDER3,
   --     	SBox_PFF_test       => Sox_PFF_test,
   --     	test_PFF_muxp_out   => tst_PFF_muxp_out,
   --         test_REG_konst      => tst_REG_konst,
   --         test_mux_konst_out  => tst_mux_konst_out,
   --     	test_NLF_muxD       => tst_NLF_muxD,
   --     	test_NLF_muxE       => tst_NLF_muxE,
   --     	test_NLF_ADDER2     => tst_NLF_ADDER2,
   --     	test_NLF_XOR        => tst_NLF_XOR,
   --     	test_NLF_F1         => tst_NLF_F1,
   --     	test_NLF5_SHIFT8    => tst_NLF5_SHIFT8,
   --     	SBox_NLF_test       => Sox_NLF_test,
   --     	test_NLF_muxH       => tst_NLF_muxH,
   --         test_NLF_REGMUX     => tst_NLF_REGMUX,
			--test_Step_op_out 	=> tst_Step_op_out,
			--test_NLF_out 		=> tst_NLF_out,
			--test_PFF_out 		=> tst_PFF_out,
			--test_wire0           => tst_wire0,
			--test_wire1           => tst_wire1,
			--test_wire4           => tst_wire4,
			--test_wire6           => tst_wire6,
			--test_wire13          => tst_wire13,
			--test_wire15          => tst_wire15,
			--test_wire_R4_in      => tst_wire_R4_in,
			--test_wire_R15_in     => tst_wire_R15_in,
			--test_wire16          => tst_wire16,
			--test_xor4_out        => tst_xor4_out,

            ciphertext          => ciphertext_in,
			plaintext            => plaintext_in,
			IV 					=> IV_in,
			initkonst            => Konst,
            Vt                  => Vt_out,
			x_in                 => Key_in
				);

	--tst_muxes_ctrl_signals		<= muxes_ctrl_signals;
	--tst_chip_en_ctrl_signals 	<= chip_en_ctrl_signals;
 --   test_count1                 <= cnt1;
 --   test_count2                 <= cnt2;
 --   test_count3                 <= cnt3;
 --   test_diffuse_count          <= diffuse_count;

ciphertext_out <= ciphertext_in and valid_out;

		--|----------------------------------|--
		--|----------- COUNTER --------------|--
		--|----------------------------------|--

    count_init : process(clk) is
    begin
        if rising_edge(clk) then
            
            if cnt1 < 100 then
                cnt1 <= cnt1 + 1;
            end if;
            
            if cnt1 = 67 AND diffuse_count < 16  then
                cnt1 <= 60;
                diffuse_count <= diffuse_count + 1; 
            end if;
            
            if cnt1 = 73 then
                if Vt_out(31 downto 24) /= X"00" then
                    konst_in_sel <= '1';
                else 
                    cnt1 <= 68;
                end if;
            end if;

            if cnt1 = 81 AND encrypt_count < 4  then
                cnt1 <= 75;
                encrypt_count <= encrypt_count + 1; 
            end if;
        end if;
    end process;

	cntrl_unt : process(cnt1) is
	begin
			case cnt1 is

						--|*******************************|--
						--|  INITIALIZATION MODE BEGIN    |--
						--|*******************************|--

                when 0  =>                  --|***Konstant = INITKONST***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "100000000000";
				when 1	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 2	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 3	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 4	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 5	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 6	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 7	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 8	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 9	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 10	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 11	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 12	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 13	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 14	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 15	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
				when 16	=>
					muxes_ctrl_signals 		<= "0000000000";
					chip_en_ctrl_signals 	<= "000000011001";
                when 17 =>
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000000011001";
                when 18 =>                  --|*** Include / R15+key0 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "010000000000";
                when 19 =>                  --|*** Include / R15 new loaded ***|--
                    muxes_ctrl_signals      <= "0000000010";
                    chip_en_ctrl_signals    <= "000000001000";
                when 20 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 21 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 22 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 23 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 24 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 25 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 26 =>                  --|*** Diffuse / Load Diffuse_REG ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "001000000000";
                when 27 =>                  --|*** Diffuse / Load R4 ***|--
                    muxes_ctrl_signals      <= "0000000100";
                    chip_en_ctrl_signals    <= "000000010000";

                when 28 =>                  --|*** Include / R15+key1 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "010000000000";
                when 29 =>                  --|*** Include / R15 new loaded ***|--
                    muxes_ctrl_signals      <= "0000000010";
                    chip_en_ctrl_signals    <= "000000001000";
                when 30 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 31 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 32 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 33 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 34 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 35 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 36 =>                  --|*** Diffuse / Load Diffuse_REG ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "001000000000";
                when 37 =>                  --|*** Diffuse / Load R4 ***|--
                    muxes_ctrl_signals      <= "0000000100";
                    chip_en_ctrl_signals    <= "000000010000";

                when 38 =>                  --|*** Include / R15+key2 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "010000000000";
                when 39 =>                  --|*** Include / R15 new loaded ***|--
                    muxes_ctrl_signals      <= "0000000010";
                    chip_en_ctrl_signals    <= "000000001000";
                when 40 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 41 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 42 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 43 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 44 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 45 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 46 =>                  --|*** Diffuse / Load Diffuse_REG ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "001000000000";
                when 47 =>                  --|*** Diffuse / Load R4 ***|--
                    muxes_ctrl_signals      <= "0000000100";
                    chip_en_ctrl_signals    <= "000000010000";

                when 48 =>                  --|*** Include / R15+key3 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "010000000000";
                when 49 =>                  --|*** Include / R15 new loaded ***|--
                    muxes_ctrl_signals      <= "0000000010";
                    chip_en_ctrl_signals    <= "000000001000";
                when 50 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 51 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 52 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 53 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 54 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 55 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 56 =>                  --|*** Diffuse / Load Diffuse_REG ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "001000000000";
                when 57 =>                  --|*** Diffuse / Load R4 ***|--
                    muxes_ctrl_signals      <= "0000000100";
                    chip_en_ctrl_signals    <= "000000010000";

                when 58 =>                  --|*** Include / keylen ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "010000000000";
                when 59 =>                  --|*** Include / R15 new loaded ***|--
                    muxes_ctrl_signals      <= "0000000010";
                    chip_en_ctrl_signals    <= "000000001000";

                    --|*******Diffuse x17*******|--
                when 60 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 61 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 62 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 63 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 64 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 65 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 66 =>                  --|*** Diffuse / Load Diffuse_REG ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "001000000000";
                when 67 =>                  --|*** Diffuse / Load R4 ***|--
                    muxes_ctrl_signals      <= "0000000100";
                    chip_en_ctrl_signals    <= "000000010000";

                        --|*******************************|--
                        --|      KONST CALCULATION        |--
                        --|*******************************|--

                when 68 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 69 =>                  --|*** Diffuse Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 70 =>                  --|*** Diffuse / R0+R16 ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 71 =>                  --|*** Diffuse / R1 ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 72 =>                  --|*** Diffuse / R6 ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 73 =>                  --|*** Diffuse / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000110000000";
                when 74 =>                  --|*** Konst_REG Loaded ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "100000000000";

						--|*******************************|--
						--|  INITIALIZATION MODE END      |--
						--|*******************************|--

						--|*******************************|--
						--|  NORMAL OPERATION MODE BEGIN  |--
						--|*******************************|--

                when 75 =>                  --|*** Encryption Step(R) ***|--
                    valid_out               <= x"00000000";
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000100000";
                when 76 =>                  --|*** Encryption Step(R) ***|--
                    muxes_ctrl_signals      <= "0000000001";
                    chip_en_ctrl_signals    <= "000000011001";
                when 77 =>                  --|*** Encryption / R0+R16 // MAC Accumulation / R4 + plaintext ***|--
                    muxes_ctrl_signals      <= "0000000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 78 =>                  --|*** Encryption / R1 // MAC Accumulation / f_out(shift8) + konst ***|--
                    muxes_ctrl_signals      <= "0101000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 79 =>                  --|*** Encryption / R6 // MAC Accumulation / R4_new Loaded ***|--
                    muxes_ctrl_signals      <= "1010000000";
                    chip_en_ctrl_signals    <= "000010000000";
                when 80 =>                  --|*** Encryption / R13 ***|--
                    muxes_ctrl_signals      <= "1111000000";
                    chip_en_ctrl_signals    <= "000111000000";
                when 81 =>                  --|*** Encryption / R13 ***|--
                    valid_out               <= x"ffffffff";
                    chip_en_ctrl_signals    <= "000000000000";

						--|*******************************|--
						--|   NORMAL OPERATION MODE END   |--
						--|*******************************|--

				when others => 
                    valid_out <= x"00000000";
			end case;
	end process;

end Behavioral;