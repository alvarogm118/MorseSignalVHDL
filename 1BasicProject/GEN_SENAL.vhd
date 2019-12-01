----------------------------------------------------------------------------------
-- Fichero de generación de señal Morse
--
-- Departamento de Ingeniería Electrónica 2018
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity GEN_SENAL is

    Port ( CLK : in  STD_LOGIC;
			  BTN_START : in  STD_LOGIC;-- acciona la reproducción del mensaje automático.
			  BTN_STOP : in  STD_LOGIC;-- para la reproducción del mensaje automático.
           SPI_CLK : out STD_LOGIC;
           SPI_DIN : out STD_LOGIC;     -- DATA_IN
			  SPI_CS1 : out STD_LOGIC);    -- CHIP_SELECT

end GEN_SENAL;

architecture Behavioral of GEN_SENAL is

constant CUARENTAYOCHO : integer := 48;
constant LONGITUD : integer := 267;     --- NUMERO de bits del mensaje, multiplo de 4, menos 1

signal CADENA : STD_LOGIC_VECTOR (LONGITUD downto 0);
signal COUNTER1 : integer range 0 to CUARENTAYOCHO-1 := 0;
signal COUNTER2 : STD_LOGIC_VECTOR (21 downto 0);
signal MORSE_CLK : STD_LOGIC; -- 20 Hz
signal COUNTER_MOD_1024 : STD_LOGIC_VECTOR (9 downto 0);
signal CS_ENABLE : STD_LOGIC;
signal CONF_DAC : STD_LOGIC_VECTOR (15 downto 0);
signal UNO_MORSE : STD_LOGIC_VECTOR (11 downto 0);
signal SAL_SERIE : STD_LOGIC;
signal CADENA1 : STD_LOGIC_VECTOR (LONGITUD downto 0) := (others=>'0');


begin

------------------------------------------------------------------------------
-- Definición de la cadena de caracteres empleada como mensaje 
--  x"03AE88BA8E2EEEE3BBA8BBBB8EEEE8BBA2E8B8EBA38A3AE8B8EA8B8A8A3AE8B8EB8" = celt1819practicabasicak -  (268 bits)
--  x"017745D171D7471475D1701D7445D47" = practicacelt - (124 bits)
-- Asegurarse de cambiar el valor de la constante LONGITUD en la línea 30 de este código al valor correspondiente
-------------------------------------------------------------------------------

CADENA <= x"03AE88BA8E2EEEE3BBA8BBBB8EEEE8BBA2E8B8EBA38A3AE8B8EA8B8A8A3AE8B8EB8";


---------------------------------------------------------------------------------
-- Obtención de reloj auxiliar por división de CLK para el contador principal del sistema
-- de módulo 1024.
-- y obtención de reloj MORSE_CLK ajustado a periodo de 50 ms que supondría
-- transmitir en el estándar morse de 20 palabras "CODEX" por minuto:

	CLK_COUNT_PROC : process (CLK) is
		begin
			if CLK'event and CLK='1' then
				COUNTER1 <= (COUNTER1 + 1) mod CUARENTAYOCHO;-- 48 cuentas = 0,96 us
				COUNTER2 <= COUNTER2 + '1'; -- cada flanco de CLK incrementa contador
				if COUNTER2 = 2500000 then -- 0,050 s (semiperiodo de señal MORSE_CLK)
					MORSE_CLK <= not MORSE_CLK; 
					COUNTER2 <= (others=>'0');
				end if;
			end if;
	end process CLK_COUNT_PROC;
	
	
--------------------------------------------------------------------------------
-- Contador principal de módulo 1024:
-- Bit menos significativo (0) = SPI_CLK de 520833,33 Hz (periodo = 1,92 us)
-- Bits (4 downto 1) marcan los 16 estados de los dos bytes de cada ciclo
-- de configuración del DAC que produce un valor analógico de seno cada 30,72 us
-- Bits (9 downto 5) marcan los 32 ciclos DAC con los 32 valores del seno
-- completándose el periodo del seno en 983,04 us (aproximadamente 1 kHz)
	
	CONTADOR_PRINCIPAL_PROC : process (CLK) is
		begin
			if CLK'event and CLK='1' then
				if COUNTER1 = (CUARENTAYOCHO-1) then
					COUNTER_MOD_1024 <= COUNTER_MOD_1024 + '1';--cada 0,96 us se incrementa el contador principal
				end if;
			end if;
	end process CONTADOR_PRINCIPAL_PROC;



---------------------------------------------------------------------------	
-- Registro de desplazamiento en anillo que al presional BTN0 carga en paralelo
-- la cadena de ejemplo y la saca en salida serie SAL_SERIE que accionará
-- automáticamente el manipulador telegráfico hasta el fin de la cadena, momento
-- en que se reinicia el proceso indefinidamente, hasta que se proesione BTN1
	
	process (MORSE_CLK)
		begin
			if MORSE_CLK'event and MORSE_CLK = '1' then
			 if BTN_STOP = '1' then 
            CADENA1 <= (others=>'0');
            SAL_SERIE <='0';
			  else
				if BTN_START = '1' then
					if CS_ENABLE = '1' then
						CADENA1 <= CADENA;
					end if;
				else
					SAL_SERIE <= CADENA1(LONGITUD);
					CADENA1 <= CADENA1((LONGITUD - 1) downto 0) & CADENA1(LONGITUD);
				end if;
			 end if;
			end if;
    end process;
	 
----------------------------------------------------------------------------
-- Asignación del bit de menor peso del contador principal a SPI_CLK
-- de 520833,33 Hz y periodo 1,92 us (1 ciclo DAC = 1,92 x 16 = 30,72 us)
SPI_CLK <= COUNTER_MOD_1024(0);


-----------------------------------------------------------------------------
-- Obtención del pulso CS_ENABLE que habilitará la señal CHIP_SELECT
-- Este pulso de habilitación dura igual que un ciclo completo de SPI_CLK (1,92 us)
-- y se produce a la vez que el último bit (subbit S0) de configuración del DAC
-- una vez cada 30,72 us.
CS_ENABLE <= COUNTER_MOD_1024(4) and COUNTER_MOD_1024(3) and
COUNTER_MOD_1024(2) and COUNTER_MOD_1024(1);


---------------------------------------------------------------------------------
-- Obtención de CHIP_SELECT: esta señal se produce al final de los dos bytes de
-- configuración del DAC y ejecuta en la salida del DAC el valor analógico
-- marcado. Este pulso dura igual que un periodo de AUX_CLK (0.96 us) y se
-- produce cada 30,72 us en la segunda mitad del subbit S0.

SPI_CS1 <= CS_ENABLE and COUNTER_MOD_1024(0);


	
		
------------------------------------------------------------------------------
-- Definición de la cadena de caracteres empleada como saludo en automático.
--CADENA <= x"017745D171D7471475D1701D7445D47";



------------------------------------------------------------------------------
-- Definición de cada bit de los dos bytes de configuración del DAC (CONF_DAC):

-- Tres primeros bits C2, C1 y C0 que marcan el modo de trabajo del DAC:

CONF_DAC(15) <= '0'; -- bit de configuración C2
CONF_DAC(14) <= '0'; -- bit de configuración C1
CONF_DAC(13) <= '0'; -- bit de configuración C0

-- Bits 4 a 15 (D11 downto D0 del DAC). Estos bits representan dos modos:

-- a) Modo UNO_MORSE con 32 diferentes valores (secuencia seno) que proporciona
-- un multiplexor de 32 a 1 con cinco bits de control procedentes de los bits de
-- mayor peso del contador principal del sistema COUNTER_MOD_1024 (9 downto 5).

	with COUNTER_MOD_1024(9 downto 5) select UNO_MORSE <=--5 bits, 32 ciclos DAC (~1kHz)
		x"666" when "00000", -- 1.00 V
		x"7A6" when "00001", -- 1.20 V
		x"8D9" when "00010", -- 1.38 V
		x"A00" when "00011", -- 1.56 V
		x"AF3" when "00100", -- 1.71 V
		x"BC0" when "00101", -- 1.84 V
		x"C59" when "00110", -- 1.93 V
		x"CB3" when "00111", -- 1.98 V
		x"CC0" when "01000", -- 2.00 V
		x"CB3" when "01001", -- 1.98 V
		x"C59" when "01010", -- 1.93 V
		x"BC0" when "01011", -- 1.84 V
		x"AF3" when "01100", -- 1.71 V
		x"A00" when "01101", -- 1.56 V
		x"8D9" when "01110", -- 1.38 V
		x"7A6" when "01111", -- 1.20 V
		x"666" when "10000", -- 1.00 V
		x"526" when "10001", -- 0.80 V
		x"3F3" when "10010", -- 0.62 V
		x"2CC" when "10011", -- 0.44 V
		x"1D9" when "10100", -- 0.29 V
		x"10C" when "10101", -- 0.16 V
		x"073" when "10110", -- 0.07 V
		x"019" when "10111", -- 0.02 V
		x"000" when "11000", -- 0.00 V
		x"019" when "11001", -- 0.02 V
		x"073" when "11010", -- 0.07 V
		x"10C" when "11011", -- 0.16 V
		x"1D9" when "11100", -- 0.29 V
		x"2CC" when "11101", -- 0.44 V
		x"3F3" when "11110", -- 0.62 V
		x"526" when "11111", -- 0.80 V
		x"FFF" when others;

-- b) Modo CERO_MORSE con valor fijo. El manipulador conmuta entre ambos modos.

	with SAL_SERIE select 
	CONF_DAC(12 downto 1) <=
                     UNO_MORSE when '1',--señal seno, de aproximadamente 1 kHz, entre 0 y 2 V
	                  	x"666" when '0',--1 V fijo (un CERO_MORSE)
		                  x"FFF" when others; --2,5 V fijos

-- Y subbit de configuración S0 que completa la secuencia de dos bytes del DAC.

CONF_DAC(0) <= '0';

-- Multiplexor 16 a 1 que proporciona la secuancia de configuración del DAC
-- con los bits (4 downto 1) del contador principal.

SPI_DIN <= CONF_DAC(15) when COUNTER_MOD_1024(4 downto 1) = "0000" else --16 periodos SPI_CLK
				CONF_DAC(14) when COUNTER_MOD_1024(4 downto 1) = "0001" else
				CONF_DAC(13) when COUNTER_MOD_1024(4 downto 1) = "0010" else
				CONF_DAC(12) when COUNTER_MOD_1024(4 downto 1) = "0011" else
				CONF_DAC(11) when COUNTER_MOD_1024(4 downto 1) = "0100" else
				CONF_DAC(10) when COUNTER_MOD_1024(4 downto 1) = "0101" else
				CONF_DAC(9) when COUNTER_MOD_1024(4 downto 1) = "0110" else
				CONF_DAC(8) when COUNTER_MOD_1024(4 downto 1) = "0111" else
				CONF_DAC(7) when COUNTER_MOD_1024(4 downto 1) = "1000" else
				CONF_DAC(6) when COUNTER_MOD_1024(4 downto 1) = "1001" else
				CONF_DAC(5) when COUNTER_MOD_1024(4 downto 1) = "1010" else
				CONF_DAC(4) when COUNTER_MOD_1024(4 downto 1) = "1011" else
				CONF_DAC(3) when COUNTER_MOD_1024(4 downto 1) = "1100" else
				CONF_DAC(2) when COUNTER_MOD_1024(4 downto 1) = "1101" else
				CONF_DAC(1) when COUNTER_MOD_1024(4 downto 1) = "1110" else
				CONF_DAC(0) when COUNTER_MOD_1024(4 downto 1) = "1111";
				
end Behavioral;


-- Cadena de saludo de 124 unidades de tiempo morse (12.4 segundos de duración):
-- Expresada en binario morse:
-- 0000 0001 0111 0111 0100 0101 1101 0001 0111 0001 1101 0111 0100
-- 0111 0001 0100 0111 0101 1101 0001 0111
-- 0000 0001 1101 0111 0100 0100 0101 1101 0100 0111
-- Expresada en hexadecimal:
-- x"017745D171D7471475D1701D7445D47"

-- Tabla binaria morse:

--A = 10111			  K = 111010111	  U = 1010111				1 = 10111011101110111
--B = 111010101	  L = 101110101	  V = 101010111			2 = 101011101110111
--C = 11101011101	  M = 1110111		  W = 101110111			3 = 1010101110111
--D = 1110101		  N = 11101			  X = 11101010111			4 = 10101010111
--E = 1				  O = 11101110111	  Y = 1110101110111		5 = 101010101
--F = 101011101	  P = 10111011101	  Z = 11101110101		   6 = 11101010101
--G = 111011101	  Q = 1110111010111 . = 10111010111010111 7 = 1110111010101
--H = 1010101		  R = 1011101		  Time Unit = 0			8 = 111011101110101
--I = 101			  S = 10101			  Sep. char. = 000		9 = 11101110111011101
--J = 1011101110111 T = 111			  Sep. words = 0000000	0 = 1110111011101110111
--
--
--
--