decoder = {
    'index': range(1, 31),
    'instruction': [
        'ADDIU', 'ADDIU3', 'ADDSP', 'ADDU', 'AND',
        'B', 'BEQZ', 'BNEZ', 'BTEQZ', 'CMP',
        'CMPI', 'JR', 'LI', 'LW', 'LW_SP',
        'MFIH', 'MFPC', 'MTIH', 'MTSP', 'NEG',
        'NOP', 'OR', 'SLL', 'SLTU', 'SRA',
        'SRAV', 'SUBU', 'SW', 'SW_RS', 'SW_SP'
    ],
    'bit15-11': [
        '01001', '01000', '01100', '11100', '11101',
        '00010', '00100', '00101', '01100', '11101',
        '01110', '11101', '01101', '10011', '10010',
        '11110', '11101', '11110', '01100', '11101',
        '00001', '11101', '00110', '11101', '00110',
        '11101', '11100', '11011', '01100', '11010'
    ],
    'bit10-8': [
        'rx', 'rx', '011', 'rx', 'rx',
        '', 'rx', 'rx', '000', 'rx',
        'rx', 'rx', 'rx', 'rx', 'rx',
        'rx', 'rx', 'rx', '100', 'rx',
        '000', 'rx', 'rx', 'rx', 'rx',
        'rx', 'rx', 'rx', '010', 'rx'
    ],
    'bit7-5': [
        '', 'ry', '', 'ry', 'ry',
        '', '', '', '', 'ry',
        '', '000', '', 'ry', '',
        '000', '010', '000', 'rx', 'ry',
        '000', 'ry', 'ry', 'ry', 'ry',
        'ry', 'ry', 'ry', '', ''
    ],
    'bit4-2': [
        '', '', '', 'rz', '011',
        '', '', '', '', '010',
        '', '000', '', '', '',
        '000', '000', '000', '000', '010',
        '000', '011', '', '000', '',
        '001', 'rz', '', '', ''
    ],
    'bit1-0': [
        '', '', '', '01', '00',
        '', '', '', '', '10',
        '', '00', '', '', '',
        '00', '00', '01', '00', '11',
        '00', '01', '00', '11', '11',
        '11', '11', '', '', ''
    ]
}

# 只有LI是无符号扩展

outputSignals = {
    'LFlag': ['0', ] * 30,
    'SFlag': ['0', ] * 30,
    'BranchFlag': ['0', ] * 30,
    'BranchTarget': ['0'*16, ] * 30,
    'BranchTargetAlu': ['0'*16, ] * 30,
    'RegisterTarget': ['1111', ] * 30,
    'AluInstruction': ['0000', ] * 30,
    'Immediate': ['0'*16, ] * 30,
    'DataSelectorInstruction': ['0000', ] * 30,
    'BubbleNext': ['0'*3, ] * 30
}

AluInstruction = [
    'NOP', 'ADD', 'SUBU', 'CMP',
    'SLTU', 'AND', 'OR', 'SLL',
    'SRA', 'NEG', 'JR', 'BN',
    'BEQZ', 'BNEZ', 'BTEQZ', 'BTNEZ'
]


def get_alu_index(alu):
    for i in range(len(AluInstruction)):
        if AluInstruction[i] == alu:
            return ("0000" + bin(i)[2:])[-4:]
    return "0000"


def get_data(key, field):
    if field not in outputSignals.keys():
        if field not in decoder.keys():
            print('%s %s- get error' % (key, field))
            return ''
        else:
            for i in range(30):
                if decoder['instruction'][i] == key:
                    return decoder[field][i]
    for i in range(30):
        if decoder['instruction'][i] == key:
            return outputSignals[field][i]
    return ''


def set_data(key, field, data):
    if field not in outputSignals.keys():
        print('%s %s %s - set error' % (key, field, data))
        return
    for i in range(30):
        if decoder['instruction'][i] == key:
            outputSignals[field][i] = data
            break


set_data('ADDIU', 'RegisterTarget', 'rx')
set_data('ADDIU', 'AluInstruction', 'ADD')
set_data('ADDIU', 'DataSelectorInstruction', '0001')

set_data('ADDIU3', 'RegisterTarget', 'ry')
set_data('ADDIU3', 'AluInstruction', 'ADD')
set_data('ADDIU3', 'DataSelectorInstruction', '0001')

set_data('ADDSP', 'RegisterTarget', 'SP')
set_data('ADDSP', 'AluInstruction', 'ADD')
set_data('ADDSP', 'DataSelectorInstruction', '0011')

set_data('ADDU', 'RegisterTarget', 'rz')
set_data('ADDU', 'AluInstruction', 'ADD')
set_data('ADDU', 'DataSelectorInstruction', '1001')

set_data('AND', 'RegisterTarget', 'rx')
set_data('AND', 'AluInstruction', 'AND')
set_data('AND', 'DataSelectorInstruction', '1001')

set_data('B', 'BranchFlag', '1')
set_data('B', 'RegisterTarget', 'PC')
set_data('B', 'AluInstruction', 'B')
set_data('B', 'DataSelectorInstruction', '0011')

set_data('BEQZ', 'BranchFlag', '1')
set_data('BEQZ', 'RegisterTarget', 'PC')
set_data('BEQZ', 'AluInstruction', 'BEQZ')
set_data('BEQZ', 'DataSelectorInstruction', '0001')

set_data('BNEZ', 'BranchFlag', '1')
set_data('BNEZ', 'RegisterTarget', 'PC')
set_data('BNEZ', 'AluInstruction', 'BNEZ')
set_data('BNEZ', 'DataSelectorInstruction', '0001')

set_data('BTEQZ', 'BranchFlag', '1')
set_data('BTEQZ', 'RegisterTarget', 'PC')
set_data('BTEQZ', 'AluInstruction', 'BTEQZ')
set_data('BTEQZ', 'DataSelectorInstruction', '0011')

set_data('CMP', 'AluInstruction', 'CMP')
set_data('CMP', 'DataSelectorInstruction', '1001')

set_data('CMPI', 'AluInstruction', 'CMP')
set_data('CMPI', 'DataSelectorInstruction', '0001')

# JR这个时候传给Branch的跳转是rx现在的取值
# 同时JR这里输出的immediate也是rx现在的取值
# 而JR的rx则在下个周期由获取旁路的data selector取到
# JR对应的运算B，等价于BNE：当immediate不等于rx时
# 跳转到rx的值去
set_data('JR', 'BranchFlag', '1')
set_data('JR', 'RegisterTarget', 'PC')
set_data('JR', 'AluInstruction', 'JR')
set_data('JR', 'DataSelectorInstruction', '0001')

# LI操作直接对两个立即数取与，返回本身作为Address
set_data('LI', 'RegisterTarget', 'rx')
set_data('LI', 'AluInstruction', 'AND')
set_data('LI', 'DataSelectorInstruction', '0000')
set_data('LI', 'BubbleNext', '001')

set_data('LW', 'LFlag', '1')
set_data('LW', 'RegisterTarget', 'ry')
set_data('LW', 'AluInstruction', 'ADD')
set_data('LW', 'DataSelectorInstruction', '0001')
set_data('LW', 'BubbleNext', '001')

set_data('LW_SP', 'LFlag', '1')
set_data('LW_SP', 'RegisterTarget', 'rx')
set_data('LW_SP', 'AluInstruction', 'ADD')
set_data('LW_SP', 'DataSelectorInstruction', '0011')
set_data('LW_SP', 'BubbleNext', '001')

set_data('MFIH', 'RegisterTarget', 'rx')
set_data('MFIH', 'AluInstruction', 'AND')
set_data('MFIH', 'DataSelectorInstruction', '1111')

set_data('MFPC', 'RegisterTarget', 'rx')
set_data('MFPC', 'AluInstruction', 'AND')
set_data('MFPC', 'DataSelectorInstruction', '1111')

set_data('MTIH', 'RegisterTarget', 'IH')
set_data('MTIH', 'AluInstruction', 'AND')
set_data('MTIH', 'DataSelectorInstruction', '0101')

set_data('MTSP', 'RegisterTarget', 'SP')
set_data('MTSP', 'AluInstruction', 'AND')
set_data('MTSP', 'DataSelectorInstruction', '0101')

set_data('NEG', 'RegisterTarget', 'rx')
set_data('NEG', 'AluInstruction', 'NEG')
set_data('NEG', 'DataSelectorInstruction', '0010')

set_data('OR', 'RegisterTarget', 'rx')
set_data('OR', 'AluInstruction', 'OR')
set_data('OR', 'DataSelectorInstruction', '1001')

set_data('SLL', 'RegisterTarget', 'rx')
set_data('SLL', 'AluInstruction', 'SLL')
set_data('SLL', 'DataSelectorInstruction', '0010')

set_data('SLTU', 'AluInstruction', 'SLTU')
set_data('SLTU', 'DataSelectorInstruction', '1001')

set_data('SRA', 'RegisterTarget', 'rx')
set_data('SRA', 'AluInstruction', 'SRA')
set_data('SRA', 'DataSelectorInstruction', '0010')

set_data('SRAV', 'RegisterTarget', 'ry')
set_data('SRAV', 'AluInstruction', 'SRA')
set_data('SRAV', 'DataSelectorInstruction', '0110')

set_data('SUBU', 'RegisterTarget', 'rz')
set_data('SUBU', 'AluInstruction', 'SUBU')
set_data('SUBU', 'DataSelectorInstruction', '1001')

set_data('SW', 'SFlag', '1')
set_data('SW', 'AluInstruction', 'ADD')
set_data('SW', 'DataSelectorInstruction', '100001')

set_data('SW_SP', 'SFlag', '1')
set_data('SW_SP', 'AluInstruction', 'ADD')
set_data('SW_SP', 'DataSelectorInstruction', '010011')


# 判断指令在某一个位置是否为固定值
def get_ins_bit(ins, index):
    if 11 <= index <= 15:
        return get_data(ins, 'bit15-11')[10 - index]
    if 8 <= index <= 10:
        data = get_data(ins, 'bit10-8')
        if data == '':
            return 'i'
        return data[7 - index] if len(data) == 3 else 'x'
    if 5 <= index <= 7:
        data = get_data(ins, 'bit7-5')
        if data == '':
            return 'i'
        return data[4 - index] if len(data) == 3 else 'x'
    if 2 <= index <= 4:
        data = get_data(ins, 'bit4-2')
        if data == '':
            return 'i'
        if ins == 'ADDIU3':
            return '0' if index == 4 else 'i'
        return data[1 - index] if len(data) == 3 else 'x'
    if 0 <= index <= 1:
        data = get_data(ins, 'bit1-0')
        if data == '':
            return 'i'
        return data[-1 - index] if len(data) == 2 else 'x'
    print('%s %s : get_ins_bit error' % (ins, str(index)))
    return 'x'


# 输出从判断条件开始的整条命令
def output_full_instruction(ins, f, tabs):
    f.write("\n\n%s-- %s\n" % (tabs, ins))
    # 判定条件
    f.write("%sif (%s) then\n" % (tabs, ' and '.join([
        ('(Instruction(%s) = \'%s\')' % (str(i), get_ins_bit(ins, i)))
        for i in range(16) if get_ins_bit(ins, i) in '01' and not (ins == 'NOP' and get_ins_bit(ins, i) == '1')
    ])))
    output_instruction(ins, f, tabs + ' '*4)
    f.write("%send if;" % tabs)


def output_instruction(ins, f, tabs):
    f.write('%sLFlag <= \'%s\';\n' % (tabs, get_data(ins, 'LFlag')))
    f.write('%sSFlag <= \'%s\';\n' % (tabs, get_data(ins, 'SFlag')))
    f.write('%sBranchFlag <= \'%s\';\n' % (tabs, get_data(ins, 'BranchFlag')))
    f.write('%sBranchForce <= \'0\';\n' % tabs)

    # 跳转语句的跳转目标
    if get_data(ins, 'BranchFlag') == '1':
        if ins not in ('B', 'JR'):
            # 需要预判的情况
            f.write(('''
            if (BranchPredict = '0') then
                BranchTarget <= PC0 + 1;
                BranchTargetAlu <= PC0 + (%s & Instruction(7 downto 0));
            else
                BranchTargetAlu <= PC0 + 1;
                BranchTarget <= PC0 + (%s & Instruction(7 downto 0));
            end if;
            ''' % ((' & '.join(['Instruction(7)', ] * 8), ) * 2)).replace(' ' * 12, tabs))
        else:
            # 不需要预判的情况
            if ins == 'B':
                # 直接跳转的情况
                f.write(('''
                BranchTargetAlu <= PC0 + 1;
                BranchTarget <= PC0 + (%s & Instruction(7 downto 0));
                ''' % (' & '.join([
                    'Instruction(7)',
                ] * 8), )).replace(' ' * 16, tabs))
            else:
                # 读取跳转的情况
                for i in range(8):
                    f.write(('''
                    if (%s) then
                        BranchTargetAlu <= PC0 + 1;
                        BranchTarget <= reg(%s downto %s);
                        Immediate <= reg(%s downto %s);
                    end if;
                    ''' % (
                        ' and '.join([
                            '(Instruction(%s) = \'%s\')' % (str(j), ("000" + bin(i)[2:])[7-j])
                            for j in [10, 9, 8]
                        ]), str((i+1)*16-1), str(i*16), str((i+1)*16-1), str(i*16)
                    )).replace(' ' * 20, tabs))
    else:
        # 不进行跳转的情况
        f.write(('''
        BranchTargetAlu <= "%s";
        BranchTarget <= "%s";\n''' % ('0'*16, '0'*16)).replace(' ' * 8, tabs))

    # 写入的寄存器编号
    for i in range(3):
        if get_data(ins, 'RegisterTarget') == 'r' + 'xyz'[i]:
            f.write('%sRegisterTarget <= "0" & Instruction(%s downto %s);\n' %
                    (tabs, str(10-3*i), str(8-3*i)))
    if get_data(ins, 'RegisterTarget') == 'PC':
        f.write('%sRegisterTarget <= "1010";\n' % (tabs,))
    elif get_data(ins, 'RegisterTarget') == 'SP':
        f.write('%sRegisterTarget <= "1001";\n' % (tabs,))
    elif get_data(ins, 'RegisterTarget') == 'IH':
        f.write('%sRegisterTarget <= "1000";\n' % (tabs,))
    elif get_data(ins, 'RegisterTarget') == '1111':
        f.write('%sRegisterTarget <= "1111";\n' % (tabs,))

    # ALU跳转
    if get_data(ins, 'BranchFlag') == '1':
        if ins == 'B':
            f.write('%sAluInstruction <= "%s";\n' % (tabs, get_alu_index('BN')))
        elif ins == 'JR':
            # 这个地方JR是扔到B
            f.write('%sAluInstruction <= "%s";\n' % (tabs, get_alu_index('JR')))
        else:
            f.write(('''
            if (BranchPredict = '0') then
                AluInstruction <= "%s";
            else
                AluInstruction <= "%s";
            end if;
            ''' % (get_alu_index(ins), get_alu_index({
                'BEQZ': 'BNEZ',
                'BNEZ': 'BEQZ',
                'BTEQZ': 'BTNEZ'
            }[ins]))).replace(' ' * 12, tabs))
    else:
        f.write('%sAluInstruction <= "%s";\n' % (tabs, get_alu_index(get_data(ins, 'AluInstruction'))))

    # 立即数
    start_immediate = -1
    end_immediate = 0
    for i in list(range(16))[::-1]:
        if get_ins_bit(ins, i) == 'i' and start_immediate < 0:
            start_immediate = i
        if get_ins_bit(ins, i) != 'i' and start_immediate >= 0:
            end_immediate = i+1
    if ins == 'JR':
        f.write('')
    elif start_immediate < 0:
        f.write('%sImmediate <= "%s";\n' % (tabs, '0'*16))
    else:
        f.write('%sImmediate <= %s;\n' %
                (tabs, ' & '.join(['Instruction(%s)' % str(start_immediate) if ins != 'LI' else '"0"', ]
                                  * (15 + end_immediate - start_immediate))
                 + ' & ' + 'Instruction(%s downto %s)' % (str(start_immediate), str(end_immediate))))

    # 数据选择器
    f.write('%sDataSelectorInstruction <= "%s";\n' % (tabs, ("00" + get_data(ins, 'DataSelectorInstruction')
                                                       )[-6:]))
    f.write('%sBubbleNext <= "%s";\n' % (tabs, get_data(ins, 'BubbleNext')))
    if get_data(ins, 'BubbleNext') != "000":
        f.write('%sBranchForce <= \'1\';\n%sBranchTarget <= PC0;\n' % (
            tabs, tabs
        ))


with open("decoder.vhd", 'w', encoding='utf-8') as f:
    f.write('''
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
    port ( 
        ForceNop : in std_logic;
        PC0 : in std_logic_vector(15 downto 0);
        Bubble: in std_logic_vector(2 downto 0);
        Instruction : in std_logic_vector(15 downto 0);
        BranchPredict : in std_logic;
        
        -- 寄存器
        reg : in std_logic_vector(127 downto 0);
        
        LFlag : out std_logic;
        SFlag : out std_logic;
        BranchFlag : out std_logic;
        BranchForce : out std_logic;
        BranchTarget : out std_logic_vector(15 downto 0);
        BranchTargetAlu : out std_logic_vector(15 downto 0);
        RegisterTarget : out std_logic_vector(3 downto 0);
        AluInstruction : out std_logic_vector(3 downto 0);
        Immediate : out std_logic_vector(15 downto 0);
        DataSelectorInstruction : out std_logic_vector(5 downto 0);
        BubbleNext : out std_logic_vector(2 downto 0)
    );
end decoder;

architecture bhv of decoder is
begin
process(PC0, Bubble, ForceNop, Instruction, BranchPredict)
begin
    -- 判断是否因为预测失败强制解析为NOP
    if (ForceNop = '1') then
    ''')
    output_instruction('NOP', f, ' ' * 8)
    f.write('''
    else
        if (%s) then
    ''' % (' or '.join(["(Bubble(%d) = '1')" % i for i in range(3)])))
    output_instruction('NOP', f, ' ' * 12)
    f.write('''
            if ((Bubble(0) = '1') or (Bubble(1) = '1')) then
                BranchForce <= '1';
                BranchTarget <= PC0;
            end if;
            BubbleNext <= Bubble + "111";
        else
    ''')
    for ins in decoder['instruction']:
        output_full_instruction(ins, f, ' '*12)
    f.write('''
        end if;
    end if;
end process;
end bhv;
    ''')
