module IF_ID(  clk_i, increment_4_i, instr_i, increment_4_o, instr_o, IF_IDwrite);

input          clk_i, IF_IDwrite;
input [32-1:0] increment_4_i;
input [32-1:0] instr_i;

output [32-1:0] increment_4_o;
output [32-1:0] instr_o;

reg [32-1:0] increment_4_o;
reg [32-1:0] instr_o;

always @(posedge clk_i ) begin
	increment_4_o <= increment_4_i;
	instr_o <= instr_i;

end

initial begin
    increment_4_o = 0;
	instr_o = 0;
end

endmodule