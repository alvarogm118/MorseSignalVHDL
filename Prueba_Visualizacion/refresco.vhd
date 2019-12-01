----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:05:21 10/22/2018 
-- Design Name: 
-- Module Name:    refresco - Behavioral 
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

entity refresco is
	Port ( CLK_1ms : in STD_LOGIC; -- reloj de refresco
			 S : out STD_LOGIC_VECTOR (1 downto 0); -- Control para el mux
			 AN : out STD_LOGIC_VECTOR (3 downto 0)); -- Control displays
end refresco;

architecture Behavioral of refresco is

signal SS  : STD_LOGIC_VECTOR (1 downto 0); 

begin

process (CLK_1ms)
  begin
  if (CLK_1ms'event and CLK_1ms='1') then  
    SS<=SS+1;                      -- genera la secuencia 00,01,10 y 11
  end if;
  end process;

S<=SS;
AN<="0111" when SS="00" else   -- activa cada display en function del valor de SS
    "1011" when SS="01" else
    "1101" when SS="10" else
    "1110" when SS="11";

end Behavioral;