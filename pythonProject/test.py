from dtw import dtw
from hmm import hmm
from struct import unpack
import time
import threading
import heapq

class myThread (threading.Thread):  # 继承父类threading.Thread
    def __init__(self, filename, test, distances, diction, num):
        threading.Thread.__init__(self)
        self.filename = filename
        self.test = test
        self.distances = distances
        self.diction=diction
        self.num = num

    def run(self):  # 把要执行的代码写到run函数里面 线程在创建后会直接运行run函数
        module = readdata(self.filename)
        prob=hmm(test,module)
        self.distances[self.num] = prob
        self.diction[self.num]=self.filename
        '''
        length = len(self.test)
        weight = 0.5
        start = 0
        distance = []
        print(length, len(module))
        while start+length < len(module):
            distance.append(hmm(self.test,  module[start:start+length]))
            start += (int)(length*weight)
            print(start)
        self.distances[self.num] = min(distance)
        '''

'''
def readMFC(filename):
    f = open(filename, "rb")
    nframes = unpack(">i", f.read(4))[0]
    frate = unpack(">i", f.read(4))[0]     # 100 ns 内的
    nbytes = unpack(">h", f.read(2))[0]    # 特征的字节数
    feakind = unpack(">h", f.read(2))[0]
    ndim = nbytes / 4   # 维数
    feature = []
    for m in range(nframes):
        feature_frame = []
        for n in range(int(ndim)):
            feature_frame.append(unpack(">f", f.read(4))[0])
        feature.append(feature_frame)
    f.close()
    return feature
'''
def readdata(filename):
    fp=open(filename)
    line =fp.readline()
    data=[]
    if not line:
        print ("No data!")
    else:
        data=[int(i) for i in line.split()]
    return data



time_start = time.time()

modules = []
test=readdata('5.txt')
'''
modules.append(readMFC("Warriors1.mfc"))
# modules.append(readMFC("Warriors2.mfc"))
# modules.append(readMFC("Warriors3.mfc"))
# modules.append(readMFC("dan1.mfc"))
# modules.append(readMFC("dan2.mfc"))
# modules.append(readMFC("dan3.mfc"))

length = (int)(len(test)/256)
length = (int)(len(test)*1.2)
weight = 0.5
finalDistance = []
for j in range(1):
    # length*=8
    nowtest = test[0:length]
    for i in range(len(modules)):
        start = 0
        distance = []
        print(length)
        print(len(modules[i]))
        print(i)
        while start+length < len(modules[i]):
            distance.append(dtw(nowtest,  modules[i][start:start+length]))
            start += (int)(length*weight)
            print(start)
        finalDistance.append(min(distance))

print(finalDistance)
'''
distances = [-1]*30
diction = [""]*30
threads=[]
threads.append(myThread("Warriors1.txt", test, distances,diction, 0))
threads.append(myThread("Warriors2.txt", test, distances,diction, 1))
threads.append(myThread("Warriors3.txt", test, distances, diction, 2))
threads.append(myThread("dan1.txt", test, distances, diction, 3))
threads.append(myThread("dan2.txt", test, distances, diction, 4))
threads.append(myThread("dan3.txt", test, distances, diction, 5))
threads.append(myThread("fly1.txt", test, distances, diction, 6))
threads.append(myThread("fly2.txt", test, distances, diction, 7))
threads.append(myThread("fly3.txt", test, distances, diction, 8))
threads.append(myThread("fish1.txt", test, distances, diction, 9))
threads.append(myThread("fish2.txt", test, distances, diction, 10))
threads.append(myThread("fish3.txt", test, distances, diction,11))
threads.append(myThread("Fractures1.txt", test, distances, diction, 12))
threads.append(myThread("Fractures2.txt", test, distances, diction, 13))
threads.append(myThread("Fractures3.txt", test, distances, diction, 14))
threads.append(myThread("hai1.txt", test, distances, diction, 15))
threads.append(myThread("hai2.txt", test, distances, diction, 16))
threads.append(myThread("hai3.txt", test, distances, diction, 17))
threads.append(myThread("Hero1.txt", test, distances, diction, 18))
threads.append(myThread("Hero2.txt", test, distances, diction, 19))
threads.append(myThread("Hero3.txt", test, distances, diction, 20))
threads.append(myThread("lucky1.txt", test, distances, diction, 21))
threads.append(myThread("lucky2.txt", test, distances, diction, 22))
threads.append(myThread("lucky3.txt", test, distances, diction, 23))    
threads.append(myThread("shijian1.txt", test, distances, diction, 24))
threads.append(myThread("shijian2.txt", test, distances, diction, 25))
threads.append(myThread("shijian3.txt", test, distances, diction, 26))
threads.append(myThread("Silver_Scrapes1.txt", test, distances, diction, 27))
threads.append(myThread("Silver_Scrapes2.txt", test, distances, diction, 28))
threads.append(myThread("Silver_Scrapes3.txt", test, distances, diction, 29))

for i in range(30):
    threads[i].start()
for i in range(30):
    threads[i].join()
'''
threads[0].start()
threads[1].start()
#threads[2].start()
threads[0].join()
threads[1].join()
#threads[2].join()
'''
print(distances)
print(heapq.nlargest(5,distances))
for i in list(map(distances.index,heapq.nlargest(5,distances))):
    print(diction[i])
time_end = time.time()
print('totally cost', time_end-time_start)
