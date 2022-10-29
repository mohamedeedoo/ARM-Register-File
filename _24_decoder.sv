// 2 to 4 decoder

`timescale 10ps/1ps
module _24_decoder (
input logic [1:0] in, // Decoder inputs
input logic en,		 // Enable 
output logic [3:0] y	 // Decoder outputs
);

	logic in1_not, in0_not;
	
	not #(5) (in0_not, in[0]);	// Inverted inputs
	not #(5) (in1_not, in[1]);
	
	and #(5) (y[0], in0_not, in1_not, en);	// Decoder logic
	and #(5) (y[1], in[0], in1_not, en);
	and #(5) (y[2], in0_not, in[1], en);
	and #(5) (y[3], in[0], in[1], en);
	

endmodule

module _24_decoder_testbench (); // Tests all possible inputs.
	logic [1:0] in;
	logic [3:0] y;
	logic en;
	
	_24_decoder dut (.in, .en, .y);
	
	initial begin // Stimulus 
		en = 0;		#30;
		en = 1; 		#30;
		in = 2'b00; #30;
		in	= 2'b01;	#30;
		in = 2'b10; #30;
		in = 2'b11; #30;
	end 
endmodule
		