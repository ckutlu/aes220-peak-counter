`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:24 10/12/2014
// Design Name:   counter_nbit_sync
// Module Name:   D:/MyWorks/aes220-USB_Controlled_FPGA_Counter/ise/Tryouts/PeakCounter/counter_nbit_sync_tb.v
// Project Name:  PeakCounter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_nbit_sync
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CNTR_WIDTH 8

module counter_nbit_sync_tb;

	// Inputs
	reg clk;
	reg rst;
	reg clken;
	reg sig_in;

	// Outputs
	wire overflow_out;
	wire [7:0] count_out;

	// Instantiate the Unit Under Test (UUT)
	counter_nbit_sync #(`CNTR_WIDTH)uut (
		.clk(clk), 
		.rst(rst), 
		.clken(clken), 
		.sig_in(sig_in), 
		.overflow_out(overflow_out), 
		.count_out(count_out)
	);

  // Testbench variables
  integer counts;
  integer i; //for loop variable

  // Clock Generation
  always begin
    clk = ~clk; 
    #10;
  end
  

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		clken = 0;
		sig_in = 0;
    
    //Initialize testbench variables
    counts = 0;
    i = 0;

		// Wait 100 ns for global reset to finish
		#50;
    rst = 1'b0;
    #50;

		// Add stimulus here
    clken = 1;
    $monitor($time, " << count_out : %d | overflow : %b",count_out,overflow_out);
    for(i = 0; i <= 2**(`CNTR_WIDTH) + 5; i = i+1)
    begin
      sig_in = 1'b1;
      counts = counts+1;
      #20;
      sig_in = 1'b0;
      #40;
    end
	end
      
endmodule

