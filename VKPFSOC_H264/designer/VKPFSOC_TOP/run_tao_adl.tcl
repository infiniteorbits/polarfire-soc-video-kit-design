set_device -family {PolarFireSoC} -die {MPFS250TS} -speed {-1}
read_adl {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/VKPFSOC_TOP.adl}
read_afl {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/VKPFSOC_TOP.afl}
map_netlist
read_sdc {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/constraint/VKPFSOC_TOP_derived_constraints.sdc}
read_sdc {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/constraint/user.sdc}
check_constraints {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/constraint/placer_sdc_errors.log}
estimate_jitter -report {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/place_and_route_jitter_report.txt}
write_sdc -mode layout {/home/ahlemzenache/Documents/polarfire-soc-video-kit-reference-design (Copie)/VKPFSOC_H264/designer/VKPFSOC_TOP/place_route.sdc}
