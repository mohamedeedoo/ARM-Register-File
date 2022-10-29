// 5 to 32 decoder constructed from 4 3:8 decoders and one 2:4 decoder

`timescale 10ps/1ps
module big_decoder (
input logic [4:0] in, // Decoder inputs
input logic en, 		 // enable
output logic [31:0] y // decoder outputs
);

	logic [3:0] twofouroutput;

	_24_decoder dec_selector(.in(in[4:3]), .y(twofouroutput), .en(en)); // Provides enable for the 3 to 8 decoders
	
	
	_38_decoder lower_8 (.in(in[2:0]), .en(twofouroutput[0]), .y(y[7:0])); // Controls bottom 8 output bits
	_38_decoder lowMid_8(.in(in[2:0]), .en(twofouroutput[1]), .y(y[15:8])); // Controls next 8 output bits
	_38_decoder topmid_8(.in(in[2:0]), .en(twofouroutput[2]), .y(y[23:16])); // Controls next 8 output bits
	_38_decoder top_8 (.in(in[2:0]), .en(twofouroutput[3]), .y(y[31:24])); // Controls top 8 output bits.

endmodule

module big_decoder_testbench ();
	logic [4:0] in;
	logic [31:0] y;
	logic en;
	
	big_decoder dut (.in, .en, .y);
	
	initial begin // stimulus
		en = 1;              #300;
		
		for (int i = 0; i <32; i++) begin // Tests possible inputs.
			{in} = i;			#300;
		end
	
	end
endmodule
