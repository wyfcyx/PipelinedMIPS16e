reg={
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
    'special':[
        'LW_SP','MFIH','MFPC'
    ],
    'sindex':[
        9,8,10
    ]
}

def Rz(index,f):
    #判断是不是特殊情况
    f.write('''
                flag2 <= "0" --初始化
            ''')
    for i in range(len(reg['special'])):
        #如果是特殊情况
        cur=reg['instruction'].index(reg['special'][i])
        f.write('''
                if Instrction(15 downto 11) = "%s"
                    flag1 <= "1" --存在特殊情况
                    flag2 <= "%d" --临时标记
                '''%(reg['bit15-11'][cur],i+1))
    t='1'+'{:03b}'.format(index)
    f.write('''
            if flag2 = "0" --正常情况
                Rz <= reg_before(%d downto %d)
                index(11 downto 8) = "%s"
            elsif  flag2 = "1"
                Rz <= reg_before(47 downto 32)
                index(11 downto 8) = "%s"
            elseif flag2 = "2"
                Rz <= reg_before(31 downto 16)
                index(11 downto 8) = "%s"
            else
                Rz<= reg_before(15 downto 0)
                index(11 downto 8) = "%s"
            end if;
            '''%(
                index*16+15,index*16,'{:04b}'.format(index),t,t,t
            ))
def R(index,f):
    cur=['z','y','x']
    for dataIndex in range(8):
        f.write('''
        if (%s) then\n'''%(
            'Instruction(%d downto %d) = "%s"'%(
                3*index+4,3*index+2,'{:03b}'.format(dataIndex)
            )
        ))
        if index !=0:
            f.write('''
            R%s <= reg_before(%d downto %d);
            Index(%d downto %d) =  "%s"
                    '''%(
                        cur[index],dataIndex*16+15,dataIndex*16,4*(2-index)+3,4*(2-index),'{:04b}'.format(dataIndex)
            )
                   )
        else:
            Rz(dataIndex,f)


    pass
with open("reg.vhd", 'w', encoding='utf-8') as f:
    f.write('''
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg is
	port(
	SP_before, IH_before : in std_logic_vector(15 downto 0);
	reg_before : in std_logic_vector(127 downto 0);
	PC0 : in std_logic_vector(15 downto 0);
	Instruction : in std_logic_vector(15 downto 0);
	Target : in std_logic_vector(3 downto 0);
	Data : in std_logic_vector(15 downto 0);

	SP_after, IH_after : out std_logic_vector(15 downto 0);
	reg_after : out std_logic_vector(127 downto 0);
	Rx, Ry, Rz : out std_logic_vector(15 downto 0);
	Index : out std_logic_vector(11 downto 0);
	led : out std_logic_vector(15 downto 0)
	);
end reg;
architecture bhv of reg is
    signal flag1: std_logic; --说明是否存在特殊情况
    signal flag2: std_logic; --临时变量
begin
process(SP_before,IH_before,reg_before,PC0,Instruction,Target,Data)
begin
    flag1 <= "0";
    ''')
    #添加中间代码
    for i in range(3):
        R(i,f);
    f.write('''
        if Target(3 downto 0) != "1111"
            --不是输出
            led(15 downto 0)=Data(15 downto 0)

            ''')
    f.write('''
end process;
end bhv;
''')
