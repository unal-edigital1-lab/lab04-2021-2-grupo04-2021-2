`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:29:15 10/17/2019
// Design Name:   BancoRegistro
// Module Name:   C:/Users/UECCI/Documents/GitHub/SPARTAN6-ATMEGA-MAX5864/lab/lab07-BancosRgistro/bancoreg/src/TestBench.v
// Project Name:  lab07-BancosRgistro
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BancoRegistro
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestBench;

	// Inputs
	reg [3:0] addrRa;
	reg [3:0] addrRb;
	reg [3:0] addrW;
	reg [3:0] datW;
	reg RegWrite;
	reg clk;
	reg rst;

	// Outputs
	wire [3:0] datOutRa;
	wire [3:0] datOutRb;
	//extras
	
	wire [6:0] sseg;
	//output reg [5:0] an,
	wire led;

	// Instantiate the Unit Under Test (UUT)
	BancoRegistro uut (
		.addrRa(addrRa), 
		.addrRb(addrRb), 
		.datOutRa(datOutRa), 
		.datOutRb(datOutRb), 
		.addrW(addrW), 
		.datW(datW), 
		.RegWrite(RegWrite), 
		.clk(clk), 
		.rst(rst),
		.sseg(sseg),
		.led(led),
		
	);

	initial begin
		// Initialize Inputs
		addrRa = 0;
		addrRb = 0;
		addrW = 0;
		datW = 0;
		RegWrite = 1;
		clk = 0;
		rst = 1;
		#5;
		
		
		
		//escritura de 8 registros
		RegWrite = 0;
		
		addrW =4'b0000; //0
		datW =4'b0010; //2
		#5;
		addrW =4'b0001; //1
		datW =4'b1001; //9
		#5;
		addrW =4'b0010; //2
		datW =4'b0001; //1
		#5;
		addrW =4'b0011; //3
		datW =4'b0011; //3
		#5;
		addrW =4'b0100; //4
		datW =4'b0101; //5
		#5;
		addrW =4'b0101; //5
		datW =4'b0111; //7
		#5;
		addrW =4'b0110; //6
		datW =4'b0001; //1
		#5
		addrW =4'b0111; //7
		datW =4'b1000; //8
		
		
		
		// Wait 100 ns for global reset to finish
		//lecctura de los 8 registros completos
		#100;
      for (addrRa = 0; addrRa < 4; addrRa = addrRa + 1) begin
			#5 addrRb=addrRa+4;
			 $display("el valor de registro %d =  %d y el valor de registro %d = %d", addrRa,datOutRa,addrRb,datOutRb) ;
		end
		
	end
	//relog que cambia
	 
	 always #1 clk = ~clk;
      
endmodule