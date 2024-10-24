set ALTERA C:/Altera 
set SRC C:/Jolly/Code_FPGA/EPT_10M04_AF_Blinky/EPT_10M04_AF_Blinky
vlog +define+SIM -reportprogress 300 -work work {C:/Jolly/Code_FPGA/EPT_10M04_AF_Blinky/EPT_10M04_AF_Blinky/src/EPT_10M04_AF_S2_Top.v}
vlog +define+SIM -reportprogress 300 -work work {C:/Jolly/Code_FPGA/EPT_10M04_AF_Blinky/EPT_10M04_AF_Blinky/Testbench/tb_ept_10m04_top.v}
vsim +maxdelays work.tb_ept_10m04_top
do wave_ept_10m04_top.do
run -all
