#Importing and Linking all the HDL source files used in the design
import_files -library work -hdl_source hdl/data_packer_h264.vhd
import_files -library work -hdl_source hdl/ddr_write_controller_enc.v
import_files -library work -hdl_source hdl/ram2port.vhd
import_files -library work -hdl_source hdl/video_fifo.vhd
import_files -library work -hdl_source hdl/jpeg_top.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/icicle-kit-reference-design/script_support/hdl/apb_wrapper.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/icicle-kit-reference-design/script_support/hdl/jpeg_control_fsm.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/icicle-kit-reference-design/script_support/hdl/jls_encoder.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/icicle-kit-reference-design/script_support/hdl/ram8bit_input.v
