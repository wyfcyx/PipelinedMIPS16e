def read2(num, l, r):
    print('when x"%s"' % num)
    print('    Result <= Ram2(%d downto %d);' % (l, r))
    print('    Result_L <= Ram2(%d downto %d);' % (l, r))
    print('    Result_L_pointer <= \'1\';')
def write2(num, l, r):
    print('when x"%s"' % num)
    print('    Ram2(%d downto %d) <= DataS;' % (l, r))
    print('    Result <= (others => \'0\');')
    print('    Result_L <= (others => \'0\');')
    print('    Result_L_pointer <= \'0\';')
def readi(num, l, r):
    print('when x"%s"' % num)
    print('    InstructionResult <= Ram2(%d downto %d);' % (l, r))

def do(func):
    b = ['0000',
         '0001',
         '0002',
         '0003',
         '0004',
         '0005',
         '0006',
         '0007',
         '0008',
         '0009',
         '000a',
         '000b',
         '000c',
         '000d',
         '000e',
         '000f',
         '0010',
         '0011',
         '0012',
         '0013'
         ]
    l, r = 15, 0
    for _ in b:
         func(_, l, r)
         l += 16
         r += 16
for i in range(32):
    print('Ram1(%d) <= (others => \'0\');' % i)
