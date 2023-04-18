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
//	This cell implements a voltage-mode DAC using the SKY130 EINVP cell.
//	Due to the special structure of this tri-state inverter this construction
//	is possible.
//
//  IMPORTANT: Make sure that the synthesis and optimization tools do not mess
//	with the resulting netlist, especially at the node `vout_notouch_`!

`ifndef __VDAC__
`define __VDAC__

`default_nettype none
`include "vdac_cell.v"

module vdac #(parameter BITWIDTH = 6) (
	input wire [BITWIDTH-1:0]	i_data,
	input wire					i_enable,
	output wire					vout_notouch_
);

	genvar i;
	generate 
		for (i = 0; i<BITWIDTH-1; i=i+1) begin : parallel_cells
			(* keep = "true" *) vdac_cell #(.PARALLEL_CELLS(2**i)) vdac_batch (
				.i_sign(i_data[BITWIDTH-1]),
				.i_data(i_data[i]),
				.i_enable(i_enable),
				.vout_notouch_(vout_notouch_)
			);
		end
	endgenerate
  
	// Single cell for transition from 011..11 to 100..00
	(* keep = "true" *) vdac_cell #(.PARALLEL_CELLS(1)) vdac_single (
		.i_sign(1'b0),
		.i_data(1'b0),
		.i_enable(i_enable & (~i_data[BITWIDTH-1])),
		.vout_notouch_(vout_notouch_)
	);

endmodule // vdac
`endif
