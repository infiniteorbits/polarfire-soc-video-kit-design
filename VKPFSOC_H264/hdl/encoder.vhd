library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity encoder is
    Port ( address : in STD_LOGIC_VECTOR(7 downto 0); -- Address input for lookup (8-bit in this example)
           data_out : out STD_LOGIC_VECTOR(11 downto 0)); -- 12-bit data output
end encoder;

architecture Behavioral of encoder is

    -- Define the lookup table with the provided values
    type positive_disparity is array (0 to 255) of STD_LOGIC_VECTOR(9 downto 0);
    signal lut : lut_type := (
        x"18b", x"189", x"185", x"18c", x"18d", x"18a", x"186", x"18e",
        x"22b", x"229", x"225", x"22c", x"22d", x"22a", x"226", x"22e",
        x"12b", x"129", x"125", x"12c", x"12d", x"12a", x"126", x"12e",
        x"314", x"319", x"315", x"313", x"312", x"31a", x"316", x"311",
        x"ab", x"a9", x"a5", x"ac", x"ad", x"aa", x"a6", x"ae",
        x"294", x"299", x"295", x"293", x"292", x"29a", x"296", x"291",
        x"194", x"199", x"195", x"193", x"192", x"19a", x"196", x"191",
        x"74", x"79", x"75", x"73", x"72", x"7a", x"76", x"71",
        x"6b", x"69", x"65", x"6c", x"6d", x"6a", x"66", x"6e",
        x"254", x"259", x"255", x"253", x"252", x"25a", x"256", x"251",
        x"154", x"159", x"155", x"153", x"152", x"15a", x"156", x"151",
        x"344", x"349", x"345", x"343", x"342", x"34a", x"346", x"348",
        x"d4", x"d9", x"d5", x"d3", x"d2", x"da", x"d6", x"d1",
        x"2c4", x"2c9", x"2c5", x"2c3", x"2c2", x"2ca", x"2c6", x"2c8",
        x"1c4", x"1c9", x"1c5", x"1c3", x"1c2", x"1ca", x"1c6", x"1c8",
        x"28b", x"289", x"285", x"28c", x"28d", x"28a", x"286", x"28e",
        x"24b", x"249", x"245", x"24c", x"24d", x"24a", x"246", x"24e",
        x"234", x"239", x"235", x"233", x"232", x"23a", x"236", x"231",
        x"134", x"139", x"135", x"133", x"132", x"13a", x"136", x"131",
        x"324", x"329", x"325", x"323", x"322", x"32a", x"326", x"321",
        x"b4", x"b9", x"b5", x"b3", x"b2", x"ba", x"b6", x"b1",
        x"2a4", x"2a9", x"2a5", x"2a3", x"2a2", x"2aa", x"2a6", x"2a1",
        x"1a4", x"1a9", x"1a5", x"1a3", x"1a2", x"1aa", x"1a6", x"1a1",
        x"5b", x"59", x"55", x"5c", x"5d", x"5a", x"56", x"5e",
        x"cb", x"c9", x"c5", x"cc", x"cd", x"ca", x"c6", x"ce",
        x"264", x"269", x"265", x"263", x"262", x"26a", x"266", x"261",
        x"164", x"169", x"165", x"163", x"162", x"16a", x"166", x"161",
        x"9b", x"99", x"95", x"9c", x"9d", x"9a", x"96", x"9e",
        x"e4", x"e9", x"e5", x"e3", x"e2", x"ea", x"e6", x"e1",
        x"11b", x"119", x"115", x"11c", x"11d", x"11a", x"116", x"11e",
        x"21b", x"219", x"215", x"21c", x"21d", x"21a", x"216", x"21e",
        x"14b", x"149", x"145", x"14c", x"14d", x"14a", x"146", x"14e"   
    );

    type negative_disparity is array (0 to 255) of STD_LOGIC_VECTOR(9 downto 0);
    signal lut : lut_type := ( 
        0x274, 0x279, 0x275, 0x273, 0x272, 0x27a, 0x276, 0x271, 0x1d4, 0x1d9, 
        0x1d5, 0x1d3, 0x1d2, 0x1da, 0x1d6, 0x1d1, 0x2d4, 0x2d9, 0x2d5, 0x2d3, 
        0x2d2, 0x2da, 0x2d6, 0x2d1, 0x31b, 0x319, 0x315, 0x31c, 0x31d, 0x31a, 
        0x316, 0x31e, 0x354, 0x359, 0x355, 0x353, 0x352, 0x35a, 0x356, 0x351, 
        0x29b, 0x299, 0x295, 0x29c, 0x29d, 0x29a, 0x296, 0x29e, 0x19b, 0x199, 
        0x195, 0x19c, 0x19d, 0x19a, 0x196, 0x19e, 0x38b, 0x389, 0x385, 0x38c, 
        0x38d, 0x38a, 0x386, 0x38e, 0x394, 0x399, 0x395, 0x393, 0x392, 0x39a, 
        0x396, 0x391, 0x25b, 0x259, 0x255, 0x25c, 0x25d, 0x25a, 0x256, 0x25e, 
        0x15b, 0x159, 0x155, 0x15c, 0x15d, 0x15a, 0x156, 0x15e, 0x34b, 0x349, 
        0x345, 0x34c, 0x34d, 0x34a, 0x346, 0x34e, 0xdb, 0xd9, 0xd5, 0xdc, 
        0xdd, 0xda, 0xd6, 0xde, 0x2cb, 0x2c9, 0x2c5, 0x2cc, 0x2cd, 0x2ca, 
        0x2c6, 0x2ce, 0x1cb, 0x1c9, 0x1c5, 0x1cc, 0x1cd, 0x1ca, 0x1c6, 0x1ce, 
        0x174, 0x179, 0x175, 0x173, 0x172, 0x17a, 0x176, 0x171, 0x1b4, 0x1b9, 
        0x1b5, 0x1b3, 0x1b2, 0x1ba, 0x1b6, 0x1b1, 0x23b, 0x239, 0x235, 0x23c, 
        0x23d, 0x23a, 0x236, 0x237, 0x13b, 0x139, 0x135, 0x13c, 0x13d, 0x13a, 
        0x136, 0x137, 0x32b, 0x329, 0x325, 0x32c, 0x32d, 0x32a, 0x326, 0x32e, 
        0xbb, 0xb9, 0xb5, 0xbc, 0xbd, 0xba, 0xb6, 0xb7, 0x2ab, 0x2a9, 0x2a5, 
        0x2ac, 0x2ad, 0x2aa, 0x2a6, 0x2ae, 0x1ab, 0x1a9, 0x1a5, 0x1ac, 0x1ad, 
        0x1aa, 0x1a6, 0x1ae, 0x3a4, 0x3a9, 0x3a5, 0x3a3, 0x3a2, 0x3aa, 0x3a6, 
        0x3a1, 0x334, 0x339, 0x335, 0x333, 0x332, 0x33a, 0x336, 0x331, 0x26b, 
        0x269, 0x265, 0x26c, 0x26d, 0x26a, 0x266, 0x26e, 0x16b, 0x169, 0x165, 
        0x16c, 0x16d, 0x16a, 0x166, 0x16e, 0x364, 0x369, 0x365, 0x363, 0x362, 
        0x36a, 0x366, 0x361, 0xeb, 0xe9, 0xe5, 0xec, 0xed, 0xea, 0xe6, 0xee, 
        0x2e4, 0x2e9, 0x2e5, 0x2e3, 0x2e2, 0x2ea, 0x2e6, 0x2e1, 0x1e4, 0x1e9, 
        0x1e5, 0x1e3, 0x1e2, 0x1ea, 0x1e6, 0x1e1, 0x2b4, 0x2b9, 0x2b5, 0x2b3, 
        0x2b2, 0x2ba, 0x2b6, 0x2b1
    );
begin
    -- Process to perform the lookup
    process(clk_20mhz)
    begin
        if rising_edge(clk_20mhz) then
            if valid = '1' then
                if k = '0' then  -- Regular data encoding
                    if disp = '0' then
                        data_out <= positive_disparity(to_integer(unsigned(data_in)));  -- Positive disparity
                    else
                        data_out <= negative_disparity(to_integer(unsigned(data_in)));  -- Negative disparity
                    end if;
                else  -- Special character encoding
                    case data_in is
                        when "10111111" =>
                            if disp = '0' then data_out <= "000101011111"; 
                            else data_out <= "111010100000"; 
                            end if;

                        when "11011111" =>
                            if disp = '0' then data_out <= "001001011111"; 
                            else data_out <= "110110100000"; 
                            end if;

                        when "11100000" =>
                            if disp = '0' then data_out <= "110000101111"; 
                            else data_out <= "001111010000"; 
                            end if;

                        when "11100001" =>
                            if disp = '0' then data_out <= "110000101010"; 
                            else data_out <= "001111100100"; 
                            end if;

                        when "11100010" =>
                            if disp = '0' then data_out <= "110000110101"; 
                            else data_out <= "001111010101"; 
                            end if;

                        when "11100011" =>
                            if disp = '0' then data_out <= "110000100110"; 
                            else data_out <= "001111001101"; 
                            end if;

                        when "11100100" =>
                            if disp = '0' then data_out <= "010001011111"; 
                            else data_out <= "001111001010"; 
                            end if;

                        when "11100101" =>
                            if disp = '0' then data_out <= "110000101111"; 
                            else data_out <= "001111101010"; 
                            end if;

                        when "11100110" =>
                            if disp = '0' then data_out <= "110000101011"; 
                            else data_out <= "001111011011"; 
                            end if;

                        when "11100111" =>
                            if disp = '0' then data_out <= "110000110110"; 
                            else data_out <= "001111100001"; 
                            end if;

                        when "11101111" =>
                            if disp = '0' then data_out <= "010001011111"; 
                            else data_out <= "101110100000"; 
                            end if;

                        when "11110111" =>
                            if disp = '0' then data_out <= "100001011111"; 
                            else data_out <= "011110100000"; 
                            end if;

                        when others =>
                            data_out <= (others => '0');  -- Default case
                    end case;
                end if;
                data_valid <= '1';
            else
                data_valid <= '0';
            end if;
        end if;
    end process;

end Behavioral;
