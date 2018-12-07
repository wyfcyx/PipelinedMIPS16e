
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name cpu_project -dir "D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/cpu_project/planAhead_run_1" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/cpu_project/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/cpu_project} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "main.ucf" [current_fileset -constrset]
add_files [list {main.ucf}] -fileset [get_property constrset [current_run]]
link_design
