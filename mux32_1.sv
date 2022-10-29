`timescale 10ps/1ps
module mux32_1 (out, inputs, select);   
  output logic out;    
  input  logic [31:0] inputs;
  input  logic [4:0] select;
     
  logic  v0, v1;   
  
  mux16_1 m0(.out(v0), .inputs(inputs[15:0]), .select(select[3:0])); //combines 2 16:1 muxes using a 2:1 mux to create 32:1 mux   
  mux16_1 m1(.out(v1), .inputs(inputs[31:16]), .select(select[3:0]));
  mux2_1 m(.out(out), .inputs({v1,v0}), .select(select[4])); // 16:1 muxes outputs go into inputs of 2:1 mux
endmodule

module mux32_1_tb();  // tests various input configurations
  logic  [31:0] inputs;
  logic  [4:0] select;  
  logic  out;      
       
  mux32_1 dut (.out, .inputs, .select);      
     
  integer i;   
  initial begin  
	 inputs = 32'b01010101010101010101010101010101; #960;
    for(i=0; i< 32; i++) begin   
      {select} = i; #30;    
    end   
  end   
endmodule
