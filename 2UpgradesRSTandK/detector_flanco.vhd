----------------------------------------------------------------------------------
-- DETECTOR DE FLANCO 
-- El detector tiene de entrada la linea de datos (LIN) y el reloj de 1Khz, y 
-- como salida el valor que se detecta (0 flanco de bajada o 1 si es de subida)
-- Se muestrea la señal de entrada acumulandola en el registro de desplazamiento y
-- calcula constantemente los 20 bits de ese registro. Si la suma es mayor de 15
-- se interpreta como un 1 y si disminuye el umbral de 5, es un 0.
-- Se utiliza para ignorar los posibles glitches que tenga la señal o los posibles
-- rebotes. Asi, si hay pocos rebotes sera un 0 y si ya hay muchos pues es 1.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector_flanco is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
			 LIN : in STD_LOGIC; -- Línea de datos
			 VALOR : out STD_LOGIC); -- Valor detectado en el flanco
end detector_flanco;

architecture a_detector_flanco of detector_flanco is

constant UMBRAL0 : STD_LOGIC_VECTOR (7 downto 0) := "00000101"; -- 5 umbral para el 0
constant UMBRAL1 : STD_LOGIC_VECTOR (7 downto 0) := "00001111"; -- 15 umbral para el 1

signal reg_desp : STD_LOGIC_VECTOR (19 downto 0):="00000000000000000000"; -- Registro de desplazamiento
signal suma : STD_LOGIC_VECTOR (7 downto 0) :="00000000"; -- Suma del registro de desplazamiento
signal s_valor : STD_LOGIC; -- señal de valor detectado en el flanco

begin

	process (CLK_1ms)
		begin
				if (CLK_1ms'event and CLK_1ms='1') then
					 
					 suma <= suma + LIN - reg_desp(19); -- Calcular la suma de los elementos del registro (Para ello sume la nueva muestra que llega y reste la última que sale)
					
					 reg_desp<=reg_desp(18 downto 0) & LIN; -- Ver si la suma supera los umbrales y asignar a s_valor el valor adecuado
					 
					 if (suma > UMBRAL1) then -- Si la suma supera el Umbral 1 (15) es un 1
						 s_valor<='1';
				    elsif (suma < UMBRAL0) then -- Si la suma es menor que el Umbral 0 (5) es un 0
						 s_valor<='0';
					 end if;
					 
					end if;
	end process;
	
	VALOR<=s_valor; -- Asignacion de la señal valor con la salida
	
end a_detector_flanco;
