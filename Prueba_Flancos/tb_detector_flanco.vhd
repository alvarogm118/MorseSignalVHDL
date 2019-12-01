----------------------------------------------------------------------------------
-- PRUEBA DE DETECTOR DE FLANCO
-- Test para el detector de flanco
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_detector_flanco IS
END test_detector_flanco;
 
ARCHITECTURE behavior OF test_detector_flanco IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT detector_flanco
    PORT(
         CLK_1ms : IN  std_logic;				-- Reloj de 1Khz
         LIN : IN  std_logic;						-- Linea de entrada de datos
         VALOR : OUT  std_logic					-- Valor detectado en el flanco
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1ms : std_logic := '0';
   signal LIN : std_logic := '0';

 	--Outputs
   signal VALOR : std_logic;

   -- Clock period definitions
   constant CLK_1ms_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: detector_flanco PORT MAP (
          CLK_1ms => CLK_1ms,
          LIN => LIN,
          VALOR => VALOR
        );

   -- Clock process definitions
   CLK_1ms_process :process
   begin
		CLK_1ms <= '0';
		wait for CLK_1ms_period/2;
		CLK_1ms <= '1';
		wait for CLK_1ms_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	   LIN<='0';
      wait for 50 ns;	

      -- glitches
 
      LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 200 ns;
		
		-- flanco de subida con rebotes
 
      LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 200 ns;
		
		-- glitches
 
      LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 200 ns;
		
		-- flanco de bajada con rebotes
		
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 20 ns;
		LIN<='1';
		wait for 20 ns;
		LIN<='0';
		wait for 200 ns;
		
		
      wait;
   end process;

END;
