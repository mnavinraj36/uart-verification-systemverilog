# uart-verification-systemverilog

Verilog based UART design with System Verilog verification , including randomized testing ,assertions , functional coverage ,and scorebaord checking .

## Project Overview

This project implements a UART transmitter and receiver in Verilog and verifies the design using SystemVerilog.

The verification environment includes :
  - Constrained-random stimulus generation
  - Interface -based communication
  - Driver
  - Monitor
  - Scorebaord
  - Systemverilog Assertions
  - Functional Coverage

## Design 

The UART design consists of : 
- Baud Rate Generator
- UART transmitter
- UART receiver

The transmitter serializes the input data and the receiver reconstructs the transmitted data.

## Verification Environment 

The Systemverilog testbench contains :
- Transaction class
- Interface
- Driver
- Monitor
- Scoreboard
- Assertions
- Functional coverage
- Test

## Verification Results 

### 1. Scoreboard

All randomized TX/RX transactions passed successfully.

<img width="764" height="596" alt="Screenshot 2026-08-22 200127" src="https://github.com/user-attachments/assets/4938eaf4-a04a-4a56-b09c-f4bc9e56e911" />

### 2. Assertion Coverage 

Baud generator and transmitter assertions achieved 100% coverage with 0 failures , reciever assertions achieved 92.81% coverage with 0 failures. 

<img width="1108" height="1099" alt="Screenshot 2026-08-22 201347" src="https://github.com/user-attachments/assets/cf0abf46-e208-4ac2-ba52-6ad848d0e13c" />

<img width="1078" height="996" alt="Screenshot 2026-08-22 201407" src="https://github.com/user-attachments/assets/551d6553-49d3-4920-8cac-a6aa89e089e6" />

<img width="1149" height="1105" alt="image" src="https://github.com/user-attachments/assets/ef42d095-6221-4e29-b58e-964274d1bcf4" />

### 3. Functional Coverage 

Functional coverage achived 91.66%.

<img width="1471" height="1109" alt="Screenshot 2026-08-22 201647" src="https://github.com/user-attachments/assets/13b8a264-52e4-4991-bec4-b2301aa9739e" />

### 4. UART Waveform 

waveform showing UART transmission and reception.

<img width="2728" height="470" alt="Screenshot 2026-08-04 175832" src="https://github.com/user-attachments/assets/a6d2486a-7ca1-4feb-9bcd-db7b4f7da382" />











