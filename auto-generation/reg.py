reg={
    'instruction': [
        'ADDIU', 'ADDIU3', 'ADDSP', 'ADDU', 'AND',
        'B', 'BEQZ', 'BNEZ', 'BTEQZ', 'CMP',
        'CMPI', 'JR', 'LI', 'LW', 'LW_SP',
        'MFIH', 'MFPC', 'MTIH', 'MTSP', 'NEG',
        'NOP', 'OR', 'SLL', 'SLTU', 'SRA',
        'SRAV', 'SUBU', 'SW', 'SW_RS', 'SW_SP'
    ]
}
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
set_data('BEQZ', 'DataSelectorInstruction', '0011')

set_data('BNEZ', 'BranchFlag', '1')
set_data('BNEZ', 'RegisterTarget', 'PC')
set_data('BNEZ', 'AluInstruction', 'BNEZ')
set_data('BNEZ', 'DataSelectorInstruction', '0011')

set_data('BTEQZ', 'BranchFlag', '1')
set_data('BTEQZ', 'RegisterTarget', 'PC')
set_data('BTEQZ', 'AluInstruction', 'BTEQZ')
set_data('BTEQZ', 'DataSelectorInstruction', '0011')

set_data('CMP', 'AluInstruction', 'CMP')
set_data('CMP', 'DataSelectorInstruction', '1001')

set_data('CMPI', 'AluInstruction', 'CMP')
set_data('CMPI', 'DataSelectorInstruction', '0001')

set_data('JR', 'BranchFlag', '1')
set_data('JR', 'RegisterTarget', 'PC')
set_data('JR', 'AluInstruction', 'B')
set_data('JR', 'DataSelectorInstruction', '0001')


