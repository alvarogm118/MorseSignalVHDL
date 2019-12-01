----------------------------------------------------------------------------------
-- MAIN
-- Modulo principal que realiza el conexionado de GEN_SENAL y RECEPTOR.
-- Tiene de entradas el reloj de la FPGA, BTN_START(boton para empezar el mensaje)
-- , BTN_STOP(boton para detener el mensaje), RST (Señal de Reset) 
-- LIN (linea de entrada de datos) y BTN_K(Reanuda mensaje despues de una K).
-- Como salidas, AN(activacion de cada display), SEG7(Controla los segmentos de 
-- los diplays, y LED_K (se activa cuando se detecta una K). SPI_CLK, SPI_DIN y 
-- SPI_CS1 (que controlan el convertidor de DAC que genera la señal analogica).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
		Port ( CLK : in STD_LOGIC; -- Reloj FPGA
				 BTN_START : in STD_LOGIC; -- Boton inicio
				 BTN_STOP : in STD_LOGIC; -- Boton pausa
				 RST : in STD_LOGIC; -- Señal de RST
				 BTN_K : in STD_LOGIC; -- Boton reaundar mensaje despues de K
				 LED_K : out STD_LOGIC; -- LED detecta K
				 SPI_CLK : out STD_LOGIC; -- Control DAC
				 SPI_DIN : out STD_LOGIC; -- Control DAC
				 SPI_CS1 : out STD_LOGIC; -- Control DAC
				 LIN : in STD_LOGIC; -- Línea de entrada de datos
				 AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación displays
				 SEG7 : out STD_LOGIC_VECTOR (0 to 6)); -- Salida para los displays
end main;

architecture a_main of main is

component gen_senal
		Port ( CLK : in STD_LOGIC; -- Reloj FPGA
				 BTN_START : in STD_LOGIC; -- Boton inicio
				 BTN_STOP : in STD_LOGIC; -- Boton pausa
				 SPI_CLK : out STD_LOGIC; -- Control DAC
				 SPI_DIN : out STD_LOGIC; -- Control DAC
				 SPI_CS1 : out STD_LOGIC); -- Control DAC
end component;

component receptor
		Port ( CLK : in STD_LOGIC; -- reloj de la FPGA
				 LIN : in STD_LOGIC; -- Línea de entrada de datos
				 BTN_START : in STD_LOGIC; -- Boton inicio
				 BTN_STOP : in STD_LOGIC; -- Boton pausa
				 RST : in STD_LOGIC; -- Señal de RST
				 BTN_K : in STD_LOGIC; -- Boton reaundar mensaje despues de K
				 LED_K : out STD_LOGIC; -- LED detecta K
				 AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación individual
				 SEG7 : out STD_LOGIC_VECTOR (0 to 6)); -- Salida para los displays
end component;

begin

U1 : gen_senal port map
	 (CLK => CLK,
	  BTN_START => BTN_START,
	  BTN_STOP => BTN_STOP,
	  SPI_CLK => SPI_CLK,
	  SPI_DIN => SPI_DIN,
	  SPI_CS1 => SPI_CS1);
	  
U2 : receptor port map
    (CLK => CLK,
	  LIN => LIN,
	  BTN_START => BTN_START, -- Ahora introducimos tambien estos en receptor
	  BTN_STOP=> BTN_STOP,
	  RST=> RST,
	  BTN_K=> BTN_K,
	  LED_K=> LED_K,
	  AN => AN,
	  SEG7 => SEG7);
	  
end a_main;

