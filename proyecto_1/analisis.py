import sys

EXPID = 0
PERCEPTION = 1
SATISFACTION = 2
ITERATION = 3
TYPES = [str, str, str, int, int, int] # en si la satisfaccion es double pero
                                       # como es llave del diccionario la dejo str

def parse():
    line = sys.stdin.readline()
    experiments = {}
    c_buffer = []
    current = -1
    while line:
        data = [t(d) for t, d in zip(TYPES, line.strip().split(','))]
        if data[ITERATION] == 0: # Nuevo experimento
            if len(c_buffer) > 0: 
                exp_dict = experiments.get(data[EXPID], {})
                perception_dict = exp_dict.get(data[PERCEPTION], {})
                satisfaction_count = perception_dict.get(data[SATISFACTION], 0)
                perception_dict[data[SATISFACTION]] = satisfaction_count + len(data)
                exp_dict[data[PERCEPTION]] = perception_dict
                experiments[data[EXPID]] = exp_dict
            c_buffer = []
            c_buffer.append(data)
        else:
            c_buffer.append(data) # siguiente grupo
        line = sys.stdin.readline()
    for key, value in experiments.iteritems():
        print '%s: %s' % (str(key), str(value))

if __name__ == '__main__':
    parse()
