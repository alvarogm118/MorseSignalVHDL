----------------------------------------------------------------------------------
-- REFRESCO
-- Este bloque controla la visualizacion sucesiva de cada carácter en cada display
-- Alterna las entradas del MUX con la activacion de cada display
-- La entrada es el reloj de 1Khz, BTN_START(Encender los displays)
-- , BTN_STOP(apagar los displays), RST (Señal de Reset)  
-- y como salidas la señal del control del MUX (S) y las entradas de activación 
-- de los displays (AN).
-- Para la mejora nos creamos un automata para los displays
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity refresco is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de refresco
			 BTN_START : in STD_LOGIC; -- Señal de encendido
			 BTN_STOP : in STD_LOGIC; -- Señal de apagado
			 RST : in STD_LOGIC; -- Señal de reset
			 S : out STD_LOGIC_VECTOR (1 downto 0); -- Control para el mux
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Control displays
end refresco;

architecture Behavioral of refresco is

type STATE_TYPE is (ENCENDIDO,APAGADO); -- Estados del automata de los displays

signal ST : STATE_TYPE := APAGADO; -- Comienzan apagados
signal SS  : STD_LOGIC_VECTOR (1 downto 0); -- Señal para control MUX

begin

process (CLK_1ms, BTN_START, BTN_STOP, RST) -- Reloj y elementos asíncronos
  begin
  if (CLK_1ms'event and CLK_1ms='1') then  
    SS<=SS+1;                      -- genera la secuencia 00,01,10 y 11
  end if;
  
  case ST is
		when ENCENDIDO=>    						-- Estado ENCENDIDO
				if (RST = '1') then				-- Si se activa el RST(max prioridad)
														-- se apagan los displays sin mas, el
														-- mensaje no se detiene.
					AN<="1111";						-- Apagado de los displays
					ST<=ENCENDIDO;					-- Se sigue en encendido(del mensaje,
														-- no de los displays).
				elsif(BTN_STOP = '1') then		-- Si se detiene el mensaje(2a max 
														-- prioridad) se apagan los displays
														-- y se pasa a estado apagado
					AN<="1111";						-- apagado displays
					ST<=APAGADO;					-- Pasar a apagado (no hay mensaje)
					
				else									-- Seleccion de display cada 1ms
					if(SS = "00") then		
						AN<="0111";
				   elsif(SS = "01") then
						AN<="1011";
					elsif(SS = "10") then
						AN<="1101";
					elsif(SS = "11") then
						AN<="1110";
					end if;
					ST<=ENCENDIDO;
				end if;
				
		when APAGADO =>							-- Estado APAGADO
				AN<="1111";							-- Displays apagados
				if (RST = '1') then				-- Si hay reset nos mantenemos ahi
					ST<=APAGADO;
					
				elsif(BTN_START = '1') then	-- Si se pulsa BTN_START se enciende
					ST<=ENCENDIDO;
					
				else
					ST<=APAGADO;					-- Si no nos quedamos en el estado
				end if;
	end case;
	
  end process;

S<=SS; -- Asignacion de la señal

end Behavioral;