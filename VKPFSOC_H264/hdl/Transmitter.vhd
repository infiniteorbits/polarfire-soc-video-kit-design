library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity apb_ram_tx_encoder is
    Port (
        -- APB Interface
        pclk       : in  std_logic;
        presetn    : in  std_logic;
        psel       : in  std_logic;
        pwrite     : in  std_logic;
        pwdata     : in  std_logic_vector(31 downto 0);
        paddr      : in  std_logic_vector(31 downto 0);
        pslverr    : out std_logic;
        pready     : out std_logic;
        prdata     : out std_logic_vector(31 downto 0);
        
        -- Transmitter Interface
        clk_20mhz  : in  std_logic;
        start_tx   : in  std_logic;
        tx_out     : out std_logic
    );
end entity;

architecture Behavioral of apb_ram_tx_encoder is

    type state_type is (IDLE, SEND_SOF, SEND_DATA);
    signal state : state_type := IDLE;
    signal addr : integer range 0 to 255 := 0;
    signal ram : array(0 to 255) of std_logic_vector(11 downto 0);
    signal shift_reg : std_logic_vector(7 downto 0);
    signal shift_count : integer range 0 to 7 := 0;
    signal encoding_data : std_logic_vector(11 downto 0);
    signal sof_reg : std_logic_vector(7 downto 0) := "10101010"; -- Example SOF pattern

begin

    -- APB Write Process
    process(pclk)
    begin
        if rising_edge(pclk) then
            if presetn = '0' then
                prdata  <= (others => '0');
                pready  <= '0';
            elsif (psel = '1' and pwrite = '1') then
                ram(to_integer(unsigned(paddr(7 downto 0)))) <= pwdata(11 downto 0);
                pready <= '1';
            else  
                pready <= '0';
            end if;
        end if;
    end process;

    -- Transmitter State Machine
    process(clk_20mhz)
    begin
        if rising_edge(clk_20mhz) then
            case state is
                when IDLE =>
                    if start_tx = '1' then
                        shift_reg <= sof_reg;
                        shift_count <= 7;
                        state <= SEND_SOF;
                    end if;
                
                when SEND_SOF =>
                    tx_out <= shift_reg(7);
                    shift_reg <= shift_reg(6 downto 0) & '0';
                    if shift_count = 0 then
                        addr <= 0;
                        state <= SEND_DATA;
                    else
                        shift_count <= shift_count - 1;
                    end if;
                    
                when SEND_DATA =>
                    encoding_data <= ram(addr);
                    tx_out <= encoding_data(11);
                    encoding_data <= encoding_data(10 downto 0) & '0';
                    if addr = 255 then
                        state <= IDLE;
                    else
                        addr <= addr + 1;
                    end if;
            end case;
        end if;
    end process;

end architecture;
