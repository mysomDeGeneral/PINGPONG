library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Toplevel is
    port (
        clk,rst: in std_logic;
        RGB : out std_logic_vector(2 downto 0);
        h_sync, v_sync : out std_logic;
		lbu3,lbd3,rbu3,rbd3 : in std_logic;
		mode: in std_logic_vector( 1 downto 0);
		cathode:  out std_logic_vector(6 downto 0);
      anode: out std_logic_vector(3 downto 0)
    );
end Toplevel;

architecture Behavioral of Toplevel is
	--component declaration
    component h_fsm is
        port ( 
            clk,rst : in std_logic;
            hcount: out std_logic_vector( 10 downto 0);
            rollover : out std_logic;
            h_sync, h_data_on: out std_logic
        );
    end component; 
    component v_fsm is
    port   (
    clk,rst : in std_logic;
    vcount : out std_logic_vector(10 downto 0);
	rollover : out std_logic;
    v_data_on, v_sync: out std_logic
    );
    end component;

	component counter1 is 
		port(
			clock, rst: in std_logic;
			new_clock : out std_logic
		);
	end component;

	component seven_segment_controller  is port (
        input1,input2,input3,input4: in std_logic_vector(3 downto 0);
       clk,rst: in std_logic;
       cathode:  out std_logic_vector(6 downto 0);
       anode: out std_logic_vector(3 downto 0));
    end component;
	 
	 
	 component clk_divider is 
		port (
			clk,rst: in std_logic;
			cnt : out std_logic_vector(15 downto 0)
			);
	end component;

	--signal declaration
    signal rollover : std_logic;
	signal rolloverclk, new_clock : std_logic; 
    signal h_data, v_data : std_logic;
	signal column_out, row_out: std_logic_vector(10 downto 0);
	--bar
	signal lbt,lbb,rbt,rbb:std_logic_vector(10 downto 0);
	
	signal lbu,lbu2,lbd,lbd2,rbu,rbu2,rbd,rbd2 : std_logic;
	--ball
	signal ball_leftn,ball_rightn,ball_topn,ball_bottomn:std_logic_vector(10 downto 0);

	signal ball_left:std_logic_vector(10 downto 0); --620
	signal ball_right: std_logic_vector(10 downto 0); --630
	signal ball_top: std_logic_vector(10 downto 0); --235
	signal ball_bottom: std_logic_vector(10 downto 0); --245
	--bar

	signal rbartop,rbarbottom,lbartop,lbarbottom : std_logic_vector(10 downto 0);
	signal ballhl,ballhr,ballvt,ballvb : std_logic_vector(10 downto 0);	 

	type ballstate is (top_left,top_right,bottom_left,bottom_right,left_top,left_bottom,right_top,right_bottom,start);
	signal ps,ns : ballstate;
	signal rgbin : std_logic_vector(2 downto 0);

	signal score1, next_score1, score2, next_score2 : std_logic_vector(3 downto 0);

	--winner
	signal winner : std_logic:= '0';
	signal winner_next: std_logic;
	signal speed : std_logic_vector(1 downto 0);	 

	--bar width 10
	constant p1left : std_logic_vector(10 downto 0):= ("0000000" & x"A"); --10 leftbar
	constant p1right : std_logic_vector(10 downto 0):= ("000" & x"14"); --20 leftbar
	constant p2right : std_logic_vector(10 downto 0):= ("100" & x"D8"); --1240 rightbar
	constant p2left : std_logic_vector(10 downto 0):= ("100" & x"CE"); --1230 rightbar
	constant one: std_logic_vector(1 downto 0):= "01";
	constant two: std_logic_vector(1 downto 0):= "10";
	constant three: std_logic_vector(1 downto 0):= "11";

	constant top : std_logic_vector(10 downto 0):=  ("000" & x"14"); --20
	constant bottom : std_logic_vector(10 downto 0):= ("001" & x"CC"); --460
	
	signal p1score, p2score : std_logic_vector(3 downto 0);
	
	signal clk_cnt: std_logic_vector(15 downto 0);




	begin

	ball:process(rst,new_clock,ns)
		begin
			if (rst = '1') then
				ball_left <= ("010" & x"6D"); --621
				ball_right <= ("010" & x"75"); --629
				ball_top <= ("000" & x"EC"); --236
				ball_bottom <= ("000" & x"F4"); --244
				score1 <= "0000";
				score2 <= "0000";
				winner <= winner;
				ps <= start;
			elsif (rising_edge(new_clock)) then
					ball_left <= ball_leftn;
					ball_right <= ball_rightn;
					ball_top <= ball_topn;
					ball_bottom <= ball_bottomn;
					winner <= winner_next;
					score1 <= next_score1;
					score2 <= next_score2;
					if(score1 = "1111" or score2 = "1111") then
						score1 <= "0000";
						score2 <= "0000";
						ps <= start;
					else
						ps <= ns;
					end if;
					
			end if;
	end process ball;
	ballhl <= ball_left;
	ballhr <= ball_right;
	ballvt <= ball_top;
	ballvb <= ball_bottom;

	p1score <= score1;
	p2score <= score2;

	ballspeed: process(mode)
		begin
				case mode is
					when "01" => 
						speed <= one; 
					when "10" => 
						speed <= two;
					when "11" => 
						speed <= three;
					when others =>
						speed <= one;
				end case;
		end process ballspeed;			
				
				
				
	moveball:process(ps,ball_left,ball_right,ball_top,ball_bottom,winner,lbt,lbb,rbt,rbb,score1,score2, speed)
	begin
		case ps is
			when start =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ("010" & x"6D"); --621
				ball_rightn <= ("010" & x"75"); --629
				ball_topn <= ("000" & x"EC"); --236
				ball_bottomn <= ("000" & x"F4"); --244
				if (winner = '0') then
					ns <= left_top;
				else
					ns <= right_top;
				end if;

				
			when left_top =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ball_left + speed;
				ball_rightn <= ball_right + speed;
				ball_topn <= ball_top - speed;
				ball_bottomn <= ball_bottom - speed;
				if (ball_top <= top) then
					ns <= top_right;
				else
					ns <= left_top;
				end if;


			when top_right =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ball_left + speed;
				ball_rightn <= ball_right + speed;
				ball_topn <= ball_top + speed;
				ball_bottomn <= ball_bottom + speed;
				if (ball_right >= p2left) then
					if ((ball_bottom > rbt) and (ball_top < rbb)) then
						ns <= right_bottom;
					else
						next_score1 <= score1 + '1';
						winner_next <= '0';
						ns <= start;
					end if;
				elsif (ball_bottom >= bottom) then
					ns <= bottom_right;
				else
					ns <= top_right;
				end if;


			when right_bottom =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ball_left - speed;
				ball_rightn <= ball_right - speed;
				ball_topn <= ball_top + speed;
				ball_bottomn <= ball_bottom + speed;	
					if (ball_bottom >= bottom) then
						ns <= bottom_left;
					else
						ns <= right_bottom;
					end if;

				
			when bottom_left =>
					winner_next <= winner;
					next_score1 <= score1;
					next_score2 <= score2;
					ball_leftn <= ball_left - speed;
					ball_rightn <= ball_right - speed;
					ball_topn <= ball_top - speed;
					ball_bottomn <= ball_bottom - speed;
					if (ball_left <= p1right) then
						if ((ball_bottom > lbt) and (ball_top < lbb)) then
							ns <= left_top;
						else
							winner_next <= '1';
							next_score2 <= score2 + '1';
							ns <= start;
						end if;
					elsif (ball_top <= top) then
						ns <= top_left;
					else 
						ns <= bottom_left;
					end if;


			when bottom_right => 
				winner_next <= winner;
				next_score1 <= score1;
				next_score2 <= score2;
				ball_leftn <= ball_left + speed;
				ball_rightn <= ball_right + speed;
				ball_topn <= ball_top - speed;
				ball_bottomn <= ball_bottom - speed;
				if (ball_right >= p2left) then
					if ((ball_bottom > rbt) and (ball_top < rbb)) then
						ns <= right_top;
					else
						winner_next <= '0';
						next_score1 <= score1 + '1';
						ns <= start;
					end if;
				elsif (ball_top <= top) then
					ns <= top_right;	
				else
					ns <= bottom_right;
				end if;


			when right_top =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ball_left - speed;
				ball_rightn <= ball_right - speed;
				ball_topn <= ball_top - speed;
				ball_bottomn <= ball_bottom - speed;
				if (ball_top <= top) then
					ns <= top_left;
				else
					ns <= right_top;
				end if;


			when top_left =>
				winner_next <= winner;
				next_score1 <= score1;
				next_score2 <= score2;
				ball_leftn <= ball_left - speed;
				ball_rightn <= ball_right - speed;
				ball_topn <= ball_top + speed;
				ball_bottomn <= ball_bottom + speed;
				if (ball_left <= p1right) then
					if ((ball_bottom > lbt) and (ball_top < lbb)) then
						ns <= left_bottom;
					else
						winner_next <= '1';
						next_score2 <= score2 + '1';
						ns <= start;
					end if;
				elsif (ball_bottom >= bottom) then
					ns <= bottom_left;
				else 
					ns <= top_left;
				end if;	


			when left_bottom =>
				next_score1 <= score1;
				next_score2 <= score2;
				winner_next <= winner;
				ball_leftn <= ball_left + speed;
				ball_rightn <= ball_right + speed;
				ball_topn <= ball_top + speed;
				ball_bottomn <= ball_bottom + speed;
				if (ball_bottom >= bottom) then
					ns <= bottom_right;
				else
					ns <= left_bottom;
				end if;


		end case;		
	end process moveball;

	process(new_clock)
	begin
		if (rising_edge(new_clock)) then
			lbu2 <= lbu3;
			lbu <= lbu2;
		end if;
	end process;

	process(new_clock)
	begin
		if (rising_edge(new_clock)) then
			lbd2 <= lbd3;
			lbd <= lbd2;
		end if;
	end process;

	process(new_clock)
	begin
		if (rising_edge(new_clock)) then
			rbu2 <= rbu3;
			rbu <= rbu2;
		end if;
	end process;

	process(new_clock)
	begin
		if (rising_edge(new_clock)) then
			rbd2 <= rbd3;
			rbd <= rbd2;
		end if;
	end process;


	leftbar:process(rst,lbt,lbb,lbu,lbd,new_clock)
		begin
			if (rst = '1') then
				lbb <= ("001" & x"09");
				lbt <= ("000" & x"D7");
			elsif rising_edge(new_clock) then
				if (lbu = '1' and lbartop /= x"0" ) then 
						lbt <= lbt - '1';
						lbb <= lbb - '1';					
				elsif (lbd = '1' and lbarbottom /= ("001" & x"DF")) then --479
						lbt <= lbt + '1';
						lbb <= lbb + '1';					
				else
					lbt <= lbt;
					lbb <= lbb;
				end if;
			end if;
	end process leftbar;
	lbartop <= lbt;
	lbarbottom <= lbb;		
			
	rightbar:process(rbt,rbb,rbu,rbd,new_clock,rst)
		begin
			if rst = '1' then
				rbb <= ("001" & x"09"); -- 265
				rbt <= ("000" & x"D7"); --245
			elsif rising_edge(new_clock) then
				if (rbu = '1' and rbartop /= x"0" ) then 
						rbt <= rbt - '1';
						rbb <= rbb - '1';					
				elsif (rbd = '1' and rbarbottom /= ("001" & x"DF")) then --479
						rbt <= rbt + '1';
						rbb <= rbb + '1';					
				else
					rbt <= rbt;
					rbb <= rbb;
				end if;
			end if;
	end process rightbar;
	rbartop <= rbt;
	rbarbottom <= rbb;

	drawobjects:process(column_out,row_out, v_data, h_data,lbartop,lbarbottom,rbartop,rbarbottom,ballhl,ballhr,ballvt,ballvb)
		begin
			if (v_data='1' and h_data = '1') then
				--leftbar
				if ((row_out >= lbartop and row_out <= lbarbottom) and (column_out >= p1left and column_out <= p1right )) then 
						rgbin <= "101";
				--rightbar	
				elsif ((row_out >= rbartop and row_out <= rbarbottom) and (column_out >= p2left and column_out <=  p2right )) then
						rgbin <= "101";
				--ball
				elsif ((row_out >= ballvt and row_out <= ballvb) and (column_out >= ballhl and column_out <= ballhr )) then
						rgbin <= "100";
				--middle_line
--				elsif (row_out > "00000000000" and row_out < ("001" & "DF") and column_out > ("010" & "7E") and column_out <  ("010" & x"82")) then
--						rgbin <= "101";
				else 
					rgbin <= "000";
				end if;
			else
				rgbin <= "000";
			end if;
	end process drawobjects;
	RGB <= rgbin;
	
	horizontal: h_fsm port map (
								clk => clk,
								rst => rst,
								hcount => column_out,
								rollover => rollover,
								h_data_on => h_data,
								h_sync => h_sync										
								);
	vertical : v_fsm port map (
								clk => rollover,
								rst => rst,
								rollover => rolloverclk,
								vcount => row_out,
								v_data_on => v_data,
								v_sync => v_sync
	);

	clock_divider : counter1 port map (
								clock => clk,
								rst => rst,
								new_clock => new_clock

	);
	
	top_counter_divider: clk_divider port map( 
															clk => clk,
															rst => rst,
																cnt => clk_cnt
																);


	score : seven_segment_controller port map (
								input1 => p2score,
								input2 => "0000",
								input3 => p1score,
								input4 => "0000",
								cathode => cathode,
								anode => anode,
								clk => clk_cnt(15),
								rst => rst
								
	);

end Behavioral;

