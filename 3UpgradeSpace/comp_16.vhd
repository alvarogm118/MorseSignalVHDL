----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- COMPARADORES
-- Son circuitos combinacionales que comparan los valores binarios de las 2 
-- entradas de 16 bits (Q y P) y generan una salida P>Q activa a nivel alto.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity comp_16 is
	Port ( P : in STD_LOGIC_VECTOR (15 downto 0); -- Entrada P
			 Q : in STD_LOGIC_VECTOR (15 downto 0); -- Entrada Q
			 P_GT_Q : out STD_LOGIC); -- Salida P > Q
end comp_16;

architecture comparador of comp_16 is

begin

	P_GT_Q <= '1' when P > Q else '0'; -- Cuando P>Q, salida igual a 1

end comparador;


