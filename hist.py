#!python -i
import sys
import matplotlib.pyplot as plt

if len(sys.argv) < 2:
  raise ValueError("Expect at least a parameter")

x = []
ans1 = 0.0
ans2 = 0.0
print(sys.argv[2])
print(sys.argv[3])
for line in sys.stdin:
  x.append(float(line))
  if x[-1] > 1.1:
    continue
  ans1 += 1 - (1 - x[-1]**int(sys.argv[2]))**(int(sys.argv[3]))
  ans2 += (1 - x[-1]**int(sys.argv[2]))**(int(sys.argv[3]))

print("In {:.6f} Not in {:.6f}".format(ans1, ans2))

# 绘制直方图
plt.hist(x, range=(0, 1), bins=30, edgecolor='black')

# 设置图表标题和坐标轴标签
plt.title("Similarity of {}".format(sys.argv[1]))
plt.xlabel("Value")
plt.ylabel("Frequency")

plt.show()