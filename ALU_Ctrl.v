module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

//Main function
/*your code here*/
assign ALU_operation_o = (ALUOp_i == 3'b010)? (funct_i == 32)? 0 :	//add
											  (funct_i == 34)? 1 : 	//sub
											  (funct_i == 36)? 2 :  //and
											  (funct_i == 37)? 3 :	//or
											  (funct_i == 39)? 4 :	//nor
											  (funct_i == 42)? 5 :	//slt
											  (funct_i == 0)?  0 :   //sll
											  (funct_i == 2)?  1 :   //srl
											  (funct_i == 4)?  0 :    //sllv
											  (funct_i == 6)?  1 : 0 ://srlv
						(ALUOp_i == 3'b100)? 6:    //addi
						(ALUOp_i == 3'b101)? 7:    // lui
						(ALUOp_i == 3'b000)? 0:	//lw sw
						(ALUOp_i == 3'b001)? 1:	//beq
						(ALUOp_i == 3'b110)? 1:	//bne
						(ALUOp_i == 3'b111)? 1: //blt
						(ALUOp_i == 3'b011)? 0: //bgez X
						0; 
// ALU result    shifter result
assign FURslt_o = (ALUOp_i == 3'b010 && (funct_i == 0 || funct_i == 2 || funct_i == 4 || funct_i == 6))? 1 : 0;


endmodule     
