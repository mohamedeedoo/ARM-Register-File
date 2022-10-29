`timescale 10ps/1ps
module register ( // 1 64 bit register
input logic write_enable, // enable
input logic [63:0] in,		// input data
output logic [63:0] out,	// output data
input logic clk,				// clock
input logic reset				// reset
);

	genvar i;
	
	logic [1:0] mux_inputs;
	logic [63:0] dff_input, previous_out;
	
	assign previous_out = out;
	
	generate
		for (i=63; i >= 0; i--) begin: reg_dff // loop 64 times to create 64 dffs for register.
			mux2_1 mux_cell (.out(dff_input[i]), .inputs({in[i], previous_out[i]}), .select(write_enable)); // Mux chooses wether to write new data or the old data if write_enable is 0
			D_FF dff_cell   (.q(out[i]), .d(dff_input[i]), .reset(reset), .clk(clk)); 
		end
	endgenerate
	
endmodule

module register_testbench(); //tests writing to a register with enable on and off.

	logic write_enable;
	logic [63:0] in;
	logic [63:0] out;
	logic clk;
	logic reset;
	logic [63:0] previous_out, dff_input;
	
	register dut(.write_enable, .in, .out, .clk, .reset);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD = 100;
 
	initial begin
		 clk <= 0;
	// Forever toggle the clock
		 forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; write_enable <= 0;						@(posedge clk);					
											@(posedge clk);
		in <= 64'b111111111111111111111111111111111111111111111111111111111111111;    @(posedge clk);
		write_enable <= 1; 			@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		in <= 64'b000000000000000000000000000000000000000000000000000000000000000;		@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		write_enable <= 0;			@(posedge clk);
											@(posedge clk);
		in <= 64'b111111111111111111111111111111111111111111111111111111111111111;    @(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		$stop;
	end
endmodule 