LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD_UNSIGNED.ALL;

ENTITY counter IS
    PORT (
        dir : IN STD_LOGIC; -- set counter direction. 1: forward, 0: backward 
        counter : OUT STD_LOGIC_VECTOR; -- increment counter for each cycle
    );
END ENTITY;

ARCHITECTURE Behavioral OF counter IS
    CONSTANT COUNTETR_CEILING : STD_LOGIC_VECTOR := X"7"; -- set maximum value for counter
    signal next_counter : STD_LOGIC_VECTOR ;
BEGIN

    -- Missing synchroner Teil: Folgewert übernehmen bei positiver Taktflanke.

    -- Kombinatorik des Übergangsschaltnetzes
    IF dir = '1' THEN
        -- increase counter, move forward until ceiling value is reached. Then reset to 1.
        IF counter >= COUNTER_CEILING THEN -- when counter is the same or larger than ceiling value
            next_counter <= "001"; -- set counter to 1
        ELSE
            next_counter <= counter + 1; -- until then increment counter.
        END IF;
    ELSE
        -- decrement counter, move backward until 1 is reached. The reset to ceiling value.
        IF counter = "001" THEN -- when counter has reached 1
            next_counter <= COUNTER_CEILING; -- set counter to ceiling value
        ELSE
            next_counter <= counter - 1; -- until then decrement counter.
        END IF;
    END IF;

END ARCHITECTURE