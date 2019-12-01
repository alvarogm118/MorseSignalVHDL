----------------------------------------------------------------------------------
-- PRUEBA DE AUTÓMATA DE CONTROL
-- Test del autómata de control
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_aut_control IS
END test_aut_control;
 
ARCHITECTURE behavior OF test_aut_control IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT aut_control
    PORT( 
         CLK_1ms : IN  std_logic;							-- reloj de 1Khz
         VALID : IN  std_logic;								-- entrada de dato válido
         DATO : IN  std_logic;								-- dato (0 o 1)
         C0 : IN  std_logic;									-- resultado comparador de ceros
         C1 : IN  std_logic;									-- resultado comparador de unos
         CODIGO : OUT  std_logic_vector(7 downto 0);	-- código morse obtenido
         VALID_DISP : OUT  std_logic						-- validación del display
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1ms : std_logic := '0';
   signal VALID : std_logic := '0';
   signal DATO : std_logic := '0';
   signal C0 : std_logic := '0';
   signal C1 : std_logic := '0';

 	--Outputs
   signal CODIGO : std_logic_vector(7 downto 0);
   signal VALID_DISP : std_logic;

   -- Clock period definitions
   constant CLK_1ms_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: aut_control PORT MAP (
          CLK_1ms => CLK_1ms,
          VALID => VALID,
          DATO => DATO,
          C0 => C0,
          C1 => C1,
          CODIGO => CODIGO,
          VALID_DISP => VALID_DISP
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
	   VALID<='0';
		DATO<='0';
		C0<='0';
		C1<='0';
		wait for 100 ns;	
      VALID<='1';      -- PUNTO
		DATO<='1';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PAUSA
		DATO<='0';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 300 ns;
		
		VALID<='1';      -- RAYA
		DATO<='1';
		C0<='0';
		C1<='1';
      wait for 1 ns;
		VALID<='0';
		wait for 300 ns;
		
		VALID<='1';      -- ESPACIO
		DATO<='0';
		C0<='1';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 300 ns;
		
		VALID<='1';      -- RAYA
		DATO<='1';
		C0<='0';
		C1<='1';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PAUSA
		DATO<='0';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PUNTO
		DATO<='1';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PAUSA
		DATO<='0';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PUNTO
		DATO<='1';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PAUSA
		DATO<='0';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		VALID<='1';      -- PUNTO
		DATO<='1';
		C0<='0';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 300 ns;
		
		VALID<='1';      -- ESPACIO
		DATO<='0';
		C0<='1';
		C1<='0';
      wait for 1 ns;
		VALID<='0';
		wait for 100 ns;
		
		

      wait;
   end process;

END;
