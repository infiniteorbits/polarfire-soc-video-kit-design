#Importing and Linking all the HDL source files used in the design
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE/data_packer.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE/ddr_write_controller_enc.v
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE/ram2port.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE/video_fifo.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE/jpeg_top.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE/apb_wrapper.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE/jpeg_control_fsm.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE/jls_encoder.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE/ram8bit_input.v
