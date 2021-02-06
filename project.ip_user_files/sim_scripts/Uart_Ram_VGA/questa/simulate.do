onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Uart_Ram_VGA_opt

do {wave.do}

view wave
view structure
view signals

do {Uart_Ram_VGA.udo}

run -all

quit -force
