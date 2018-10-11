module Forwarding(EX_MEM_RegWrite, EX_MEM_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt, MEM_WB_RegWrite, MEM_WB_RegisterRd, ForwardA, ForwardB);

input EX_MEM_RegWrite, MEM_WB_RegWrite;
input [5-1:0] EX_MEM_RegisterRd, ID_EX_RegisterRs, ID_EX_RegisterRt, MEM_WB_RegisterRd;
output [2-1:0] ForwardA, ForwardB;

				   //EX hazard
assign ForwardA = (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)&& (EX_MEM_RegisterRd == ID_EX_RegisterRs))? 2'b10:
				   //MEM hazard
				  (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)&&  (MEM_WB_RegisterRd == ID_EX_RegisterRs))? 2'b01:
				  0;
				  //EX hazard
assign ForwardB = (EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0)&& (EX_MEM_RegisterRd == ID_EX_RegisterRt))? 2'b10:
				  //MEM hazard
				  (MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0)&& (MEM_WB_RegisterRd == ID_EX_RegisterRt))? 2'b01:
				  0;

endmodule