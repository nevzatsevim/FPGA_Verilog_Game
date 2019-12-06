module  block_shifter(in, row_no, out);
	input [199:0] in;
	input [4:0] row_no;
	output [199:0] out;
	
	//out[9:0] = in[9:0]*(row_no>0) + in[19:10]*(row_no<=0);
	genvar c;
	generate
	for (c = 0; c <19; c = c + 1) begin: test2
            assign out[c*10+9:c*10] = in[c*10+9:c*10]*(row_no>0) + in[c*11+9:c*11]*(row_no<=0);
    end
	 endgenerate
	 assign out[199:190] = 0;
	
endmodule	