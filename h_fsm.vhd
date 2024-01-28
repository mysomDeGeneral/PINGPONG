----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:16:08 09/25/2023 
-- Design Name: 
-- Module Name:    h_fsm - Behavioral 
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

entity h_fsm is
port ( 
    clk,rst: in std_logic;
    hcount: out std_logic_vector(10 downto 0);
    rollover : out std_logic;
    h_sync, h_data_on: out std_logic
);
end h_fsm;


architecture Behavioral of h_fsm is
    type state is (H_B,H_C,H_D,H_E);
    signal ps,ns : state;
	 signal hcntcurr : std_logic_vector(10 downto 0):="00000000000";
    signal hcntnxt : std_logic_vector(10 downto 0);
    signal rollcurr, rollnxt: std_logic;
    signal dcntcurr, dcntnxt : std_logic_vector(10 downto 0);

begin

    sync:process(clk,rst)
    begin
        if (rst = '1') then 
            hcntcurr <= (others => '0');
            ps <= H_B;
            rollcurr <= '0';
        elsif rising_edge(clk) then
                ps <= ns;
                rollcurr <= rollnxt;
					 hcntcurr <= hcntnxt;
					 dcntcurr <= dcntnxt;
			
         end if;
    end process;


    comb:process(ps,rollcurr,hcntcurr, dcntcurr)
    begin
        case ps is 
            when H_B =>
                 hcntnxt <= hcntcurr + 1;
                h_sync <= '0';
                h_data_on <= '0';
					 dcntnxt <= (others => '0');
					 rollnxt <= '0';
                if (hcntcurr = "00010111101") then
                    ns <= H_C;
                else 
                    ns <= H_B;
                    --rollnxt <= '0';
                   
                end if;
            when H_C =>
                hcntnxt <= hcntcurr + 1;
                h_sync <= '1';
                h_data_on <= '0';
					 dcntnxt <= (others => '0');
					 rollnxt <= '0';
                if (hcntcurr = "00100010111") then
                    ns <= H_D;
                    
                else 
                    ns <= H_C;
						  
                end if;
            when H_D =>
                hcntnxt <= hcntcurr + 1;
                h_sync <= '1';
                h_data_on <= '1';
					 rollnxt <= '0';
                if (hcntcurr = "11000010100") then
                    ns <= H_E;
                    
						  dcntnxt <= (others => '0');
                else 
                    ns <= H_D;
                    --rollnxt <= '0';
						  dcntnxt <= dcntcurr + 1;
						  
                end if;
            when H_E =>
                hcntnxt <= hcntcurr + 1;
                h_sync <= '1';
                h_data_on <= '0';
					 dcntnxt <= (others => '0');
                if (hcntcurr = "11000111111") then
                    ns <= H_B;
                    rollnxt <= '1';
						  hcntnxt <= (others => '0');
                else 
                    ns <= H_E;
                    rollnxt <= '0';
						  
                end if;
        end case;
    end process;

    hcount <= dcntcurr;
    rollover <= rollcurr;
                        





end Behavioral;

