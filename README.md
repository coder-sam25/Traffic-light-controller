# Traffic Light Controller – Verilog

## Overview
FSM-based traffic light controller implemented in Verilog HDL.

## Features
- Red, Yellow, Green light control
- Pedestrian request button with latch
- Safe pedestrian crossing during red light
- Verified using a dedicated testbench
- Simulated using EDA Playground

## Folder Structure
rtl/ - RTL design  
tb/  - Testbench  

## How It Works
The controller cycles through:
RED → GREEN → YELLOW → RED

If a pedestrian presses the button, the request is latched and served safely during the red phase.

## Author
Sampurna Raychaudhuri

