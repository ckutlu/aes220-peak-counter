`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Çaglar Kutlu
// 
// Create Date:    18:42:04 10/12/2014 
// Design Name: 
// Module Name:    peak_counter_datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This module instantiates all the counters and assigns various i/o signals
// associated with the application flow. Note that peak inputs must be synchronised inputs. Thus, the
// synchronisation process must be done outside this module. The reason for not including the 
// sync process into this module was to keep that least bit of modularity intact.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module peak_counter_datapath (
  // Global Inputs
  clk,
  rst,
  // Inputs
  sig_in,
  counter_clk_en,
  sreg_load_en, // Acts as a clk enable for counter output register
  sreg_shift_en,
  // Outputs
  count_out,
  overflow_out,
  count_vld_out // Valid flag for the data out
  );

// Module Parameter Declarations
parameter CNTR_DEPTH = 24; // Number of counters
parameter CNTR_WIDTH = 8;


// PORT DECLARATIONS //
// Global Inputs
input clk;
input rst;
// Inputs
input [CNTR_DEPTH-1:0] sig_in;
input counter_clk_en;
input sreg_load_en;
input sreg_shift_en;
// Outputs
output [CNTR_WIDTH-1:0] count_out;
output [CNTR_DEPTH-1:0] overflow_out;
output count_vld_out;
// PORT DECLARATIONS END //

// Variable Declarations
wire [CNTR_WIDTH-1:0] counter_out_w[CNTR_DEPTH-1:0];
reg [CNTR_WIDTH-1:0] counter_out_reg[CNTR_DEPTH-1:0];
reg count_vld_reg;

// Peak Counter Generate Block
genvar i;
generate
  for (i = 0; i < CNTR_DEPTH ; i=i+1)
  begin : COUNTERS
    counter_nbit_sync #(CNTR_WIDTH) CNTR(
      .clk(clk),
      .rst(rst),
      .clken(counter_clk_en),
      .sig_in(sig_in[i]),
      .overflow_out(overflow_out[i]),
      .count_out(counter_out_w[i])
    );
  end
endgenerate

// PISO Shift Register CNTR_DEPTH x CNTR_WIDTH bits
// Description :
// This is a parallel in serial out shift register with width of CNTR_WIDTH
// and depth of CNTR_DEPTH.
// Working Principle:
// Bytes are loaded into the registers when the sreg_load_en signal is high and
// bytes are shifted at every rising clock edge that sreg_shift_en is held high.
// Note that the state at which both flags are high can cause undefined behaviour.
// Thus, to ensure that there is no undefined behaviour, the register holds its
// value during when these signals are both high.

always@(posedge clk)
begin
  if(rst)
  begin
    begin : SREG_FOR_GEN0
      integer i;
      for (i = 0; i < CNTR_DEPTH; i = i+1)
      begin
        counter_out_reg[i] <= {CNTR_WIDTH{1'b0}};
      end
    end
    count_vld_reg <= 1'b0;
  end
  else if (sreg_load_en & (~sreg_shift_en))
  begin
    begin : SREG_FOR_GEN1
      integer i;
      for (i = 0; i < CNTR_DEPTH; i = i+1)
      begin
        counter_out_reg[i] <= counter_out_w[i];
      end
    end
    count_vld_reg <= 1'b1;
  end
  else if (sreg_shift_en & (~sreg_load_en))
  begin
    begin : SREG_FOR_GEN2
      integer i;
      for (i = 0; i < CNTR_DEPTH-1 ; i = i+1) // Notice the "-1"
      begin
        counter_out_reg[i] <= counter_out_reg[i+1];
      end
    end
    // The most significant byte register becomes 0 after shifting
    counter_out_reg[CNTR_DEPTH-1] <= {CNTR_WIDTH{1'b0}};
    count_vld_reg <= 1'b1;
  end
  else
  begin
    begin : SREG_FOR_GEN3
    integer i;
      for (i = 0; i < CNTR_DEPTH ; i = i+1)
      begin
        counter_out_reg[i] <= counter_out_reg[i];
      end
    end
    count_vld_reg <= 1'b0;
  end
end

// Continuous Assignments
assign count_vld_out = count_vld_reg;
assign count_out = counter_out_reg[0];



endmodule