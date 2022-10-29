//3 to 8 decoder

`timescale 10ps/1ps
module _38_decoder (
input logic [2:0] in, // Decoder inputs
input logic en,		 // enable
output logic [7:0] y	 // outputs
);

	logic in0_not, in1_not, in2_not;
	
	not #(5) (in0_not, in[0]); 	// Inverted inputs
	not #(5) (in1_not, in[1]);		
	not #(5) (in2_not, in[2]);
	
	and #(5) (y[0], in0_not, in1_not, in2_not, en);	// Decoder gate Logic
	and #(5) (y[1], in[0], in1_not, in2_not, en);
	and #(5) (y[2], in0_not, in[1], in2_not, en);
	and #(5) (y[3], in[0], in[1], in2_not, en);
	and #(5) (y[4], in0_not, in1_not, in[2], en);
	and #(5) (y[5], in[0], in1_not, in[2], en);
	and #(5) (y[6], in0_not, in[1], in[2], en);
	and #(5) (y[7], in[0], in[1], in[2], en);
endmodule

module _38_decoder_testbench (); // Tests all possible inputs.
	logic [2:0] in;
	logic [7:0] y;
	logic en;
	
	_38_decoder dut (.in, .en, .y);
	
	initial begin // Stimulus 
		en = 0;		#30;
		en = 1;		#30;
		in = 3'b000; #30;
		in	= 3'b001; #30;
		in = 3'b010; #30;
		in = 3'b011; #30;
		in = 3'b100; #30;
		in	= 3'b101; #30;
		in = 3'b110; #30;
		in = 3'b111; #30;
						 #30;
	end 
endmodule

