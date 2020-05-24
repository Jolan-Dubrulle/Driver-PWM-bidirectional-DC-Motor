-- VHDL code for PWM Generator 
-- Two de-bounced push-buttons
-- One: increase duty cycle by 10%
-- Another: Decrease duty cycle by 10%

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Generator_50M is
port (
   clk_50M: in std_logic; -- 50MHz clock input 
   DUTY_INCREASE: in std_logic; -- button to increase duty cycle by 10%
   DUTY_DECREASE: in std_logic; -- button to decrease duty cycle by 10%
	sens_H: in std_logic; -- button to drive motor of clockwise
	PWM_OUT_H:out std_logic;-- rotation motor of clockwise
	PWM_OUT_A:out std_logic;-- rotation motor of anticlockwise
	PWM_OUT_O:out std_logic;-- rotation motor
	LED_OUT: out std_logic_vector(3 downto 0) -- gestion des leds
	
  );
end PWM_Generator_50M;

architecture Behavioral of PWM_Generator_50M is
 -- D-Flip-Flop for debouncing module
 
component DFF_Debounce 
Port( 
		CLK : in std_logic;
		en : in std_logic;
		D : in std_logic;
		Q : out std_logic
	);
end component;

signal slow_clk_en: std_logic:='0'; -- slow clock enable for debouncing
signal counter_slow: std_logic_vector(27 downto 0):=(others => '0');-- counter for creating slow clock
signal tmp1,tmp2,duty_inc: std_logic;-- temporary signals for deboucing
signal tmp3,tmp4,duty_dec: std_logic;-- temporary signals for deboucing
signal counter_PWM: std_logic_vector(3 downto 0):=(others => '0');-- counter for PWM signal
signal DUTY_CYCLE: std_logic_vector(3 downto 0):=x"3";
signal clk_50: std_logic:='0'; -- slow clock enable for debouncing
signal counter_clk50: std_logic_vector(1 downto 0):=(others => '0');-- counter for creating slow clock
signal PWM_OUT: std_logic:= '0'; -- PWM signal out with frequency of 10MHz
signal PWM_Cycle: std_logic:= '0';
signal LED_Counter: std_logic_vector(3 downto 0):=(others => '0');-- counter led signal
begin

 -- Debouncing process
 -- First generate slow clock enable for deboucing (4Hz)
 
process(clk_50M)
 begin
	if(rising_edge(clk_50M)) then
   counter_slow <= counter_slow + x"0000001";
   --if(counter_slow>=x"BEBC20") then -- for running on FPGA -- comment when running simulation
		if(counter_slow>=x"0000001") then -- for running simulation -- comment when running on FPGA
		counter_slow <= x"0000000";
		end if;
	end if;
 end process;

--slow_clk_en <= '1' when counter_slow = x"BEBC20" else '0';-- for running on FPGA -- comment when running simulation 
slow_clk_en <= '1' when counter_slow = x"000001" else '0';-- for running simulation -- comment when running on FPGA
-- debounce part for duty increasing button

-- debounce part for duty increasing button( géré les antis rebond incrémentation)

stage0: DFF_Debounce port map(clk_50M,slow_clk_en , DUTY_INCREASE, tmp1);
stage1: DFF_Debounce port map(clk_50M,slow_clk_en , tmp1, tmp2); 
duty_inc <=  tmp1 and (not tmp2) and slow_clk_en;

-- debounce part for duty decreasing button ( géré les antis rebond décrémentation)

stage2: DFF_Debounce port map(clk_50M,slow_clk_en , DUTY_DECREASE, tmp3);
stage3: DFF_Debounce port map(clk_50M,slow_clk_en , tmp3, tmp4); 
duty_dec <=  tmp3 and (not tmp4) and slow_clk_en;
-- for controlling duty cycle by these buttons

 PWM_Cycle <= '1' when counter_PWM = x"9"  else '0';
process(PWM_Cycle)
begin
	
	if(falling_edge(PWM_Cycle)) then
		if(DUTY_INCREASE='1' and DUTY_CYCLE <= x"9") then
			DUTY_CYCLE <= DUTY_CYCLE + x"1";--increase duty cycle by 10%
		elsif(DUTY_DECREASE='1' and DUTY_CYCLE>=x"1") then
			DUTY_CYCLE <= DUTY_CYCLE - x"1";--decrease duty cycle by 10%
		end if;
  end if;
end process;

 -- Create 5MHz PWM signal
 
process(clk_50M)
begin
	if(rising_edge(clk_50M)) then
		counter_PWM <= counter_PWM + x"1";
		if(counter_PWM>=x"9") then
			counter_PWM <= x"0";
		end if;
	end if;
end process;

 PWM_OUT <= '1' when counter_PWM < DUTY_CYCLE else '0';
 
 PWM_OUT_H <= PWM_OUT when sens_H ='1'  else '0';
 PWM_OUT_A <= PWM_OUT when sens_H ='0'  else '0';
 PWM_OUT_O <= PWM_OUT;

process(clk_50M)
begin
	if(rising_edge(clk_50M)) then
		if(counter_PWM >= x"9") then
			LED_Counter <= x"0";
		elsif(PWM_OUT = '1') then
			LED_Counter <= LED_Counter + x"1";
		end if;
	end if;
end process;
LED_OUT <= LED_Counter;

end Behavioral;