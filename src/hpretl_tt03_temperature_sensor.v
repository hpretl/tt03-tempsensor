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
//	- Simulate logic
//	- Simulate mixed-signal

`default_nettype none

`include "tempsense.v"
`include "seg7.v"
`include "bin2dec.v"

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
	wire cal_clk = io_in[2];
	wire cal_dat = io_in[3];
	wire cal_ld = io_in[4];
	wire cal_ena = io_in[5];
	wire [1:0] en_dbg = io_in[7:6];


	// definition of external outputs
	wire [7:0] led_out;
	wire [6:0] segments;
	assign io_out[7:0] = led_out; 


	// definition of internal wires and regs
	reg [N_CTR-1:0] ctr;
	reg [N_VDAC-1:0] tempsens_res_raw;
	reg [N_VDAC-1:0] calib_mem[0:2**N_VDAC-1];
	reg [N_VDAC-1:0] calib_incoming_word;
	reg [N_VDAC-1:0] calib_store_ctr;

	wire [N_VDAC-1:0] tempsens_res;
	wire [1:0] meas_state = ctr[1:0];
	wire [N_VDAC-1:0] dac_value = ctr[N_VDAC+1:2];
	wire show_tens = ~ctr[N_CTR-1];
	wire show_ones = ctr[N_CTR-1];

	wire in_reset, in_precharge, in_transition, in_transition_ph0, in_transition_ph1, in_measurement, in_evaluation;

    wire tempsens_en, temp_delay, tempsens_measure;
	wire [N_VDAC-1:0] tempsens_dat;
	wire [3:0] digit;


	// debug vectors
	wire [7:0] dbg1 = cal_ena ? {tempsens_en, tempsens_measure, tempsens_dat} : {temp_delay, in_reset, in_precharge, in_transition, in_transition_ph0, in_transition_ph1, in_measurement, in_evaluation};
	wire [7:0] dbg2 = cal_ena ? {ctr[7:0]} : {meas_state, tempsens_res_raw};
	wire [7:0] dbg3 = cal_ena ? {{(N_CTR-12){1'b0}}, ctr[N_CTR-1:8]} : {show_ones, cal_ena, calib_store_ctr};


	// measurement state machine (meas_state)
	localparam PRECHARGE	= 2'b00;
	localparam TRANSITION	= 2'b01;
	localparam MEASURE		= 2'b10;
	localparam EVALUATE		= 2'b11;


	// VDAC max and min value
	localparam VMAX = {N_VDAC{1'b1}};
	localparam VMIN = {N_VDAC{1'b0}};


	// select raw or calibrated result
	assign tempsens_res = cal_ena ? calib_mem[tempsens_res_raw] : tempsens_res_raw;


	// create state signals based on state of state machine
	assign in_reset = (ctr == {N_CTR{1'b0}});
	assign in_precharge = (meas_state == PRECHARGE);
	assign in_transition = (meas_state == TRANSITION);
	assign in_transition_ph0 = in_transition && (clk == 1'b1);
	assign in_transition_ph1 = in_transition && (clk == 1'b0);
	assign in_measurement = (meas_state == MEASURE);
	assign in_evaluation = (meas_state == EVALUATE);


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


	// display decimal number (tens or ones) on number LED or debug signals
	assign led_out = 	(en_dbg == 2'b00) ? {show_ones, segments} :
						(en_dbg == 2'b01) ? dbg1 :
						(en_dbg == 2'b10) ? dbg2 :
						(en_dbg == 2'b11) ? dbg3 :
						{show_ones, segments};
	

	// state machine implementation for temperature sensor control
    always @(posedge clk) begin
        if (reset) begin
			ctr <= {N_CTR{1'b0}};
			tempsens_res_raw <= {N_VDAC{1'b0}};
		end else begin
			ctr <= ctr + 1'b1;

			if (in_evaluation) begin
				if (temp_delay == 1'b0) begin
					tempsens_res_raw <= dac_value;
				end
			end
		end
	end


	// state machine for calibration memory loading
	// the new word is first loaded serially (we just keep shifting as long as clk pulsed come)
	always @(posedge cal_clk) begin
		if (reset) begin
			calib_incoming_word <= {N_VDAC{1'b0}};
		end else begin
			calib_incoming_word <= {calib_incoming_word[N_VDAC-2:0],cal_dat};
		end
	end
	// the incoming word is then stored into the calibration memory, the store counter just
	// keeps rolling around (but starts at zero after reset)
	always @(posedge cal_ld) begin
		if (reset) begin
			calib_store_ctr <= {N_VDAC{1'b0}};
		end else begin
			calib_mem[calib_store_ctr] <= calib_incoming_word;
			calib_store_ctr <= calib_store_ctr + 1'b1;
		end
	end


    // instantiate temperature-dependent delay (this is the core circuit)
    tempsense #(.DAC_RESOLUTION(N_VDAC), .CAP_LOAD(16)) temp1 (
        .i_dac_data(tempsens_dat),
        .i_dac_en(tempsens_en),
        .i_precharge_n(tempsens_measure),
        .o_tempdelay(temp_delay)
    );


	// binary to decimal decoder to show measurement result on 7-segment LED
	bin2dec dec1 (
		.i_bin(tempsens_res),
		.i_tens(show_tens),
		.i_ones(show_ones),
		.o_dec(digit)
	);


    // instantiate segment display decoder
    seg7 seg1 (
        .i_disp(digit),
        .o_segments(segments)
    );

endmodule // hpretl_tt03_temperature_sensor
