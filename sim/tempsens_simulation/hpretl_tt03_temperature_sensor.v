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

//	TODO
//	- DONE Add LUT for result calibration
//	- DONE Add more testmodes
//	- DONE Simulate logic
//	- Simulate mixed-signal

//	CHANGES
//	- Remove LUT, bin2dec, seg7; just output raw simulation result

`default_nettype none

`include "tempsense.v"

module hpretl_tt03_temperature_sensor (
	input [7:0]		io_in,
	output [7:0]	io_out
);

	// PCB IO assignement:
	// io_in[0] = 10kHz clock or pushbutton or dipswitch
	// io_in[7:1] = dipswitch[8:2]
	// io_out[6:0] = 7-segment LED
	// io_out[7] = decimal point


	// size the design with these constants
	localparam N_VDAC = 6;
	localparam N_CTR = 14; // 2**N_CTR gives roughly a second tick @ clk=10kHz
	

	// definition of external inputs
	wire clk = io_in[0];
	wire reset = io_in[1];


	// definition of external outputs
	assign io_out[7:0] = {temp_delay,in_measurement,tempsens_res_raw};


	// definition of internal wires and regs
	reg [N_CTR-1:0] ctr;
	reg [N_VDAC-1:0] tempsens_res_raw;
	reg temp_delay_last;

	wire [1:0] meas_state = ctr[1:0];
	wire [N_VDAC-1:0] dac_value = {N_VDAC{1'b1}} - ctr[N_VDAC+1:2];
	wire idle_cycle = |ctr[N_CTR-1:N_VDAC+2];

	wire in_reset, in_precharge, in_transition, in_transition_ph0, in_transition_ph1, in_measurement, in_evaluation;

    wire tempsens_en, temp_delay, tempsens_measure;
	wire [N_VDAC-1:0] tempsens_dat;


	// measurement state machine (meas_state)
	localparam PRECHARGE	= 2'b00;
	localparam TRANSITION	= 2'b01;
	localparam MEASURE		= 2'b10;
	localparam EVALUATE		= 2'b11;


	// VDAC max and min value
	localparam VMAX = {N_VDAC{1'b1}};
	localparam VMIN = {N_VDAC{1'b0}};


	// create state signals based on state of state machine
	assign in_reset = (ctr == {N_CTR{1'b1}});
	assign in_precharge = (meas_state == PRECHARGE)				&& !in_reset && !idle_cycle;
	assign in_transition = (meas_state == TRANSITION) 			&& !in_reset && !idle_cycle;
	assign in_transition_ph0 = in_transition && (clk == 1'b1) 	&& !in_reset && !idle_cycle;
	assign in_transition_ph1 = in_transition && (clk == 1'b0) 	&& !in_reset && !idle_cycle;
	assign in_measurement = (meas_state == MEASURE) 			&& !in_reset && !idle_cycle;
	assign in_evaluation = (meas_state == EVALUATE) 			&& !in_reset && !idle_cycle;


	// create temperature sensor input signal based on state signals, gate output to
	assign tempsens_en = in_reset ? 1'b0 : 1'b1;
	assign tempsens_dat =		in_precharge		? VMAX :
								in_transition_ph0	? VMIN :
								in_transition_ph1	? VMIN :
								in_measurement		? dac_value :
								in_evaluation		? dac_value :
								VMAX;
	assign tempsens_measure = 	in_precharge		? 1'b0 :
								in_transition_ph0	? 1'b0 :
								in_transition_ph1	? 1'b1 :
								in_measurement 		? 1'b1 :
								in_evaluation		? 1'b1 :
								1'b0;


	// state machine implementation for temperature sensor control
    always @(posedge clk) begin
        if (reset) begin
			ctr <= {N_CTR{1'b1}};
			tempsens_res_raw <= {N_VDAC{1'b0}};
			temp_delay_last <= 1'b1;
		end else begin
			ctr <= ctr + 1'b1;

			if (in_evaluation) begin
				if ((temp_delay_last == 1'b0) && (temp_delay == 1'b1)) begin
					tempsens_res_raw <= dac_value;
				end

				temp_delay_last <= temp_delay;
			end
		end
	end


    // instantiate temperature-dependent delay (this is the core circuit)
    tempsense #(.DAC_RESOLUTION(N_VDAC), .CAP_LOAD(16)) temp1 (
        .i_dac_data(tempsens_dat),
        .i_dac_en(tempsens_en),
        .i_precharge_n(tempsens_measure),
        .o_tempdelay(temp_delay)
    );

endmodule // hpretl_tt03_temperature_sensor
