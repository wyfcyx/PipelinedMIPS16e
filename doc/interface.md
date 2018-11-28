# 接口说明

## main.vhd里的信号

PC(15 downto 0)：特殊寄存器 #1010

SP(15 downto 0)：特殊寄存器 #1001

IH(15 downto 0)：特殊寄存器 #1000

reg(127 downto 0)：8个通用寄存器，编号为0~7，每个寄存器16位

BranchPredict：对下次跳转是否预测为成功

T：标志位

### IF/ID锁存

PC0(15 downto 0)：IF段PC+1之后得到的结果

Instruction(15 downto 0)：IF段读取到的指令

Bubble(2 downto 0)：剩余的气泡数量

### ID/EX锁存

LFlag：是否外部读取

SFlag：是否外部写入

BranchFlag：是否为跳转语句

BranchTargetAlu(15 downto 0)：传递给ALU的跳转目标地址

RegisterTarget(3 downto 0)：写入的寄存器编号【不写入则为1111】

AluInstruction(3 downto 0)：执行的ALU指令编号

Immediate(15 downto 0)：立即数

DataSelectorInstruction(3 downto 0)：前两位和后两位各表示一个选择，00~11分别代表立即数、Rx、Ry、Rz，指示参加ALU运算的两个数

Rx(15 downto 0)：正常情况为Instruction(10 downto 8)对应寄存器的值，在MFPC、MFIH、MTIH、MFSP之类的语句的情形，为特殊寄存器的值

Ry(15 downto 0)：Instruction(7 downto 5)对应寄存器的值。

Rz(15 downto 0)：Instruction(4 downto 2)对应寄存器的值。

index(11 downto 0)：Rx、Ry、Rz的4位寄存器编号。

ModifiedIndex(3 downto 0)：上一条语句修改的寄存器编号

ModifiedValue(3 downto 0)：上一条语句修改的寄存器的值

### EX/MEM锁存

LFlag：是否外部读取

SFlag：是否外部写入

RegisterTarget(3 downto 0)：写入的寄存器编号【不写入则为1111】

AluResult(15 downto 0)：ALU计算结果

DataS(15 downto 0)：写入外部的数据

### MEM/WB锁存

RegisterTarget(3 downto 0)：写入的寄存器编号【不写入则为1111】

WriteInData(15 downto 0)：向寄存器中写入的数据

## Decoder模块（组合逻辑）

### in

ForceNop：是否【因为预测失败】强制解析为NOP

PC0(15 downto 0)：当前PC的值【用来在气泡时将其减一】

Bubble(2 downto 0)：剩余的气泡数量

Instruction(15 downto 0)：指令内容

reg(127 downto 0)：寄存器读入

BranchPredict：对下次跳转是否预测为成功【影响Branch语句的BranchTarget和AluInstruction输出，比如BNEZ 0x20，当Predict为1的时候下次会预测跳转，所以解析成BEQZ PC0+1，其中PC0+1用Decoder内部的加法器算出，当Predict为0时下次不预测跳转，正常解析】

### out

LFlag：是否外部读取

SFlag：是否外部写入

BranchFlag：是否为跳转语句

BranchForce：是否为强制跳转【只有在气泡的时候使用】

BranchTarget(15 downto 0)：传递给PCSelector的跳转目标地址【气泡的情况下为PC0-1】【预测跳转目标】

BranchTargetAlu(15 downto 0)：传递给ALU的跳转目标地址【预测失败跳转目标】

RegisterTarget(3 downto 0)：写入的寄存器编号【不写入则为1111】

AluInstruction(3 downto 0)：执行的ALU指令编号

Immediate(15 downto 0)：立即数

DataSelectorInstruction(5 downto 0)：前两位和后两位各表示一个选择，00~11分别代表立即数、Rx、Ry、Rz，指示参加ALU运算的两个数

BubbleNext(2 downto 0)：此条命令之后剩余的气泡数量【本语句为气泡的情况是Bubble-1，否则除非是生成气泡的语句为0，生成气泡的语句包括Load语句1个气泡，修改指令内存语句3个气泡】

led(15 downto 0)：输出到外部led方便查看代码运行结果

## Register模块（组合逻辑）

### in

PC0(15 downto 0)：当前PC的值【用于进行MFPC】

Instruction(15 downto 0)：指令内容

Target(3 downto 0)：写入寄存器编号

Data(15 downto 0)：写入寄存器的数据

### out

Rx(15 downto 0)：Instruction(10 downto 8)对应寄存器的值。

Ry(15 downto 0)：Instruction(7 downto 5)对应寄存器的值。

Rz(15 downto 0)：正常情况下Instruction(4 downto 2)对应寄存器的值。在MFPC、MFIH、MTIH、MFSP、LW_SP之类的语句的情形，为特殊寄存器的值。

index(11 downto 0)：Rx、Ry、Rz的4位寄存器编号。

## DataSelector模块（组合逻辑）

### in

Data(63 downto 0)：4个16位数据，00~11分别代表立即数、Rx、Ry、Rz

DataSelectorInstruction(5 downto 0)：每两位表示一个选择，00~11分别代表立即数、Rx、Ry、Rz，指示DataA、DataB和DataS

index(11 downto 0)：Rx、Ry、Rz的4位寄存器编号。

ModifiedIndex(3 downto 0)：上一条语句修改的寄存器编号

ModifiedValue(15 downto 0)：上一条语句修改的寄存器的值

### out

DataA(15 downto 0)：选择出的第一个数

DataB(15 downto 0)：选择出的第二个数

DataS(15 downto 0)：即将写入外部的数据

## ALU模块（组合逻辑）

### in

BranchFlag：是否为跳转语句

DataA(15 downto 0)：参与运算的第一个数

DataB(15 downto 0)：参与运算的第二个数

AluInstruction(3 downto 0)：执行的ALU指令编号

T：输入标志

BranchTargetAlu(15 downto 0)：传递给ALU的跳转目标地址

### out

BranchFlag：是否为跳转语句

BranchConfirm：是否确认跳转

BranchTargetConfirm(15 downto 0)：跳转目标

Tout：输出标志

Result(15 downto 0)：运算结果

ALU的Instruction对应表：

【其中BN为B的反义，Decoder因为受到预测影响，会将一些B转义成BN，此时预测已经成功】

| AluInstruction | 运算  | 对应的操作                                 |
| -------------- | ----- | ------------------------------------------ |
| 0000           | NOP   | Res = 0                                    |
| 0001           | ADD   | Res = A + B                                |
| 0010           | SUBU  | Res = A - B（无符号）                      |
| 0011           | CMP   | Res = A - B（无符号）                      |
| 0100           | SLTU  | Res = A - B（无符号），T=(Res<0)           |
| 0101           | AND   | Res = A & B                                |
| 0110           | OR    | Res = A \| B                               |
| 0111           | SLL   | Res = A << B                               |
| 1000           | SRA   | Res = A >> B（算术）                       |
| 1001           | NEG   | Res = -A 以上Flag=0以下Flag=1              |
| 1010           | B     | Res = 0; Confirm = 1， Target = A + B      |
| 1011           | BN    | Res = 0; Confirm = 0                       |
| 1100           | BEQZ  | Res = 0; Confirm = (A==0)， Target = A + B |
| 1101           | BNEZ  | Res = 0; Confirm = (A!=0)， Target = A + B |
| 1110           | BTEQZ | Res = 0; Confirm = (T==0)， Target = A + B |
| 1111           | BTNEZ | Res = 0; Confirm = (T!=0)， Target = A + B |

## PCSelector模块（敏感信号为CLK）

### in

PC0(15 downto 0)：来自IF段的“下一条指令的地址”

BranchPredict：对下次跳转是否预测为跳转

BranchFlag：上一条语句是否为跳转语句

BranchForce：上一条语句是否为强制跳转

BranchTarget(15 downto 0)：上一条语句提供的跳转目标地址

BranchFlagForward：更上一条语句是否为跳转语句

BranchConfirm：更上一条语句进行跳转

BranchTargetConfirm(15 downto 0)：更上一条语句的跳转目标

### out

PCNext(15 downto 0)：选择之后的“下一条指令的地址”

PredictionFailed：指示本次预测是否失败【不预测的情况为0】

BranchPredictNext：下次跳转预测是否预测为跳转

【注意，因为我们在Decoder的地方做了特殊处理，所以在译码器的视角，永远是“预测跳转的”。所以Confirm=1相当于“预测正确”，Confirm=0相当于“预测失败并转向TargetConfirm”】

此模块的真值表：

| Flag | Force | FlagF | Confirm | PCNext        | PredFailed | PredNext    |
| ---- | ----- | ----- | ------- | ------------- | ---------- | ----------- |
| X    | 1     | X     | X       | Target        | 0          | Predict     |
| X    | 0     | 1     | 1       | PC0           | 0          | Predict     |
| X    | 0     | 1     | 0       | TargetConfirm | 1          | not Predict |
| 1    | 0     | 0     | X       | Target        | 0          | Predict     |
| 0    | 0     | 0     | X       | PC0           | 0          | Predict     |

## Memory模块（组合逻辑）

### in

LFlag：是否外部读取

SFlag：是否外部写入

Address(15 downto 0)：读取/写入的目标地址

DataS(15 downto 0)：写入的数据

### out

Result(15 downto 0)：读取到的数据