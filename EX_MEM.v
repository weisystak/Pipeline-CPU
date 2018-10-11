module EX_MEM(  clk_i, MemtoReg_i, Regwrite_i, BranchType_i, Branch_i, Memwrite_i, Memread_i,  pc_jump_i, pc_branch_i, zero_i, ALU_result_i, write_data_i, Reg_addr_i, Jump_i,                                           
					  MemtoReg_o, Regwrite_o, BranchType_o, Branch_o, Memwrite_o, Memread_o,   pc_jump_o, pc_branch_o, zero_o, ALU_result_o, write_data_o, Reg_addr_o, Jump_o );

input          clk_i;
input  MemtoReg_i, Regwrite_i, Branch_i, Memwrite_i, Memread_i, zero_i;
input 		   BranchType_i, Jump_i;
input [32-1:0]  pc_jump_i, pc_branch_i, ALU_result_i, write_data_i;
input [5-1:0]  Reg_addr_i;

output reg MemtoReg_o, Regwrite_o, Branch_o, Memwrite_o, Memread_o, zero_o;
output reg 			BranchType_o, Jump_o;
output reg [32-1:0]  pc_jump_o, pc_branch_o, ALU_result_o, write_data_o;
output reg [5-1:0]  Reg_addr_o;


always @(posedge clk_i) begin
	    MemtoReg_o <= MemtoReg_i; Regwrite_o <= Regwrite_i; BranchType_o <= BranchType_i; 
		Branch_o <= Branch_i; Memwrite_o <=  Memwrite_i; Memread_o <= Memread_i; pc_jump_o <= pc_jump_i;
		pc_branch_o <= pc_branch_i; zero_o <= zero_i; ALU_result_o <= ALU_result_i; 
		write_data_o <= write_data_i; Reg_addr_o <= Reg_addr_i;	Jump_o <= Jump_i;
end

initial begin
MemtoReg_o = 0; Regwrite_o = 0; BranchType_o = 0; Branch_o = 0; Memwrite_o = 0; Memread_o = 0;  pc_jump_o = 0; pc_branch_o = 0; zero_o = 0; ALU_result_o = 0; write_data_o = 0; Reg_addr_o = 0; Jump_o = 0;
end

endmodule