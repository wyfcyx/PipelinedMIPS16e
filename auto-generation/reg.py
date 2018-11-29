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
            f.write('''
            if (%s) then
                Rz
            else
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
end process;
end bhv;
''')
