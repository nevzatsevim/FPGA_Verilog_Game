module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 keyboard_data,
							 keyboard_pressed,
							 test_sw_mem_res,
							 test_sw_mem_adr,
							 sw_true_mem_test,
							 
							 q_imem); 
							 
input [31:0] q_imem, test_sw_mem_res, test_sw_mem_adr;	
input sw_true_mem_test;						 
/*****************************************************************************
 *                           INPUTS DECLARATION                              *
 *****************************************************************************/							 						 
input [7:0] keyboard_data;
input keyboard_pressed;
reg kp;
initial kp = 0;

wire left,right,up,down,right_rotate,left_rotate,pause_key, start_key, cheat_key, invisible_key;
assign left = (keyboard_data==8'h6b && kp == 1);
assign right = (keyboard_data==8'h74 && kp == 1);
assign down = (keyboard_data==8'h72 && kp == 1);
assign up = (keyboard_data==8'h75 && kp == 1); 
assign right_rotate = (keyboard_data==8'h21 && kp==1);
assign left_rotate = (keyboard_data==8'h22 && kp==1);
assign pause_key = (keyboard_data==8'h4d && kp==1);
assign start_key = (keyboard_data==8'h1b && kp==1);
assign cheat_key = (keyboard_data==8'h2c && kp==1);
assign invisible_key = (keyboard_data==8'h43 && kp==1);


input iRST_n;
input iVGA_CLK;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;  
                 
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;

assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
										
						
/*****************************************************************************
 *                           ADDRESS GENERATION                              *
 *****************************************************************************/

always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end


/*INDEX addr.*/
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
	
/*Add switch-input logic here=
	Color table output*/
	
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
	
/*latch valid data at falling edge;*/

always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;

wire[6:0] size;
assign size = 20;

/*Define the game frame*/
wire [9:0] gf_x_start, gf_y_start;
wire [9:0] gf_x_size, gf_y_size;

assign gf_x_size = 200;
assign gf_y_size = 400;

assign gf_x_start = 200;
assign gf_y_start = 40;


/*Define starting point for the boxes*/

wire [9:0] x0_start, y0_start;
wire [9:0] x1_start, y1_start;
wire [9:0] x2_start, y2_start;
wire [9:0] x3_start, y3_start;

assign x0_start = 200+gf_x_size/2;
assign y0_start = 40;
assign x1_start = 200+gf_x_size/2;
assign y1_start = 20;

//square

wire [9:0] x2_start_sq, y2_start_sq, x3_start_sq, y3_start_sq;	
assign x2_start_sq = 180+gf_x_size/2;
assign y2_start_sq = 40;
assign x3_start_sq = 180+gf_x_size/2;
assign y3_start_sq = 20;

//L Block
wire [9:0] x2_start_l, y2_start_l, x3_start_l, y3_start_l;
assign x2_start_l = 180+gf_x_size/2;
assign y2_start_l = 40;
assign x3_start_l = 200+gf_x_size/2;
assign y3_start_l = 0;

//Reverse L Block
wire [9:0] x2_start_rl, y2_start_rl, x3_start_rl, y3_start_rl;
assign x2_start_rl = 220+gf_x_size/2;
assign y2_start_rl = 40;
assign x3_start_rl = 200+gf_x_size/2;
assign y3_start_rl = 0;

//Z block
wire [9:0] x2_start_z, y2_start_z, x3_start_z, y3_start_z;
assign x2_start_z = 180+gf_x_size/2;
assign y2_start_z = 20;
assign x3_start_z = 220+gf_x_size/2;
assign y3_start_z = 40; 

//Reverse Z Block
wire [9:0] x2_start_rz, y2_start_rz, x3_start_rz, y3_start_rz;
assign x2_start_rz = 180+gf_x_size/2;
assign y2_start_rz = 40;
assign x3_start_rz = 220+gf_x_size/2;
assign y3_start_rz = 20; 

//T Block
wire [9:0] x2_start_t, y2_start_t, x3_start_t, y3_start_t;
assign x2_start_t = 180+gf_x_size/2;
assign y2_start_t = 40;
assign x3_start_t = 220+gf_x_size/2;
assign y3_start_t = 40; 

//Line Piece
wire [9:0] x2_start_lp, y2_start_lp, x3_start_lp, y3_start_lp;
assign x2_start_lp = 200+gf_x_size/2;
assign y2_start_lp = 0;
assign x3_start_lp = 200+gf_x_size/2;
assign y3_start_lp = 60; 

mux_16 x2_st(random, x2_start_sq, x2_start_rl, x2_start_l,  x2_start_z, x2_start_rz, x2_start_t,
							x2_start_lp, x2_start_sq, x2_start_rl, x2_start_l, x2_start_z,  x2_start_rz,
							x2_start_t,  x2_start_lp, x2_start_t,  x2_start_rz, x2_start);
									
mux_16 y2_st(random, y2_start_sq, y2_start_rl, y2_start_l,  y2_start_z,  y2_start_rz, y2_start_t,
							y2_start_lp, y2_start_sq, y2_start_rl, y2_start_l,  y2_start_z,  y2_start_rz,
							y2_start_t,  y2_start_lp, y2_start_t,  y2_start_rz, y2_start);
							
mux_16 x3_st(random, x3_start_sq, x3_start_rl, x3_start_l,  x3_start_z,  x3_start_rz, x3_start_t,
							x3_start_lp, x3_start_sq, x3_start_rl, x3_start_l,  x3_start_z,  x3_start_rz,
							x3_start_t,  x3_start_lp, x3_start_t,  x3_start_rz, x3_start);
									
mux_16 y3_st(random, y3_start_sq, y3_start_rl, y3_start_l,  y3_start_z,  y3_start_rz, y3_start_t,
							y3_start_lp, y3_start_sq, y3_start_rl, y3_start_l,  y3_start_z,  y3_start_rz,
							y3_start_t,  y3_start_lp, y3_start_t,  y3_start_rz, y3_start);
						  

/*Define the boxes*/

reg[10:0] x0_loc,y0_loc;
wire[10:0] x0_loc_def,y0_loc_def;

reg[10:0] x1_loc,y1_loc;
wire[10:0] x1_loc_def,y1_loc_def;

reg[10:0] x2_loc,y2_loc;
wire[10:0] x2_loc_def,y2_loc_def;

reg[10:0] x3_loc,y3_loc;
wire[10:0] x3_loc_def,y3_loc_def;

assign x0_loc_def = x0_loc - gf_x_start;
assign y0_loc_def = y0_loc - gf_y_start; 
assign x1_loc_def = x1_loc - gf_x_start;
assign y1_loc_def = y1_loc - gf_y_start;  
assign x2_loc_def = x2_loc - gf_x_start;
assign y2_loc_def = y2_loc - gf_y_start; 
assign x3_loc_def = x3_loc - gf_x_start;
assign y3_loc_def = y3_loc - gf_y_start; 

initial x0_loc = 300;
initial y0_loc = 40;
initial x1_loc = 300;
initial y1_loc = 20;
initial x2_loc = 300;
initial y2_loc = 0;
initial x3_loc = 280;
initial y3_loc = 40;

reg[31:0] counter_vga;
reg[3:0] color_select;
reg[3:0] random;

reg game_clock = 0;

always @(posedge iVGA_CLK)
begin
	color_select <= color_select + 1;
	random <= random + 1;
	counter_vga <= counter_vga + 1;
	if (keyboard_pressed == 1) begin
	kp <=1;
	end
	if(counter_vga==2500000) begin
		game_clock <= 1;
		end
	if(counter_vga==2500001) begin
		game_clock <= 0;
		kp <= 0;
		counter_vga <= 0;
		end
end


reg[199:0] board_cell_visited; 
wire[199:0] board_cell_backup;
assign board_cell_backup = board_cell_visited;
///change this when TOTAL CELL NUMBER
//initial board_cell_visited = 200'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;					 
wire [10:0] y0_cell_loc, x0_cell_loc;
wire [10:0] y1_cell_loc, x1_cell_loc;
wire [10:0] y2_cell_loc, x2_cell_loc;
wire [10:0] y3_cell_loc, x3_cell_loc;

wire [20:0] cell0_index,cell1_index,cell2_index,cell3_index;

wire[5:0] y_cell_count, x_cell_count;

assign y_cell_count = gf_y_size/size;  //might be reg // 380->y 320->x size=50    
assign x_cell_count = gf_x_size/size;


assign y0_cell_loc = y_cell_count-y0_loc_def/size;
assign x0_cell_loc = x0_loc_def/size;

assign y1_cell_loc = y_cell_count-y1_loc_def/size;
assign x1_cell_loc = x1_loc_def/size;

assign y2_cell_loc = y_cell_count-y2_loc_def/size;
assign x2_cell_loc = x2_loc_def/size;

assign y3_cell_loc = y_cell_count-y3_loc_def/size;
assign x3_cell_loc = x3_loc_def/size;

assign cell0_index = y0_cell_loc*x_cell_count+x0_cell_loc;
assign cell1_index = y1_cell_loc*x_cell_count+x1_cell_loc;
assign cell2_index = y2_cell_loc*x_cell_count+x2_cell_loc;
assign cell3_index = y3_cell_loc*x_cell_count+x3_cell_loc;

//Check the cell location(board divided to 200) off all 4 squares, and check if any of them
//have a filled block to the left/right/down. (For hitting purposes).

//have a filled block to the left/right/down. (For hitting purposes).

wire cell_one_down, cell_one_right, cell_one_left,cell_one_right2, cell_one_left2,cell_two_down;
assign cell_one_down = board_cell_visited[cell0_index-(1*x_cell_count)]||
         board_cell_visited[cell1_index-(1*x_cell_count)]||
         board_cell_visited[cell2_index-(1*x_cell_count)]||
         board_cell_visited[cell3_index-(1*x_cell_count)];
        
assign cell_two_down = board_cell_visited[cell0_index-(2*x_cell_count)]||
         board_cell_visited[cell1_index-(2*x_cell_count)]||
         board_cell_visited[cell2_index-(2*x_cell_count)]||
         board_cell_visited[cell3_index-(2*x_cell_count)];
        
        

//2 right and lefts because a square can be blocked by two possible blocks to the right/left.
assign cell_one_right = board_cell_visited[cell0_index+1]||
        board_cell_visited[cell1_index+1]||
        board_cell_visited[cell2_index+1]||
        board_cell_visited[cell3_index+1];
        
assign cell_one_left = board_cell_visited[cell0_index-1]||
         board_cell_visited[cell1_index-1]||
         board_cell_visited[cell2_index-1]||
         board_cell_visited[cell3_index-1];
assign cell_one_right2 = board_cell_visited[cell0_index+1-x_cell_count]||
         board_cell_visited[cell1_index+1-x_cell_count]||
         board_cell_visited[cell2_index+1-x_cell_count]||
         board_cell_visited[cell3_index+1-x_cell_count];
assign cell_one_left2 = board_cell_visited[cell0_index-1-x_cell_count]||
          board_cell_visited[cell1_index-1-x_cell_count]||
          board_cell_visited[cell2_index-1-x_cell_count]||
          board_cell_visited[cell3_index-1-x_cell_count];


wire[0:9] shift_size;
assign shift_size = 20;
reg true;
wire [19:0] row_filled; 
row_counter rc(board_cell_visited, row_filled);
integer count,count2;


//SHIFT GLOBAL SECTION
wire right_free,left_free;
wire temp_loc0, temp_loc1, temp;

//Right shift details


wire[29:0] right_shift_Xlocs, right_shift_Ylocs;
assign right_shift_Xlocs[9:0] =  x0_loc+(y0_loc-y1_loc);
assign right_shift_Xlocs[19:10] = x0_loc+(y0_loc-y2_loc);                                 
assign right_shift_Xlocs[29:20] = x0_loc+(y0_loc-y3_loc);                            
assign right_shift_Ylocs[9:0] =  y0_loc+(x0_loc-x1_loc);
assign right_shift_Ylocs[19:10] = y0_loc+(x0_loc-x2_loc);                         
assign right_shift_Ylocs[29:20] = y0_loc+(x0_loc-x3_loc);

wire [29:0] rs_X_loc_def, rs_Y_loc_def, rs_X_cell_locs, rs_Y_cell_locs, rs_cell_indexes;
assign rs_X_loc_def[9:0] =  right_shift_Xlocs[9:0]  - gf_x_start;
assign rs_X_loc_def[19:10] = right_shift_Xlocs[19:10] - gf_x_start;
assign rs_X_loc_def[29:20] = right_shift_Xlocs[29:20] - gf_x_start;
assign rs_Y_loc_def[9:0]  = right_shift_Ylocs[9:0]  - gf_y_start;  
assign rs_Y_loc_def[19:10] = right_shift_Ylocs[19:10] - gf_y_start;  
assign rs_Y_loc_def[29:20] = right_shift_Ylocs[29:20] - gf_y_start;  

assign rs_Y_cell_locs[9:0]  = y_cell_count-rs_Y_loc_def[9:0]/size;
assign rs_Y_cell_locs[19:10]  = y_cell_count-rs_Y_loc_def[19:10]/size;
assign rs_Y_cell_locs[29:20] = y_cell_count-rs_Y_loc_def[29:20]/size;
assign rs_X_cell_locs[9:0] = x_cell_count-rs_X_loc_def[9:0]/size;
assign rs_X_cell_locs[19:10] = x_cell_count-rs_X_loc_def[19:10]/size;
assign rs_X_cell_locs[29:20] = x_cell_count-rs_X_loc_def[29:20]/size;

assign rs_cell_indexes[9:0] = rs_Y_cell_locs[9:0]*x_cell_count+rs_X_cell_locs[9:0];
assign rs_cell_indexes[19:10] = rs_Y_cell_locs[19:10]*x_cell_count+rs_X_cell_locs[19:10];
assign rs_cell_indexes[29:20] = rs_Y_cell_locs[29:20]*x_cell_count+rs_X_cell_locs[29:20];


assign right_free = !board_cell_visited[rs_cell_indexes[9:0]]   &&
						  !board_cell_visited[rs_cell_indexes[19:10]] &&
						  !board_cell_visited[rs_cell_indexes[29:20]] &&
						  right_shift_Xlocs[9:0]   <= gf_x_start+180    &&
				        right_shift_Xlocs[19:10] <= gf_x_start+180    &&
				        right_shift_Xlocs[29:20] <= gf_x_start+180    &&
				        right_shift_Ylocs[9:0]   <= gf_y_start+380       &&
				        right_shift_Ylocs[19:10] <= gf_y_start+380       &&
				        right_shift_Ylocs[29:20] <= gf_y_start+380 &&
						  right_shift_Xlocs[9:0]   >=gf_x_start &&
				        right_shift_Xlocs[19:10] >=gf_x_start &&
				        right_shift_Xlocs[29:20] >=gf_x_start &&
				        right_shift_Ylocs[9:0]   <=(gf_y_start+380) &&
				        right_shift_Ylocs[19:10] <=(gf_y_start+380) &&
				        right_shift_Ylocs[29:20] <=(gf_y_start+380);
                                 

//Left shift details

wire[29:0] left_shift_Xlocs, left_shift_Ylocs;
assign left_shift_Xlocs[9:0]   =  x0_loc-(y0_loc-y1_loc);
assign left_shift_Xlocs[19:10] = x0_loc-(y0_loc-y2_loc);                                 
assign left_shift_Xlocs[29:20] = x0_loc-(y0_loc-y3_loc);                            
assign left_shift_Ylocs[9:0]   =  y0_loc-(x0_loc-x1_loc);
assign left_shift_Ylocs[19:10] = y0_loc-(x0_loc-x2_loc);                         
assign left_shift_Ylocs[29:20] = y0_loc-(x0_loc-x3_loc);

wire [29:0] ls_X_loc_def, ls_Y_loc_def, ls_X_cell_locs, ls_Y_cell_locs, ls_cell_indexes;
assign ls_X_loc_def[9:0] =  left_shift_Xlocs[9:0]  - gf_x_start;
assign ls_X_loc_def[19:10] = left_shift_Xlocs[19:10] - gf_x_start;
assign ls_X_loc_def[29:20] = left_shift_Xlocs[29:20] - gf_x_start;
assign ls_Y_loc_def[9:0]  = left_shift_Ylocs[9:0]  - gf_y_start;  
assign ls_Y_loc_def[19:10] = left_shift_Ylocs[19:10] - gf_y_start;  
assign ls_Y_loc_def[29:20] = left_shift_Ylocs[29:20] - gf_y_start;  

assign ls_Y_cell_locs[9:0]  = y_cell_count-ls_Y_loc_def[9:0]/size;
assign ls_Y_cell_locs[19:10]  = y_cell_count-ls_Y_loc_def[19:10]/size;
assign ls_Y_cell_locs[29:20] = y_cell_count-ls_Y_loc_def[29:20]/size;
assign ls_X_cell_locs[9:0] = x_cell_count-ls_X_loc_def[9:0]/size;
assign ls_X_cell_locs[19:10] = x_cell_count-ls_X_loc_def[19:10]/size;
assign ls_X_cell_locs[29:20] = x_cell_count-ls_X_loc_def[29:20]/size;

assign ls_cell_indexes[9:0] = ls_Y_cell_locs[9:0]*x_cell_count+ls_X_cell_locs[9:0];
assign ls_cell_indexes[19:10] = ls_Y_cell_locs[19:10]*x_cell_count+ls_X_cell_locs[19:10];
assign ls_cell_indexes[29:20] = ls_Y_cell_locs[29:20]*x_cell_count+ls_X_cell_locs[29:20];


assign left_free = !board_cell_visited[ls_cell_indexes[9:0]] &&
						  !board_cell_visited[ls_cell_indexes[19:10]] &&
						  !board_cell_visited[ls_cell_indexes[29:20]]&&
						  left_shift_Xlocs[9:0]   >=gf_x_start &&
				        left_shift_Xlocs[19:10] >=gf_x_start &&
				        left_shift_Xlocs[29:20] >=gf_x_start &&
				        left_shift_Ylocs[9:0]   <=(gf_y_start+380) &&
				        left_shift_Ylocs[19:10] <=(gf_y_start+380) &&
				        left_shift_Ylocs[29:20] <=(gf_y_start+380) &&
						  left_shift_Xlocs[9:0]   <= gf_x_start+180    &&
				        left_shift_Xlocs[19:10] <= gf_x_start+180    &&
				        left_shift_Xlocs[29:20] <= gf_x_start+180    &&
				        left_shift_Ylocs[9:0]   <= gf_y_start+380       &&
				        left_shift_Ylocs[19:10] <= gf_y_start+380       &&
				        left_shift_Ylocs[29:20] <= gf_y_start+380;
				

reg pause;
reg start;
reg fail;
reg invisible;
reg [9:0] piece_count;
reg [9:0] drop_speed;
initial piece_count = 1;
initial start = 0; 
initial pause = 0;
initial fail = 0;
initial invisible = 0;
reg[9:0] score;
reg[9:0] score_keep;
initial score=0;

//where we work with the inputs from the controller

always @(posedge game_clock)
begin
   start <= start + start_key;
	invisible <= invisible + invisible_key;
	drop_speed <= (piece_count/20) + 1;
	if(start == 0) begin
	board_cell_visited = 0;
   y0_loc <= y0_start;
   x0_loc <= x0_start;
   y1_loc <= y1_start;
   x1_loc <= x1_start;
   y2_loc <= y2_start;
   x2_loc <= x2_start;
   y3_loc <= y3_start;
   x3_loc <= x3_start;
	piece_count <= 1; 
	score_keep <= 0;
	end
	else begin
 //Altinda Blok yoksa
  pause<=pause + pause_key;
  fail <= board_cell_visited[186] ||  board_cell_visited[185] ||  board_cell_visited[184];
  if(!pause && !fail) 
  begin
  
  	if(cheat_key == 1) begin
	board_cell_visited = board_cell_visited >> 10;
	score_keep <= score_keep + 1; 
	end
 
  y0_loc <= y0_loc+drop_speed; //free fall'a devam et
  y1_loc <= y1_loc+drop_speed;
  y2_loc <= y2_loc+drop_speed;
  y3_loc <= y3_loc+drop_speed;

  
  if(((y0_loc)>=(gf_y_size+gf_y_start-size) ||  //GF yerine degmezse
    (y1_loc)>=(gf_y_size+gf_y_start-size) ||
  (y2_loc)>=(gf_y_size+gf_y_start-size) ||
  (y3_loc)>=(gf_y_size+gf_y_start-size)) ||
  ((cell_one_down) ))
     begin      
    board_cell_visited[cell0_index] = 1;   
    board_cell_visited[cell1_index] = 1;
    board_cell_visited[cell2_index] = 1;
    board_cell_visited[cell3_index] = 1;
    
   y0_loc <= y0_start;
   x0_loc <= x0_start;
   y1_loc <= y1_start;
   x1_loc <= x1_start;
   y2_loc <= y2_start;
   x2_loc <= x2_start;
   y3_loc <= y3_start;
   x3_loc <= x3_start;
	piece_count <= piece_count + 1; 
   end
  
 if (up==1)
 begin
    y0_loc <= y0_loc - shift_size;
  y1_loc <= y1_loc - shift_size;
  y2_loc <= y2_loc - shift_size;
  y3_loc <= y3_loc - shift_size;
  end
  if (down==1)
  begin //DOWN'un calisacagi zaman
  if(
    (y0_loc+shift_size)<(gf_y_size+gf_y_start-size) &&
  (y1_loc+shift_size)<(gf_y_size+gf_y_start-size) &&
  (y2_loc+shift_size)<(gf_y_size+gf_y_start-size) &&
  (y3_loc+shift_size)<(gf_y_size+gf_y_start-size) &&
   !cell_two_down)
   begin
    y0_loc <= y0_loc + shift_size;
  y1_loc <= y1_loc + shift_size;
  y2_loc <= y2_loc + shift_size;
  y3_loc <= y3_loc + shift_size;
 end
   
  else//DOWN'un carpip duracagi zaman
  begin
  //if((y0_loc+shift_size)>(gf_y_size+gf_y_start-size)  && y0_loc>0) begin
   
    board_cell_visited[cell0_index-10] = 1;
    board_cell_visited[cell1_index-10] = 1;
    board_cell_visited[cell2_index-10] = 1;
    board_cell_visited[cell3_index-10] = 1;
    
  y0_loc <= y0_start;
  x0_loc <= x0_start;
  y1_loc <= y1_start;
  x1_loc <= x1_start;
  y2_loc <= y2_start;
  x2_loc <= x2_start;
  y3_loc <= y3_start;
  x3_loc <= x3_start;
  piece_count <= piece_count + 1; 
  end
   
 end
 if ((right==1) && (x0_loc+shift_size)<=(gf_x_size+gf_x_start-size) &&
       (x1_loc+shift_size)<=(gf_x_size+gf_x_start-size) &&
       (x2_loc+shift_size)<=(gf_x_size+gf_x_start-size) &&
       (x3_loc+shift_size)<=(gf_x_size+gf_x_start-size))
		  begin
		  
			
		if ((!cell_one_right&&!cell_one_right2))
			begin
			x0_loc <= x0_loc + shift_size;
			x1_loc <= x1_loc + shift_size;
			x2_loc <= x2_loc + shift_size;
			x3_loc <= x3_loc + shift_size; 
			end
		else if((y0_loc_def%size<=1)&&(!cell_one_right)) begin
		
			
			
			board_cell_visited[cell0_index+1] = 1;
			board_cell_visited[cell1_index+1] = 1;
			board_cell_visited[cell2_index+1] = 1;
			board_cell_visited[cell3_index+1] = 1;
			
			y0_loc <= y0_start;
         x0_loc <= x0_start;
         y1_loc <= y1_start;
         x1_loc <= x1_start;
         y2_loc <= y2_start;
         x2_loc <= x2_start;
         y3_loc <= y3_start; 
         x3_loc <= x3_start;
			piece_count <= piece_count + 1; 
			
      end
	end
 if ((left==1) && (x0_loc-shift_size)>=(gf_x_start) &&
        (x1_loc-shift_size)>=(gf_x_start) &&
        (x2_loc-shift_size)>=(gf_x_start) &&
        (x3_loc-shift_size)>=(gf_x_start)) begin
		  
		  if ((!cell_one_left&&!cell_one_left2))
			begin
			x0_loc <= x0_loc - shift_size;
			x1_loc <= x1_loc - shift_size;
			x2_loc <= x2_loc - shift_size;
			x3_loc <= x3_loc - shift_size; 
			end
		else if((y0_loc_def%size==0)&&!cell_one_left) begin
		
			
			
			board_cell_visited[cell0_index-1] = 1;
			board_cell_visited[cell1_index-1] = 1;
			board_cell_visited[cell2_index-1] = 1;
			board_cell_visited[cell3_index-1] = 1;
			
			y0_loc <= y0_start;
         x0_loc <= x0_start;
         y1_loc <= y1_start;
         x1_loc <= x1_start;
         y2_loc <= y2_start;
         x2_loc <= x2_start;
         y3_loc <= y3_start; 
         x3_loc <= x3_start;
			piece_count <= piece_count + 1; 
			
      end
	end

  
  /// Rotate
  
  if(right_rotate && right_free)
  begin
	  x0_loc<=x0_loc;
	  y0_loc<=y0_loc;
    y1_loc<=y0_loc+(x1_loc-x0_loc);
	 x1_loc<=x0_loc+(y0_loc-y1_loc);
	 y2_loc<=y0_loc+(x2_loc-x0_loc);
	 x2_loc<=x0_loc+(y0_loc-y2_loc);
	 y3_loc<=y0_loc+(x3_loc-x0_loc);
	 x3_loc<=x0_loc+(y0_loc-y3_loc); 
	  
	  
  end
  
  if(left_rotate && left_free)
  begin
	  x0_loc<=x0_loc;
	  y0_loc<=y0_loc;
 
	 y1_loc<=y0_loc-(x1_loc-x0_loc);
	 x1_loc<=x0_loc-(y0_loc-y1_loc);
	 y2_loc<=y0_loc-(x2_loc-x0_loc);
	 x2_loc<=x0_loc-(y0_loc-y2_loc);
	 y3_loc<=y0_loc-(x3_loc-x0_loc);
	 x3_loc<=x0_loc-(y0_loc-y3_loc);
  end  
  
  score_keep<= score_keep + row_filled[19] + row_filled[18] + row_filled[17] + row_filled[16] + 
						row_filled[15] + row_filled[14] + row_filled[13] + row_filled[12] + 
						row_filled[11] + row_filled[10] + row_filled[9] +  row_filled[8] + 
						row_filled[7] +  row_filled[6] +  row_filled[5] +  row_filled[4] +
						row_filled[3] +  row_filled[2] +  row_filled[1] +  row_filled[0];		
			
	score[4:0] <= score_keep %10;
	score[9:5] <= score_keep/10;
						
	if(row_filled[19] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[189:0] = board_cell_backup[189:0];
	end
	
	if(row_filled[18] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[179:0] = board_cell_backup[179:0];
	end
	
	if(row_filled[17] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[169:0] = board_cell_backup[169:0];
	end
	
	if(row_filled[16] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[159:0] = board_cell_backup[159:0];
	end
	
	if(row_filled[15] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[149:0] = board_cell_backup[149:0];
	end
	
	if(row_filled[14] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[139:0] = board_cell_backup[139:0];
	end
	
	if(row_filled[13] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[129:0] = board_cell_backup[129:0];
	end
	
	if(row_filled[12] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[119:0] = board_cell_backup[119:0];
	end
	
	if(row_filled[11] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[109:0] = board_cell_backup[109:0];
	end
	
	if(row_filled[10] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[99:0] = board_cell_backup[99:0];
	end
	
	if(row_filled[9] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[89:0] = board_cell_backup[89:0];
	end
	
	
	if(row_filled[8] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[79:0] = board_cell_backup[79:0];
	end
	
	if(row_filled[7] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[69:0] = board_cell_backup[69:0];
	end
	
	if(row_filled[6] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[59:0] = board_cell_backup[59:0];
	end
	
	if(row_filled[5] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[49:0] = board_cell_backup[49:0];
	end
	
	if(row_filled[4] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[39:0] = board_cell_backup[39:0];
	end
	
	if(row_filled[3] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[29:0] = board_cell_backup[29:0];
	end
	
	if(row_filled[2] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[19:0] = board_cell_backup[19:0];
	end
	
	if(row_filled[1] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	board_cell_visited[9:0] = board_cell_backup[9:0];
	end
	
	if(row_filled[0] == 1) begin
	//board_cell_backup = board_cell_visited;
	board_cell_visited = board_cell_visited >> 10;
	end
	

end	 
end	 
end



wire[9:0] x_loc_pixel, y_loc_pixel;
assign x_loc_pixel = ADDR%640;
assign y_loc_pixel = ADDR/640;

reg in_square,in_gf, in_digit;
always @(posedge VGA_CLK_n)
begin
  in_digit = 0;
  if (((y_loc_pixel)<=(y0_loc+size) && (y_loc_pixel)>(y0_loc) && (x_loc_pixel)<(x0_loc+size) && (x_loc_pixel)>=(x0_loc))||
		((y_loc_pixel)<=(y1_loc+size) && (y_loc_pixel)>(y1_loc) && (x_loc_pixel)<(x1_loc+size) && (x_loc_pixel)>=(x1_loc))||
		((y_loc_pixel)<=(y2_loc+size) && (y_loc_pixel)>(y2_loc) && (x_loc_pixel)<(x2_loc+size) && (x_loc_pixel)>=(x2_loc))||
		((y_loc_pixel)<=(y3_loc+size) && (y_loc_pixel)>(y3_loc) && (x_loc_pixel)<(x3_loc+size) && (x_loc_pixel)>=(x3_loc)))
	  in_square = 1;
	else
    in_square = 0;
  if (y_loc_pixel>(gf_y_start) && y_loc_pixel<(gf_y_start+gf_y_size) && x_loc_pixel>(gf_x_start) && x_loc_pixel<(gf_x_start+gf_x_size))
	  in_gf = 1;
   else
		in_gf = 0;	
		
	if((box_loc_x>=0 && box_loc_x<=2 && box_loc_y>=0 &&box_loc_y<=4))
 begin
  if(no_cell_filled_digit1[box1_cell_index])
  begin
   in_digit = 1;
  end
 end
 
 else if(box_loc_x>=4 && box_loc_x<=6 && box_loc_y>=0 &&box_loc_y<=4)
 begin
 if(no_cell_filled_digit2[box2_cell_index])
  begin
   in_digit = 1;
  end
 end

	 else if (box_loc_x>=84 && box_loc_x<=86 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(t[t1])
		begin
		in_digit=1;
		end
	end
	
	 else if (box_loc_x>=88 && box_loc_x<=90 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(e[e1])
		begin
		in_digit=1;
		end
	end
	
	 else if (box_loc_x>=92 && box_loc_x<=94 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(t[t2])
		begin
		in_digit=1;
		end
	end
	
	 else if (box_loc_x>=96 && box_loc_x<=98 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(r[r1])
		begin
		in_digit=1;
		end
	end
	
	 else if (box_loc_x>=100 && box_loc_x<=102 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(i[i1])
		begin
		in_digit=1;
		end
	end
	
	 else if (box_loc_x>=104 && box_loc_x<=106 && box_loc_y>=0 &&box_loc_y<=4)begin
		if(s[s1])
		begin
		in_digit=1;
		end
	end
	
	if(start==0) begin
	
		if (box_loc_x>=44 && box_loc_x<=46 && box_loc_y>=15 &&box_loc_y<=19)
		begin
			if(p[p1])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=48 && box_loc_x<=50 && box_loc_y>=15 &&box_loc_y<=19)
		begin
			if(r[r2])
			begin
				in_digit=1;
			end
		end
		
		
		else if (box_loc_x>=52 && box_loc_x<=54 && box_loc_y>=15 &&box_loc_y<=19)
		begin
			if(e[e2])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=56 && box_loc_x<=58 && box_loc_y>=15 &&box_loc_y<=19)
		begin
			if(s[s2])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=60 && box_loc_x<=62 && box_loc_y>=15 &&box_loc_y<=19)
		begin
			if(s[s3])
			begin
				in_digit=1;
			end
		end
		
		
		else if (box_loc_x>=52 && box_loc_x<=54 && box_loc_y>=25 &&box_loc_y<=29)
		begin
			if(s[s4])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=50 && box_loc_x<=52 && box_loc_y>=35 &&box_loc_y<=39)
		begin
			if(t[t3])
			begin
				in_digit=1;
			end
		end
		
		
		else if (box_loc_x>=54 && box_loc_x<=56 && box_loc_y>=35 &&box_loc_y<=39)
		begin
			if(o[o1])
			begin
				in_digit=1;
			end
		end
		
	
		else if (box_loc_x>=44 && box_loc_x<=46 && box_loc_y>=45 &&box_loc_y<=49)
		begin
			if(s[s5])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=48 && box_loc_x<=50 && box_loc_y>=45 &&box_loc_y<=49)
		begin
			if(t[t4])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=52 && box_loc_x<=54 && box_loc_y>=45 &&box_loc_y<=49)
		begin
			if(a[a1])
			begin
				in_digit=1;
			end
		end
		
		
		else if (box_loc_x>=56 && box_loc_x<=58 && box_loc_y>=45 &&box_loc_y<=49)
		begin
			if(r[r3])
			begin
				in_digit=1;
			end
		end
		
			
		else if (box_loc_x>=60 && box_loc_x<=62 && box_loc_y>=45 &&box_loc_y<=49)
		begin
			if(t[t5])
			begin
				in_digit=1;
			end
		end
		
	end
 
end

wire[3:0] select;
wire [23:0] bgr_rep;
//pixel in board occupied cell
wire [9:0] pix_x_cell, pix_y_cell,pix_index; 
assign pix_x_cell = (x_loc_pixel-gf_x_start)/size;  
assign pix_y_cell = y_cell_count-(y_loc_pixel-gf_y_start)/size;   //y_cell_count-y_loc_def/size
assign pix_index = pix_y_cell*x_cell_count+pix_x_cell;


 
//digit drawing
wire[14:0] no_cell_filled_digit1,no_cell_filled_digit2;

assign no_cell_filled_digit2[0] =  1;
assign no_cell_filled_digit2[1] = score[4:0]!=4;
assign no_cell_filled_digit2[2] = score[4:0]!=1;
assign no_cell_filled_digit2[3] = score[4:0]!=1 && score[4:0]!=2 && score[4:0]!=3 && score[4:0]!=7;
assign no_cell_filled_digit2[4] = score[4:0]==1;
assign no_cell_filled_digit2[5] = score[4:0]!=1 &&score[4:0]!=5 &&score[4:0]!=6;
assign no_cell_filled_digit2[6] = score[4:0]!=1 &&score[4:0]!=7;
assign no_cell_filled_digit2[7] = score[4:0]!=7 && score[4:0]!=0;
assign no_cell_filled_digit2[8] = score[4:0]!=1;
assign no_cell_filled_digit2[9] = score[4:0]==0 || score[4:0]==2 || score[4:0]==6 ||score[4:0]==8 ;
assign no_cell_filled_digit2[10] = score[4:0]==1;
assign no_cell_filled_digit2[11] = score[4:0]!=1 && score[4:0]!=2;
assign no_cell_filled_digit2[12] = score[4:0]!=1 && score[4:0]!=4 &&score[4:0]!=7;
assign no_cell_filled_digit2[13] = score[4:0]!=7 && score[4:0]!=4;
assign no_cell_filled_digit2[14] = score[4:0]!=1;
assign no_cell_filled_digit1[0] =  1;
assign no_cell_filled_digit1[1] = score[9:5]!=4;
assign no_cell_filled_digit1[2] = score[9:5]!=1;
assign no_cell_filled_digit1[3] = score[9:5]!=1 && score[9:5]!=2 && score[9:5]!=3 && score[9:5]!=7;
assign no_cell_filled_digit1[4] = score[9:5]==1;
assign no_cell_filled_digit1[5] = score[9:5]!=1 &&score[9:5]!=5 &&score[9:5]!=6;
assign no_cell_filled_digit1[6] = score[9:5]!=1 &&score[9:5]!=7;
assign no_cell_filled_digit1[7] = score[9:5]!=7 && score[9:5]!=0;
assign no_cell_filled_digit1[8] = score[9:5]!=1;
assign no_cell_filled_digit1[9] = score[9:5]==0 || score[9:5]==2 || score[9:5]==6 ||score[9:5]==8 ;
assign no_cell_filled_digit1[10] = score[9:5]==1;
assign no_cell_filled_digit1[11] = score[9:5]!=1 && score[9:5]!=2;
assign no_cell_filled_digit1[12] = score[9:5]!=1 && score[9:5]!=4 &&score[9:5]!=7;
assign no_cell_filled_digit1[13] = score[9:5]!=7 && score[9:5]!=4;
assign no_cell_filled_digit1[14] = score[9:5]!=1;
wire[10:0] digit_x, digit_y, distance_x, distance_y, box_loc_x, box_loc_y, box1_cell_index,box2_cell_index;
assign digit_x = 30;
assign digit_y = 30;
wire[3:0] digit_box_size;
assign digit_box_size=5;
assign distance_x = x_loc_pixel - digit_x;
assign distance_y = y_loc_pixel - digit_y;
assign box_loc_y = distance_y/digit_box_size;
assign box_loc_x = distance_x/digit_box_size;
assign box1_cell_index = box_loc_x+box_loc_y*3;
assign box2_cell_index = (box_loc_x-4)+box_loc_y*3;

/*Display the Game Name*/

wire [10:0] t1,e1,t2,r1,i1,s1;
wire [10:0] p1,r2,e2,s2,s3, s4, t3,o1, s5,t4,a1,r3,t5;
wire [14:0] p,t,e,r,i,s,o,l,a,y,u,v;

assign p = 15'b001001111101111;
assign t = 15'b010010010010111;
assign e = 15'b111001111001111;
assign r = 15'b101011111101111;
assign i = 15'b111010010010111;
assign s = 15'b111100111001111;
assign o = 15'b111101101101111;
assign l = 15'b111001001001001;
assign a = 15'b101101111101111;
assign y = 15'b010010010111101;
assign u = 15'b111101101101101;
assign v = 15'b010101101101101;

//tetris
assign t1 = (box_loc_x-84)+box_loc_y*3;
assign e1 = (box_loc_x-88)+box_loc_y*3;
assign t2 = (box_loc_x-92)+box_loc_y*3;
assign r1 = (box_loc_x-96)+box_loc_y*3;
assign i1 = (box_loc_x-100)+box_loc_y*3;
assign s1 = (box_loc_x-104)+box_loc_y*3;

//press s to start
assign p1 = (box_loc_x-44)+(box_loc_y-15)*3;
assign r2 = (box_loc_x-48)+(box_loc_y-15)*3;
assign e2 = (box_loc_x-52)+(box_loc_y-15)*3;
assign s2 = (box_loc_x-56)+(box_loc_y-15)*3;
assign s3 = (box_loc_x-60)+(box_loc_y-15)*3;

assign s4 = (box_loc_x-52)+(box_loc_y-25)*3;

assign t3 = (box_loc_x-50)+(box_loc_y-35)*3;
assign o1 = (box_loc_x-54)+(box_loc_y-35)*3;

assign s5 = (box_loc_x-44)+(box_loc_y-45)*3;
assign t4 = (box_loc_x-48)+(box_loc_y-45)*3;
assign a1 = (box_loc_x-52)+(box_loc_y-45)*3;
assign r3 = (box_loc_x-56)+(box_loc_y-45)*3;
assign t5 = (box_loc_x-60)+(box_loc_y-45)*3;


assign select[0] = in_square;
assign select[1] = in_gf;
assign select[2] = board_cell_visited[pix_index];
assign select[3] = 0; 
//k_test row_filled[pix_index/x_cell_count]

wire [23:0] sq_color, gf_color, bg_color, rw_color, bf_color, level_color, sq_fun, bf_fun;
reg [23:0] color_rand;
assign gf_color = in_digit? 24'h000000 : 24'hacacac;
assign bg_color = in_digit ?  24'h000000 : 24'hcacaca;
assign sq_color = in_sq_border ? 24'h000000 : level_color;
assign bf_color = in_bf_border ?  bf_fun : sq_fun;

//invisible ve sqborder = hcacac
//invisible ve !sqborder
mux_16 (drop_speed, 24'hff4d3c, 24'h94ff3c, 24'h3cfffd, 24'h3ca0ff, 24'h3c3cff, 24'hf53cff,24'hfe8942,
						  24'hff4d3c, 24'h94ff3c, 24'h3cfffd, 24'h3ca0ff, 24'h3c3cff, 24'hf53cff,24'hfe8942,
						  24'hff4d3c, 24'h94ff3c,
						  level_color);
						  
assign sq_fun = invisible ? 24'hacacac : level_color;
assign bf_fun = invisible ? 24'hacacac : 24'h000000;				  


wire in_sq_border, in_bf_border;

assign in_sq_border = (in_square && 
                      ((y_loc_pixel-y0_loc)%20==0) || 
							  ((x_loc_pixel-gf_x_start)%20==0) ||
							  ((x_loc_pixel-gf_x_start)%20==19) ||
							  ((y_loc_pixel-y0_loc)%20==19));
assign in_bf_border = (select[2] && 
							  (((y_loc_pixel-gf_y_start)%20==0) ||
							  ((x_loc_pixel-gf_x_start)%20==0) ||
							  ((y_loc_pixel-gf_y_start)%20==19) ||
							  ((x_loc_pixel-gf_x_start)%20==19) ));
							  
mux_16 m16(select, bg_color, sq_color, gf_color, sq_color, bg_color,bg_color,bf_color,sq_color,  
						 bg_color, sq_color, gf_color, sq_color, rw_color,rw_color,rw_color,rw_color,
						 bgr_rep);


assign b_data = bgr_rep[23:16];//bgr_data[23:16]
assign g_data = bgr_rep[15:8];//bgr_data[23:16]
assign r_data = bgr_rep[7:0];//bgr_data[23:16]
///////////////////

/*
wire [11:0] address_imem;
wire [31:0] q_imem;
imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );
	 
	 
	 */
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule

