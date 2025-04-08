library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Transmitter is
    Port (
        -- APB Interface
        pclk       : in  std_logic;
        presetn    : in  std_logic;
        psel       : in  std_logic;
        penable		: in    std_logic ;
        pwrite     : in  std_logic;
        pwdata     : in  std_logic_vector(31 downto 0);
        paddr      : in  std_logic_vector(31 downto 0);
        pslverr    : out std_logic;
        pready     : out std_logic;
        prdata     : out std_logic_vector(31 downto 0);
        
        -- Transmitter Interface
        clk_20mhz  : in  std_logic;
        --ready_in : in  std_logic;
        tx_out     : out std_logic
    );
end entity;

architecture Behavioral of transmitter is

    -- Encoder Component Declaration
    component encoder is
        Port (
            clk_20mhz : in STD_LOGIC;
            data_in : in STD_LOGIC_VECTOR(8 downto 0); -- Address input for lookup (8-bit in this example)
            valid : in STD_LOGIC;
            data_valid : out STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR(9 downto 0)
            ); 
    end component;
    
    constant PAYLOAD_SIZE : integer := 8;
    signal ready_in: std_logic;
    type state_type is (IDLE, SEND_SOF, SEND_DATA);
    signal state : state_type := IDLE;
    type state_type2 is (idle, encode);
    signal status : state_type2 := idle;
    signal addr : integer range 0 to 10 := 0;
    signal addr2, addr3 : integer range 0 to 9 := 0;
    signal index : integer range 0 to 9 := 0;
    type ram_type is array(0 to PAYLOAD_SIZE-1) of std_logic_vector(8 downto 0);
    type ram_type1 is array(0 to PAYLOAD_SIZE-1) of std_logic_vector(9 downto 0);
    signal ram : ram_type;
    signal ram1 : ram_type1;
    signal shift_reg : std_logic_vector(9 downto 0);
    signal shift_count : integer range 0 to 9 := 0;
    signal encoding_data, sending_data : std_logic_vector(9 downto 0):= "0000000000";
    signal sof_reg : std_logic_vector(9 downto 0) := "0101010000"; -- Example SOF pattern
    signal ready : std_logic := '0';
    signal encoding_done : std_logic := '0';
    signal data_in : std_logic_vector(8 downto 0):="000000000";
    signal encoded_output : std_logic_vector(9 downto 0):="0000000000";
    signal started_transmission : std_logic := '0';
    --signal ram_valid : std_logic := '0';
    signal end_of_transmission : std_logic := '0';
    signal tx_out_reg : std_logic := '0';

begin

    -- Instantiate the Encoder
    encoder_inst : encoder
    port map (
        clk_20mhz => clk_20mhz,
        data_in   => data_in,
        valid     => ready_in,
        data_valid => ready,
        data_out  => encoded_output
    );
pslverr <= '0';
    -- APB Write Process
    process(pclk)
    begin
        if rising_edge(pclk) then
            if presetn = '0' then
                prdata  <= (others => '0');
                pready  <= '0';
            elsif (psel = '1' and pwrite = '1') then
                --ram(to_integer(unsigned(paddr(7 downto 0)))) <= '0' & pwdata(8 downto 0);
                ram(to_integer(unsigned(paddr(7 downto 0)))) <= pwdata(8 downto 0);
                ready_in <= pwdata(31);
                --start_transmission <= pwdata(10);
                --ram_valid <= pwdata(9);
                pready <= '1';
            elsif (psel = '1' and pwrite = '0') then
                prdata(0) <= encoding_done;
                prdata(1) <= started_transmission;
                pready <= '1';
                -- APB Read (optional)
            else  
                prdata <= (others =>'0');
                pready <= '0';
            end if;
        end if;
    end process;
    -- Encoding Process (Combinational)
    process(clk_20mhz)
    begin
        if rising_edge(clk_20mhz) then
           case status is
                when idle =>
                    encoding_done <= '0';
                    data_in <= ram(addr)(8 downto 0);
                    if ready_in = '1' then
                        status <= encode;
                        addr <= addr + 1;
                        data_in <= ram(addr+1)(8 downto 0);
                    end if;

                when encode =>
                    if addr < 7 then
                        data_in <= ram(addr+1)(8 downto 0);
                        ram1(addr-1) <= encoded_output;
                        addr <= addr + 1;
                    elsif addr = 7 then
                        ram1(addr-1) <= encoded_output;
                        addr <= addr + 1;
                    elsif addr = 8 then
                        ram1(addr-1) <= encoded_output;
                        addr <= addr + 1;
                    else 
                        addr <= 0;
                        encoding_done <= '1';
                        status <= idle;
                    end if;
            end case;
        end if;
    end process;
    
    -- Transmitter State Machine
    process(clk_20mhz)
    begin
        if rising_edge(pclk) then
            case state is
                when IDLE =>
                    if encoding_done = '1' then
                        shift_reg <= sof_reg;
                        shift_count <= 9;
                        state <= SEND_SOF;
                        started_transmission <= '1'; -- Notify PS that transmission started
                    end if;
                
                when SEND_SOF =>
                    tx_out_reg <= shift_reg(9);
                    shift_reg <= shift_reg(8 downto 0) & '0';
                    if shift_count = 0 then
                        addr2 <= 0;
                        encoding_data <= ram1(addr3);
                        addr3 <= addr3 + 1;
                        --sending_data <= encoding_data;
                        state <= SEND_DATA;
                    else
                        shift_count <= shift_count - 1;
                    end if;
                    
                when SEND_DATA =>
                    tx_out_reg <= encoding_data(9); 
                    if index < PAYLOAD_SIZE-1 then 
                        encoding_data <= encoding_data(8 downto 0) & '0';
                        index <= index+1;
                        state <= SEND_DATA;
                    elsif addr3 = PAYLOAD_SIZE-1 then
                        started_transmission <= '0';
                        end_of_transmission <= '1'; 
                        addr3 <= 0;
                        state <= IDLE;
                    else
                        addr3 <= addr3 + 1;
                        encoding_data <= ram1(addr3);
                        --addr3 <= addr3 + 1;
                        index <= 0;
                        state <= SEND_DATA;

                    end if;
            end case;
        end if;
    end process;
tx_out <= tx_out_reg;
end architecture;
