# Project 5: Classify
## Team: The Multiplexers
Team Code: E

Team Members:
Diwan Anuj Jitendra, 170070005
Soumya Chatterjee, 170070010
Arnab Jana, 170100082
Mohan Abhyas, 170260032

## How to run the code:
1. Open Xilinx ISE and create a new project 
using the standard chip settings used in the lab. 
These are given for your reference in the instructions/ directory.

2. Click 'Add Source' by right-clicking the xc6slx45-2csg324
and import our 3 .vhd files. Make association of the testbench
as 'Simulation'.

3. Click 'New Source' and add a FIFO using IP CORE of Xilinx (please name the fifo as 'fifo') and 
the settings shown in the screenshots in the instructions/ directory of this submission.

4. Simulate the testbench.

## Input and Output
* The classifier has 32 data input ports, 1 physical data output port, and 32 logical data output ports. The module requests data from only one input port at a time.
* It takes as input from the previous module:
  * iData_av : 32-bit one-hot signal informing data availability at input ports
  * iData0 to iData 31 : 144-bit signals of input data.
  * valid_in : 1-bit, Asserts validity of input data.
* It provides as output to the previous module:
  * iRd_data : 32-bit one-hot signal requesting exactly one of the 32 input data ports to send its available data.
* It provides as output to the next module:
  * oData_av : 1-bit, informs availability of data at output port.
  * oData: 144-bit, the actual output data.
  * valid_out : 1-bit, Asserts validity of output data.
  * Opcode : 3-bit, Outputs the opcode of the current packet if Read_opcode is enabled.
  * Input_port : 5-bit, Informs which input port sent the current packet.
  * Port_mask : 5-bit, informs which logical output port the data is being sent on.
  * Edge_port : 32-bit, informs which ports are edge ports
  * Core_port : 32-bit, informs which ports are core ports.
* It takes as input from the next module:
  * ORd_Data : 1-bit, high if the next module wants data.
  * Read_opcode : 1-bit, high if the next module wants the packet's opcode.

* Other inputs :
  * MAC : 48-bit, denotes the MAC address of the classifier.
  * clk : 1-bit, Clock
  * rst : 1-bit, reset signal

## Description:
* Header contains Dest and Src IP Addr, Ether type and value, Seq No, Path info(pointer, hop count), Target MAC, and Data.
* The classifier arbitrates amongst the available ports using **Round-robin**.
* Given a packet, it extracts Ethertype, ethervalue, path pointer and vector, target MAC. If path vector is invalid, and if MAC addresses match, it classifies packet based on ether value. If path vector is invalid, and if MAC Addresses don't match, packet is dropped. If path vector is valid, it is forwarded.
* In case it is an inter-switch packet, the input port is marked as core port and  a 1-s counter is started. If an inter-switch packet is received, counter is reset. If no inter-switch packet is received, the port is marked as edge port.

## Detailed working is explained in the report.

