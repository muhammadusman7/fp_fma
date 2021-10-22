# Variable Precision Fused Multiply Add Unit
Table of Contents
1. [Brief Overview](#brief-overview)
2. [Organization of Files](#organization-of-files)
3. [Architecture](#architecture)
4. [Simulations](#simulations)
6. [Implementation](#implementation-1)
7. [To Dos](#to-dos)

## Brief Overview
High-Performance computation, 3D Graphics and Signal Processing utilize high-performance floating-point computation units. More than 80% operation in floating point computation comprise of addition and multiplication operations. In most of the cases an addition operation is followed by multiplication operation. This emphasizes the need of more efficient fused multiply and add unit to increase the overall throughput and power efficiency within a floating-point unit (FMA). A fused multiply and add (FMA) unit performs both multiply and add operations in a single iteration.

Higher precisions of floating point offer higher accuracy but are more expensive in terms of power and throughput. An efficient FMA may have higher throughput, but compromise much on precision of a floating-point number, while utilizing less power. Therefore, when an inputs are higher precision numbers and throughput is the main concern other than the accuracy. Arithmetic operations could be performed in lower precision datapaths, it would yield approximate results (Approximate Computing). This allows circuits to operate at higher throughput at lower power utilizing lower precision datapath. As an example, a double precision fused add unit can perform a single double precision operation, two single precision or four half precision operations in the same iteration, while performing exact calculations. While, we can perform two or four double precision approximate arithmetic operation while utilizing two single precision, or four half precision datapaths respectively.

In this project, we have tried to accomplish the same as discussed above. We have developed a FMA, that can perform the operations as shown in the tables below based upon the Mode, Precision and Op Values, Where A, B and C are 64-bit inputs, and O is 64-bit output:

| Mode  | Precision      | No of Operations | Type        |
|-------|----------------|------------------|-------------|
| 2'b11 | 2'b11 (Double) | 1                | Exact       |
| 2'b10 | 2'b11 (Double) | 2                | Approximate |
| 2'b01 | 2'b11 (Double) | 4                | Approximate |
| 2'b10 | 2'b10 (Single) | 2                | Exact       |
| 2'b01 | 2'b10 (Single) | 4                | Approximate |
| 2'b01 | 2'b01 (Half)   | 4                | Exact       |

Any combination of the Mode and Precision other than the combinations mentioned in the above table is not supported. Arithmetic operations are performed according to the following table opcodes:

| Op    | Type           | Operation     |
|-------|----------------|---------------|
| 2'b11 | FMA            | O = A × B + C |
| 2'b10 | Addition       | O = A + C     |
| 2'b01 | Subtraction    | O = A - C     |
| 2'b00 | Multiplication | O = A × C     |

This solution extends the work done in [1], with aim to improve the multiply fused add unit to implement double precision operation compliant with IEEE 754 standard [2]. The proposed solution performs a single double precision, two single and four half precision operations in a single iteration. The multiplier is implemented using radix-4 encoding to generate partial products, followed by Wallace tree compression. Addition is implemented using cascaded 4-bit carry look ahead adders.
## Organization of Files
##### GDS
Includes GDS files of floorplane, std cell placement, and post route layout
##### Images
Floorplan, placement, routing and layout images
##### Implementation
This folder includes lib, lef, and gds implementation files. Floorplan, powerplan, placement, postCTS, nanoRoute def files, innovus.tcl, io assignment file, and innovus constraints file are also uploaded in this directory. Additionally, it has clock, hold, setup, power, skew, and violations reports.
##### Synthesis 
Synthesis script, constraints, reports, synthesized netlist is place there.
##### RTL
Includes all Verilog files
##### Tests
Verilog testbenchs and related files

## Architecture
The base architecture is shown in the image below. Inputs and outputs are always 64-bit wide. For single and half precision, we may add 32 and 48 leading ones respectively, so that it becomes NaN for Higher precisions. The output follows the same pattern. Additionally, certainty tracking is added which calculates the certainty of the output based upon the input values, the input and output certainties are 6 bit wide to cater 53 bit tracking. However, certainty tracking is only valid for FMA operations, it is not valid for multiplication, addition and subtraction.

![Architecture](https://user-images.githubusercontent.com/50042093/154183389-b9f26e7a-f053-4cf8-96c8-8098b96825d7.png)

There are 12 input and 4 output registers which accepts the inputs and outputs in the following pattern.
| No of Operations | A     | B     | C     | O    |
|------------------|-------|-------|-------|------|
| 1                | in_a0 | in_b0 | in_c0 | out0 |
| 2                | in_a0 | in_b0 | in_c0 | out0 |
|                  | in_a1 | in_b1 | in_c1 | out1 |
| 4                | in_a0 | in_b0 | in_c0 | out0 |
|                  | in_a1 | in_b1 | in_c1 | out1 |
|                  | in_a2 | in_b2 | in_c2 | out2 |
|                  | in_a3 | in_b3 | in_c3 | out3 |

## Simulations
The design has been tesedt both at module and top level. Multiplication and Addition modules were tested with 10M random values. While FMA top module was tested with 1M Double Precision inputs ranging from -10000 to 10000. Test vectors were generated using this [file](https://github.com/muhammadusman7/fp_fma/blob/main/tests/testVectorGen.m) in MATLAB, and then final results were compared again in MATLAB using this [file](https://github.com/muhammadusman7/fp_fma/blob/main/tests/testOutCheck.m). The sample [input](https://github.com/muhammadusman7/fp_fma/blob/main/tests/input.txt) and [output](https://github.com/muhammadusman7/fp_fma/blob/main/tests/output.txt) test files uploaded here only include 1000 test values. In [input](https://github.com/muhammadusman7/fp_fma/blob/main/tests/input.txt) file starting from top every three values are A, B and C respectively. In the [output](https://github.com/muhammadusman7/fp_fma/blob/main/tests/output.txt) file, starting from top every four values are A, B, C and O (output).
## Implementation
The project is implemented using Sky Water 130A Open Source [PDK](https://github.com/google/skywater-pdk). The sythesis was completed using cadence genus and implementaion was done in innovus. The design goal was to attain 50 MHz frequency, but slack values shows that it rather can run on slightly higher frequency. The design has following parameter reported:
| Parameter   | Value  |
|-------------|--------|
| Frequency   | 50 MHz |
| Power       | 28 mW  |
| Hold Slack  | 0.604  |
| Setup Slack | 3.376  |

#### Floorplane
Floorplane Area is 1000x1500um^2

![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/Floorplan.gif)
#### Powerplan
![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/Powerplan.specialroute.gif)
#### Stdcell Placement
![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/StdCellPlacement.gif)
#### Nano Route
![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/nanoRoute.gif)
#### Nano Route Density
![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/nanoRoute.density.gif)
#### Layout
![image](https://github.com/muhammadusman7/fp_fma/blob/main/images/Layout.png)
## To Dos
 - Post Layout Simulation
 - Adding DECAPS
 - Metal Filling
### References
[1] H. Kaul  _et al._, “A 1.45GHz 52-to-162GFLOPS/W variable-precision floating-point fused multiply-add unit with certainty tracking in 32nm CMOS,”  _Dig. Tech. Pap. - IEEE Int. Solid-State Circuits Conf._, vol. 55, pp. 182–183, 2012, doi: 10.1109/ISSCC.2012.6176987

[2] Microprocessor Standards Committee,  _IEEE Standard for Floating-Point Arithmetic - IEEE Xplore Document_. 2019

