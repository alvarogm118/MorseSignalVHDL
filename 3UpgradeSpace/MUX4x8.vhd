----------------------------------------------------------------------------------
-- MULTIPLEXOR 4X8
-- Este elemento permite visualizar caracteres diferentes en cada display.
-- Se introducen 4 (E1 a E3) entradas de 8 bits,hay una salida de 8 bits (Y) y la 
-- señal de control (S).
-- Este modulo se utiliza porque los 4 displays presentes en la BASYS2 comparten las
-- mismas lineas CA,CB,CC,CD,CE,CF,CG aunque poseen señales de activacion diferente.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MUX4x8 is
	 Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 0
			  E1 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 1
			  E2 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 2
			  E3 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 3
			  S : in STD_LOGIC_VECTOR (1 downto 0); -- Señal de control
			  Y : out STD_LOGIC_VECTOR (7 downto 0)); -- Salida
end MUX4x8;

architecture MUX4x8 of MUX4x8 is
begin

Y <= E0 when S="00" else  -- se selecciona la salida en función de las entradas
     E1 when S="01" else  -- de control
     E2 when S="10" else
     E3 when S="11";	  

end MUX4x8;

