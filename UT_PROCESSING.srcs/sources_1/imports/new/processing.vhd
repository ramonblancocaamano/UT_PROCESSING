----------------------------------------------------------------------------------
-- @FILE : processing.vhd 
-- @AUTHOR: BLANCO CAAMANO, RAMON. <ramonblancocaamano@gmail.com> 
-- 
-- @ABOUT: ACQUISITION & SIGNAL PRE-PROCESSING OF THE SAMPLED DATA.
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY processing is
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
END processing;

ARCHITECTURE behavioral OF processing IS

    SIGNAL processing_dout : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');  
    SIGNAL processing_wr_trigger : STD_LOGIC := '0';
    
    SIGNAL CAST_SHORT : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CAST_LONG : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL FULL : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '1');
    SIGNAL RES : INTEGER := 0;   

BEGIN

    dout <= processing_dout;  
    wr_trigger <= processing_wr_trigger;

    WITH resolution SELECT
    RES <= 1 WHEN 0,
           2 WHEN 1,
           4 WHEN 2,
           8 WHEN 3,
           16 WHEN 4,
           32 WHEN 5,
           64 WHEN 6,
           128 WHEN 7,
           256 WHEN 8,
           512 WHEN 9,
           1024 WHEN 10,
           2048 WHEN 11,
           4096 WHEN 12,
           1 WHEN OTHERS;
    
    PROCESS(rst, clk_radar, en_acquire, en_resolution, resolution, din, overflow, rd_trigger,
        processing_dout, processing_wr_trigger, CAST_SHORT, CAST_LONG, FULL, RES)
    
        VARIABLE st_enable : BOOLEAN := FALSE;
        VARIABLE counter_data : INTEGER := 0;
        VARIABLE counter_resolution : INTEGER := 1;
        
    BEGIN
        
        IF rst = '1' OR en_acquire = '0' THEN
            st_enable := FALSE;
            counter_data := 0;
            counter_resolution := 1;
            processing_wr_trigger <= '0'; 
            processing_dout <= (OTHERS => '0'); 
        ELSIF RISING_EDGE(clk_radar) THEN
            IF st_enable = FALSE AND rd_trigger = '1' THEN
                st_enable := TRUE;                    
            END IF;
            IF st_enable = TRUE AND counter_data < DATA THEN            
                IF en_resolution = '1'AND counter_resolution < RES THEN
                    counter_resolution := counter_resolution + 1;
                    processing_wr_trigger <= '0';
                    processing_dout <= (OTHERS => '0');  
                ELSE 
                    IF overflow = '1' THEN
                        processing_dout <= CAST_SHORT & FULL;
                    ELSE
                        processing_dout <= CAST_SHORT & din;
                    END IF;
                    counter_resolution := 1;
                    processing_wr_trigger <= '1'; 
                END IF;
                counter_data := counter_data + 1;
            ELSE 
                st_enable := FALSE;
                counter_data := 0;
                counter_resolution := 1;
                processing_wr_trigger <= '0'; 
                processing_dout <= (OTHERS => '0'); 
            END IF;       
        END IF;
        
    END PROCESS;

END behavioral;
