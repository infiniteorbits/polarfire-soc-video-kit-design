read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/VKPFSOC_TOP_layout_combinational_loops.xml}
report -type slack {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/VKPFSOC_TOP_place_and_route_constraint_coverage.xml}]
set reportfile {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp