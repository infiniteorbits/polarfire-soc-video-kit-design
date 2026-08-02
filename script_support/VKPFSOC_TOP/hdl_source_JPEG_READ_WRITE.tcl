#Importing and Linking all the HDL source files used in the design
import_files -library work -hdl_source hdl/data_packer.vhd
import_files -library work -hdl_source hdl/ddr_write_controller_enc.v
import_files -library work -hdl_source hdl/ram2port.vhd
import_files -library work -hdl_source hdl/video_fifo.vhd
import_files -library work -hdl_source hdl/jpeg_top.v
import_files -library work -hdl_source hdl/ram_input.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITECopie/script_support/hdl/JPEG_WRITE_READ/apb_wrapper.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITECopie/script_support/hdl/JPEG_WRITE_READ/jpeg_control_fsm.v
create_links -library work -hdl_source /home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design_READ_WRITECopie/script_support/hdl/JPEG_WRITE_READ/jls_encoder.v
