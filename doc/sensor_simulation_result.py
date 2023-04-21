import numpy as np
import matplotlib.pyplot as plt

# This values have been found by parasitic extraction of the .mag file produced
# by OpenLane, and this resulting SPICE netlist has been included in a xschem-
# based simulation testbench for ngspice.

temperature = [-30, 0, 30, 60, 90, 120]
code_result = [26, 24, 21, 17, 13, 7]

plt.xlabel('Temperature (degree Celsius)')
plt.ylabel('Output Code')
plt.xticks(np.arange(-30,130,10))
plt.yticks(np.arange(0,30,5))
plt.grid()
plt.title('Temperature Sensor Simulation Result')
plt.plot(temperature, code_result, '-bv', markersize = '5')
plt.axis([-30, 120, 0, 30])
plt.show()
