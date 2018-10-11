module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles

// PC, Adder 
wire    [32-1:0] pc_out_o;
wire	[32-1:0] sum_o;
//PCSrc_branchOrNot
wire PCSrc;
wire b_o;
wire [32-1:0]PCSrc_branchOrNot_o;
//PCSrc_jumpOrNot
wire [32-1:0] pc_jump_p;
wire [32-1:0] pc_jump;
//Adder1
wire [32-1:0] increment_4_o;
//Adder2
wire [32-1:0] increment_imm_o;
// Instr_Memory
wire    [32-1:0] instr_o;
// Decoder
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
//Mux_Write_Reg
wire  		[5-1:0]	Write_Reg;
//Reg_File
wire        [32-1:0] RSdata_o;
wire        [32-1:0] RTdata_o;
//ALU_Ctrl
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;
//Sign_Extend
wire 		[32-1:0] sign_extended;
//Zero_Filled
wire		[32-1:0] zero_filled;
//ALU_src2Src
wire 		[32-1:0] ALUSrc_data;
//ALU
wire			 zero;
wire			 overflow;
wire	[32-1:0] ALU_result;
//shifter
wire	[32-1:0] shift_result;
wire	[32-1:0] shamt;

assign shamt = {27'd0,{sign_extended[10:6]}};
//RDdata_Source
wire        [32-1:0] RDdata;
//Data_Memory
wire [32-1:0] RD_Memory_Data_o;
//Mem_Reg_mux
wire [32-1:0]wb;
//******
assign b_o = (BranchType_o == 0)? zero:
								 !zero;

assign PCSrc = Branch_o & b_o;
assign pc_jump_p = {increment_4_o[31:28], instr_o[25:0], 2'b00};


//modules
wire PCwrite;
wire [32-1:0] sum_o_p;
assign sum_o_p = (PCwrite)? sum_o: pc_out_o;
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(sum_o_p) ,   
	    .pc_out_o(pc_out_o),
		.PCwrite(PCwrite)
	    );

wire [32-1:0] increment_4_o_p;
wire [32-1:0] pc_out_o_p;
assign pc_out_o_p = (PCSrc || Jump_o)? sum_o : pc_out_o;
Adder Adder1(
        .src1_i(pc_out_o_p),     
	    .src2_i(32'd4),
	    .sum_o(increment_4_o_p)    
	    );

wire [32-1:0] instr_o_p;
Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	    .instr_o(instr_o_p)    
	    );

wire  IF_IDwrite, IF_flush, ID_flush, EX_flush, Memread_o_EX;
wire [5-1:0]  RT_addr;
HazardDetectionUnit HD(.ID_EX_MemRead(Memread_o_EX), .ID_EX_RegisterRt(RT_addr), .IF_ID_RegisterRs(instr_o[25:21]), .IF_ID_RegisterRt(instr_o[20:16]), .branch(PCSrc), .jump(Jump_o), .PCwrite(PCwrite), .IF_IDwrite(IF_IDwrite), .IF_flush(IF_flush), .ID_flush(ID_flush), .EX_flush(EX_flush) );

wire [32-1:0] increment_4_o_ID, increment_4_o_pp;	
wire [32-1:0] instr_o_pp, instr_o_ppp;
								//nop
assign instr_o_pp = (IF_flush)? {6'b111111,instr_o_p[25:0]} : instr_o_p;
assign increment_4_o_pp = (IF_IDwrite)? increment_4_o_p: increment_4_o_ID;
assign instr_o_ppp = (IF_IDwrite)? instr_o_pp: instr_o;
IF_ID IFID(
	.clk_i(clk_i), 
	.increment_4_i(increment_4_o_pp), 
	.instr_i(instr_o_ppp), 
	.increment_4_o(increment_4_o_ID), 
	.instr_o(instr_o),
	.IF_IDwrite(IF_IDwrite)
	);


wire [32-1:0] increment_imm_o_p;
Adder Adder2(
        .src1_i(increment_4_o),     
	    .src2_i({sign_extended[29:0], 2'b00}),
	    .sum_o(increment_imm_o_p)    
	    );
		
wire  [32-1:0] pc_branch_o;
Mux2to1 #(.size(32)) PCSrc_branchOrNot(
        .data0_i(increment_4_o_p),
        .data1_i(pc_branch_o),
        .select_i(PCSrc),
        .data_o(PCSrc_branchOrNot_o)
        );	
		
Mux2to1 #(.size(32)) PCSrc_jumpOrNot(
        .data0_i(PCSrc_branchOrNot_o),
        .data1_i(pc_jump),
        .select_i(Jump_o),
        .data_o(sum_o)
        );
		

wire [5-1:0] Write_Reg_p;
wire [5-1:0]   RD_addr;
Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RT_addr),
        .data1_i(RD_addr),
        .select_i(RegDst_o),
        .data_o(Write_Reg_p)
        );	

wire  [32-1:0] RSdata_o_p;
wire  [32-1:0] RTdata_o_p; 		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .Wrtaddr_i(Write_Reg) ,  
        .Wrtdata_i(wb)  , 
        .RegWrite_i(RegWrite_o),
        .RSdata_o(RSdata_o_p) ,  
        .RTdata_o(RTdata_o_p)   
        );

wire 			RegWrite_o_p;
wire	[3-1:0] ALUOp_o_p;
wire			ALUSrc_o_p;
wire			RegDst_o_p;
wire 			Branch_o_p;
wire			BranchType_o_p;
wire 			Jump_o_p;
wire		    MemRead_o_p;
wire 			MemWrite_o_p;
wire			MemtoReg_o_p;	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(RegWrite_o_p), 
	    .ALUOp_o(ALUOp_o_p),   
	    .ALUSrc_o(ALUSrc_o_p),   
	    .RegDst_o(RegDst_o_p),
		.Branch_o(Branch_o_p),
		.BranchType_o(BranchType_o_p),
		.Jump_o(Jump_o_p),
		.MemRead_o(MemRead_o_p),
		.MemWrite_o(MemWrite_o_p),
		.MemtoReg_o(MemtoReg_o_p)
		);

ALU_Ctrl AC(
        .funct_i(sign_extended[5:0]),   
        .ALUOp_i(ALUOp_o),   
        .ALU_operation_o(ALU_operation_o),
		.FURslt_o(FURslt_o)
        );

wire [32-1:0] sign_extended_p;		
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_extended_p)
        );

wire MemtoReg_o_EX, Regwrite_o_EX, Branch_o_EX, Memwrite_o_EX;
wire 		  BranchType_o_EX, Jump_o_EX;
wire [32-1:0] RTdata_o_EX, pc_jump_EX;
wire [5-1:0] RS_addr;

wire RegWrite_o_pp, Branch_o_pp, MemWrite_o_pp, Jump_o_pp, MemRead_o_pp;
wire [5-1:0] Rs_addr_i_p, Rt_addr_i_p;
assign RegWrite_o_pp = (ID_flush)? 0 : RegWrite_o_p;
assign Branch_o_pp = (ID_flush)? 0 : Branch_o_p;
assign MemWrite_o_pp = (ID_flush)? 0 : MemWrite_o_p;
assign Jump_o_pp = (ID_flush)? 0 : Jump_o_p;
assign Rs_addr_i_p = (ID_flush)? 0 : instr_o[25:21];
assign Rt_addr_i_p = (ID_flush)? 0 : instr_o[20:16];
assign MemRead_o_pp = (ID_flush)? 0 : MemRead_o_p;
ID_EX IDEX(  .clk_i(clk_i), .MemtoReg_i(MemtoReg_o_p), .Regwrite_i(RegWrite_o_pp), .BranchType_i(BranchType_o_p), .Branch_i(Branch_o_pp), .Memwrite_i(MemWrite_o_pp), .Memread_i(MemRead_o_pp), .pc_jump_i(pc_jump_p),.RegDst_i(RegDst_o_p), .ALUOP_i(ALUOp_o_p), .ALUSrc_i(ALUSrc_o_p), .increment_4_i(increment_4_o_ID), .data1_i(RSdata_o_p), .data2_i(RTdata_o_p), .sign_extend_i(sign_extended_p), .Rt_addr_i(Rt_addr_i_p), .Rd_addr_i(instr_o[15:11]), .Jump_i(Jump_o_pp), .RS_addr_i(Rs_addr_i_p),   .IF_IDwrite(IF_IDwrite),                                           
							.MemtoReg_o(MemtoReg_o_EX),.Regwrite_o(Regwrite_o_EX),.BranchType_o(BranchType_o_EX),.Branch_o(Branch_o_EX),.Memwrite_o(Memwrite_o_EX),.Memread_o(Memread_o_EX),.pc_jump_o(pc_jump_EX),.RegDst_o(RegDst_o),   .ALUOP_o(ALUOp_o),   .ALUSrc_o(ALUSrc_o),   .increment_4_o(increment_4_o), .data1_o(RSdata_o), .data2_o(RTdata_o_EX), .sign_extend_o(sign_extended), .Rt_addr_o(RT_addr), .Rd_addr_o(RD_addr), .Jump_o(Jump_o_EX), .RS_addr_o(RS_addr));

							
Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zero_filled)
        );

Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(RTdata_o_EX),
        .data1_i(sign_extended),
        .select_i(ALUSrc_o),
        .data_o(ALUSrc_data)
        );	

wire   Regwrite_o_MEM;
wire  [5-1:0]  Reg_addr_o_MEM;
wire [2-1:0] ForwardA, ForwardB;
Forwarding FD(.EX_MEM_RegWrite(Regwrite_o_MEM), .EX_MEM_RegisterRd(Reg_addr_o_MEM), .ID_EX_RegisterRs(RS_addr), .ID_EX_RegisterRt(RT_addr), .MEM_WB_RegWrite(RegWrite_o), .MEM_WB_RegisterRd(Write_Reg), .ForwardA(ForwardA), .ForwardB(ForwardB));

wire			 zero_p;
wire	[32-1:0] ALU_result_p;		
wire [32-1:0] aluSrc1, aluSrc2, RDdata_MEM;
assign aluSrc1 = (ForwardA == 0)? RSdata_o:
				 (ForwardA == 2'b10)? RDdata_MEM:
				 wb;
assign aluSrc2 = (ForwardB == 0)? ALUSrc_data:
				 (ForwardB == 2'b10)? RDdata_MEM:
				 wb;
ALU ALU(
		.aluSrc1(aluSrc1),
	    .aluSrc2(aluSrc2),
	    .ALU_operation_i(ALU_operation_o),
		.result(ALU_result_p),
		.zero(zero_p),
		.overflow(overflow)
	    );
		
Shifter shifter( 
		.result(shift_result), 
		.leftRight(ALU_operation_o[0]),
		.shamt(shamt),
		.sftSrc(ALUSrc_data) 
		);



wire [32-1:0] RDdata_p;
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALU_result_p),
        .data1_i(shift_result),
		.data2_i(zero_filled),
        .select_i(FURslt_o),
        .data_o(RDdata_p)
        );			


//wire  [32-1:0] pc_branch_o;
wire           MemtoReg_o_MEM;

wire Regwrite_o_EX_p, Branch_o_EX_p, Memwrite_o_EX_p, Jump_o_EX_p;
assign Regwrite_o_EX_p = (EX_flush)? 0: Regwrite_o_EX;
assign Branch_o_EX_p = (EX_flush)? 0: Branch_o_EX;
assign Memwrite_o_EX_p = (EX_flush)? 0: Memwrite_o_EX;
assign Jump_o_EX_p = (EX_flush)? 0: Jump_o_EX;

EX_MEM EXMEM(  .clk_i(clk_i), .MemtoReg_i(MemtoReg_o_EX), .Regwrite_i(Regwrite_o_EX_p), .BranchType_i(BranchType_o_EX), .Branch_i(Branch_o_EX_p), .Memwrite_i(Memwrite_o_EX_p), .Memread_i(Memread_o_EX), .pc_jump_i(pc_jump_EX), .pc_branch_i(increment_imm_o_p), .zero_i(zero_p), .ALU_result_i(RDdata_p), .write_data_i(RTdata_o_EX), .Reg_addr_i(Write_Reg_p), .Jump_i(Jump_o_EX_p)  ,                                              
						.MemtoReg_o(MemtoReg_o_MEM),.Regwrite_o(Regwrite_o_MEM),.BranchType_o(BranchType_o),.Branch_o(Branch_o), .Memwrite_o(MemWrite_o),.Memread_o(MemRead_o), .pc_jump_o(pc_jump), .pc_branch_o(pc_branch_o), .zero_o(zero), .ALU_result_o(RDdata_MEM), .write_data_o(RTdata_o), .Reg_addr_o(Reg_addr_o_MEM) , .Jump_o(Jump_o) );

wire  [32-1:0]	RD_Memory_Data_o_p;  
Data_Memory DM(
			.clk_i(clk_i),
			.addr_i(RDdata_MEM),
			.data_i(RTdata_o),
			.MemRead_i(MemRead_o),
			.MemWrite_i(MemWrite_o),
			.data_o(RD_Memory_Data_o_p)
			);

Mux2to1 #(.size(32)) Mem_Reg_mux(
        .data0_i(RD_Memory_Data_o),
        .data1_i(RDdata),
        .select_i(MemtoReg_o),
        .data_o(wb)
        );	


MEM_WB MEMWB(  .clk_i(clk_i), .MemtoReg_i(MemtoReg_o_MEM), .Regwrite_i(Regwrite_o_MEM), .ALU_result_i(RDdata_MEM), .Mem_data_i(RD_Memory_Data_o_p), .Reg_addr_i(Reg_addr_o_MEM),                                                 
							  .MemtoReg_o(MemtoReg_o), .Regwrite_o(RegWrite_o), .ALU_result_o(RD_Memory_Data_o), .Mem_data_o(RDdata), .Reg_addr_o(Write_Reg) );
							  
endmodule



