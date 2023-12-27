//	Copyright 2023 Harald Pretl
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

`default_nettype none

`include "tempsense.v"

module temp_sensor (
	input [N_VDAC-1:0]	i_dac,
	input				i_en,
	input				i_meas,
	output				o_res
);

	// size the design with these constants
	localparam N_VDAC = 6;
	

    // instantiate temperature-dependent delay (this is the core circuit)
    tempsense #(.DAC_RESOLUTION(N_VDAC), .CAP_LOAD(16)) temp1 (
        .i_dac_data(i_dac),
        .i_dac_en(i_en),
        .i_precharge_n(i_meas),
        .o_tempdelay(o_res)
    );


endmodule // temp_sensor
