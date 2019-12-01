----------------------------------------------------------------------------------
-- MAIN
-- Modulo principal que realiza el conexionado de GEN_SENAL y RECEPTOR.
-- Tiene de entradas el reloj de la FPGA, BTN0(boton para empezar el mensaje)
-- , BTN1(boton para detener el mensaje) y LIN (linea de entrada de datos).
-- Como salidas, AN(activacion de cada display), SEG7(Controla los segmentos de 
-- los diplays y SPI_CLK, SPI_DIN y SPI_CS1 (que controlan el convertidor de DAC
-- que genera la señal analogica).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
		Port ( CLK : in STD_LOGIC; -- Reloj FPGA
				 BTN0 : in STD_LOGIC; -- Boton inicio
				 BTN1 : in STD_LOGIC; -- Boton pausa
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
				 BTN0 : in STD_LOGIC; -- Boton inicio
				 BTN1 : in STD_LOGIC; -- Boton pausa
				 SPI_CLK : out STD_LOGIC; -- Control DAC
				 SPI_DIN : out STD_LOGIC; -- Control DAC
				 SPI_CS1 : out STD_LOGIC); -- Control DAC
end component;

component receptor
		Port ( CLK : in STD_LOGIC; -- reloj de la FPGA
				 LIN : in STD_LOGIC; -- Línea de entrada de datos
				 AN : out STD_LOGIC_VECTOR (3 downto 0); -- Activación individual
				 SEG7 : out STD_LOGIC_VECTOR (0 to 6)); -- Salida para los displays
end component;

begin

U1 : gen_senal port map
	 (CLK => CLK,
	  BTN0 => BTN0,
	  BTN1 => BTN1,
	  SPI_CLK => SPI_CLK,
	  SPI_DIN => SPI_DIN,
	  SPI_CS1 => SPI_CS1);
	  
U2 : receptor port map
    (CLK => CLK,
	  LIN => LIN,
	  AN => AN,
	  SEG7 => SEG7);
	  
end a_main;

