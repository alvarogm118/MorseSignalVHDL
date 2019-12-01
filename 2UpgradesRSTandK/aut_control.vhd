----------------------------------------------------------------------------------
-- AUTOMATA DE CONTROL
-- Las entradas son el reloj de 1Khz, la señal VALID y DATO que vienen del 
-- automata de duracion y C0 y C1 que vienen de los comparadores.
-- Ademas tiene una señal de entrada de RST (reset) y el BTN_K que reaunda el 
-- automata Las salidas son el LED_K (que se activa cuando se detecta una K),
-- el CODIGO (compuesto por s_ncod, los 3 bits más significativos, y por s_cod,
-- los 5 bits menos significativos) y VALID_DISP, que valida la activacion del 
-- display. El automata espera hasta que llega un simbolo y lo va almacenando en
-- en CODIGO hasta que acaba la letra y luego valida el display.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity aut_control is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
			 RST : in STD_LOGIC; -- Señal de RST
			 BTN_K : in STD_LOGIC; -- Boton reaundar mensaje despues de K
			 LED_K : out STD_LOGIC; -- LED detecta K
			 VALID : in STD_LOGIC; -- entrada de dato válido
			 DATO : in STD_LOGIC; -- dato (0 o 1)
			 C0 : in STD_LOGIC; -- resultado comparador de ceros
			 C1 : in STD_LOGIC; -- resultado comparador de unos
			 CODIGO : out STD_LOGIC_VECTOR (7 downto 0); -- código morse obtenido
			 VALID_DISP : out STD_LOGIC); -- validación del display
end aut_control;

architecture a_aut_control of aut_control is

type STATE_TYPE is (ESPACIO,RESET,SIMBOLO,ESPERA,DETECCION); -- Estados del automata

signal ST : STATE_TYPE := RESET;  -- Estado inicial en RESET.

signal s_ncod : STD_LOGIC_VECTOR (2 downto 0):="000"; -- Nº de simbolos de s_cod 
																		-- que hay que leer.
signal s_cod : STD_LOGIC_VECTOR (4 downto 0):="00000";-- Indica el simbolo Morse.
signal n : INTEGER range 0 to 4;-- Indice para la señal s_cod.

begin

process (CLK_1ms,RST,BTN_K)				-- Reloj y señales asincronas
	begin
	if (RST = '1') then -- Si el reset se activa, pasa a RESET, actualiza n=4 y 
		ST<=RESET;		  -- Pone a 0 s_ncod y s_cod.
		n <= 4;
		s_ncod<="000";
		s_cod<="00000";
		
	elsif(BTN_K = '1') then -- Si se pulsa el boton K, se vuelve a reset
		ST<=RESET;
		
	elsif (CLK_1ms'event and CLK_1ms='1') then
		case ST is
			when SIMBOLO =>			-- Estado SIMBOLO
				s_ncod<=s_ncod+1;		-- Aumenta
				s_cod(n)<=C1; -- el resultado del comparador indica punto o raya
				n<=n-1;       -- Disminuye el indice del array s_cod.
				ST<=ESPERA;	  -- Salta a ESPERA.
				
			when ESPERA =>				-- Estado ESPERA
				if(VALID='0' or (VALID='1' and dato='0' and C0='0')) then
					ST<=ESPERA;	-- Si es una pausa (entre punto y raya), va a ESPERA
				elsif(VALID='1' and dato='0' and C0='1') then
					ST<=ESPACIO; -- Si es un espacio entre letras, va a ESPACIO
				elsif(VALID='1' and dato='1') then
					ST<=SIMBOLO; -- Si es otro simbolo, salta a SIMBOLO
				end if;
					
			when ESPACIO =>			-- Estado ESPACIO (valida display)
				if(s_ncod = "011" and s_cod = "10100") then-- Si es una K va a deteccion
					ST<=DETECCION;
				else
				ST<=RESET;				-- Va a RESET (no es una K)
				end if;
				
			when DETECCION =>			-- Estado DETECCION
				ST<=DETECCION;			-- Solo se sale de este estado cuando se pulsa BTN_K
				
			when RESET =>			  -- Estado RESET
				n <= 4;				  -- Pone el indice del array s_cod a 4
				s_ncod<="000";		  -- Reseteo s_ncod y s_cod
				s_cod<="00000";
				if (VALID='1' and dato='1' and RST='0') then -- Sale cuando llega 1 simbolo
					ST<=SIMBOLO;
				else
					ST<=RESET;		  -- Si no, permanece en RESET
				end if;
				
		end case;
	end if;
end process;

-- PARTE COMBINACIONAL
VALID_DISP<='1' when (ST=ESPACIO) else '0'; -- Solo se valida cuando llega un espacio.
LED_K<='1' when (ST=DETECCION) else '0'; -- Se activa el led en el estado DETECCION
CODIGO(4 downto 0)<= s_cod; -- Asignacion a los 5 primeros bits a CODIGO
CODIGO(7 downto 5)<= s_ncod;-- Asignacion a los 3 ultimos bits a CODIGO

end a_aut_control ;