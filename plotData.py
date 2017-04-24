# Reads in recData.txt and plots it using matplotlib

import matplotlib.pyplot as plt
#import seaborn

data = []
with open("recData.txt") as f:
    for line in f:
        s = line.split()
        data.append(float(s[0]))

fig=plt.figure()
plt.xlabel("Timestep")
plt.ylabel("Accelerometer Value")
plt.title("Acceleration Data")
plt.plot(data)
plt.show(block=False)
plt.show()
