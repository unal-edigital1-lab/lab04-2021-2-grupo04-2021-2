# lab04 Diseño de banco de Registro
* Abraham Felipe Másmela Ramirez
# Comentarios y compresion del banco de registros en verilog

```verilog
module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 8,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 4  //  BIT_DATO  Número de bit para el dato
	)
	(
    input [BIT_ADDR-1:0] addrRa, //direcciones de los  2 registros que se leen simultaneamente
    input [BIT_ADDR-1:0] addrRb,
    
	 output [BIT_DATO-1:0] datOutRa, //datos de los 2 registros que se leen simultaneamente
    output [BIT_DATO-1:0] datOutRb,
    
	 input [BIT_ADDR:0] addrW, // direccion del registro que se escribe
    input [BIT_DATO-1:0] datW, // dato en binario que se escribe (maximo 9 - 1001)
    
	 input RegWrite, //señal que dicta si se guarda o no un dato
    input clk, //reloj del sistema
    input rst // opcion para resetear cada registro 
    );

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** BIT_ADDR; //constante que no se modifica (corregir, solo deben ser 8)
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];


assign  datOutRa = breg[addrRa]; //elementos del banco de registros en una direccion especificia
assign  datOutRb = breg[addrRb];

always @(posedge clk) begin //se ejecuta con cada flanco positivo del relog
	if (RegWrite == 1) //con el 1 se guarda la informacion en un registro espefico
     breg[addrW] <= datW;
  end



endmodule
```