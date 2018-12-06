def func(data):
    _ = [hex(x) for x in data]
    re = (_[0])[2:]
    if (len(re) == 1):
        re = '0' + re
    return re
with open('fmemory.vhd', 'w') as f:
    with open('prefix.txt', 'r') as _:
        lines = _.readlines()
        for line in lines:
            f.write(line)
    f.write('\n')
    with open('mini.dat', 'rb') as _:
        for i in range(1024):
            dataa = _.read(1)
            datab = _.read(1)
            f.write('            Ram2(%d) <= x"%s%s";\n' % (i, func(datab), func(dataa)))
        for i in range(1024):
            f.write('            Ram1(%d) <= x"0000";\n' % i)
    with open('suffix.txt', 'r') as _:
        lines = _.readlines()
        for line in lines:
            f.write(line)
