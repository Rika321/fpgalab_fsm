proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.cache/wt [current_project]
  set_property parent.project_path /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.xpr [current_project]
  set_property ip_repo_paths /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.cache/ip [current_project]
  set_property ip_output_repo /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.cache/ip [current_project]
  add_files -quiet /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.runs/synth_1/top_level.dcp
  add_files -quiet /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.runs/clk_wiz_synth_1/clk_wiz.dcp
  set_property netlist_only true [get_files /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.runs/clk_wiz_synth_1/clk_wiz.dcp]
  read_xdc -mode out_of_context -ref clk_wiz -cells inst /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz_ooc.xdc
  set_property processing_order EARLY [get_files /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz -cells inst /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz_board.xdc
  set_property processing_order EARLY [get_files /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz_board.xdc]
  read_xdc -ref clk_wiz -cells inst /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz.xdc
  set_property processing_order EARLY [get_files /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/sources_1/ip/clk_wiz/clk_wiz.xdc]
  read_xdc /home/hequ2/cs233/hequ2/fpgalab4_fsm/fpgalab4_fsm.srcs/constrs_1/imports/FPGALab4/Basys3_Master.xdc
  link_design -top top_level -part xc7a35tcpg236-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force top_level_opt.dcp
  report_drc -file top_level_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file top_level.hwdef}
  place_design 
  write_checkpoint -force top_level_placed.dcp
  report_io -file top_level_io_placed.rpt
  report_utilization -file top_level_utilization_placed.rpt -pb top_level_utilization_placed.pb
  report_control_sets -verbose -file top_level_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force top_level_routed.dcp
  report_drc -file top_level_drc_routed.rpt -pb top_level_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file top_level_timing_summary_routed.rpt -rpx top_level_timing_summary_routed.rpx
  report_power -file top_level_power_routed.rpt -pb top_level_power_summary_routed.pb
  report_route_status -file top_level_route_status.rpt -pb top_level_route_status.pb
  report_clock_utilization -file top_level_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force top_level.mmi }
  write_bitstream -force top_level.bit 
  catch { write_sysdef -hwdef top_level.hwdef -bitfile top_level.bit -meminfo top_level.mmi -file top_level.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

