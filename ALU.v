module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
/*your code here*/
wire	[32-1:0] a;
wire	[32-1:0] b;
wire [4-1:0] operation;

assign operation = ALU_operation_i;


assign a = aluSrc1;
assign b = (operation == 1 || operation == 5)? (aluSrc2 != 0)? ~aluSrc2 + 1: aluSrc2: //slt, sub
			(operation == 7)?  {{aluSrc2[15:0]},{16'h0000}}: //LUi
			aluSrc2;

wire[31:0] carryOut;
wire[31:0] t_result;

  
ALU_1bit a0( a[0], b[0], operation, t_result[0], 1'b0, carryOut[0]);
ALU_1bit a1( a[1], b[1], operation, t_result[1], carryOut[0], carryOut[1]);
ALU_1bit a2( a[2], b[2], operation, t_result[2], carryOut[1], carryOut[2]);
ALU_1bit a3( a[3], b[3], operation, t_result[3], carryOut[2], carryOut[3]);
ALU_1bit a4( a[4], b[4], operation, t_result[4], carryOut[3], carryOut[4]);
ALU_1bit a5( a[5], b[5], operation, t_result[5], carryOut[4], carryOut[5]);
ALU_1bit a6( a[6], b[6], operation, t_result[6], carryOut[5], carryOut[6]);
ALU_1bit a7( a[7], b[7], operation, t_result[7], carryOut[6], carryOut[7]);
ALU_1bit a8( a[8], b[8], operation, t_result[8], carryOut[7], carryOut[8]);
ALU_1bit a9( a[9], b[9], operation, t_result[9], carryOut[8], carryOut[9]);
ALU_1bit a10( a[10], b[10], operation, t_result[10], carryOut[9], carryOut[10]);
ALU_1bit a11( a[11], b[11], operation, t_result[11], carryOut[10], carryOut[11]);
ALU_1bit a12( a[12], b[12], operation, t_result[12], carryOut[11], carryOut[12]);
ALU_1bit a13( a[13], b[13], operation, t_result[13], carryOut[12], carryOut[13]);
ALU_1bit a14( a[14], b[14], operation, t_result[14], carryOut[13], carryOut[14]);
ALU_1bit a15( a[15], b[15], operation, t_result[15], carryOut[14], carryOut[15]);
ALU_1bit a16( a[16], b[16], operation, t_result[16], carryOut[15], carryOut[16]);
ALU_1bit a17( a[17], b[17], operation, t_result[17], carryOut[16], carryOut[17]);
ALU_1bit a18( a[18], b[18], operation, t_result[18], carryOut[17], carryOut[18]);
ALU_1bit a19( a[19], b[19], operation, t_result[19], carryOut[18], carryOut[19]);
ALU_1bit a20( a[20], b[20], operation, t_result[20], carryOut[19], carryOut[20]);
ALU_1bit a21( a[21], b[21], operation, t_result[21], carryOut[20], carryOut[21]);
ALU_1bit a22( a[22], b[22], operation, t_result[22], carryOut[21], carryOut[22]);
ALU_1bit a23( a[23], b[23], operation, t_result[23], carryOut[22], carryOut[23]);
ALU_1bit a24( a[24], b[24], operation, t_result[24], carryOut[23], carryOut[24]);
ALU_1bit a25( a[25], b[25], operation, t_result[25], carryOut[24], carryOut[25]);
ALU_1bit a26( a[26], b[26], operation, t_result[26], carryOut[25], carryOut[26]);
ALU_1bit a27( a[27], b[27], operation, t_result[27], carryOut[26], carryOut[27]);
ALU_1bit a28( a[28], b[28], operation, t_result[28], carryOut[27], carryOut[28]);
ALU_1bit a29( a[29], b[29], operation, t_result[29], carryOut[28], carryOut[29]);
ALU_1bit a30( a[30], b[30], operation, t_result[30], carryOut[29], carryOut[30]);
ALU_1bit a31( a[31], b[31], operation, t_result[31], carryOut[30], carryOut[31]);


assign result = (operation == 5)? (aluSrc1[31] == 0 && aluSrc2[31] == 1)? 0 :  //slt
								  (aluSrc1[31] == 1 && aluSrc2[31] == 0)? 1 :
								  (t_result[31] == 1 )? 1 : 0 :
								   t_result; 
//add sub slt
assign overflow = (operation == 0 )? 				   (aluSrc1[31] == 0 && aluSrc2[31] == 0 && t_result[31] == 1) ? 1 : 
													   (aluSrc1[31] == 1 && aluSrc2[31] == 1 && t_result[31] == 0) ? 1 : 0 :
				  (operation == 1 || operation == 5)?  (aluSrc1[31] == 0 && aluSrc2[31] == 1 && t_result[31] == 1) ? 1 : 
													   (aluSrc1[31] == 1 && aluSrc2[31] == 0 && t_result[31] == 0) ? 1 : 0 :
																								0;
assign zero = (result == 0)? 1:0;
  
endmodule
