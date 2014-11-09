`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:13:13 10/12/2014 
// Design Name: 
// Module Name:    counter_nbit_sync 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This is a single synchronised peak counter with a width defined using the
// overridable parameter 'CNTR_WIDTH' with a default value of 8. overflow_out is pulled up
// when an overflow occurs.

//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module counter_nbit_sync #(parameter CNTR_WIDTH = 8) (
  // Inputs
  input clk,
  input rst,
  input clken,
  input sig_in,
  // Outputs
  output overflow_out,
  output [CNTR_WIDTH-1:0] count_out
	);

// Local Parameter Declarations
localparam MAXCOUNT = 2**CNTR_WIDTH - 1;

// Variable Declarations
reg sig_in_ff;
reg [CNTR_WIDTH-1:0]counter_reg;
reg overflow_ff;
wire sig_in_posedge;

// Continuous Assignments
assign sig_in_posedge = sig_in & (~sig_in_ff); // Peak detection
assign overflow_out = overflow_ff;
assign count_out = counter_reg;

// Signal register instance (for peak detection)
always@(posedge clk)
begin
  if(rst)
    sig_in_ff <= 1'b0;
  else if (clken)
    sig_in_ff <= sig_in;
end

// Counter Sequential Block
always@(posedge clk)
begin
  if(rst)
  begin
    counter_reg[CNTR_WIDTH-1:0] <= {CNTR_WIDTH{1'b0}};
    overflow_ff <= 1'b0;
  end
  else if(clken)
  begin
    if(sig_in_posedge)
    begin
      if(counter_reg == MAXCOUNT)
      begin
        counter_reg[CNTR_WIDTH-1:0] <= {CNTR_WIDTH{1'b0}};
        overflow_ff <= 1'b1;
      end
      else
        counter_reg <= counter_reg + 1;
    end
  end
end


endmodule
