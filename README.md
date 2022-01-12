# lab04 Diseño de banco de Registro
* Abraham Felipe Másmela Ramirez
# Comentarios y compresion del banco de registros en verilog

## Codigo del modulo BancoRegistroTotal
```verilog
module BancoRegistroTotal(//modulo grande
	
	//Entradas y salidas del sistema
	input [3:0]addrRa, //direcciones de los  2 registros que se leen simultaneamente
   input [3:0]addrRb,
	input  [3:0]addrW, // direccion del registro que se escribe
   input  [3:0]datW, // dato en binario que se escribe (maximo 9 - 1001)
	input RegWrite, //señal que dicta si se guarda o no un dato //boton
   input clk, //reloj del sistema
   input rst, // opcion para resetear cada registro //boton

	//output que conectan con el modulo display 
	output [6:0] sseg,
	output [3:0] an,
	output led);
	
	//conexiones entre el top y el modulo display y banco de registro
	
	wire[3:0] datOutRa; //datos de los 2 registros que se leen simultaneamente
   wire [3:0] datOutRb;
	
	//instancia modulo bancoRegistro
	BancoRegistro #(.BIT_ADDR(3), .BIT_DATO(4)) B(.addrRa(addrRa), .addrRb(addrRb), .datOutRa(datOutRa), .datOutRb(datOutRb), .addrW(addrW), .datW(datW), .RegWrite(RegWrite), .clk(clk), .rst(rst));
	
	//instancia modulo display
	display disp(.datA(datOutRa), .datB(datOutRb), .addrRa(addrRa), .addrRb(addrRb), .clk(clk), .sseg(sseg), .an(an), .led(led));
	
	endmodule
```
## Codigo del modulo BancoRegistro
```verilog
module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 3,  //   BIT_ADDR Números de bit para la dirección
         parameter BIT_DATO = 4  //  BIT_DATO  Números de bits para el dato
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
    input rst // opcion para resetear cada registro //boton
	 
	 //output [6:0] sseg,
	 //output [5:0] an,
	 //output led
    );

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** (BIT_ADDR); //constante que no se modifica
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];



assign  datOutRa = breg[addrRa]; //elementos del banco de registros en una direccion especificia
assign  datOutRb = breg[addrRb];

integer x;
always @(posedge clk) begin //se ejecuta con cada flanco positivo del relog
	if (RegWrite == 0) //si se oprime el boton regWrite con el 1 se guarda la informacion en un registro espefico
     breg[addrW] <= datW;
	  
	if (rst == 0)begin //si se oprime el boton reset todos los elementos de los registros se igualan a 0
		for(x=0; x<NREG; x =x+1)begin
			breg[x] <=0;
		end
		
	end
		
	
	
end

//precargar con datos
initial begin
	 $readmemh("RegistroInicial.txt", breg);
end

endmodule
```
## Codigo del modulo display
```verilog
`timescale 1ns / 1ps

module display(//entran 6 numeros que seran represetnados en 6 displays
    //input [15:0] num, //arreglo de 16 digitos que en realidad son 4 numeros en BCD
	 input [3:0] datA,
	 input [3:0]datB,
	 input [3:0] addrRa,
	 input [3:0]addrRb,
	 //input [3:0]datW,
	 //input [3:0]addrW,
    input clk, // //reloj
    output [6:0] sseg, //Arreglo de 7 bits para prender los leds de los displays
    output reg [3:0] an, //Arreglo de 6 bits para prender y apagar los 4 displays
	 //input rst,
	 output led
    );



reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));//implementacion del modulo BCDtoSSeg

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16]; //aumento numero, disminuyo velocidad, aumenta periodo
assign led =enable;
always @(posedge clk) begin //Se ejecutara el procedimiento cuando detecte flanco positivo del reloj.
	cfreq <=cfreq+1;
end

reg [1:0] count =0;
always @(posedge enable) begin //Se ejecutara el procedimiento en un flanco positivo del enable.
		count<= count+1;
		an<=4'b1101; 
		case (count) //dependiendo del Count se le asigna al bcd un agrupamiento de 4 bits contenidos en num
			2'h0: begin bcd <= datA;   an<=4'b1110; end 
			2'h1: begin bcd <= datB;   an<=4'b1101; end 
			2'h2: begin bcd <= addrRa; an<=4'b1011; end 
			2'h3: begin bcd <= addrRb; an<=4'b0111; end 
			//numeros extra
			default;
		endcase
end

endmodule
```
## Codigo del modulo BCDtoSSeg
```verilog
module BCDtoSSeg (BCD, SSeg); //creacion del modulo

  input [3:0] BCD; // Digito representado en 4 bits 
  output reg [0:6] SSeg; // Agrupacion de 7 bits que apaga o prende los siete diodos de un display para representar un numero hexadecimal


always @ ( * ) begin //Cada que cambia el BDC se ejecutan estas lineas de codigo
  case (BCD) // Se compara el valor BCD con 15 posibles opciones donde cada uno corresponde a 
  //una configuracion de diodos prendidos para representar un numero o simbolo hexadecimal
    4'b0000: SSeg = 7'b0000001; // "0"  
	4'b0001: SSeg = 7'b1001111; // "1" 
	4'b0010: SSeg = 7'b0010010; // "2" 
	4'b0011: SSeg = 7'b0000110; // "3" 
	4'b0100: SSeg = 7'b1001100; // "4" 
	4'b0101: SSeg = 7'b0100100; // "5" 
	4'b0110: SSeg = 7'b0100000; // "6" 
	4'b0111: SSeg = 7'b0001111; // "7" 
	4'b1000: SSeg = 7'b0000000; // "8"  
	4'b1001: SSeg = 7'b0000100; // "9" 
    4'ha: SSeg = 7'b0001000;     // "A" 
    4'hb: SSeg = 7'b1100000;     // "B" 
    4'hc: SSeg = 7'b0110001;     // "C" 
    4'hd: SSeg = 7'b1000010;     // "D" 
    4'he: SSeg = 7'b0110000;     // "E" 
    4'hf: SSeg = 7'b0111000;     // "F" 
    default:
    SSeg = 0;
  endcase
end

endmodule
```

## Codigo del modulo TestBench
```verilog
`timescale 1ns / 1ps

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
	BancoRegistroTotal uut (
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
```
## Codigo del modulo TestBench
El video del funcionamiento del banco de registros en la fpga
<https://youtu.be/m0D_aaN-RmQ>