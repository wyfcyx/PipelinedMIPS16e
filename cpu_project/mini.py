ins = 1024
with open('rom.dat', 'rb') as f:
    with open('mini.dat', 'wb') as g:
        for i in range(ins):
            print('i = %d' % i)
            data = f.read(2)
            print(data)
            g.write(data)
            


