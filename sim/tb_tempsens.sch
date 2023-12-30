v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
T {ts_cfg[5:3] = dbg[2:0]} 210 -170 0 0 0.4 0.4 {}
N 60 -250 60 -230 {
lab=GND}
N 220 -220 220 -210 {
lab=GND}
N 220 -220 280 -220 {
lab=GND}
N 280 -230 280 -220 {
lab=GND}
N 220 -300 220 -290 {
lab=ts_cfg5}
N 280 -300 280 -290 {
lab=ts_cfg4}
N 340 -220 400 -220 {
lab=GND}
N 400 -230 400 -220 {
lab=GND}
N 340 -300 340 -290 {
lab=ts_cfg3}
N 400 -300 400 -290 {
lab=ts_cfg2}
N 460 -230 460 -220 {
lab=GND}
N 460 -300 460 -290 {
lab=ts_cfg1}
N 280 -220 340 -220 {
lab=GND}
N 340 -230 340 -220 {
lab=GND}
N 400 -220 460 -220 {
lab=GND}
N 520 -230 520 -220 {
lab=GND}
N 520 -300 520 -290 {
lab=ts_cfg0}
N 460 -220 520 -220 {
lab=GND}
N 660 -440 700 -440 {
lab=rst}
N 660 -220 660 -210 {
lab=GND}
N 660 -370 660 -360 {
lab=GND}
N 660 -290 660 -280 {
lab=clk}
N 660 -290 700 -290 {
lab=clk}
N 1330 -590 1330 -570 {
lab=VDD}
N 1330 -360 1330 -340 {
lab=GND}
N 1060 -540 1130 -540 {
lab=clk}
N 1060 -520 1130 -520 {
lab=rst}
N 1060 -500 1130 -500 {
lab=ts_cfg0}
N 1060 -480 1130 -480 {
lab=ts_cfg1}
N 1060 -460 1130 -460 {
lab=ts_cfg2}
N 1060 -440 1130 -440 {
lab=ts_cfg3}
N 1060 -420 1130 -420 {
lab=ts_cfg4}
N 1060 -400 1130 -400 {
lab=ts_cfg5}
N 1510 -540 2280 -540 {
lab=st0}
N 1510 -520 2200 -520 {lab=st1}
N 1510 -400 1740 -400 {
lab=st7}
N 1740 -260 1740 -240 {
lab=GND}
N 1880 -260 1960 -260 {
lab=GND}
N 2280 -280 2280 -260 {
lab=GND}
N 2200 -280 2200 -260 {
lab=GND}
N 1740 -400 1740 -340 {
lab=st7}
N 2200 -520 2200 -340 {
lab=st1}
N 2280 -540 2280 -340 {
lab=st0}
N 2120 -280 2120 -260 {
lab=GND}
N 2040 -280 2040 -260 {
lab=GND}
N 1960 -280 1960 -260 {
lab=GND}
N 1880 -280 1880 -260 {
lab=GND}
N 2200 -260 2280 -260 {
lab=GND}
N 220 -230 220 -220 {
lab=GND}
N 1740 -280 1740 -260 {
lab=GND}
N 2120 -260 2200 -260 {
lab=GND}
N 2040 -260 2120 -260 {
lab=GND}
N 1960 -260 2040 -260 {
lab=GND}
N 1810 -260 1880 -260 {
lab=GND}
N 1510 -500 2120 -500 {
lab=st2}
N 2120 -500 2120 -340 {
lab=st2}
N 1510 -480 2040 -480 {
lab=st3}
N 2040 -480 2040 -340 {
lab=st3}
N 1510 -460 1960 -460 {
lab=st4}
N 1960 -460 1960 -340 {
lab=st4}
N 1510 -440 1880 -440 {
lab=st5}
N 1880 -440 1880 -340 {
lab=st5}
N 1510 -420 1810 -420 {
lab=st6}
N 1810 -420 1810 -340 {
lab=st6}
N 1810 -280 1810 -260 {
lab=GND}
N 660 -440 660 -430 {
lab=rst}
N 60 -410 60 -390 {
lab=VDD}
N 60 -330 60 -310 {
lab=#net1}
N 1740 -260 1810 -260 {
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
.include hpretl_tt03_temperature_sensor_golden.pex.spice

****************
* Misc
****************
.param fclk=10k
.options method=gear maxord=2
.temp 30

.control
tran 10u 30m
<<<<<<< Updated upstream
*tran 10u 20u
write tb_tempsens.raw
=======
*tran 10u 1u

let k=length(time)-1
print st0[k] st1[k] st2[k] st3[k] st4[k] st5[k] st6[k] st7[k] > res.txt

exit
>>>>>>> Stashed changes
.endc
"}
C {devices/gnd.sym} 220 -210 0 0 {name=l21 lab=GND}
C {devices/lab_wire.sym} 220 -300 1 0 {name=l22 sig_type=std_logic lab=ts_cfg5}
C {devices/lab_wire.sym} 280 -300 1 0 {name=l23 sig_type=std_logic lab=ts_cfg4}
C {devices/lab_wire.sym} 340 -300 1 0 {name=l24 sig_type=std_logic lab=ts_cfg3}
C {devices/lab_wire.sym} 400 -300 1 0 {name=l25 sig_type=std_logic lab=ts_cfg2}
C {devices/lab_wire.sym} 460 -300 1 0 {name=l26 sig_type=std_logic lab=ts_cfg1}
C {devices/lab_wire.sym} 520 -300 1 0 {name=l27 sig_type=std_logic lab=ts_cfg0}
C {devices/vsource.sym} 220 -260 0 0 {name=V19 value=0
}
C {devices/vsource.sym} 280 -260 0 0 {name=V20 value=1.8}
C {devices/vsource.sym} 340 -260 0 0 {name=V21 value=1.8}
C {devices/vsource.sym} 400 -260 0 0 {name=V22 value=0}
C {devices/vsource.sym} 460 -260 0 0 {name=V23 value=0}
C {devices/vsource.sym} 520 -260 0 0 {name=V24 value=0}
C {devices/vsource.sym} 660 -250 0 0 {name=VCM value="0 pulse(0 1.8 1u 1n 1n \{0.5/fclk\} \{1/fclk\})"}
C {devices/gnd.sym} 660 -210 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} 660 -400 0 0 {name=VRES value="1.8 pwl(0 1.8 \{0.5/fclk\} 1.8 \{0.5/fclk+1n\} 0)"}
C {devices/gnd.sym} 660 -360 0 0 {name=l5 lab=GND}
C {devices/lab_wire.sym} 700 -440 0 1 {name=l6 sig_type=std_logic lab=rst}
C {devices/lab_wire.sym} 700 -290 0 1 {name=l7 sig_type=std_logic lab=clk}
C {hpretl_tt03_temperature_sensor.sym} 1150 -380 0 0 {name=x1}
C {devices/gnd.sym} 1330 -340 0 0 {name=l8 lab=GND}
C {devices/vdd.sym} 1330 -590 0 0 {name=l9 lab=VDD}
C {devices/lab_wire.sym} 1060 -520 0 1 {name=l10 sig_type=std_logic lab=rst}
C {devices/lab_wire.sym} 1060 -540 0 1 {name=l11 sig_type=std_logic lab=clk}
C {devices/lab_wire.sym} 1060 -500 0 1 {name=l12 sig_type=std_logic lab=ts_cfg0}
C {devices/lab_wire.sym} 1060 -480 0 1 {name=l13 sig_type=std_logic lab=ts_cfg1}
C {devices/lab_wire.sym} 1060 -460 0 1 {name=l14 sig_type=std_logic lab=ts_cfg2}
C {devices/lab_wire.sym} 1060 -440 0 1 {name=l15 sig_type=std_logic lab=ts_cfg3}
C {devices/lab_wire.sym} 1060 -420 0 1 {name=l16 sig_type=std_logic lab=ts_cfg4}
C {devices/lab_wire.sym} 1060 -400 0 1 {name=l17 sig_type=std_logic lab=ts_cfg5}
C {devices/lab_wire.sym} 1640 -540 0 1 {name=l18 sig_type=std_logic lab=st0}
C {devices/capa.sym} 1740 -310 0 0 {name=C1
m=1
value=10f}
C {devices/gnd.sym} 1740 -240 0 0 {name=l28 lab=GND}
C {devices/capa.sym} 2200 -310 0 0 {name=C3
m=1
value=10f}
C {devices/capa.sym} 2280 -310 0 0 {name=C4
m=1
value=10f}
C {devices/capa.sym} 2040 -310 0 0 {name=C2
m=1
value=10f}
C {devices/capa.sym} 2120 -310 0 0 {name=C5
m=1
value=10f}
C {devices/capa.sym} 1880 -310 0 0 {name=C6
m=1
value=10f}
C {devices/capa.sym} 1960 -310 0 0 {name=C7
m=1
value=10f}
C {devices/capa.sym} 1810 -310 0 0 {name=C8
m=1
value=10f}
C {devices/lab_wire.sym} 1640 -520 0 1 {name=l19 sig_type=std_logic lab=st1}
C {devices/lab_wire.sym} 1640 -500 0 1 {name=l20 sig_type=std_logic lab=st2}
C {devices/lab_wire.sym} 1640 -480 0 1 {name=l29 sig_type=std_logic lab=st3}
C {devices/lab_wire.sym} 1640 -460 0 1 {name=l30 sig_type=std_logic lab=st4}
C {devices/lab_wire.sym} 1640 -440 0 1 {name=l31 sig_type=std_logic lab=st5}
C {devices/lab_wire.sym} 1640 -420 0 1 {name=l32 sig_type=std_logic lab=st6}
C {devices/lab_wire.sym} 1640 -400 0 1 {name=l33 sig_type=std_logic lab=st7}
C {devices/ammeter.sym} 60 -360 0 0 {name=Visupply}
C {devices/spice_probe.sym} 1680 -540 0 0 {name=p1 attrs=""}
C {devices/spice_probe.sym} 1680 -520 0 0 {name=p2 attrs=""}
C {devices/spice_probe.sym} 1680 -500 0 0 {name=p3 attrs=""}
C {devices/spice_probe.sym} 1680 -480 0 0 {name=p4 attrs=""}
C {devices/spice_probe.sym} 1680 -460 0 0 {name=p5 attrs=""}
C {devices/spice_probe.sym} 1680 -440 0 0 {name=p6 attrs=""}
C {devices/spice_probe.sym} 1680 -420 0 0 {name=p7 attrs=""}
C {devices/spice_probe.sym} 1680 -400 0 0 {name=p8 attrs=""}
