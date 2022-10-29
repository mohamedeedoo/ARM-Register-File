//16:1 mux

`timescale 10ps/1ps
module mux16_1 (out, inputs, select);   
  output logic out;    // Output
  input  logic [15:0] inputs; // Inputs
  input  logic [3:0] select; // Select
     
  logic  v0, v1;   
  
  mux8_1 m0(.out(v0), .inputs(inputs[7:0]), .select(select[2:0]));  // Combines two 8:1 muxes using a 2:1 mux to create 16:1 mux.
  mux8_1 m1(.out(v1), .inputs(inputs[15:8]), .select(select[2:0]));
  mux2_1 m(.out(out), .inputs({v1,v0}), .select(select[3])); // 8:1 muxes outputs go into inputs of 2:1 mux
endmodule     