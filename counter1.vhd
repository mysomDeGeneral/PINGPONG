----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:49:15 01/28/2024 
-- Design Name: 
-- Module Name:    counter1 - Behavioral 
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

entity counter1 is 
    port(
        clock, rst: in std_logic;
        new_clock : out std_logic
    );
end counter1;

architecture Behavioral of counter1 is

    signal next_count,count : std_logic_vector(16 downto 0);
    signal clk_div : std_logic := '0';
    constant count_value : std_logic_vector(16 downto 0):= ("1" & x"86A0");

begin

    process(rst,clock)
    begin
        if (rst = '1') then
            next_count <= (others => '0');
        elsif (rising_edge(clock)) then
            if (next_count = count_value) then
                next_count <= (others => '0');
            else
                next_count <= next_count + '1';
            end if;
        end if;
    end process;
    
    count <= next_count;

    process(clock,rst)
    begin
        if (rst = '1') then
            clk_div <= '0';
        elsif (rising_edge(clock)) then
            if (next_count = count_value) then
                clk_div <= not clk_div;
            else
                clk_div <= clk_div;
            end if;
        end if;
    end process;

    new_clock <= clk_div;

end Behavioral;



