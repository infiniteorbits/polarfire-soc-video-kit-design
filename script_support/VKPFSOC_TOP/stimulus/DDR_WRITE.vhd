--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity DDR_WRITE is
end DDR_WRITE;

architecture behavioral of DDR_WRITE is

    component ddr_write
        port(
            apb_pin        : in std_logic;

            DDR_A          : out std_logic_vector(13 downto 0);
            DDR_ACT_N      : out std_logic;
            DDR_BA         : out std_logic_vector(1 downto 0);
            DDR_BG         : out std_logic;

            DDR_CAS_N      : out std_logic;
            DDR_CK0        : out std_logic;
            DDR_CK0_N      : out std_logic;

            DDR_CKE_0      : out std_logic;
            DDR_CS_N       : out std_logic;

            DDR_DM_N       : out std_logic_vector(1 downto 0);

            DDR_ODT_0      : out std_logic;

            DDR_RAS_N      : out std_logic;
            DDR_RESET_N_0  : out std_logic;

            DDR_SHIELD0    : out std_logic;
            DDR_SHIELD1    : out std_logic;

            DDR_WE_N       : out std_logic;

            DDR_DQS_0      : inout std_logic_vector(1 downto 0);
            DDR_DQS_N_0    : inout std_logic_vector(1 downto 0);
            DDR_DQ_0       : inout std_logic_vector(15 downto 0)
        );
    end component;
    component ddr4 is
        port (
            reset_n      : in    std_logic;
            clk_p        : in    std_logic;
            clk_n        : in    std_logic;
            cke          : in    std_logic;
            cs_n         : in    std_logic;
            act_n        : in    std_logic;
            ten          : in    std_logic;
            ras_n        : in    std_logic;
            cas_n        : in    std_logic;
            we_n         : in    std_logic;
            dm           : in    std_logic_vector(1 downto 0);
            bg           : in    std_logic_vector(1 downto 0);
            ba           : in    std_logic_vector(1 downto 0);
            sa           : in    std_logic_vector(13 downto 0);
            sa17         : in    std_logic;
            dq           : inout std_logic_vector(15 downto 0);
            dqs          : inout std_logic_vector(1 downto 0);
            dqs_n        : inout std_logic_vector(1 downto 0);
            odt          : in    std_logic;
            par_in       : in    std_logic;
            model_enable  : in    std_logic;
            mem_alert_n  : out   std_logic
        );
    end component;
   
signal DDR_A          : std_logic_vector(13 downto 0);
signal DDR_ACT_N      : std_logic;
signal DDR_BA         : std_logic_vector(1 downto 0);
signal DDR_BG         : std_logic;

signal DDR_CAS_N      : std_logic;
signal DDR_RAS_N      : std_logic;
signal DDR_WE_N       : std_logic;

signal DDR_CKE_0      : std_logic;
signal DDR_CS_N       : std_logic;

signal DDR_CK0        : std_logic;
signal DDR_CK0_N      : std_logic;

signal DDR_ODT_0      : std_logic;
signal DDR_RESET_N_0  : std_logic;

signal DDR_SHIELD0    : std_logic;
signal DDR_SHIELD1    : std_logic;

signal DDR_DM_N       : std_logic_vector(1 downto 0);

signal DDR_DQ_0       : std_logic_vector(15 downto 0);
signal DDR_DQS_0      : std_logic_vector(1 downto 0);
signal DDR_DQS_N_0    : std_logic_vector(1 downto 0);

signal DDR4_MEM_ALERT_N : std_logic;

signal apb_pin : std_logic := '0';

begin

    -- DUT instantiation
        DUT : entity work.ddr_write(RTL)
    port map (

        apb_pin        => apb_pin,

        DDR_A          => DDR_A,
        DDR_ACT_N      => DDR_ACT_N,
        DDR_BA         => DDR_BA,
        DDR_BG         => DDR_BG,

        DDR_CAS_N      => DDR_CAS_N,
        DDR_CK0        => DDR_CK0,
        DDR_CK0_N      => DDR_CK0_N,

        DDR_CKE_0      => DDR_CKE_0,
        DDR_CS_N       => DDR_CS_N,

        DDR_DM_N       => DDR_DM_N,

        DDR_ODT_0      => DDR_ODT_0,

        DDR_RAS_N      => DDR_RAS_N,
        DDR_RESET_N_0  => DDR_RESET_N_0,

        DDR_SHIELD0    => DDR_SHIELD0,
        DDR_SHIELD1    => DDR_SHIELD1,

        DDR_WE_N       => DDR_WE_N,

        DDR_DQ_0       => DDR_DQ_0,
        DDR_DQS_0      => DDR_DQS_0,
        DDR_DQS_N_0    => DDR_DQS_N_0
    );

    DDR4_MEM : component ddr4
    port map (

        reset_n      => DDR_RESET_N_0,

        clk_p        => DDR_CK0,
        clk_n        => DDR_CK0_N,

        cke          => DDR_CKE_0,
        cs_n         => DDR_CS_N,
        act_n        => DDR_ACT_N,
        ten          => '0',
        ras_n        => DDR_RAS_N,
        cas_n        => DDR_CAS_N,
        we_n         => DDR_WE_N,
        dm           => DDR_DM_N,
        bg           => "0" & DDR_BG,
        ba           => DDR_BA,
        sa           => DDR_A,
        sa17         => '0',
        dq           => DDR_DQ_0,
        dqs          => DDR_DQS_0,
        dqs_n        => DDR_DQS_N_0,

        odt          => DDR_ODT_0,
        par_in       => '0',
        model_enable => '1',
        mem_alert_n  => DDR4_MEM_ALERT_N
    );
end behavioral;

