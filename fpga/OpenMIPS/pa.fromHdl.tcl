
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name OpenMIPS -dir "Z:/Documents/Project/fpga/OpenMIPS/planAhead_run_1" -part xc6slx100fgg676-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "Atom.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {Atom.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top Atom $srcset
add_files [list {Atom.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx100fgg676-2
