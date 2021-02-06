# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_param synth.incrementalSynthesisCache C:/Users/99681/AppData/Roaming/Xilinx/Vivado/.Xil/Vivado-13272-DESKTOP-8DK78OG/incrSyn
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/99681/Desktop/vivadoProject/project/project.cache/wt [current_project]
set_property parent.project_path C:/Users/99681/Desktop/vivadoProject/project/project.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/99681/Desktop/vivadoProject/project/project.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/99681/Desktop/Fdiv.v
  C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/new/Fdiv2.v
  C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/new/Fdiv3.v
  C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/new/Fdiv_slow.v
  C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/new/uart.v
  C:/Users/99681/Desktop/vga.v
  C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/new/uart_ram.v
}
read_ip -quiet C:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/ip/Uart_Ram_VGA/Uart_Ram_VGA.xci
set_property used_in_implementation false [get_files -all c:/Users/99681/Desktop/vivadoProject/project/project.srcs/sources_1/ip/Uart_Ram_VGA/Uart_Ram_VGA_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/99681/Desktop/vivadoProject/project/project.srcs/constrs_1/new/pro.xdc
set_property used_in_implementation false [get_files C:/Users/99681/Desktop/vivadoProject/project/project.srcs/constrs_1/new/pro.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top uart_ram -part xc7a100tfgg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef uart_ram.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file uart_ram_utilization_synth.rpt -pb uart_ram_utilization_synth.pb"
