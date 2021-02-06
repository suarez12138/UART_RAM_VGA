onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Uart_Ram_VGA -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Uart_Ram_VGA xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Uart_Ram_VGA.udo}

run -all

endsim

quit -force
