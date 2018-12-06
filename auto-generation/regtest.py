special = {
    'token' : [
        '10010', '11110', '11101', '11010'
    ],
    'target' : [
        'SP_before', 'IH_before',
        'PC0', 'SP_before'
    ],
    'target_index' : [
        '1001', '1000',
        '1010', '1001'
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

def output_R(index, f):
    cur = "zyx"
    if index == 0:
        for i in range(4):
            f.write('''
        if (Instruction(15 downto 11) = "%s") then
            if (Target = "%s") then
                Rz <= Data;
            else
                Rz <= %s;
            end if;
            Index(11 downto 8) <= "%s";
        end if;\n''' % (special['token'][i], special['target_index'][i],
                              special['target'][i], special['target_index'][i]))
        f.write('''
        if (%s) then\n''' % (
            ' and '.join([
                '(Instruction(15 downto 11) /= "%s")' % special['token'][x]
                for x in range(4)
            ])
        ))

    for i in range(8):
        f.write('''
        if (Instruction(%d downto %d) = "%s") then
            if (Target = "%s") then
                R%s <= Data;
            else
                R%s <= reg_before(%d downto %d);
            end if;
            Index(%d downto %d) <= "%s";
        end if;
        ''' % (
            index*3+4, index*3+2, ("000"+bin(i)[2:])[-3:],
            ("0000" + bin(i)[2:])[-4:], cur[index],cur[index],
            i * 16 + 15, i * 16, (2-index)*4+3, (2-index)*4, ("0000" + bin(i)[2:])[-4:]
        ))

    if index == 0:
        f.write('''
        end if;\n''')


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
    for i in range(3):
        output_R(i, f)
    f.write('''
        if Target(3 downto 0) < 15 then
            -- 不是输出
            led(15 downto 0)<=Data(15 downto 0);
        else 
            led(15 downto 0)<= (others=>'0');
        end if;

        if Target(3) = '0' then
            if Target(2 downto 0) = Instruction(10 downto 8) then
                Rx(15 downto 0) <= Data(15 downto 0);
            end if;

            if Target(2 downto 0) = Instruction(7 downto 5) then
                Ry(15 downto 0) <= Data(15 downto 0);
            end if;

            if flag1 = '0' then --不存在特殊情况
                if Target(2 downto 0) = Instruction(4 downto 2) then
                    Rz(15 downto 0) <= Data(15 downto 0);
                end if;
            end if;
        else
            if flag1 = '1' then --存在特殊情况
                if Target(3 downto 0) = flag3(3 downto 0) then
                    Rz(15 downto 0)<= Data(15 downto 0);
                end if;
            end if;
        end if;

            ''')
    writereg(f)
    f.write('''
end process;
end bhv;
''')
