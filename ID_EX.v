module ID_EX(  clk_i, MemtoReg_i, Regwrite_i, BranchType_i, Branch_i, Memwrite_i, Memread_i, pc_jump_i, RegDst_i, ALUOP_i, ALUSrc_i, increment_4_i, data1_i, data2_i, sign_extend_i, Rt_addr_i, Rd_addr_i, Jump_i, RS_addr_i, IF_IDwrite,                                              
					  MemtoReg_o, Regwrite_o, BranchType_o, Branch_o, Memwrite_o, Memread_o, pc_jump_o, RegDst_o, ALUOP_o, ALUSrc_o, increment_4_o, data1_o, data2_o, sign_extend_o, Rt_addr_o, Rd_addr_o ,Jump_o, RS_addr_o);

input          clk_i;
input  MemtoReg_i, Regwrite_i, Branch_i, Memwrite_i, Memread_i, RegDst_i,  ALUSrc_i;
input 		   BranchType_i, Jump_i,  IF_IDwrite;
input [3-1:0]  ALUOP_i;
input [32-1:0] pc_jump_i, increment_4_i, data1_i, data2_i, sign_extend_i;
input [5-1:0]  RS_addr_i, Rt_addr_i, Rd_addr_i;

output reg MemtoReg_o, Regwrite_o, Branch_o, Memwrite_o, Memread_o, RegDst_o,  ALUSrc_o;
output reg 		    BranchType_o, Jump_o;
output reg [3-1:0]  ALUOP_o;
output reg [32-1:0] pc_jump_o, increment_4_o, data1_o, data2_o, sign_extend_o;
output reg [5-1:0]  RS_addr_o, Rt_addr_o, Rd_addr_o;


always @(posedge clk_i) begin
	    MemtoReg_o <= MemtoReg_i; Regwrite_o <= Regwrite_i; BranchType_o <= BranchType_i; 
		Branch_o <= Branch_i; Memwrite_o <=  Memwrite_i; Memread_o <= Memread_i; pc_jump_o <= pc_jump_i;
		RegDst_o <= RegDst_i; ALUOP_o <= ALUOP_i; ALUSrc_o <= ALUSrc_i; 
		increment_4_o <= increment_4_i; data1_o <= data1_i; data2_o <= data2_i; 
		sign_extend_o <= sign_extend_i; Rt_addr_o <= Rt_addr_i; Rd_addr_o <= Rd_addr_i; Jump_o <= Jump_i;                                                
		RS_addr_o <= RS_addr_i;			 

end

initial begin
	    MemtoReg_o = 0; Regwrite_o = 0; BranchType_o = 0; 
		Branch_o = 0; Memwrite_o =  0; Memread_o = 0; pc_jump_o = 0;
		RegDst_o = 0; ALUOP_o = 0; ALUSrc_o = 0; 
		increment_4_o = 0; data1_o = 0; data2_o = 0; 
		sign_extend_o = 0; Rt_addr_o = 0; Rd_addr_o = 0; Jump_o = 0;
		RS_addr_o = 0;
end

endmodule