----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:23:01 09/07/2023 
-- Design Name: 
-- Module Name:    decoder2x3 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder2x4 is
port(
	din: in std_logic_vector(1 downto 0);
	 dout: out std_logic_vector(3 downto 0)
);
end decoder2x4;

architecture Behavioral of decoder2x4 is

begin
	
	dout <= "0111" when (din="11") else
				"1011" when (din="10") else
				"1101" when (din="01") else
				"1110" when (din="00") else
				"1111";



end Behavioral;

