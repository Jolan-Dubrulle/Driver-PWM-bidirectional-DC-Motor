-- VHDL testbench code for PWM Generator 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PWM_Generator_50M_TB IS
END PWM_Generator_50M_TB;
 
ARCHITECTURE behavior OF PWM_Generator_50M_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM_Generator_50M
    PORT(
			clk_50M: in std_logic; -- 50MHz clock input 
			DUTY_INCREASE: in std_logic; -- button to increase duty cycle by 10%
			DUTY_DECREASE: in std_logic; -- button to decrease duty cycle by 10%
			sens_H: in std_logic; -- button to drive motor of clockwise
			PWM_OUT_H:out std_logic;-- rotation motor of clockwise
			PWM_OUT_A:out std_logic;-- rotation motor of anticlockwise
			PWM_OUT_O:out std_logic;-- rotation motor
			LED_OUT: out std_logic_vector (3 downto 0) -- gestion des leds
			
        );
    END COMPONENT;

   --Inputs
	
   signal clk_50M : std_logic := '0';
   signal DUTY_INCREASE : std_logic := '0';
   signal DUTY_DECREASE : std_logic := '0';
	signal sens_H: std_logic := '0';
	
  --Outputs
  
	signal PWM_OUT_H: std_logic;
	signal PWM_OUT_A: std_logic;
	signal PWM_OUT_O: std_logic;
	signal LED_OUT  : std_logic_vector (3 downto 0);
	
   -- Clock period definitions
   constant clk_period : time := 20 ns;

BEGIN
 
 -- Instantiate the Unit Under Test (UUT)
   uut: PWM_Generator_50M PORT MAP (
          clk_50M => clk_50M,
          DUTY_INCREASE => DUTY_INCREASE,
          DUTY_DECREASE => DUTY_DECREASE,
			 sens_H => sens_H ,
          PWM_OUT_H => PWM_OUT_H ,
			 PWM_OUT_A => PWM_OUT_A ,
			 PWM_OUT_O => PWM_OUT_O,
			 LED_OUT   => LED_OUT
			 
        );

  -- Clock process definitions
   clk_process :process
  begin
  clk_50M <= '0';
  wait for clk_period/2;
  clk_50M <= '1';
  wait for clk_period/2;
   end process;
 
		-- Stimulus process
	
   stim_proc: process
   begin
	
		-- duty increase
	
  DUTY_INCREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_INCREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_INCREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_INCREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_INCREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_INCREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_INCREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_INCREASE <= '0';
		wait until PWM_Out_O = '0';
		
		-- duty decrease
 
  DUTY_DECREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_DECREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_DECREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_DECREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_DECREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_DECREASE <= '0';
		wait until PWM_Out_O = '0';
  DUTY_DECREASE <= '1'; 
      wait until PWM_Out_O = '1';
  DUTY_DECREASE <= '0';
		wait until PWM_Out_O = '0';
  
  sens_H <= not sens_H ;
      
   end process;

END;