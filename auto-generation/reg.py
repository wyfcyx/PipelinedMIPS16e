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
        'LW_SP','SW_SP'
    ],
    'sbit15-11':[
        '1001','1000','1010'
    ]
}

def writereg(f):
    for i in range(8):
        f.write('''
        if (Target(3 downto 0) = "%s") then
            reg_after(%d downto %d) <= Data(15 downto 0);
        else
            reg_after(%d downto %d) <= reg_before(%d downto %d);
        end if;
                '''%(
                    '{:04b}'.format(i),i*16+15,i*16,i*16+15,i*16,i*16+15,i*16
                ))
    f.write('''
        if (Target(3 downto 0) = "1001") then
            SP_after(15 downto 0) <= Data(15 downto 0);
        else
            SP_after(15 downto 0) <= SP_before(15 downto 0);
        end if;

        if (Target(3 downto 0) = "1000") then
            IH_after(15 downto 0) <= Data(15 downto 0);
        else
            IH_after(15 downto 0) <= IH_before(15 downto 0);
        end if;

            ''')

def Rz(index,f):
    #判断是不是特殊情况
    f.write('''
                if (Instruction(15 downto 11) = "10010") then
                    --LW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11010") then
                    --SW_SP
                    if Target(3 downto 0) = "1001" then
                        Rz(15 downto 0) <= Data(15 downto 0);
                    else
                        Rz(15 downto 0) <= SP_before(15 downto 0);
                    end if;
                    index(11 downto 8) <= "1001";
                elsif (Instruction(15 downto 11) = "11110") then
                    if (Instruction(7 downto 0) = "00000000") then
                        --MFIH
                        if Target(3 downto 0) = "1000" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz <= IH_before;
                        end if;
                        index(11 downto 8) <= "1000";
                    end if;
                elsif (Instruction(15 downto 11) = "11101") then
                    if (Instruction(7 downto 0) = "01000000") then
                        --MFPC
                        if Target(3 downto 0) = "1010" then
                            Rz(15 downto 0) <= Data(15 downto 0);
                        else
                            Rz(15 downto 0) <= PC0(15 downto 0);
                        end if;
                        index(11 downto 8) <= "1010";
                    end if;
                else
                    --normal
                    if Target(3 downto 0) = "%s" then
                        Rz <= Data(15 downto 0);
                    else
                        Rz <= reg_before(%d downto %d);
                    end if;
                    index(11 downto 8) <= "%s";'''%(
    '{:04b}'.format(index),index*16+15,index*16,'{:04b}'.format(index)
            ))
    f.write('''
                end if;
            ''')
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
            if Target(3 downto 0) = "%s" then
                R%s <= Data(15 downto 0);
            else
                R%s <= reg_before(%d downto %d);
            end if;
            Index(%d downto %d) <=  "%s";
                    '''%(
                        '{:04b}'.format(dataIndex),cur[index],cur[index],dataIndex*16+15,dataIndex*16,4*(2-index)+3,4*(2-index),'{:04b}'.format(dataIndex)
            )
                   )
        else:
            Rz(dataIndex,f)
        f.write('''
        end if;
                ''')


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
begin
process(SP_before,IH_before,reg_before,PC0,Instruction,Target,Data)
begin
    ''')
    #添加中间代码
    for i in range(3):
        R(i,f);
    f.write('''
        if Target(3 downto 0) < 15 then
            led(15 downto 0)<=Data(15 downto 0);
        else 
            led(15 downto 0)<= (others=>'0');
        end if;

            ''')
    writereg(f)
    f.write('''
end process;
end bhv;
''')
