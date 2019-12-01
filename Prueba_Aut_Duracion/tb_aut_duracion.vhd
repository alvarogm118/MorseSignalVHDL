----------------------------------------------------------------------------------
-- PRUEBA DE AUTÓMATA DE DURACIÓN
-- Test para el autómata medidor de duración
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_aut_duracion IS
END test_aut_duracion;
 
ARCHITECTURE behavior OF test_aut_duracion IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT aut_duracion
    PORT(
         CLK_1ms : IN  std_logic; 							 -- reloj de 1 ms
         ENTRADA : IN  std_logic; 							 -- línea de entrada de datos
         VALID : OUT  std_logic;  							 -- salida de validación de dato
         DATO : OUT  std_logic;   							 -- salida de dato (0 o 1)
         DURACION : OUT  std_logic_vector(15 downto 0) -- salida de duración del dato
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_1ms : std_logic := '0';
   signal ENTRADA : std_logic := '0';

 	--Outputs
   signal VALID : std_logic;
   signal DATO : std_logic;
   signal DURACION : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_1ms_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: aut_duracion PORT MAP (
          CLK_1ms => CLK_1ms,
          ENTRADA => ENTRADA,
          VALID => VALID,
          DATO => DATO,
          DURACION => DURACION
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
	   ENTRADA<='0';
      wait for 100 ns;	

      ENTRADA<='1';
      wait for 300 ns;	
		ENTRADA<='0';
      wait for 100 ns;	
		ENTRADA<='1';
      wait for 100 ns;	
		ENTRADA<='0';
      wait for 300 ns;	
		ENTRADA<='1';
      wait for 300 ns;	
		ENTRADA<='0';
      wait for 100 ns;	
		ENTRADA<='1';
      wait for 100 ns;	
		ENTRADA<='0';
		wait for 700 ns;
 
      
      wait;
   end process;

END;
