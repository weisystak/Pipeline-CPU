module MEM_WB(  clk_i, MemtoReg_i, Regwrite_i, ALU_result_i, Mem_data_i, Reg_addr_i,                                                 
					   MemtoReg_o, Regwrite_o, ALU_result_o, Mem_data_o, Reg_addr_o );

input   clk_i;
input  MemtoReg_i, Regwrite_i;
input [32-1:0] ALU_result_i, Mem_data_i;
input [5-1:0]  Reg_addr_i;

output reg MemtoReg_o, Regwrite_o;
output reg [32-1:0] ALU_result_o, Mem_data_o;
output reg [5-1:0]  Reg_addr_o;


always @(posedge clk_i) begin
	    MemtoReg_o <= MemtoReg_i; Regwrite_o <= Regwrite_i;
		ALU_result_o <= ALU_result_i; Mem_data_o <= Mem_data_i;
		Reg_addr_o <= Reg_addr_i;	
end

initial begin
MemtoReg_o = 0; Regwrite_o = 0; ALU_result_o = 0; Mem_data_o = 0; Reg_addr_o = 0;
end

endmodule