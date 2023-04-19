//	Copyright 2022-2023 Manuel Moser and Harald Pretl
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//		http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//
//	This cell implements a digitall-controlled delay cell (dcdel), which when
//	operated in subthreshold has a strong temperature dependcy of the delay time.
//	This effect can be used to implement e.g. a digital temperature sensor.
//
//	IMPORTANT: Make sure that the synthesis and optimization tools do not mess
//	with the resulting netlist, especially at the node `vout_notouch_`!

`ifndef __TEMPSENSE__
`define __TEMPSENSE__

`default_nettype none
`timescale 1us/1ps
`ifndef SIMULATION
`include "vdac.v"
`endif
//`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
//`include "/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v"

module tempsense #( parameter DAC_RESOLUTION = 6, parameter CAP_LOAD = 4 )(
      input wire [DAC_RESOLUTION-1:0]     i_dac_data,
      input wire                          i_dac_en,
      input wire                          i_precharge_n,
      output wire                         o_tempdelay
  );

`ifdef SIMULATION
      wire dac0, dac1, dac_change;
      assign dac0 = ~|i_dac_data;
      assign dac1 = &i_dac_data;

      assign #50 dac_change = (i_dac_data == 4) ? (~dac0 & ~dac1) : 1'b0;

      assign o_tempdelay = ~(i_dac_en & dac_change & i_precharge_n);
`else
      // Voltage-mode digital-to-analog converter (VDAC)
      (* keep = "true" *) wire dac_vout_notouch_;
      (* keep = "true" *) vdac #(.BITWIDTH(DAC_RESOLUTION)) dac (
            .i_data(i_dac_data),
            .i_enable(i_dac_en),
            .vout_notouch_(dac_vout_notouch_)
      );

      // Digitally-controled delay cell (dcdel)
      wire tie0 = 1'b0;
      (* keep = "true" *) wire dcdel_capnode_notouch_;
      (* keep = "true" *) wire dcdel_out_n;
      (* keep = "true" *) wire [CAP_LOAD-1:0] dummy_notouch_;

      (* keep = "true" *) sky130_fd_sc_hd__einvp_1 dcdc (.A(i_precharge_n), .TE(dac_vout_notouch_), .Z(dcdel_capnode_notouch_));
      (* keep = "true" *) sky130_fd_sc_hd__inv_1 inv1 (.A(dcdel_capnode_notouch_),.Y(dcdel_out_n));
      (* keep = "true" *) sky130_fd_sc_hd__inv_1 inv2 (.A(dcdel_out_n),.Y(o_tempdelay));

      genvar i;
	generate
		for (i=0; i < CAP_LOAD; i=i+1) begin : capload
			(* keep = "true" *) sky130_fd_sc_hd__nand2_1 cap (.B(dcdel_capnode_notouch_), .A(tie0), .Y(dummy_notouch_[i]));
		end
  	endgenerate
`endif

endmodule // tempsense
`endif
