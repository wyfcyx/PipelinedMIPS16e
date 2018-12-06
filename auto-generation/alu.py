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


def output_sltu(index):
    if index == 0:
        return '((not DataA(0)) and DataB(0))'
    else:
        return '(((not DataA(%d)) and DataB(%d)) or ((DataA(%d) xnor DataB(%d)) and %s))' % \
               ((index, ) * 4 + (output_sltu(index-1),))


def output_alu(ins, f):
    # 输出条件
    f.write('''
    
    -- %s
    if (AluInstruction(3 downto 0) = "%s") then''' % (
        ins, get_alu_index(ins)
    ))
    f.write('''
        BranchFlagForward <= '%d';''' %
            (1 if ins[0] == 'B' or ins == 'JR' else 0))

    if ins == 'JR':
        f.write('''
        BranchConfirm <= (%s);''' % (
          ' or '.join([
              '(DataA(%d) xor DataB(%d))' % (x, x) for x in range(16)
          ]), ))
    elif ins == 'BN':
        f.write('''
        BranchConfirm <= '0';''')
    elif ins == 'BEQZ':
        f.write('''
        BranchConfirm <= not (%s);''' % (
            ' or '.join([
                'DataA(%d)' % x for x in range(16)
            ]), ))
    elif ins == 'BNEZ':
        f.write('''
        BranchConfirm <= (%s);''' % (
            ' or '.join([
                'DataA(%d)' % x for x in range(16)
            ]),))
    elif ins == 'BTEQZ':
        f.write('''
        BranchConfirm <= not T;''')
    elif ins == 'BTNEZ':
        f.write('''
        BranchConfirm <= T;''')
    else:
        f.write('''
        BranchConfirm <= '0';''')
    if ins == 'JR':
        f.write('''
        BranchTargetConfirm <= DataA;''')
    else:
        f.write('''
        BranchTargetConfirm <= BranchTargetAlu;''')

    if ins == 'CMP':
        # 进行比较
        f.write('''
        Tout <= (%s);''' % (
            ' or '.join([
                '(DataA(%d) xor DataB(%d))' % (x, x)
                for x in range(16)
            ])
        ))
    elif ins == 'SLTU':
        # A < B
        f.write('''
        Tout <= %s;''' % output_sltu(15))
    else:
        f.write('''
        Tout <= T;''')

    if ins[0] == 'B' or ins in ('NOP', 'CMP', 'SLTU', 'JR'):
        f.write('''
        Result0 <= "%s";
        if (RegisterTarget /= "1111") then
            ModifiedValue <= "%s";
        end if;''' % (('0'*16, ) * 2))
    elif ins == 'ADD':
        f.write('''
        Result0 <= DataA + DataB;
        if (RegisterTarget /= "1111") then
            ModifiedValue <= DataA + DataB;
        end if;''')
    elif ins == 'SUBU':
        f.write('''
        Result0 <= DataA - DataB;
        if (RegisterTarget /= "1111") then
            ModifiedValue <= DataA - DataB;
        end if;''')
    elif ins == 'AND':
        f.write('''
        Result0 <= %s;
        if (RegisterTarget /= "1111") then
            ModifiedValue <= %s;
        end if;''' % ((' & '.join([
            '(DataA(%d) and DataB(%d))' %
            (x, x) for x in list(range(16))[::-1]
        ]), )*2))
    elif ins == 'OR':
        f.write('''
        Result0 <= %s;
        if (RegisterTarget /= "1111") then
            ModifiedValue <= %s;
        end if;''' % ((' & '.join([
            '(DataA(%d) or DataB(%d))' %
            (x, x) for x in list(range(16))[::-1]
        ]),)*2))
    elif ins == 'NEG':
        f.write('''
        Result0 <= (not DataA(15 downto 0)) + 1;
        if (RegisterTarget /= "1111") then
            ModifiedValue <= (not DataA(15 downto 0)) + 1;
        end if;''')
    elif ins == 'SLL':
        for i in range(8):
            f.write('''
        if (DataB(2 downto 0) = "%s") then
            Result0 <= DataA(%d downto 0) & "%s";
            if (RegisterTarget /= "1111") then
                ModifiedValue <= DataA(%d downto 0) & "%s";
            end if;
        end if;''' % (
                ("000" + bin(i)[2:])[-3:], 7 if i == 0 else 15-i, '0' * (8 if i == 0 else i)
                , 7 if i == 0 else 15 - i, '0' * (8 if i == 0 else i)
            ))
    elif ins == 'SRA':
        for i in range(8):
            f.write('''
        if (DataB(2 downto 0) = "%s") then
            Result0 <= %s & DataA(15 downto %d);
            if (RegisterTarget /= "1111") then
                ModifiedValue <= %s & DataA(15 downto %d);
            end if;
        end if;''' % (
                ("000" + bin(i)[2:])[-3:], ' & '.join(['DataA(15)', ] * (8 if i == 0 else i)),
                8 if i == 0 else i, ' & '.join(['DataA(15)', ] * (8 if i == 0 else i)),
                8 if i == 0 else i
            ))

    f.write('''
    end if;''')


with open("alu.vhd", 'w', encoding='utf-8') as f:
    f.write('''
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
    port ( 
        DataA : in std_logic_vector(15 downto 0);
        DataB : in std_logic_vector(15 downto 0);
        AluInstruction : in std_logic_vector(3 downto 0);
        T : in std_logic;
        BranchTargetAlu : in std_logic_vector(15 downto 0);
        RegisterTarget : in std_logic_vector(3 downto 0);
        ModifiedIndex_before : in std_logic_vector(3 downto 0);
        ModifiedValue_before : in std_logic_vector(15 downto 0);
        LFlag : in std_logic;
        SFlag : in std_logic;
        PC0 : in std_logic_vector(15 downto 0);

        BranchFlagForward : out std_logic;
        BranchConfirm : out std_logic;
        BranchTargetConfirm : out std_logic_vector(15 downto 0);
        Tout : out std_logic;
        Result: out std_logic_vector(15 downto 0);
        ModifiedIndex : out std_logic_vector(3 downto 0);
        ModifiedValue : out std_logic_vector(15 downto 0);
        NextForceNop : out std_logic;
        BubbleNext_Alu : out std_logic_vector(2 downto 0);
        BranchForce_Alu : out std_logic;
        BranchTarget_Alu : out std_logic_vector(15 downto 0)
    );
end alu;

architecture bhv of alu is
begin
signal Result0 : std_logic_vector(15 downto 0) := (others =>'0');
process(DataA, DataB, AluInstruction, T, BranchTargetAlu, RegisterTarget, ModifiedIndex_before, ModifiedValue_before)
begin
    ''')
    for ins in AluInstruction:
        output_alu(ins, f)
    f.write('''
    
    if (RegisterTarget = "1111") then
        ModifiedIndex <= ModifiedIndex_before;
        ModifiedValue <= ModifiedValue_before;
    else
        ModifiedIndex <= RegisterTarget;
    end if;
    
    if ((LFlag = '1' or SFlag = '1') and Result0(15 downto 14) = "00") then
        NextForceNop <= '1';
        BubbleNext_Alu <= "010";
        BranchForce_Alu <= '1';
        BranchTarget_Alu <= PC0;
    else
        NextForceNop <= '0';
        BubbleNext_Alu <= "000";
        BranchForce_Alu <= '0';
        BranchTarget_Alu <= "0000000000000000";
    end if;
end process;
end bhv;
    ''')