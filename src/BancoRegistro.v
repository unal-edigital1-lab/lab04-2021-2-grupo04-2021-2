`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:28 10/12/2019 
// Design Name: 	 ferney alberto beltran
// Module Name:    BancoRegistro 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 4,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 4  //  BIT_DATO  Número de bit para el dato
	)
	(
    input [BIT_ADDR-1:0] addrRa, //direcciones de los  2 registros que se leen simultaneamente
    input [BIT_ADDR-1:0] addrRb,
    
	 output [BIT_DATO-1:0] datOutRa, //datos de los 2 registros que se leen simultaneamente
    output [BIT_DATO-1:0] datOutRb,
    
	 input [BIT_ADDR-1:0] addrW, // direccion del registro que se escribe
    input [BIT_DATO-1:0] datW, // dato en binario que se escribe (maximo 9 - 1001)
    
	 input RegWrite, //señal que dicta si se guarda o no un dato //boton
    input clk, //reloj del sistema
    input rst, // opcion para resetear cada registro //boton
	 
	 output [6:0] sseg,
	 //output reg [5:0] an,
	 output led
    );

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** (BIT_DATO-1); //constante que no se modifica
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];


assign  datOutRa = breg[addrRa]; //elementos del banco de registros en una direccion especificia
assign  datOutRb = breg[addrRb];

always @(posedge clk) begin //se ejecuta con cada flanco positivo del relog
	if (RegWrite == 0) //si se oprime el boton regWrite con el 1 se guarda la informacion en un registro espefico
     breg[addrW] <= datW;
	if (rst == 0)begin //si se oprime el boton reset todos los elementos de los registros se igualan a 0
		breg[0] <= 0;
		breg[1] <= 0;
		breg[2] <= 0;
		breg[3] <= 0;
		breg[4] <= 0;
		breg[5] <= 0;
		breg[6] <= 0;
		breg[7] <= 0;
	end
	
		
  end


  //instancia del modulo de display
  
display disp(.datA(datOutRa), .datB(datOutRb), .addrRa(addrRa), .addrRb(addrRb), .datW(datW), .addrW(addrW), .clk(clk), .sseg(sseg), .led(led));
endmodule

