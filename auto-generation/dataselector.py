def select_data(index, f):
    for dataIndex in range(4):
        f.write('''
        if (%s) then\n''' % (
            'DataSelectorInstruction(%d downto %d) = "%s"' % (
                    2*index+1, 2*index, ("00" + bin(dataIndex)[2:])[-2:]
                )
        ))
        if dataIndex != 0:
            f.write('''
            if (%s) then
                Data%s <= ModifiedValue;
            else
                Data%s <= Data(%d downto %d);
            end if;\n''' % (
                'Index(%d downto %d) = ModifiedIndex(3 downto 0)' % (
                    (dataIndex-1)*4+3, (dataIndex-1)*4
                ),
                'ABS'[index], 'ABS'[index],
                dataIndex*16+15, dataIndex*16
            ))
        else:
            f.write('''
            Data%s <= Data(%d downto %d);\n''' % (
                'ABS'[index],
                dataIndex * 16 + 15, dataIndex * 16
            ))
        f.write('''
        end if;\n''')


with open("dataselector.vhd", 'w', encoding='utf-8') as f:
    f.write('''
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DataSelector is
    port ( 
        Data : in std_logic_vector(63 downto 0);
        DataSelectorInstruction : in std_logic_vector(5 downto 0);
        Index : in std_logic_vector(11 downto 0);
        ModifiedIndex : in std_logic_vector(3 downto 0);
        ModifiedValue : in std_logic_vector(15 downto 0);
        
        DataA : out std_logic_vector(15 downto 0);
        DataB : out std_logic_vector(15 downto 0);
        DataS : out std_logic_vector(15 downto 0)
    );
end DataSelector;

architecture bhv of DataSelector is
begin
process(Data, DataSelectorInstruction, Index, ModifiedIndex, ModifiedValue)
begin
    ''')
    for i in range(3):
        select_data(i, f)
    f.write('''
end process;
end bhv;
''')
