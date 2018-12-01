setMode -bscan
setCable -p auto
addDevice -position 1 -file D:\Tsinghua\Autumn2018\computer\PipelinedMIPS16e\lib\flashRam\exe\flashram.bit
ReadIdcode -p 1
program -p 1
quit
