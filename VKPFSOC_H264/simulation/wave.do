onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ddr_read_ip/reset_i
add wave -noupdate /tb_ddr_read_ip/pixel_clk_i
add wave -noupdate /tb_ddr_read_ip/ddr_clk_i
add wave -noupdate /tb_ddr_read_ip/frame_start_i
add wave -noupdate /tb_ddr_read_ip/read_en_i
add wave -noupdate /tb_ddr_read_ip/line_gap_i
add wave -noupdate /tb_ddr_read_ip/horz_resl_i
add wave -noupdate /tb_ddr_read_ip/h_offset_i
add wave -noupdate /tb_ddr_read_ip/v_offset_i
add wave -noupdate /tb_ddr_read_ip/read_ackn_i
add wave -noupdate /tb_ddr_read_ip/read_done_i
add wave -noupdate /tb_ddr_read_ip/ddr_data_valid_i
add wave -noupdate /tb_ddr_read_ip/frame_start_addr_i
add wave -noupdate /tb_ddr_read_ip/wdata_i
add wave -noupdate /tb_ddr_read_ip/read_req_o
add wave -noupdate /tb_ddr_read_ip/read_start_addr_o
add wave -noupdate /tb_ddr_read_ip/burst_size_o
add wave -noupdate /tb_ddr_read_ip/data_valid_o
add wave -noupdate /tb_ddr_read_ip/data_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/aresetn_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/raempty_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rclock_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rdata_count_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rdata_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rdata_rdy_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rempty_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/ren_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/reset_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/rhempty_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wafull_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wclock_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wdata_count_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wdata_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wen_i
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wfull_o
add wave -noupdate /tb_ddr_read_ip/DUT/DDR_Read_C0_0/genblk1/DDR_Read_Native_0/video_fifo_r/wresetn_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999287 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1050 ns}
