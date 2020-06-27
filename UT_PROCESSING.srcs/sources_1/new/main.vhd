LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY main IS
    GENERIC( 
        NDATA : INTEGER := 16;
        RES : INTEGER := 2
    );
    PORT(
        rst: IN STD_LOGIC; 
        clk_radar : IN STD_LOGIC; 
        trigger_radar : IN STD_LOGIC;     
        en_acquire : IN STD_LOGIC;
        en_resolution : IN STD_LOGIC;       
        din: IN STD_LOGIC_VECTOR (11 downto 0);
        overflow: IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        hsk_rd1 : OUT STD_LOGIC;
        hsk_rd_ok1 : IN STD_LOGIC;     
        buff_wr_en : OUT STD_LOGIC 
    );
END main;

ARCHITECTURE behavioral OF main IS

    COMPONENT processing 
        GENERIC( 
            NDATA : INTEGER
        );
        PORT(
            rst: IN STD_LOGIC; 
            clk_radar : IN STD_LOGIC; 
            trigger_radar : IN STD_LOGIC;     
            en_acquire : IN STD_LOGIC;
            en_resolution : IN STD_LOGIC; 
            resolution: IN INTEGER;       
            din: IN STD_LOGIC_VECTOR (11 downto 0);
            overflow: IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            hsk_rd1 : OUT STD_LOGIC;
            hsk_rd_ok1 : IN STD_LOGIC;     
            buff_wr_en : OUT STD_LOGIC 
        );
    END COMPONENT;

BEGIN

    INST_PROCESSING : processing
        GENERIC MAP( 
            NDATA => NDATA
        )
        PORT MAP(
            rst => rst, 
            clk_radar => clk_radar,
            trigger_radar => trigger_radar,     
            en_acquire => en_acquire,
            en_resolution => en_resolution,
            resolution => RES,      
            din => din,
            overflow => overflow,
            dout => dout,
            hsk_rd1 => hsk_rd1,
            hsk_rd_ok1 => hsk_rd_ok1,  
            buff_wr_en => buff_wr_en  
        );

END behavioral;
