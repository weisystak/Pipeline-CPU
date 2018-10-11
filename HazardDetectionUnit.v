module HazardDetectionUnit(ID_EX_MemRead, ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt, branch, jump, PCwrite, IF_IDwrite, IF_flush, ID_flush, EX_flush );

input ID_EX_MemRead, branch, jump;
input [5-1:0] ID_EX_RegisterRt, IF_ID_RegisterRs, IF_ID_RegisterRt;
output PCwrite, IF_IDwrite, IF_flush, ID_flush, EX_flush;

					//load
assign PCwrite = (ID_EX_MemRead && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt)))? 0: 1;
assign IF_IDwrite = (ID_EX_MemRead && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt)))? 0: 1;

assign IF_flush = (branch || jump)? 1:0;
assign ID_flush = (branch || jump || (ID_EX_MemRead && ((ID_EX_RegisterRt == IF_ID_RegisterRs) || (ID_EX_RegisterRt == IF_ID_RegisterRt))))? 1:0;
assign EX_flush = (branch || jump)? 1:0;

endmodule