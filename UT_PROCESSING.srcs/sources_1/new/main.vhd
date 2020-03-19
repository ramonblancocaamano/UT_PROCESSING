LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY main IS
    GENERIC( 
        DATA : INTEGER := 16;
        RES : INTEGER := 2
    );
    PORT(
        rst: IN STD_LOGIC; 
        radar_clk : IN STD_LOGIC;      
        en_acquire : IN STD_LOGIC;
        sw_resolution : IN STD_LOGIC;       
        radar_din: IN STD_LOGIC_VECTOR (11 downto 0);
        radar_overflow: IN STD_LOGIC;
        f_ref_81_din : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        radar_trigger : IN STD_LOGIC;
        dram_trigger : OUT STD_LOGIC
    );
END main;

ARCHITECTURE behavioral OF main IS

    COMPONENT processing 
        GENERIC( 
            DATA : INTEGER
        );
        PORT(
            rst: IN STD_LOGIC; 
            clk_radar : IN STD_LOGIC;      
            en_acquire : IN STD_LOGIC;
            en_resolution : IN STD_LOGIC; 
            resolution: IN INTEGER;       
            din: IN STD_LOGIC_VECTOR (11 downto 0);
            overflow: IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            rd_trigger : IN STD_LOGIC;
            wr_trigger : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    INST_PROCESSING : processing
        GENERIC MAP( 
            DATA => DATA
        )
        PORT MAP(
            rst => rst,
            clk_radar => radar_clk,            
            en_acquire => en_acquire,
            en_resolution =>  sw_resolution,    
            resolution => RES,
            din => radar_din,
            overflow => radar_overflow,
            dout => f_ref_81_din,
            rd_trigger => radar_trigger,
            wr_trigger => dram_trigger     
        );

END behavioral;
