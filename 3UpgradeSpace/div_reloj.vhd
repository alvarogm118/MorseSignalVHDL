---------------------------------------------------------------------------------- 
-- DIVISOR DE RELOJ
-- Modulo que toma como entrada la señal de reloj de la FPGA (50Mhz) y lo convierte
-- en un reloj de (1Khz) mediante un contador y una señal auxiliar.
----------------------------------------------------------------------------------- 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity div_reloj is
		Port ( CLK : in STD_LOGIC; -- Entrada reloj de la FPGA 50 MHz
				 CLK_1ms : out STD_LOGIC); -- Salida reloj a 1 KHz
end div_reloj;

architecture a_div_reloj of div_reloj is

signal contador : STD_LOGIC_VECTOR (15 downto 0):="0000000000000000"; -- Contador para el nuevo reloj
signal flag : STD_LOGIC:='0'; -- Nueva señal de Reloj

begin

process(CLK)
  begin
  if (CLK'event and CLK='1') then
    contador<=contador+1; -- Aumenta el contador +1
    if (contador=25000) then -- El valor es 25000 ya que es (1ms/20ns)/2 (Solo la mitad)
		contador<=(others=>'0'); -- Pone el contador a cero tras llegar a 25000
		flag<=not flag; -- Invierte el valor del nuevo reloj
	 end if;
  end if;
end process;

CLK_1ms<=flag; -- Asigna la señal a la salida CLK_1ms

end a_div_reloj;
