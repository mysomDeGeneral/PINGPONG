----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:43 09/20/2023 
-- Design Name: 
-- Module Name:    decoder4x7 - Behavioral 
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

entity decoder4x7 is port (
	din: in std_logic_vector(3 downto 0);
	dout: out std_logic_vector(6 downto 0));
end decoder4x7;

architecture Behavioral of decoder4x7 is

begin




with din select dout <=
		"0000001" when "0000",
		"1001111" when "0001",
		"0010010" when "0010",
		"0000110" when "0011",
		"1001100" when "0100",
		"0100100" when "0101",
		"0100000" when "0110",
		"0001111" when "0111",
		"0000000" when "1000",
		"0000100" when "1001",
	  	"0001000" when "1010",
		"1100000" when "1011",
		"0110001" when "1100",
		"1000010" when "1101",
		"0110000" when "1110",
		"0111000" when "1111",
		"1111111" when others;


end Behavioral;

