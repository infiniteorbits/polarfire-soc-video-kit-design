library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity apb_ram_interface is
    generic (
        ADDR_WIDTH : integer := 8;
        DATA_WIDTH : integer := 8
    );
    port (
        -- APB Signals
        pclk     : in  std_logic;
        presetn  : in  std_logic;
        psel     : in  std_logic;
        pwrite   : in  std_logic;
        paddr    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        pwdata   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        pslverr  : out std_logic;
        pready   : out std_logic;
        prdata   : out std_logic_vector(DATA_WIDTH-1 downto 0);

        -- RAM Write Signals
        clk      : in  std_logic;
        valid    : in  std_logic;
        EOF      : in  std_logic;
        data_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity apb_ram_interface;

architecture Behavioral of apb_ram_interface is

    type ram_type is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    signal addr_reg : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');

begin

    -- RAM Write Process (Valid Data)
    process(clk)
    begin
        if rising_edge(clk) then
            if EOF = '1' then
                addr_reg <= (others => '0');  -- Reset address when EOF
            elsif valid = '1' then
                ram(to_integer(unsigned(addr_reg))) <= data_in;
                addr_reg <= std_logic_vector(unsigned(addr_reg) + 1);
            end if;
        end if;
    end process;

    -- APB Read Process
    process(pclk)
    begin
        if rising_edge(pclk) then
            if presetn = '0' then
                prdata  <= (others => '0');
                pready  <= '0';
                pslverr <= '0';
            elsif (psel = '1' and pwrite = '0') then  -- Read operation
                prdata  <= ram(to_integer(unsigned(paddr)));
                pready  <= '1';
            else  
                pready  <= '0';
            end if;
        end if;
    end process;

end architecture Behavioral;
