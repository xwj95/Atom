
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name OpenMIPS -dir "Z:/Documents/Project/fpga/OpenMIPS/planAhead_run_1" -part xc6slx100fgg676-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "Z:/Documents/Project/fpga/OpenMIPS/Atom.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Z:/Documents/Project/fpga/OpenMIPS} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Atom.ucf" [current_fileset -constrset]
add_files [list {Atom.ucf}] -fileset [get_property constrset [current_run]]
link_design
