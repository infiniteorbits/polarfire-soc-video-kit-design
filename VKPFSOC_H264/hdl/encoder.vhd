library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity encoder is
    Port ( 
        clk_20mhz : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(8 downto 0); 
        valid : in STD_LOGIC;
        data_valid : out STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(9 downto 0)
        );
end encoder;

architecture Behavioral of encoder is

    signal disp : std_logic := '0'; 
    type byte_array is array (0 to 255) of std_logic_vector(11 downto 0);
    signal positive_disparity : byte_array := (
        x"18b", x"189", x"185", x"18c", x"18d", x"18a", x"186", x"18e",
        x"22b", x"229", x"225", x"22c", x"22d", x"22a", x"226", x"22e",
        x"12b", x"129", x"125", x"12c", x"12d", x"12a", x"126", x"12e",
        x"314", x"319", x"315", x"313", x"312", x"31a", x"316", x"311",
        x"0ab", x"0a9", x"0a5", x"0ac", x"0ad", x"0aa", x"0a6", x"0ae",
        x"294", x"299", x"295", x"293", x"292", x"29a", x"296", x"291",
        x"194", x"199", x"195", x"193", x"192", x"19a", x"196", x"191",
        x"074", x"079", x"075", x"073", x"072", x"07a", x"076", x"071",
        x"06b", x"069", x"065", x"06c", x"06d", x"06a", x"066", x"06e",
        x"254", x"259", x"255", x"253", x"252", x"25a", x"256", x"251",
        x"154", x"159", x"155", x"153", x"152", x"15a", x"156", x"151",
        x"344", x"349", x"345", x"343", x"342", x"34a", x"346", x"348",
        x"0d4", x"0d9", x"0d5", x"0d3", x"0d2", x"0da", x"0d6", x"0d1",
        x"2c4", x"2c9", x"2c5", x"2c3", x"2c2", x"2ca", x"2c6", x"2c8",
        x"1c4", x"1c9", x"1c5", x"1c3", x"1c2", x"1ca", x"1c6", x"1c8",
        x"28b", x"289", x"285", x"28c", x"28d", x"28a", x"286", x"28e",
        x"24b", x"249", x"245", x"24c", x"24d", x"24a", x"246", x"24e",
        x"234", x"239", x"235", x"233", x"232", x"23a", x"236", x"231",
        x"134", x"139", x"135", x"133", x"132", x"13a", x"136", x"131",
        x"324", x"329", x"325", x"323", x"322", x"32a", x"326", x"321",
        x"0b4", x"0b9", x"0b5", x"0b3", x"0b2", x"0ba", x"0b6", x"0b1",
        x"2a4", x"2a9", x"2a5", x"2a3", x"2a2", x"2aa", x"2a6", x"2a1",
        x"1a4", x"1a9", x"1a5", x"1a3", x"1a2", x"1aa", x"1a6", x"1a1",
        x"05b", x"059", x"055", x"05c", x"05d", x"05a", x"056", x"05e",
        x"0cb", x"0c9", x"0c5", x"0cc", x"0cd", x"0ca", x"0c6", x"0ce",
        x"264", x"269", x"265", x"263", x"262", x"26a", x"266", x"261",
        x"164", x"169", x"165", x"163", x"162", x"16a", x"166", x"161",
        x"09b", x"099", x"095", x"09c", x"09d", x"09a", x"096", x"09e",
        x"0e4", x"0e9", x"0e5", x"0e3", x"0e2", x"0ea", x"0e6", x"0e1",
        x"11b", x"119", x"115", x"11c", x"11d", x"11a", x"116", x"11e",
        x"21b", x"219", x"215", x"21c", x"21d", x"21a", x"216", x"21e",
        x"14b", x"149", x"145", x"14c", x"14d", x"14a", x"146", x"14e"   
    );
    signal negative_disparity : byte_array := ( 
        X"274", X"279", X"275", X"273", X"272", X"27A", X"276", X"271", X"1D4", X"1D9", 
        X"1D5", X"1D3", X"1D2", X"1DA", X"1D6", X"1D1", X"2D4", X"2D9", X"2D5", X"2D3", 
        X"2D2", X"2DA", X"2D6", X"2D1", X"31B", X"319", X"315", X"31C", X"31D", X"31A", 
        X"316", X"31E", X"354", X"359", X"355", X"353", X"352", X"35A", X"356", X"351", 
        X"29B", X"299", X"295", X"29C", X"29D", X"29A", X"296", X"29E", X"19B", X"199", 
        X"195", X"19C", X"19D", X"19A", X"196", X"19E", X"38B", X"389", X"385", X"38C", 
        X"38D", X"38A", X"386", X"38E", X"394", X"399", X"395", X"393", X"392", X"39A", 
        X"396", X"391", X"25B", X"259", X"255", X"25C", X"25D", X"25A", X"256", X"25E", 
        X"15B", X"159", X"155", X"15C", X"15D", X"15A", X"156", X"15E", X"34B", X"349", 
        X"345", X"34C", X"34D", X"34A", X"346", X"34E", X"0DB", X"0D9", X"0D5", X"0DC", 
        X"0DD", X"0DA", X"0D6", X"0DE", X"2CB", X"2C9", X"2C5", X"2CC", X"2CD", X"2CA", 
        X"2C6", X"2CE", X"1CB", X"1C9", X"1C5", X"1CC", X"1CD", X"1CA", X"1C6", X"1CE", 
        X"174", X"179", X"175", X"173", X"172", X"17A", X"176", X"171", X"1B4", X"1B9", 
        X"1B5", X"1B3", X"1B2", X"1BA", X"1B6", X"1B1", X"23B", X"239", X"235", X"23C", 
        X"23D", X"23A", X"236", X"237", X"13B", X"139", X"135", X"13C", X"13D", X"13A", 
        X"136", X"137", X"32B", X"329", X"325", X"32C", X"32D", X"32A", X"326", X"32E", 
        X"0BB", X"0B9", X"0B5", X"0BC", X"0BD", X"0BA", X"0B6", X"0B7", X"2AB", X"2A9", X"2A5", 
        X"2AC", X"2AD", X"2AA", X"2A6", X"2AE", X"1AB", X"1A9", X"1A5", X"1AC", X"1AD", 
        X"1AA", X"1A6", X"1AE", X"3A4", X"3A9", X"3A5", X"3A3", X"3A2", X"3AA", X"3A6", 
        X"3A1", X"334", X"339", X"335", X"333", X"332", X"33A", X"336", X"331", X"26B", 
        X"269", X"265", X"26C", X"26D", X"26A", X"266", X"26E", X"16B", X"169", X"165", 
        X"16C", X"16D", X"16A", X"166", X"16E", X"364", X"369", X"365", X"363", X"362", 
        X"36A", X"366", X"361", X"0EB", X"0E9", X"0E5", X"0EC", X"0ED", X"0EA", X"0E6", X"0EE", 
        X"2E4", X"2E9", X"2E5", X"2E3", X"2E2", X"2EA", X"2E6", X"2E1", X"1E4", X"1E9", 
        X"1E5", X"1E3", X"1E2", X"1EA", X"1E6", X"1E1", X"2B4", X"2B9", X"2B5", X"2B3", 
        X"2B2", X"2BA", X"2B6", X"2B1" 
        );

begin

    process(clk_20mhz)
    begin
        if rising_edge(clk_20mhz) then
            if valid = '1' then
                if data_in(8) = '0' then  -- Regular data encoding
                    if disp = '0' then
                           data_out <= positive_disparity(to_integer(unsigned(data_in(7 downto 0))))(9 downto 0);
                    else
                           data_out <= negative_disparity(to_integer(unsigned(data_in(7 downto 0))))(9 downto 0);
                    end if;
                else  -- Special character encoding
                    case data_in(7 downto 0) is
                        when "10111111" =>
                            if disp = '0' then data_out <= "0001010111"; 
                            else data_out <= "1110101000"; 
                            end if;

                        when "11011111" =>
                            if disp = '0' then data_out <= "0010010111"; 
                            else data_out <= "1101101000"; 
                            end if;

                        when "11100000" =>
                            if disp = '0' then data_out <= "1100001011"; 
                            else data_out <= "0011110100"; 
                            end if;

                        when "11100001" =>
                        
                            if disp = '0' then data_out <= "1100001010"; 
                            else data_out <= "0011111001"; 
                            end if;

                        when "11100010" =>
                            if disp = '0' then data_out <= "1100001101"; 
                            else data_out <= "0011110101"; 
                            end if;

                        when "11100011" =>
                            if disp = '0' then data_out <= "1100001001"; 
                            else data_out <= "0011110011"; 
                            end if;

                        when "11100100" =>
                            if disp = '0' then data_out <= "0100010111"; 
                            else data_out <= "0011110010"; 
                            end if;

                        when "11100101" =>
                            if disp = '0' then data_out <= "1100001011"; 
                            else data_out <= "0011111010"; 
                            end if;

                        when "11100110" =>
                            if disp = '0' then data_out <= "1100001010"; 
                            else data_out <= "0011110110"; 
                            end if;

                        when "11100111" =>
                            if disp = '0' then data_out <= "1100001101"; 
                            else data_out <= "0011111000"; 
                            end if;

                        when "11101111" =>
                            if disp = '0' then data_out <= "0100010111"; 
                            else data_out <= "1011101000"; 
                            end if;

                        when "11110111" =>
                            if disp = '0' then data_out <= "1000010111"; 
                            else data_out <= "0111101000"; 
                            end if;

                        when others =>
                            data_out <= (others => '0');  -- Default case
                    end case;
                end if;
                --disp <= ~ disp;
                data_valid <= '1';
            else
                data_valid <= '0';
            end if;
        end if;
    end process;

end Behavioral;
