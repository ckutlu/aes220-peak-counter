`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:45:20 10/13/2014
// Design Name:   peak_counter_datapath
// Module Name:   D:/MyWorks/aes220-USB_Controlled_FPGA_Counter/ise/Tryouts/PeakCounter/peak_counter_datapath_tb.v
// Project Name:  PeakCounter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: peak_counter_datapath
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define CNTR_WIDTH 8
`define CNTR_DEPTH 24

module peak_counter_datapath_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [`CNTR_DEPTH-1:0] sig_in;
	reg counter_clk_en;
	reg sreg_load_en;
	reg sreg_shift_en;

	// Outputs
	wire [`CNTR_WIDTH-1:0] count_out;
	wire [`CNTR_DEPTH-1:0] overflow_out;
	wire count_vld_out;

	// Instantiate the Unit Under Test (UUT)
	peak_counter_datapath #(
    .CNTR_WIDTH(`CNTR_WIDTH),
    .CNTR_DEPTH(`CNTR_DEPTH)
    ) 
    uut (
      .clk(clk), 
      .rst(rst), 
      .sig_in(sig_in), 
      .counter_clk_en(counter_clk_en), 
      .sreg_load_en(sreg_load_en), 
      .sreg_shift_en(sreg_shift_en), 
      .count_out(count_out), 
      .overflow_out(overflow_out), 
      .count_vld_out(count_vld_out)
	);

  // Testbench variables
  integer i,j; //for loop variable
  reg peaks_finished;

  // Clock Generation
  always begin
    clk = ~clk; 
    #10;
  end
  
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		sig_in = 0;
		counter_clk_en = 0;
		sreg_load_en = 0;
		sreg_shift_en = 0;

		// Wait 100 ns for global reset to finish
		#50;
    rst = 0;
    #50;
        
		// Add stimulus here
    counter_clk_en = 1;
    $monitor($time, " << count_out : %d | count_vld_out : %b",count_out,count_vld_out);
    for(i = 0; i < `CNTR_DEPTH; i = i+1)
    begin
      for(j = 0; j < i+1; j = j+1)
      begin
        sig_in[i] = 1'b1;
        #20;
        sig_in[i] = 1'b0;
        #40;
      end
    end
    peaks_finished = 1;
	end
  
  initial begin
  #100;
  wait(peaks_finished == 1);
  counter_clk_en = 1'b1;
  sreg_load_en = 1'b1;
  wait (count_vld_out == 1)
  sreg_load_en = 1'b0;
  sreg_shift_en = 1'b1;
  #500;

  end
endmodule

