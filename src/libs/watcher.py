import subprocess
import csv
from collections import namedtuple

cmd = ("nvidia-smi --query-gpu=name,index,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv,noheader,nounits")

GpuRecord = namedtuple('GpuRecord', ('name', 'index', 'gpu_temperature', 'gpu_utilization', 'memory_utilization', 'memory_total', 'memory_free', 'memory_used'))

def res_cmd(cmd):
    return subprocess.Popen(cmd, stdout=subprocess.PIPE,shell=True).stdout.readlines()

def parse_res(res):
    """
    res: csv test array
    """
    reader = csv.reader(res)
    for row in reader:
        record = GpuRecord(*row)
        yield record

def get_smi_record():
    text_list = res_cmd(cmd)
    for record in parse_res([text.decode('utf-8') for text in text_list]):
        yield record


if __name__=='__main__':
    for record in get_smi_record():
        print(record)

