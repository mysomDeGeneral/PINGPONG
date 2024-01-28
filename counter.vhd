----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:41:01 01/27/2024 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is port (
					clk,rst: in std_logic;
					count: out std_logic_vector(1 downto 0));
end counter;

architecture Behavioral of counter is
signal count_value: std_logic_vector(1 downto 0):="00";

begin

process(clk,rst)
begin

if rst = '1' then 
	count_value <= "00";
elsif (rising_edge(clk)) then
		if ( count_value = "11") then
			count_value <= "00";
		else
			count_value <= count_value + 1;
		end if; 
end if;	
	
end process;
count <= count_value;

end Behavioral;

