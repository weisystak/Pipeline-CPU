module ALU_1bit( a,b, operation, result, carryIn, carryOut); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire[4-1:0] operation;
  input wire carryIn;
  

  /*your code here*/   
  wire out;
  wire sum;
  Full_adder fa1(sum, out, carryIn, a, b);
	
	
	assign result = (operation == 0 || operation == 1)? sum:               // add sub
					(operation == 2)?  a & b:  // and
					(operation == 3)?  a | b:  // or
					(operation == 4)? ~(a | b):// nor
					(operation == 5)? sum:     //slt
					(operation == 6)? sum:     //addi
					(operation == 7)? a | b:   //LUi
					0;
	assign carryOut = out;
 	/* always @* begin
	  if(operation == 2'b10) begin
		//Add
		if( invertA == 0 && invertB == 0) begin
			assign result = sum;
			assign carryOut = out;
			end
		//Sub
		else if( invertA == 0 && invertB == 1) begin
			assign result = sum;
			assign carryOut = out;
			end
	   end
	   else if(operation == 2'b00)
			//And
			if( invertA == 0 && invertB == 0) 
				assign result = a & b;
			//Nor
			else if( invertA == 1 && invertB == 1)
				assign result = ~(a | b);
		else if(operation == 2'b01)
			//Or
			if( invertA == 0 && invertB == 0)
				assign result = a | b;
			//Nand
			else if( invertA == 1 && invertB == 1)
				assign result = ~(a & b);
		else if(operation == 2'b11)
			//Slt
			if(invertA == 0 && invertB == 1)
				assign result = 0;
	end  */
	
endmodule















