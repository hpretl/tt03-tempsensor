![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# Synthesizable Digital Temperature Sensor

(c) 2023 **Harald Pretl and Manuel Moser**, Insitute for Integrated Circuits, Johannes Kepler University, Linz, Austria

This design is intended for inclusion in **the Tiny Tapeout 03** from Matt Venn.

## What does it do?

A temperature-dependent digital code (a value ranging from 0 to 63) is output at the LED display, showing tens (dot off) and ones (dot on) with a measurement rate of 1Hz and a display change rate of 0.5Hz.

A calibration engine via a LUT is included, to allow linearizing and calibrating the shown temperature code (the codes 0...31 can be transformed into a code 0...63).

In order to monitor various internal states and signals, comprehensive debug modes are also implemented.

## How does it work?

By creatively twisting the use of a tristate-inverter (EINVP), a voltage DAC is built. This voltage-mode DAC is used in another twisted arrangement of an EINVP to bias an NMOS into subthreshold operation to discharge a pre-charged capacitor (the input capacitor of an inverter). Since the subthreshold current of a MOSFET is a strong function of temperature, the resulting delay time is also a strong function of temperature; thus, a digital temperature sensor is built.

## Usage

After reset, one temperature measurement is taken per second and displayed using the LEDs. A code ranging from 0...63 is displayed with tens first (dot off) and ones later (dot on) with a display rate of ca. 0.5Hz.

Between measurements, the temperature sensor is turned off to minimize power consumption.

During normal operation, io_in[7:5] has to be set to 000. Setting a value different from 000 enables various debug modes documented in the Verilog code.

For calibration, the internal LUT can be serially loaded by using CAL_CLK (io_in[2]) and CAL_DAT (io_in[3]). Once fully loaded, the calibration engine is enabled by setting CAL_ENA (io_in[4]) to 1 (setting it to 0 displays the raw sensor code).
