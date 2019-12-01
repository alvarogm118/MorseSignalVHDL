----------------------------------------------------------------------------------
-- RECEPTOR
-- Modulo que contiene la descripcion arquitectural de conexiones de todo el 
-- hardware digital. Une todos los componentes descritos anteriormente.
-- Tiene de entradas el reloj de 1KHz, una linea de entrada de datos (LIN), la
-- salida de los displays (SEG7) y la activacion de cada display (AN).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity receptor is
	Port ( CLK : in STD_LOGIC; -- reloj de la FPGA
			 LIN : in STD_LOGIC; -- Línea de entrada de datos
			 SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end receptor;

architecture a_receptor of receptor is

constant UMBRAL0 : STD_LOGIC_VECTOR (15 downto 0) := "0000000011001000"; -- 200 umbral ceros
constant UMBRAL1 : STD_LOGIC_VECTOR (15 downto 0) := "0000000011001000"; -- 200 umbral unos

component div_reloj
	Port ( CLK : in STD_LOGIC; -- Entrada reloj de la FPGA 50 MHz
			 CLK_1ms : out STD_LOGIC); -- Salida reloj a 1 KHz
end component;

component detector_flanco
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
			 LIN : in STD_LOGIC; -- Línea de datos
			 VALOR : out STD_LOGIC); -- Valor detectado en el flanco
end component;

component aut_duracion
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de 1 ms
			 ENTRADA : in STD_LOGIC; -- línea de entrada de datos
			 VALID : out STD_LOGIC; -- salida de validación de dato
			 DATO : out STD_LOGIC; -- salida de dato (0 o 1)
			 DURACION : out STD_LOGIC_VECTOR (15 downto 0)); -- salida de duración del dato
end component;

component comp_16
	Port ( P : in STD_LOGIC_VECTOR (15 downto 0); -- Entrada P
			 Q : in STD_LOGIC_VECTOR (15 downto 0); -- Entrada Q
			 P_GT_Q : out STD_LOGIC); -- Salida P > Q
end component;

component aut_control
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
			 VALID : in STD_LOGIC; -- entrada de dato válido
			 DATO : in STD_LOGIC; -- dato (0 o 1)
			 C0 : in STD_LOGIC; -- resultado comparador de ceros
			 C1 : in STD_LOGIC; -- resultado comparador de unos
			 CODIGO : out STD_LOGIC_VECTOR (7 downto 0); -- código morse obtenido
			 VALID_DISP : out STD_LOGIC); -- validación del display
end component;

component visualizacion
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada siguiente carácter
			 EN : in STD_LOGIC; -- Activación para desplazamiento
			 CLK_1ms : in STD_LOGIC; -- Entrada de reloj de refresco
			 SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Salida para los displays
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Activación individual
end component;

-- Creacion de señales

signal N_CLK_1ms  : STD_LOGIC;

signal N_VALOR  : STD_LOGIC;

signal N_DATO  : STD_LOGIC;
signal N_VALID  : STD_LOGIC;
signal N_DURACION  : STD_LOGIC_VECTOR(15 downto 0);

signal N_C0  : STD_LOGIC;
signal N_C1  : STD_LOGIC;

signal N_VALID_DISP  : STD_LOGIC;
signal N_CODIGO  : STD_LOGIC_VECTOR(7 downto 0);

begin

-- Interconexiones de módulos

U1 : div_reloj
      port map (
					CLK=>CLK,
					CLK_1ms=>N_CLK_1ms
					);
					
U2 : detector_flanco
      port map (
					CLK_1ms=>N_CLK_1ms,
					LIN=>LIN,
					VALOR=>N_VALOR
					);
					
U3 : aut_duracion
      port map (
					CLK_1ms=>N_CLK_1ms,
					ENTRADA=>N_VALOR,
					VALID=>N_VALID,
					DATO=>N_DATO,
					DURACION=>N_DURACION
					);
U4 : comp_16
      port map (
					P=>N_DURACION,
					Q=>UMBRAL0,
					P_GT_Q=>N_C0
					);
U5 : comp_16
      port map (
					P=>N_DURACION,
					Q=>UMBRAL1,
					P_GT_Q=>N_C1
					);
					
U6 : aut_control
      port map (
					CLK_1ms=>N_CLK_1ms,
					VALID=>N_VALID,
					DATO=>N_DATO,
					C0=>N_C0,
					C1=>N_C1,
					CODIGO=>N_CODIGO,
					VALID_DISP=>N_VALID_DISP
					);
					
U7 : visualizacion
      port map (
					E0=>N_CODIGO,
					EN=>N_VALID_DISP,
					CLK_1ms=>N_CLK_1ms,
					SEG7=>SEG7,
					AN=>AN
					);	
					
end a_receptor;

