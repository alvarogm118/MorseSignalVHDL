----------------------------------------------------------------------------------
-- VISUALIZACION 
-- Modulo de cableado de todos los elementos de Visualizacion. Se realiza la 
-- interconexion de todos los componentes (components).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity visualizacion is
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada sig. carácter
			 EN : in STD_LOGIC; -- Activación para desplazamiento
			 CLK_1ms : in STD_LOGIC; -- Entrada de reloj
			 BTN_START : in STD_LOGIC; -- Señal inicio
			 BTN_STOP : in STD_LOGIC; -- Señal detencion
			 RST : in STD_LOGIC; -- Señal de RST
			 SEG7 : out STD_LOGIC_VECTOR (0 to 6); -- Segmentos displays
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Activación displays
end visualizacion;

architecture a_visualizacion of visualizacion is

component MUX4x8
	Port ( E0 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 0
			 E1 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 1
			 E2 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 2
			 E3 : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada 3
			 S : in STD_LOGIC_VECTOR (1 downto 0); -- Señal de control
			 Y : out STD_LOGIC_VECTOR (7 downto 0)); -- Salida
end component;

component decodmorsea7s
	Port ( SIMBOLO : in STD_LOGIC_VECTOR (7 downto 0); -- Entrada del código morse
			 SEGMENTOS : out STD_LOGIC_VECTOR (0 to 6)); -- Salidas al display
end component;

component refresco
	Port ( CLK_1ms : in STD_LOGIC; -- reloj
			 BTN_START : in STD_LOGIC; -- Señal de encendido
			 BTN_STOP : in STD_LOGIC; -- Señal de apagado		 
			 RST : in STD_LOGIC; -- Señal de reset
			 S : out STD_LOGIC_VECTOR (1 downto 0); -- Control para el mux
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Control displays
end component;

component rdesp_disp
	Port ( CLK_1ms : in STD_LOGIC; -- entrada de reloj
			 BTN_STOP : in STD_LOGIC; -- Señal detencion
			 RST : in STD_LOGIC; -- Señal de RST
			 EN : in STD_LOGIC; -- enable
			 E : in STD_LOGIC_VECTOR (7 downto 0); -- entrada de datos
			 Q0 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q0
			 Q1 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q1
			 Q2 : out STD_LOGIC_VECTOR (7 downto 0); -- salida Q2
			 Q3 : out STD_LOGIC_VECTOR (7 downto 0)); -- salida Q3
end component;

signal N_Q0  : STD_LOGIC_VECTOR (7 downto 0); -- Señales que salen del rdesp al MUX
signal N_Q1  : STD_LOGIC_VECTOR (7 downto 0);
signal N_Q2  : STD_LOGIC_VECTOR (7 downto 0);
signal N_Q3  : STD_LOGIC_VECTOR (7 downto 0);

signal N_Y  : STD_LOGIC_VECTOR (7 downto 0); -- Señal que sale del MUX al decod

signal N_S  : STD_LOGIC_VECTOR (1 downto 0); -- SEñal que sale de Refresco a MUX

begin

U1 : rdesp_disp
      port map (
					CLK_1ms=>CLK_1ms,
					BTN_STOP=>BTN_STOP,
					RST=>RST,
					EN=>EN,
					E=>E0,
					Q0=>N_Q0,
               Q1=>N_Q1,
               Q2=>N_Q2,
               Q3=>N_Q3
					);
					
U2 : MUX4x8
      port map (
					E0=>N_Q0,
					E1=>N_Q1,
					E2=>N_Q2,
					E3=>N_Q3,
					S=>N_S,
					Y=>N_Y
					);
					
U3 : decodmorsea7s
      port map (
               SIMBOLO=>N_Y,
               SEGMENTOS=>SEG7
               );  

					
U4 : refresco
      port map (
					CLK_1ms=>CLK_1ms,
					BTN_START=>BTN_START,
					BTN_STOP=>BTN_STOP,
					RST=>RST,
					S=>N_S,
					AN=>AN
					);

end a_visualizacion;