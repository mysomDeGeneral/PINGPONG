----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:38:23 09/20/2023 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity seven_segment_controller  is port (
	 input1,input2,input3,input4: in std_logic_vector(3 downto 0);
	clk,rst: in std_logic;
	cathode:  out std_logic_vector(6 downto 0);
	anode: out std_logic_vector(3 downto 0));
end seven_segment_controller;

architecture Behavioral of seven_segment_controller is

component counter is 
port (
					clk,rst: in std_logic;
					count:  out std_logic_vector(1 downto 0)
					);
end component;

component decoder2x4 is
port(
	din: in std_logic_vector(1 downto 0);
	 dout: out std_logic_vector(3 downto 0)
);
end component;


component decoder4x7 is 
port (
	din: in std_logic_vector(3 downto 0);
	dout: out std_logic_vector(6 downto 0)
	);
end component;


component smux is 
port (
		m3,m2,m1,m0: in std_logic_vector( 3 downto 0);
		sel: in std_logic_vector(1 downto 0);
		Z: out std_logic_vector(3 downto 0)
		);
end component;




signal sel: std_logic_vector(1 downto 0);
signal muxout : std_logic_vector(3 downto 0);
--signal cnt_clk: std_logic_vector(15 downto 0);


begin



top_mux : smux port map (
								m3 => input4,
								m2 => input3,
								m1 => input2,
								m0 => input1,
								sel => sel,
								z => muxout
								);
								
top_counter: counter port map( 
										clk => clk,
										rst => rst,
										count => sel
											);
											
top_2decoder: decoder2x4 port map (
												din => sel,
												dout => anode
												);
												
top_4decoder: decoder4x7 port map (
												din => muxout,
												dout => cathode
												);
								

end Behavioral;

