module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, Branch_o, BranchType_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
output 			Branch_o;
output			BranchType_o;
output 			Jump_o;
output			MemRead_o;
output 			MemWrite_o;
output			MemtoReg_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;
wire 			Branch_o;
wire			BranchType_o;
wire 			Jump_o;
wire			MemRead_o;
wire 			MemWrite_o;
wire			MemtoReg_o;

//Main function
/*your code here*/
assign RegWrite_o = (instr_op_i == 6'd0 || instr_op_i == 6'd8 || instr_op_i == 6'd15 || instr_op_i == 6'b100011 || instr_op_i == 6'b000011)? 1: 0;  //Rtype, ADDI, LUI, lw, Jal                                   
assign ALUOp_o = (instr_op_i == 6'd0)? 3'b010:  //Rtype
				 (instr_op_i == 6'd8)? 3'b100:	//addi
				 (instr_op_i == 6'd15)? 3'b101: 
				 (instr_op_i == 6'b100011 || instr_op_i == 6'b101011)? 3'b000:  //lw sw
				 (instr_op_i == 6'b000100)? 3'b001: //beq
				 (instr_op_i == 6'b000101)? 3'b110: //bne
				 (instr_op_i == 6'b000110)? 3'b111: //blt
				 (instr_op_i == 6'b000001)? 3'b011: //bgez
										3'b000;
assign ALUSrc_o = (instr_op_i == 6'd0 || instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110 || instr_op_i == 6'b000001)? 0: 1;
assign RegDst_o = (instr_op_i == 6'd0)? 1: 0;
assign Branch_o = (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110 || instr_op_i == 6'b000001)? 1 : 0; //beq, bgez, blt, bne
assign BranchType_o = (instr_op_i == 6'b000100)? 0 :	//beq
												 1 ;	//bne

assign Jump_o = (instr_op_i == 6'b000011 || instr_op_i == 6'b000010)? 1 : 0; //jump, jal
assign MemRead_o = (instr_op_i == 6'b100011)? 1:0; //lw
assign MemWrite_o = (instr_op_i == 6'b101011)? 1:0; //sw
assign MemtoReg_o = (instr_op_i == 6'b100011)? 1:0; //lw 
endmodule
   