ins = 1000
with open('rom.dat', 'rb') as f:
    with open('after.dat', 'wb') as g:
        for i in range(ins):
            print('i = %d' % i)
            data = f.read(2)
            print(data)
            g.write(data)
            


