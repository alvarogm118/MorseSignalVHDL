----------------------------------------------------------------------------------
-- REGISTRO DE DESPLAZAMIENTO
-- Permite que los caracteres se desplacen a la izquierda cuando llega un nuevo
-- carácter. La entrada en serie y la salida en paralelo de 4 posiciones de 8 bits
-- Hay una señal de Enable que cuando vale 1 pone en funcionamiento el módulo 
-- (desplaza a la izquierda los caracteres con cada flanco de reloj y almacena en
-- QS3)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rdesp_disp is
	Port( CLK_1ms : in STD_LOGIC; -- entrada de reloj
			BTN_STOP : in STD_LOGIC; -- Señal de detencion
			RST : in STD_LOGIC; -- Señal de RST
			EN : in STD_LOGIC; -- enable
			E : in STD_LOGIC_VECTOR (7 downto 0); -- entrada de datos
			Q0 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q0
			Q1 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q1
			Q2 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q2
			Q3 : out STD_LOGIC_VECTOR (7 downto 0)); -- salida Q3
end rdesp_disp;

architecture Behavioral of rdesp_disp is

signal QS0 : STD_LOGIC_VECTOR (7 downto 0); -- señal que almacena el valor de Q0
signal QS1 : STD_LOGIC_VECTOR (7 downto 0); -- señal que almacena el valor de Q1
signal QS2 : STD_LOGIC_VECTOR (7 downto 0); -- señal que almacena el valor de Q2
signal QS3 : STD_LOGIC_VECTOR (7 downto 0); -- señal que almacena el valor de Q3

begin
  process (CLK_1ms, BTN_STOP, RST)
    begin
		if (BTN_STOP = '1' or RST = '1') then
		  QS3<="00000000";		   -- se limpian los registros para apagar todos los displays
        QS2<="00000000";                       
        QS1<="00000000";
        QS0<="00000000";

      elsif (CLK_1ms'event and CLK_1ms='1' and EN='1') then -- con cada flanco activo y EN = 1
        QS3<=QS2;		           -- se desplazan todas las salidas 
        QS2<=QS1;                       
        QS1<=QS0;
        QS0<=E;                         -- y se copia el valor de la entrada en Q0
      end if;  
  end process;
	 
  Q0<=QS0;                              -- actualización de las salidas
  Q1<=QS1;
  Q2<=QS2;
  Q3<=QS3;



end Behavioral;

