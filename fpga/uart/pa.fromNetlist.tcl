
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name test2 -dir "C:/Users/Wendy/Documents/ISEWork/test2/planAhead_run_1" -part xc6slx100fgg676-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Wendy/Documents/ISEWork/test2/serial.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Wendy/Documents/ISEWork/test2} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "serial.ucf" [current_fileset -constrset]
add_files [list {serial.ucf}] -fileset [get_property constrset [current_run]]
link_design
