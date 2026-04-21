#Importing and Linking all the HDL source files used in the design
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/data_packer.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/ddr_write_controller_enc.v
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/ram2port.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/video_fifo.vhd
import_files -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/jpeg_top.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/apb_wrapper.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/jpeg_control_fsm.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/jls_encoder.v
create_links -library work -hdl_source script_support/hdl/JPEG_WRITE_READ/ram8bit_input.v
