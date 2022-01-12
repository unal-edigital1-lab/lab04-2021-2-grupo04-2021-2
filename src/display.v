`timescale 1ns / 1ps

module display(//entran 6 numeros que seran represetnados en 6 displays
    //input [15:0] num, //arreglo de 16 digitos que en realidad son 4 numeros en BCD
	 input [3:0] datA,
	 input [3:0]datB,
	 input [3:0] addrRa,
	 input [3:0]addrRb,
	 input [3:0]datW,
	 input [3:0]addrW,
    input clk, // //reloj
    output [6:0] sseg, //Arreglo de 7 bits para prender los leds de los displays
    output reg [5:0] an, //Arreglo de 6 bits para prender y apagar los 6 displays
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

reg [2:0] count =0;
always @(posedge enable) begin //Se ejecutara el procedimiento en un flanco positivo del enable.
		count<= count+1;
		an<=4'b1101; 
		case (count) //dependiendo del Count se le asigna al bcd un agrupamiento de 4 bits contenidos en num
			2'h0: begin bcd <= datA;   an<=6'b111110; end 
			2'h1: begin bcd <= datB;   an<=6'b111101; end 
			2'h2: begin bcd <= addrRa; an<=6'b111011; end 
			2'h3: begin bcd <= addrRb; an<=6'b110111; end 
			2'h4: begin bcd <= datW;   an<=6'b101111; end 
			2'h5: begin bcd <= addrW;  an<=6'b011111; end 
			//numeros extra
			2'h6: begin bcd <= datA;   an<=6'b111110; end
			2'h7: begin bcd <= datB;   an<=6'b111101; end 
		endcase
end

endmodule