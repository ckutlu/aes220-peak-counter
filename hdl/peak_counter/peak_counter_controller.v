`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:53 10/16/2014 
// Design Name: 
// Module Name:    peak_counter_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module peak_counter_controller(
  // Global Inputs
  clk,
  rst,
  // Datapath Inputs
  count_vld_in,
  
  // Datapath Outputs
  sreg_load_en_out,
  sreg_shift_en_out,
  counter_clk_en_out,
  
  // Application Inputs
  cmd_vld_in,
  cmd_get_rst_in,
  cmd_start_in,
  // Application Outputs
  cmd_rdy_out,
  running_out,
  sending_out
  );
  
// Module Parameter Declarations
parameter CNTR_DEPTH = 24; // Number of counters
localparam CNTR_DEPTH_BLEN = clog2(CNTR_DEPTH); // Minimum number of bits needed to represent CNTR_DEPTH number

// PORT DECLARATIONS
  // Global Inputs
input clk;
input rst;
  // Datapath Inputs
input count_vld_in;
  // Datapath Outputs
output  sreg_load_en_out;
output  sreg_shift_en_out;
output  counter_clk_en_out;
  // Application Inputs
output cmd_vld_in;
output cmd_get_rst_in;
output cmd_start_in;
  // Application Outputs
output  cmd_rdy_out;  
output  running_out;
output  sending_out;
// PORT DECLARATIONS END


// Variable Declarations
// Word is used to represent collection of CNTR_WIDTH number of bits.
// The amount of words need to be passed to count_out in datapath is determined by the 
// CNTR_DEPTH parameter as it refers to the total number of counters used.
reg [CNTR_DEPTH_BLEN-1:0] word_counter;
reg sending_out_reg;
reg running_out_reg;
reg sreg_load_en_out_reg;
reg sreg_shift_en_out_reg;
reg counter_clk_en_out_reg;


//// @TODO: DON'T DO THIS LIKE THIS, WRITE A MOORE MACHINE INSTEAD OF MEALY
// Sequential Block for Counter Start-Stop Command
always@(posedge clk)
begin
  if(rst)
  begin
    counter_clk_en_out_reg <= 1'b1;
  end
  else if(cmd_vld_in)
  begin
    if(cmd_start_in)
      counter_clk_en_out_reg <= 1'b1;
    else
      counter_clk_en_out_reg <= 1'b0;
  end
end

// Sequential Block for getReset Command




////////////////////////////////
// ceil(log2(x)) Function  ////
function integer clog2;
  input integer value;
  begin
    value = value-1;
    for (clog2=0; value>0; clog2=clog2+1)
      value = value>>1;
  end
endfunction
/////////////////////////////////
/////////////////////////////////

endmodule
