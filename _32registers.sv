// This module combines all the 32 registers into one 
// 32X64 array to keep top level module clean.

`timescale 10ps/1ps
module _32registers (
input logic [30:0] write_en,			// write enable for all the registers
input logic [30:0][63:0] write_data,	// write data for all the registers
output logic [31:0][63:0] output_data, // Output of all the registers
input logic clk,
input logic reset
);
	
	logic [63:0] zero_reg = '{default:0}; // array of zeros for the zero register.
	
	genvar i;
	generate
		for (i = 30; i >= 0; i--) begin : each_register // Connecting all the registers together (basically a 2d array)
			register x_x (.write_enable(write_en[i]), .in(write_data[i]), .out(output_data[i]), .clk(clk), .reset(reset));
		end
	endgenerate

	register x31 (.write_enable(1'b0), .in(zero_reg), .out(output_data[31]), .clk(clk), .reset(reset)); // Hardcode register zero register to prevent writing.
	
endmodule

module registers_tb ();	
	logic [30:0] write_en;
	logic [30:0][63:0] write_data;
	logic [31:0][63:0] output_data;
	logic clk;
	logic reset;
	
	_32registers dut (.write_en, .write_data, .output_data, .clk, .reset);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD = 100;
 
	initial begin
		 clk <= 0;
	// Forever toggle the clock
		 forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; write_en <= 0;	@(posedge clk);					
											@(posedge clk);
		write_data <= 0;				@(posedge clk);
		write_data[0] <= 64'b111111111111111111111111111111111111111111111111111111111111111;    @(posedge clk);
		write_en[30:1] <= 0; write_en[0] <= 1; 		@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		write_data[0] <= 64'b000000000000000000000000000000000000000000000000000000000000000;		@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		write_en[0] <= 0;			@(posedge clk);
											@(posedge clk);
		write_data[0] <= 64'b111111111111111111111111111111111111111111111111111111111111111;    @(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule 
	
	
	
	
	