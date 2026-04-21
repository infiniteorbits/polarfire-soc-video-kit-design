/*************************************************************************************************************************************
--
-- File Name    : H264_Encoder_tb.v 
-- Description  : H264_Encoder_tb 
-- H264 Encoder (only I frames support) testbench is running for following inputs
--      QUANT_QP          = 10
--      H_RES             = 224
--      V_RES             = 224
--		NUM_FRMS          = 2
-- COPYRIGHT 2021 BY MICROSEMI 
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS 
-- FROM MICROSEMI CORP.  IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM 
-- MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND 
-- NO BACK-UP OF THE FILE SHOULD BE MADE. 
--
--*************************************************************************************************************************************/
`timescale 1ns/100ps
module H264_Encoder_tb;

parameter SYSCLK_PERIOD     = 10;// 100MHZ
parameter g_DW              = 8;
parameter QUANT_QP          = 10;
parameter H_RES             = 224;
parameter V_RES             = 224;
parameter h_blanking        = 100;;
parameter v_blanking        = 45;
parameter N_FRAMES          = 2;

reg                         SYSCLK;
reg                         NSYSRESET;

wire [5  : 0]               Quant_QP;
reg  [15 : 0]               vert_resol;
reg  [15 : 0]               horiz_resol;

reg [g_DW-1:0]              Y_array[0:N_FRAMES*(H_RES*V_RES)-1];
reg [g_DW-1:0]              C_array[0:N_FRAMES*(H_RES*V_RES)-1];
reg  [23 :0]                addr_y;

reg                         data_valid;
reg [g_DW-1:0]              data_y;
reg [g_DW-1:0]              data_c;
wire                        data_valid_o;
wire [15 : 0]               data_o;

wire [15 : 0]               h_total;
wire [15 : 0]               v_total;
reg  [15 : 0]               h_counter;
reg  [15 : 0]               v_counter;
wire                        h_active;
wire                        v_active;
wire                        hv_active;
reg                         v_active_dly1;
wire                        v_active_re;
reg                         f_start;

reg                         frame_data_valid;
reg                         frame_valid;
reg                         frame_valid_dly1;
wire                        frame_valid_re;

reg                         frame_end;
reg                         frame_end_dly1;
wire                        frame_end_fe;
reg [10 : 0]                frame_end_fe_dly_arr;

reg [7 : 0]                 error;
reg [7 : 0]                 frame_counter;

reg [31:0]                  byte_counter;

reg [23 :0]                 refdata_addr;
reg [7 : 0]                 RefOut_array[0:2**17-1];

wire[15 : 0]                diff;
wire[15 : 0]                data_ref;

integer                     File_1;
//////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////
initial
begin
    SYSCLK     = 1'b0;
    NSYSRESET  = 1'b0;
end

//////////////////////////////////////////////////////////////////////
// Reset Pulse
//////////////////////////////////////////////////////////////////////
initial
begin
    #(SYSCLK_PERIOD * 20 )
        NSYSRESET = 1'b1;
end

//////////////////////////////////////////////////////////////////////
// Clock Driver
//////////////////////////////////////////////////////////////////////
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;

/************************************************************************
	text input read
*************************************************************************/    
initial $readmemh("H264_sim_data_in_y.txt", Y_array);
initial $readmemh("H264_sim_data_in_c.txt", C_array);
initial $readmemh("H264_refOut.txt", RefOut_array);

/************************************************************************
	Assignments
*************************************************************************/
assign Quant_QP         =   QUANT_QP;
assign vert_resol       =   V_RES;
assign horiz_resol      =   H_RES; 

assign v_active_re     =   v_active & (~v_active_dly1);
/************************************************************************
    Process to generate
*************************************************************************/
always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        addr_y       <= 0;
        data_y       <= 0;
        data_c       <= 0;
        data_valid   <= 0;
    end
    else begin
        data_valid   <= frame_data_valid;
        if(frame_end) begin 
            data_y   <= 0;
            data_c   <= 0;
            //addr_y   <= 0; 
        end
        else if(frame_data_valid) begin
            data_y   <= Y_array[addr_y];
            data_c   <= C_array[addr_y];
            addr_y   <= addr_y + 1;
        end
        else begin 
            data_y   <= data_y;
            data_c   <= data_c;
            addr_y   <= addr_y;
        end
    end
end

/*=======================================================================
 Timing Generator		 
=======================================================================*/
/************************************************************************
 Asynchronous statemens : generating h_active, v_active and hv_active		 
*************************************************************************/
assign h_active         = (h_counter >= (h_blanking)) ? 1'b1 : 1'b0;
assign v_active         = (v_counter >= (v_blanking)) ? 1'b1 : 1'b0;
assign hv_active        = h_active & v_active;
assign v_total          = V_RES + v_blanking;
assign h_total          = H_RES + h_blanking;

assign  frame_end_fe    = (~frame_end) & (frame_end_dly1);
assign  frame_valid_re  = (frame_valid) & (~frame_valid_dly1);

/************************************************************************
Process to generates Horizontal counter				 
*************************************************************************/
always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        v_active_dly1  <= 0;
        f_start        <= 0;
    end
    else begin 
        v_active_dly1   <= v_active;
        if(v_active_re) begin 
            f_start     <= 1;
        end
    end
end
/************************************************************************
Process to generates Horizontal counter				 
*************************************************************************/
always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        h_counter <= 0;
    end
    else begin 
        if(h_counter == h_total-1) begin
            h_counter <= 0;
        end
        else begin 
            h_counter <= h_counter + 1;
        end
    end
end

/************************************************************************
Process to generates Vertical counter				 
*************************************************************************/
always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        v_counter <= 0;
    end
    else begin 
        if(h_counter == h_total-1) begin 
            if(v_counter == v_total-1) begin 
                v_counter <= 0;
            end
            else begin 
                v_counter <= v_counter + 1;
            end
        end
    end
end

/************************************************************************
Process to generates Veframe_data_valid, frame_valid and frame_end				 
*************************************************************************/
always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        frame_data_valid <= 0;
        frame_valid      <= 0;
        frame_end        <= 0;
    end
    else begin 
        if(v_counter >= v_blanking && v_counter <= v_total) frame_data_valid <= hv_active;
        else frame_data_valid <= 0;
        
        if(v_counter == 30) frame_valid <= 1;
        else frame_valid  <= 0;
        
        if(f_start ==1 && v_counter == 20) frame_end   <= 1;
        else frame_end  <= 0;
    end
end

always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        frame_end_dly1     	  <= 0;
        frame_end_fe_dly_arr  <= 0;
        frame_valid_dly1   	  <= 0;
    end
    else begin 
        frame_end_dly1       <= frame_end;
        frame_end_fe_dly_arr <= {frame_end_fe_dly_arr[9:0],frame_end_fe};
        frame_valid_dly1     <= frame_valid;
    end
end

/************************************************************************
  Process to write the output into a file
*************************************************************************/  
  initial
    begin
      $display("*************I Frame Only Testbench***********************\n");
      File_1 = $fopen("h264_sim_out.txt","w");
      byte_counter = 1; 
      forever @(posedge SYSCLK)
      begin
          if (data_valid_o)          
          begin
		  $fwrite(File_1,"%x\n%x\n",data_o[7:0],data_o[15:8]);	     
            byte_counter = byte_counter + 2;
          end
			          		  
      end 	    
    end


//////////////////////////////////////////////////////////////////////
// Instantiate Unit Under Test:  H264_Encoder
//////////////////////////////////////////////////////////////////////
H264_Encoder #(
   . G_SLICES( 1 ),
   . G_P_FRM ( 0 ),
   . G_4K_EN ( 0 ),
   . G_16x16_INTRA_PRED ( 0 ), 
   . G_AXI4L  ( 0 ),
   . G_DW 	  ( 8 )
   )
H264_Encoder_0   
 (    
   .PIX_CLK_I (SYSCLK),
   .RESET_N   (NSYSRESET),
   .ENABLE_I  (1'b1),
   .VRES_I    (vert_resol),
   .HRES_I    (horiz_resol),
   .QP_I      (Quant_QP),
   .DATA_VALID_I (data_valid),
   .DATA_Y_I (data_y),
   .DATA_C_I (data_c),
   .FRAME_START_I(frame_valid), 
   
   .DDR_CLK_I (1'b0),
   .SKIP_THRESHOLD_I (16'b0),
   .P_COUNT_I (8'b0),
   .I_FORCE_I (1'b0),
   .DDR_LINE_GAP_I(16'b0),
   .R_FRAME_START_ADDR_I(8'b0),   
   .W_FRAME_START_ADDR_I(8'b0),  
   
   //Arbiter bus 0
   .RDATA0_I   (512'b0),
   .RVALID0_I  (1'b0),
   .ARREADY0_I (1'b0),
   .BUSER0_I   (1'b0),
   .ARADDR0_O  (   ),
   .ARVALID0_O (   ),
   .ARSIZE0_O  (   ),
   
   //Arbiter bus 1
   .RDATA1_I   (512'b0),
   .RVALID1_I  (1'b0),
   .ARREADY1_I (1'b0),
   .BUSER1_I   (1'b0),
   .ARADDR1_O  (   ),
   .ARVALID1_O (   ),
   .ARSIZE1_O  (   ),
   
   //Arbiter bus 2
   .RDATA2_I   (512'b0),
   .RVALID2_I  (1'b0),
   .ARREADY2_I (1'b0),
   .BUSER2_I   (1'b0),
   .ARADDR2_O  (   ),
   .ARVALID2_O (   ),
   .ARSIZE2_O  (   ),
   
   //Arbiter bus 3
   .RDATA3_I   (512'b0),
   .RVALID3_I  (1'b0),
   .ARREADY3_I (1'b0),
   .BUSER3_I   (1'b0),
   .ARADDR3_O  (   ),
   .ARVALID3_O (   ),
   .ARSIZE3_O  (   ),
   
   //Arbiter bus 4
   .RDATA4_I   (512'b0),
   .RVALID4_I  (1'b0),
   .ARREADY4_I (1'b0),
   .BUSER4_I   (1'b0),
   .ARADDR4_O  (   ),
   .ARVALID4_O (   ),
   .ARSIZE4_O  (   ),
   
   //Arbiter bus 5
   .RDATA5_I   (512'b0),
   .RVALID5_I  (1'b0),
   .ARREADY5_I (1'b0),
   .BUSER5_I   (1'b0),
   .ARADDR5_O  (   ),
   .ARVALID5_O (   ),
   .ARSIZE5_O  (   ),
   
   //Arbiter bus 6
   .RDATA6_I   (512'b0),
   .RVALID6_I  (1'b0),
   .ARREADY6_I (1'b0),
   .BUSER6_I   (1'b0),
   .ARADDR6_O  (   ),
   .ARVALID6_O (   ),
   .ARSIZE6_O  (   ),
   
   //Arbiter bus 7
   .RDATA7_I   (512'b0),
   .RVALID7_I  (1'b0),
   .ARREADY7_I (1'b0),
   .BUSER7_I   (1'b0),
   .ARADDR7_O  (   ),
   .ARVALID7_O (   ),
   .ARSIZE7_O  (   ),
   
   //Arbiter wbus 0
   .AWREADY0_I (1'b0),
   .WBUSER0_I  (1'b0),
   .AWADDR0_O  (   ),
   .AWSIZE0_O  (   ),
   .AWVALID0_O (   ),
   .WDATA0_O   (   ),
   .WVALID0_O  (   ),
   
   //Arbiter wbus 1
   .AWREADY1_I (1'b0),
   .WBUSER1_I  (1'b0),
   .AWADDR1_O  (   ),
   .AWSIZE1_O  (   ),
   .AWVALID1_O (   ),
   .WDATA1_O   (   ),
   .WVALID1_O  (   ),
   
   //Arbiter wbus 2
   .AWREADY2_I (1'b0),
   .WBUSER2_I  (1'b0),
   .AWADDR2_O  (   ),
   .AWSIZE2_O  (   ),
   .AWVALID2_O (   ),
   .WDATA2_O   (   ),
   .WVALID2_O  (   ),
   
   //Arbiter wbus 3
   .AWREADY3_I (1'b0),
   .WBUSER3_I  (1'b0),
   .AWADDR3_O  (   ),
   .AWSIZE3_O  (   ),
   .AWVALID3_O (   ),
   .WDATA3_O   (   ),
   .WVALID3_O  (   ),
   
   //output data
   .DDR_RECON_ADDR0_O (),
   .DDR_RECON_ADDR1_O (),
   .DDR_RECON_ADDR2_O (),
   .DDR_RECON_ADDR3_O (),
   .DATA0_VALID_O     (data_valid_o),
   .DATA0_O           (data_o),
   .DATA1_VALID_O     (),
   .DATA1_O           (),
   .DATA2_VALID_O     (),
   .DATA2_O           (),
   .DATA3_VALID_O     (),
   .DATA3_O           (),
   .FRAME_START_O     (),
   
   //******************** AXI4Lite ports ****************//
   .ACLK_I            (1'b0)  ,
   .ARESETN_I         (1'b0)  ,
   .AWVALID_I         (1'b0)  ,  
   .AWREADY_O         (   )   , 
   .AWADDR_I          (32'b0) ,
   .WDATA_I           (32'b0) , 
   .WVALID_I          (1'b0)  , 
   .WREADY_O          (   )   ,   
   .BRESP_O           (   )   , 
   .BVALID_O          (   )   , 
   .BREADY_I          (1'b0)  ,
   .ARADDR_I          (32'b0) , 
   .ARVALID_I         (1'b0)  , 
   .ARREADY_O         (   )   , 
   .RREADY_I          (1'b0)  , 
   .RDATA_O           (   )   , 
   .RRESP_O           (   )   , 
   .RVALID_O          (   )       
 );    

/************************************************************************
    Print simulation output
*************************************************************************/
assign data_ref = {RefOut_array[refdata_addr+1],RefOut_array[refdata_addr]};
assign diff = (data_valid_o == 1) ? data_o - data_ref : 0;

always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        refdata_addr        <= 0;
        error               <= 0;
    end
    else begin 
        if(frame_end_fe_dly_arr[10]) begin 
            error       <= 0;
        end
        else if(data_valid_o) begin 
            refdata_addr <= refdata_addr +2;
            if(diff == 0) begin 
                error   <= error;
            end
            else begin 
                error   <= error + 1;
            end
        end
    end
end


always@(posedge SYSCLK, negedge NSYSRESET) begin 
    if(!NSYSRESET) begin 
        error           <= 0;
        frame_counter   <= 0;
    end
    else begin 
        if(frame_valid_re) begin 
            $display("**********************************************************\n");
            $display("Frame Number :%d \n",frame_counter+1);
            $display("QP : %d  H_Res :%d  V_Res :%d\n",Quant_QP,horiz_resol,vert_resol);
        end
        else if(frame_end_fe_dly_arr[10]) begin 
            frame_counter   <= frame_counter + 1;

            
            if(error == 0 && byte_counter != 0) begin 
            $display("H264 I frame Encryption test passed                       \n");    
            $display("----------------------------------------------------------\n");    
            end
            else begin 
            $display("H264 I frame Encryption test failed                       \n");    
            $display("----------------------------------------------------------\n");      
            end                    
            
        end
        
        if(frame_counter == 2) begin 
            #100  $stop;
        end
        
    end
end


endmodule