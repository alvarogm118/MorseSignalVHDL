----------------------------------------------------------------------------------
-- DECODIFICADOR DE MORSE A 7 SEGMENTOS
-- Este modulo es un decodificador que asocia un codigo Morse expresado con 8 bits
-- a un vector de 7 bits que indica los segmentos del display que deben encenderse
-- La entrada es el símbolo morse y la salida los segmentos a encenderse.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decodmorsea7s is
    Port ( SIMBOLO : in  STD_LOGIC_VECTOR (7 downto 0);  -- Entrada del código morse
           SEGMENTOS : out  STD_LOGIC_VECTOR (0 to 6));  -- Salidas al display
end decodmorsea7s;

architecture a_decodmorsea7s of decodmorsea7s is

begin
  with SIMBOLO select SEGMENTOS<=
    "0001000"  when "01001000", -- A (2 .-   ) 
	 "1100000"  when "10010000", -- B (4 -... )
	 "0110001"  when "10010100", -- C (4 _._. )
	 "1000010"  when "01110000", -- D (3 _..  )
	 "0110000"  when "00100000", -- E (1 .    )
	 "0111000"  when "10000100", -- F (4 ..-. )
	 "0000100"  when "01111000", -- G (3 --.  )
	 "1001000"  when "10000000", -- H (4 .... )
	 "1101111"  when "01000000", -- I (2 ..   )
	 "1000011"  when "10001110", -- J (4 .--- )
	 "1111111"  when "01110100", -- K (3 -.-  )
	 "1110001"  when "10001000", -- L (4 .-.. )
	 "1111111"  when "01011000", -- M (2 --   )
	 "1101010"  when "01010000", -- N (2 -.   )
	 "1100010"  when "01111100", -- O (3 ---  ) 
	 "0011000"  when "10001100", -- P (4 .--. )
	 "1111111"  when "10011010", -- Q (4 --.- )
	 "1111010"  when "01101000", -- R (3 .-.  )
	 "0100100"  when "01100000", -- S (3 ...  )
	 "1110000"  when "00110000", -- T (1 -    )
	 "1100011"  when "01100100", -- U (3 ..-  )
	 "1111111"  when "10000010", -- V (4 ...- )
	 "1111111"  when "01101100", -- W (3 .--  )
	 "1111111"  when "10010010", -- X (4 -..- )
	 "1000100"  when "10010110", -- Y (4 -.-- )
	 "1111111"  when "10011000", -- Z (4 --.. )
	 "1001111"  when "10101111", -- 1 (5 .----)
	 "0010010"  when "10100111", -- 2 (5 ..---)
	 "0000110"  when "10100011", -- 3 (5 ...--)
	 "1001100"  when "10100001", -- 4 (5 ....-)
	 "0100100"  when "10100000", -- 5 (5 .....)
	 "0100000"  when "10110000", -- 6 (5 -....)
	 "0001111"  when "10111000", -- 7 (5 --...)
	 "0000000"  when "10111100", -- 8 (5 ---..)
	 "0001100"  when "10111110", -- 9 (5 ----.)
	 "0000001"  when "10111111", -- 0 (5 -----)
	 "1111111" when others; 

end a_decodmorsea7s;

