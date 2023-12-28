v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 60 -250 60 -230 {
lab=GND}
N 220 -220 220 -210 {
lab=GND}
N 220 -220 280 -220 {
lab=GND}
N 280 -230 280 -220 {
lab=GND}
N 220 -300 220 -290 {
lab=dac5}
N 280 -300 280 -290 {
lab=dac4}
N 340 -220 400 -220 {
lab=GND}
N 400 -230 400 -220 {
lab=GND}
N 340 -300 340 -290 {
lab=dac3}
N 400 -300 400 -290 {
lab=dac2}
N 460 -230 460 -220 {
lab=GND}
N 460 -300 460 -290 {
lab=dac1}
N 280 -220 340 -220 {
lab=GND}
N 340 -230 340 -220 {
lab=GND}
N 400 -220 460 -220 {
lab=GND}
N 520 -230 520 -220 {
lab=GND}
N 520 -300 520 -290 {
lab=dac0}
N 460 -220 520 -220 {
lab=GND}
N 740 -220 740 -210 {
lab=GND}
N 740 -290 740 -280 {
lab=strb}
N 740 -290 780 -290 {
lab=strb}
N 1330 -590 1330 -570 {
lab=VDD}
N 1330 -360 1330 -340 {
lab=GND}
N 1060 -540 1130 -540 {
lab=dac0}
N 1060 -520 1130 -520 {
lab=dac1}
N 1060 -500 1130 -500 {
lab=dac2}
N 1060 -480 1130 -480 {
lab=dac3}
N 1060 -460 1130 -460 {
lab=dac4}
N 1060 -440 1130 -440 {
lab=dac5}
N 1060 -420 1130 -420 {
lab=ena}
N 1060 -400 1130 -400 {
lab=strb}
N 220 -230 220 -220 {
lab=GND}
N 60 -410 60 -390 {
lab=VDD}
N 60 -330 60 -310 {
lab=#net1}
N 1740 -540 1740 -360 {
lab=res}
N 1510 -540 1740 -540 {
lab=res}
N 620 -300 620 -290 {
lab=ena}
N 620 -230 620 -220 {
lab=GND}
N 520 -220 620 -220 {
lab=GND}
N 1740 -300 1740 -240 {
lab=GND}
C {devices/title.sym} 160 -30 0 0 {name=l1 author="Harald Pretl, IIC @ JKU"}
C {devices/vsource.sym} 60 -280 0 0 {name=VDD1 value=1.8}
C {devices/vdd.sym} 60 -410 0 0 {name=l2 lab=VDD}
C {devices/gnd.sym} 60 -230 0 0 {name=l3 lab=GND}
C {devices/code.sym} 210 -760 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib sky130.lib.spice.tt.red tt

"
spice_ignore=false}
C {devices/simulator_commands.sym} 210 -570 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
* ngspice commands
****************
.include temp_sensor.pex.spice

****************
* Misc
****************
.param dacval0=0
.param dacval1=0
.param dacval2=1.8
.param dacval3=0
.param dacval4=1.8
.param dacval5=0

.options method=gear maxord=2
.temp -30


.save x1.temp1.dac_vout_notouch_
.save x1.temp1.dcdel_capnode_notouch_


.control

tran 10u 20m

plot v(x1.temp1.dac_vout_notouch_) v(x1.temp1.dcdel_capnode_notouch_) v(res)

meas tran tmeas WHEN v(res)=0.9

let k=length(time)-1
let daccode=\{dac0[k]/1.8*1 + dac1[k]/1.8*2 + dac2[k]/1.8*4 + dac3[k]/1.8*8 + dac4[k]/1.8*16 + dac5[k]/1.8*32\}
let vdac=v(x1.temp1.dac_vout_notouch_)[k]

*print dac tmeas > res.txt
print daccode
print vdac
print tmeas

*exit
.endc
"}
C {devices/gnd.sym} 220 -210 0 0 {name=l21 lab=GND}
C {devices/lab_wire.sym} 220 -300 1 0 {name=l22 sig_type=std_logic lab=dac5}
C {devices/lab_wire.sym} 280 -300 1 0 {name=l23 sig_type=std_logic lab=dac4}
C {devices/lab_wire.sym} 340 -300 1 0 {name=l24 sig_type=std_logic lab=dac3}
C {devices/lab_wire.sym} 400 -300 1 0 {name=l25 sig_type=std_logic lab=dac2}
C {devices/lab_wire.sym} 460 -300 1 0 {name=l26 sig_type=std_logic lab=dac1}
C {devices/lab_wire.sym} 520 -300 1 0 {name=l27 sig_type=std_logic lab=dac0}
C {devices/vsource.sym} 740 -250 0 0 {name=Vclk value="0 pwl(0 0 20u 0 20.1u 1.8)"}
C {devices/gnd.sym} 740 -210 0 0 {name=l4 lab=GND}
C {devices/lab_wire.sym} 780 -290 0 1 {name=l7 sig_type=std_logic lab=strb}
C {temp_sensor.sym} 1150 -380 0 0 {name=x1}
C {devices/gnd.sym} 1330 -340 0 0 {name=l8 lab=GND}
C {devices/vdd.sym} 1330 -590 0 0 {name=l9 lab=VDD}
C {devices/lab_wire.sym} 1060 -520 0 1 {name=l10 sig_type=std_logic lab=dac1}
C {devices/lab_wire.sym} 1060 -540 0 1 {name=l11 sig_type=std_logic lab=dac0}
C {devices/lab_wire.sym} 1060 -500 0 1 {name=l12 sig_type=std_logic lab=dac2}
C {devices/lab_wire.sym} 1060 -480 0 1 {name=l13 sig_type=std_logic lab=dac3}
C {devices/lab_wire.sym} 1060 -460 0 1 {name=l14 sig_type=std_logic lab=dac4}
C {devices/lab_wire.sym} 1060 -440 0 1 {name=l15 sig_type=std_logic lab=dac5}
C {devices/lab_wire.sym} 1060 -420 0 1 {name=l16 sig_type=std_logic lab=ena}
C {devices/lab_wire.sym} 1060 -400 0 1 {name=l17 sig_type=std_logic lab=strb}
C {devices/lab_wire.sym} 1640 -540 0 1 {name=l18 sig_type=std_logic lab=res}
C {devices/gnd.sym} 1740 -240 0 0 {name=l28 lab=GND}
C {devices/capa.sym} 1740 -330 0 0 {name=C4
m=1
value=10f}
C {devices/ammeter.sym} 60 -360 0 0 {name=Visupply}
C {devices/spice_probe.sym} 740 -290 0 0 {name=p10 attrs=""}
C {devices/spice_probe.sym} 1740 -540 0 0 {name=p18 attrs=""}
C {devices/lab_wire.sym} 620 -300 1 0 {name=l5 sig_type=std_logic lab=ena}
C {devices/vsource.sym} 620 -260 0 0 {name=Ven value=1.8}
C {devices/vsource.sym} 520 -260 0 0 {name=Vdac0 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval0)"}
C {devices/vsource.sym} 460 -260 0 0 {name=Vdac1 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval1)"}
C {devices/vsource.sym} 400 -260 0 0 {name=Vdac2 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval2)"}
C {devices/vsource.sym} 340 -260 0 0 {name=Vdac3 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval3)"}
C {devices/vsource.sym} 280 -260 0 0 {name=Vdac4 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval4)"}
C {devices/vsource.sym} 220 -260 0 0 {name=Vdac5 value="1.8 pwl(0 1.8 10u 1.8 10.001u 0 30u 0 30.001u dacval5)"}
C {devices/spice_probe.sym} 220 -300 0 0 {name=p1 attrs=""}
C {devices/spice_probe.sym} 280 -300 0 0 {name=p2 attrs=""}
C {devices/spice_probe.sym} 340 -300 0 0 {name=p3 attrs=""}
C {devices/spice_probe.sym} 460 -300 0 0 {name=p4 attrs=""}
C {devices/spice_probe.sym} 520 -300 0 0 {name=p5 attrs=""}
C {devices/spice_probe.sym} 400 -300 0 0 {name=p6 attrs=""}
C {devices/spice_probe.sym} 60 -390 0 0 {name=p7 attrs=""}
