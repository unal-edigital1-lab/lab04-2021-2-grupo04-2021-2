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