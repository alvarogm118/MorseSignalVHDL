----------------------------------------------------------------------------------
-- AUTOMATA DE DURACION
-- Tiene de entradas el reloj de 1Khz y la salida del detector de flancos. Las 
-- salidas son DURACION(registro de 16 bits que guarda el numero de cilcos de 
-- contados), VALID(señal de validacion si el intervalo ha acabado) y DATO(valor
-- que indica si el intervalo está a 0 o a 1.
-- El automata cuenta los ciclos de relojs transcurridos entre dos flancos 
-- consecutivos. Se define un contador y un registro para el resultado final.
-- Dice que ha llegado el final del mensaje si la señal se mantiene a 0 mas de 600
-- milisegundos, activando VALID. En general, guarda lo que dura cada 0 ó 1.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aut_duracion is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de 1 ms
			 ENTRADA : in STD_LOGIC; -- línea de entrada de datos
			 VALID : out STD_LOGIC; -- salida de validación de dato
			 DATO : out STD_LOGIC; -- salida de dato (0 o 1)
			 DURACION : out STD_LOGIC_VECTOR (15 downto 0)); -- salida de duración del dato
end aut_duracion;

architecture a_aut_duracion of aut_duracion is

type STATE_TYPE is (CERO,ALM_CERO,VALID_CERO,UNO,ALM_UNO,VALID_UNO,VALID_FIN); -- Estados

signal ST : STATE_TYPE := CERO; -- Inicializamos el estado a CERO (Esperando a que llegue un 1).

signal cont : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000"; -- Señal contador de tiempo.
signal reg : STD_LOGIC_VECTOR (15 downto 0) :="0000000000000000"; -- Duracion de cada 0 ó 1.

begin

process (CLK_1ms) -- autómata
	begin
	if (CLK_1ms'event and CLK_1ms='1') then
		case ST is
				when CERO => 							-- Estado CERO.
						cont<=cont+1;					-- Aumenta el contador de duracion de un 0.
						if (ENTRADA='0') then 	 	-- Si no llega un 1, seguimos en CERO.
							ST<=CERO;
							if (cont > 600) then    -- Si cont>600, lo interpreta como fin de mensaje.
								ST<=VALID_FIN;			-- Pasa el estado a VALID_FIN.
							end if;
						else
							ST<=ALM_CERO;				-- Si llega un 1, salta a ALM_CERO.
						end if;
				when ALM_CERO =>						-- Estado ALM_CERO.
						reg<=cont;						-- Guarda la duracion del 0 que se estaba contando.
						cont<="0000000000000000";	-- Resetea el contador.
						ST<=VALID_CERO;     			-- Pasa al estado VALID_CERO.
				when VALID_CERO =>					-- Estado VALID_CERO.
						ST<=UNO;							-- Valida el 0 de antes y pasa al estado UNO.
				when UNO =>								-- Estado UNO.
						cont<=cont+1;					-- Aumenta el contador de duracion de un 1.
						if (ENTRADA='1') then		-- Si sigue llegando un uno, se mantiene en UNO.
							ST<=UNO;						
						else
							ST<=ALM_UNO;				-- Si llega un 0, salta a ALM_UNO.
						end if;
				when  ALM_UNO =>						-- Estado ALM_UNO
						reg<=cont;						-- Guarda la duracion del 1 que se estaba contando.
						cont<="0000000000000000";	-- Resetea el contador.
						ST<=VALID_UNO;					-- Pasa al estado VALID_UNO.
				when VALID_UNO =>						-- Estado VALID_UNO
						ST<=CERO;						-- Valida el 1 de antes y pasa al estado CERO.
				when VALID_FIN =>						-- Estado VALID_FIN
						reg<=cont;						-- Guarda el valor del contador en el registro. 
						cont<="0000000000000000";	-- Resetea al contador
						ST<=CERO;						-- Vuelve a CERO a esperar un mensaje nuevo.
		end case;
	end if;
end process;

-- PARTE COMBINACIONAL

VALID<='1' when (ST=VALID_CERO or ST=VALID_UNO or ST=VALID_FIN) else '0'; -- Validacion de Dato
DATO <='1' when (ST=UNO or ST=ALM_UNO or ST=VALID_UNO) else '0';	-- Asignacion de Dato
DURACION<= reg; -- Asignacion de la Duracion de 0 ó 1 con la señal registro

end a_aut_duracion;

