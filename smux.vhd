----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:36 09/20/2023 
-- Design Name: 
-- Module Name:    smux - Behavioral 
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

entity smux is
port (
		m3,m2,m1,m0: in std_logic_vector( 3 downto 0);
		sel: in std_logic_vector(1 downto 0);
		Z: out std_logic_vector(3 downto 0)
		);
end smux;

architecture Behavioral of smux is

begin

with sel select 
	z <= m3 when "11",
			m2 when "10",
			m1 when "01",
			m0 when others;


end Behavioral;

