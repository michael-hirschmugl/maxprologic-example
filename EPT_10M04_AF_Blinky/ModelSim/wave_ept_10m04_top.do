onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Testbench Signals}
add wave -noupdate /tb_ept_10m04_top/clk_10
add wave -noupdate /tb_ept_10m04_top/clk_32K
add wave -noupdate /tb_ept_10m04_top/reset
add wave -noupdate -divider EPT-10M04-Top
add wave -noupdate /tb_ept_10m04_top/DUT/CLK_10MHZ
add wave -noupdate /tb_ept_10m04_top/DUT/CLK_32KHZ
add wave -noupdate /tb_ept_10m04_top/DUT/RST
add wave -noupdate /tb_ept_10m04_top/DUT/CLK_10MHZ_ENABLE
add wave -noupdate /tb_ept_10m04_top/DUT/CLK_32KHZ_ENABLE
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/XIO_1
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/XIO_2
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/XIO_3
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/XIO_4
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/LED
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/state
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/next
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/timer_value
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/seed_value
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/led_delay_counter
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/start_blinky
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/static_load_value
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/led_reg
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/shift_count_value
add wave -noupdate -radix ascii /tb_ept_10m04_top/DUT/state_name
add wave -noupdate -radix hexadecimal /tb_ept_10m04_top/DUT/led_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 19} {7254725913 ps} 0} {{Cursor 3} {1247655982 ps} 0} {{Cursor 4} {6891545513 ps} 0} {{Cursor 5} {552485341 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 227
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {552423151 ps} {552504045 ps}
