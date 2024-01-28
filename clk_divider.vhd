----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:48:04 09/20/2023 
-- Design Name: 
-- Module Name:    clk_divider - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is port (
			clk,rst : in std_logic;
			cnt : out std_logic_vector(15 downto 0));
end clk_divider;

architecture Behavioral of clk_divider is
signal counter_value : std_logic_vector(15 downto 0):="0000000000000000";

begin

process (clk,rst)
begin
	if (rst='1') then
		counter_value <= "0000000000000000";

	elsif (rising_edge(clk)) then 
			if (counter_value = "1111111111111111") then
				counter_value <= "0000000000000000";
			else
				counter_value <= counter_value + 1;
			end if;
	end if;

end process;
cnt <= counter_value;

end Behavioral;

