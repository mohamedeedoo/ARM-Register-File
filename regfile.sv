// Top Level Module

`timescale 10ps/1ps
module regfile (
output logic [63:0] ReadData1,
output logic [63:0] ReadData2,
input logic [63:0] WriteData,
input logic [4:0] ReadRegister1, 
input logic [4:0] ReadRegister2, 
input logic [4:0] WriteRegister,
input logic RegWrite, 
input logic clk
);

	logic [31:0] register_selector; // Wires for registers' write_enable.
	logic [30:0][63:0] register_inputs; // Wires for registers' WriteData
	logic [31:0][63:0] register_outputs; // Wires for regiters' ReadData
	
	big_decoder decoder (.in(WriteRegister), .en(RegWrite), .y(register_selector)); // Decoder, sends output to write enable of every register (register_selector)
	  
	genvar i;
	generate
		for (i = 30; i >= 0; i--) begin: regester_write_data
			assign register_inputs[i][63:0] = WriteData; // Assigns WriteData to every registers input.
		end
	endgenerate
	
	_32registers registers (				// Instantiates the 32 registers, the input for the registers comes from register_inputs.
	.write_en(register_selector[30:0]), // a write enable wire is connected to each register and the outputs go into the muxes.
	.write_data(register_inputs),
	.output_data(register_outputs),
	.clk(clk),
	.reset(1'b0));
	
	big_daddy_elon_mux read_reg_1 (.output_data(ReadData1), .input_data(register_outputs), .selects(ReadRegister1)); // two 64x31:1 muxes for ReadData1 and ReadData2
	big_daddy_elon_mux read_reg_2 (.output_data(ReadData2), .input_data(register_outputs), .selects(ReadRegister2)); // controlled by ReadRegister1 and ReadRegister2
endmodule
