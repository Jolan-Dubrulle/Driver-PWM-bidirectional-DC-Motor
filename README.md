# Driver-PWM-bidirectional-DC-Motor

The goal of this project is to create a VHDL code to control a bi-directional DC motor by PWM and then implement it on the DE1 Altera board. To do so, we used a VHDL-coded PWM generator from fpga4student.com (https://www.fpga4student.com/2017/06/pwm-generator-in-vhdl.html?fbclid=IwAR0gGq8p3NFqNLn61wZvySt9sNkjd1lIysqcSB0_jd4QlKwlcNoliYAMjlo).

We have adapted this code so that it can work with a 50MHz clock (corresponding to the DE1 Altera board) instead of the 100MHz initially planned.  We have also made the necessary modifications to obtain the signals needed to control the DC motor clockwise and anticlockwise. Finally, we have implemented a small application to display in real time on the LEDs of the DE1 Altera board the number of clock cycles that composes the PWM signal width. Simulations of the project could be carried out by the Intel Quartus Prime software via ModelSim.

Unfortunately, as we no longer had access to the university's premises following the Covid-19 epidemic, we were unable to implement our code on the DE1 Altera board. 


In this repository, you will find the VHDL codes of the project (including the test bench), a Tutorial technical document which describes and explains the whole project and a ZIP document of our project on Altera.

