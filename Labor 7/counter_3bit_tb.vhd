LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE std.env.finish;

ENTITY counter_3bit_tb IS
    -- empty
END counter_3bit_tb;

ARCHITECTURE Behavioral OF counter_3bit_tb IS
    COMPONENT counter_3bit
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enb : IN STD_LOGIC;
            dir : IN STD_LOGIC;
            ceil : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT CLK_PERIOD : TIME := 10ns; -- Periodendauer fuer clk
    SIGNAL clk_count : INTEGER := 0; -- Zaehler fuer durchlaufene Taktzyklen
    SIGNAL clk, rst, dir, enb : STD_LOGIC;
    SIGNAL ceil, count : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    -- DUT instanziieren
    DUT : counter_3bit PORT MAP(
        clk => clk,
        rst => rst,
        enb => enb,
        ceil => ceil,
        dir => dir,
        count => count
    );

    -- Taktgenerator mit Zaehler fuer Taktzyklen
    clk_generator : PROCESS BEGIN
        clk <= '0';
        WAIT FOR CLK_PERIOD/2;
        clk <= '1';
        WAIT FOR CLK_PERIOD/2;
        clk_count <= clk_count + 1; -- Taktzyklen zaehlen
    END PROCESS;

    -- Den Zaehler testen
    test_process : PROCESS (clk_count) IS BEGIN
        CASE clk_count IS
                ----------------------
                -- enb testen
                ----------------------
            WHEN 0 => -- Vor der ersten Taktlanke
                rst <= '1', '0' AFTER 2ns; -- DUT zuruecksetzen, count ist 0
                enb <= '1'; -- enable 1 setzen
                dir <= '1'; -- dir 1 setzen (vorwaerts)
                ceil <= "111"; -- ceil auf 7 setzen
            WHEN 2 => -- nach zweiter Taktflanke
                -- enb war 1, count muss 2 sein
                ASSERT count = "010" REPORT "enb test failed" SEVERITY failure;
                enb <= '0'; --enb 0 setzen
            WHEN 3 => -- nach dritter Taktflanke
                -- enb war 0, count muss immernoch 2 sein
                ASSERT count = "010" REPORT "enb test failed" SEVERITY failure;
                ----------------------
                -- ceil und dir testen
                ----------------------
                rst <= '1', '0' AFTER 2ns; -- DUT zuruecksetzen, count ist 0
                enb <= '1'; -- enb auf 1 setzen
                ceil <= "101"; -- ceil auf 5 setzten
                dir <= '1'; -- dir 1 setzen (vorwaerts)
            WHEN 9 => -- nach neunter Taktflanke
                -- count muss nun 0->1->2->3->4->5->1 sein
                ASSERT count = "001" REPORT "ceil test failed" SEVERITY failure;
                dir <= '0'; --dir low schalten (rueckwaerts)
            WHEN 10 => -- nach zehnter Taktflanke
                -- count muss nun 1->5 sein (rueckwaerts)
                ASSERT count = "101" REPORT "ceil test failed" SEVERITY failure;
            WHEN 11 => -- nach elfter Taktflanke
                finish; --sim beenden
            WHEN OTHERS => -- nichts tun
        END CASE;
    END PROCESS;
END Behavioral;