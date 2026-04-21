`timescale 1 ns/100 ps
// Version: 2025.1 2025.1.0.14


module PF_OSC_C0_PF_OSC_C0_0_PF_OSC(
       RCOSC_2MHZ_CLK_DIV
    );
output RCOSC_2MHZ_CLK_DIV;

    wire GND_net, VCC_net;
    
    VCC vcc_inst (.Y(VCC_net));
    OSC_RC2MHZ I_OSC_2 (.OSC_2MHZ_ON(VCC_net), .CLK(RCOSC_2MHZ_CLK_DIV)
        );
    GND gnd_inst (.Y(GND_net));
    
endmodule
