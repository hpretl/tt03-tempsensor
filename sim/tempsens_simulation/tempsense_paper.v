module tempsense #( parameter NDAC=6, parameter NCAP=4 )(
  input wire [NDAC-1:0] i_dat, input wire i_en, input wire i_prchrg_n,
  output wire o_tmpdel);
  wire dac_vout;
  vdac #(.NBIT(NDAC)) dac (.i_dat(i_dat), .i_en(i_en), .vout(dac_vout));
  wire tie0 = 1'b0, capn, del_n;
  wire [NCAP-1:0] dummy;
  sky130_fd_sc_hd__einvp_1 dcdc (.A(i_prchrg_n), .TE(dac_vout), .Z(capn));
  sky130_fd_sc_hd__inv_1 inv1 (.A(capn), .Y(del_n));
  sky130_fd_sc_hd__inv_1 inv2 (.A(del_n), .Y(o_tmpdel));
  genvar i; generate
    for (i=0; i<NCAP; i=i+1) begin : capload
      sky130_fd_sc_hd__nand2_1 cap (.B(capn), .A(tie0), .Y(dummy[i]));
    end endgenerate
endmodule // tempsense
module vdac #(parameter NBIT=6 )(
  input wire [NBIT-1:0] i_dat, input wire i_en, output wire vout);
  genvar i; generate 
    for (i = 0; i<NBIT-1; i=i+1) begin : NPAR
      vdac_cell #(.NPAR(2**i)) vdac_batch (
        .i_sgn(i_dat[NBIT-1]), .i_dat(i_dat[i]), .i_en(i_en), .vout(vout));
  end endgenerate
  vdac_cell #(.NPAR(1)) vdac_single (
    .i_sgn(1'b0), .i_dat(1'b0), .i_en(i_en & (~i_dat[NBIT-1])), .vout(vout));
endmodule // vdac
module vdac_cell #(parameter NPAR=4 )(
  input wire i_sgn, input wire i_dat, input wire	i_en, output wire vout);
  wire en_vref, en_pupd, npu_pd;
  assign npu_pd  = ~i_dat;
  assign en_pupd = i_en & (~(i_sgn^i_dat));
  assign en_vref = i_en & (i_sgn^i_dat);
  genvar i; generate
    for (i=0; i<NPAR; i=i+1) begin : einvp_batch
      sky130_fd_sc_hd__einvp_1 pupd (.A(npu_pd), .TE(en_pupd), .Z(vout));
      sky130_fd_sc_hd__einvp_1 vref (.A(vout), .TE(en_vref), .Z(vout));
  end endgenerate
endmodule // vdac_cell