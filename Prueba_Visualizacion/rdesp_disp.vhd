----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:11 10/22/2018 
-- Design Name: 
-- Module Name:    rdesp_disp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rdesp_disp is
	Port( CLK_1ms : in STD_LOGIC; -- entrada de reloj
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
  process (CLK_1ms)
    begin
      if (CLK_1ms'event and CLK_1ms='1' and EN='1') then   -- con cada flanco activo y ENABLE = 1
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

