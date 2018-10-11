module Shifter( result, leftRight, shamt, sftSrc );

//I/O ports 
output	[32-1:0] result;

input			leftRight;
input	[32-1:0] shamt;
input	[32-1:0] sftSrc ;

//Internal Signals
wire	[32-1:0] result;
  
//Main function
/*your code here*/
genvar i;
 
for (i=0; i<32; i=i+1) 
	assign result[i] = (leftRight == 1)?     //shift left 
										(i+shamt>=0 && i+shamt<=31)? sftSrc[(i+shamt)%32]: 0:
										(i-shamt>=0 && i-shamt<=31)?  sftSrc[(i-shamt)%32]:0 ;

endmodule