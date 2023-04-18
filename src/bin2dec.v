//  Copyright 2023 Harald Pretl
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//		http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

`ifndef __BIN2DEC__
`define __BIN2DEC__

`default_nettype none

module bin2dec (
	input wire [5:0]    i_bin,
    input wire          i_tens,
    input wire          i_ones,
	output wire [3:0]   o_dec
);

    // we use this algorithm for BIN to BCD conversion (called "double-dabble"):
    // https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d

    reg [7:0] bcd;
    integer i;

    assign o_dec =  (i_tens == 1'b1) ? bcd[7:4] :
                    (i_ones == 1'b1) ? bcd[3:0] :
                    4'd10;

    always @(*) begin
        bcd=0;
        for (i=0; i<6 ; i=i+1) begin
            if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
	        if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	        bcd = {bcd[6:0],i_bin[5-i]};
        end
    end

endmodule // bin2dec
`endif
