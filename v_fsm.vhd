----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:16:29 09/25/2023 
-- Design Name: 
-- Module Name:    v_fsm - Behavioral 
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

entity v_fsm is
    port   (
    clk,rst: in std_logic;
    vcount : out std_logic_vector(10 downto 0);
	 rollover : out std_logic;
    v_data_on, v_sync: out std_logic
    );
end v_fsm;

architecture Behavioral of v_fsm is
    type state_type is (V_P,V_Q,V_R,V_S);
    signal ps, ns: state_type;
	 signal rollcurr, rollnxt: std_logic;
    signal vcntcurr, vcntnxt: std_logic_vector(10 downto 0);
	 signal rcntcurr, rcntnxt: std_logic_vector(10 downto 0);

begin

    sync:process(clk,rst)
    begin
        if (rst='1') then
                vcntcurr <= "00000000000";
                ps <= V_P;
					 rollcurr <= '0';
                --rst <= '0';
        elsif (rising_edge(clk)) then
                ps <= ns;
					 vcntcurr <= vcntnxt;
					 rcntcurr <= rcntnxt;
					 rollcurr <= rollnxt;
        end if;
    end process;



    comb:process(ps,vcntcurr, rcntcurr)
    begin
        case ps is 
            when V_P => 
                v_sync <= '0';
                v_data_on <= '0';
               vcntnxt <= vcntcurr + 1;
					rcntnxt <= (others => '0');
                if (vcntcurr = "00000000010") then
                    ns <= V_Q;
						  rollnxt <= '0';
                else
                    ns <= ps;
						  rollnxt <= '0';
                end if;
            when V_Q =>
                v_sync <= '1';
                v_data_on <= '0';
					 vcntnxt <= vcntcurr + 1;
                rcntnxt <= (others => '0');
                if (vcntcurr = "00000100010") then
                    ns <= V_R;
						  rollnxt <= '0';
                else
                    ns <= ps;
						  rollnxt <= '0';
                end if;   
            when V_R => 
                v_sync <= '1';
                v_data_on <= '1';
					 vcntnxt <= vcntcurr + 1;
                   
                if (vcntcurr = "01000000010") then
                    ns <= V_S;
						  rcntnxt <= (others => '0');
						  rollnxt <= '0';
                else
                    ns <= ps;
						  rcntnxt <= rcntcurr + 1;
						  rollnxt <= '0';
                end if;  
            when V_S => 
                v_sync <= '1';
                v_data_on <= '0';
					 vcntnxt <= vcntcurr + 1;
					 rcntnxt <= (others => '0');     
                if (vcntcurr = "01000010000") then
                    ns <= V_P;
						  vcntnxt <= (others => '0');
						  rollnxt <= '1';
                else
                    ns <= ps;
						  rollnxt <= '0';
					end if;
        end case;
    end process;  
	

    vcount <= rcntcurr;
    rollover <= rollcurr;
end Behavioral;

