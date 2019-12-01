----------------------------------------------------------------------------------
-- REFRESCO
-- Este bloque controla la visualizacion sucesiva de cada carácter en cada display
-- Alterna las entradas del MUX con la activacion de cada display
-- La entrada es el reloj de 1Khz y como salidas la señal del control del MUX (S) 
-- y las entradas de activación de los displays (AN)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity refresco is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de refresco
			 S : out STD_LOGIC_VECTOR (1 downto 0); -- Control para el mux
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Control displays
end refresco;

architecture Behavioral of refresco is

signal SS  : STD_LOGIC_VECTOR (1 downto 0); -- Señal para control MUX

begin

process (CLK_1ms)
  begin
  if (CLK_1ms'event and CLK_1ms='1') then  
    SS<=SS+1;                      -- genera la secuencia 00,01,10 y 11
  end if;
  end process;

S<=SS; -- Asigna la señal SS a la salida S

AN<="0111" when SS="00" else   -- Activacion display 3
    "1011" when SS="01" else   -- Activacion display 2
    "1101" when SS="10" else   -- Activacion display 1
    "1110" when SS="11";       -- Activacion display 0

end Behavioral;