onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /generatorcontrol_tb/I_tester/regulationMode
add wave -noupdate -radixshowbase 0 /generatorcontrol_tb/I_dut/regulationType
add wave -noupdate -group {Reset and clock} /generatorcontrol_tb/reset
add wave -noupdate -group {Reset and clock} /generatorcontrol_tb/clock
add wave -noupdate /generatorcontrol_tb/I_dut/regulationType
add wave -noupdate -group {Triggered inputs} /generatorcontrol_tb/mains
add wave -noupdate -group {Triggered inputs} /generatorcontrol_tb/generator
add wave -noupdate -group {Triggered inputs} /generatorcontrol_tb/I_dut/mainsRising
add wave -noupdate -group {Triggered inputs} /generatorcontrol_tb/I_dut/generatorRising
add wave -noupdate -group {Triggered inputs} -format Analog-Step -height 20 -max 12000.0 -radix unsigned /generatorcontrol_tb/I_dut/I_PD/refCount
add wave -noupdate -group {Triggered inputs} /generatorcontrol_tb/I_dut/noRefInput
add wave -noupdate -group {Manual control} -expand /generatorcontrol_tb/buttons
add wave -noupdate -group {Manual control} /generatorcontrol_tb/I_dut/decrementControl
add wave -noupdate -group {Manual control} /generatorcontrol_tb/I_dut/incrementControl
add wave -noupdate -group {Manual control} -format Analog-Step -height 30 -max 525.0 -min 510.0 -radix unsigned /generatorcontrol_tb/I_dut/namualControlVal
add wave -noupdate -group {Manual control} /generatorcontrol_tb/I_dut/I_buttons/current_state
add wave -noupdate -expand -group {Frequency control} -radix unsigned -childformat {{/generatorcontrol_tb/I_dut/I_PD/refPeriod(15) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(14) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(13) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(12) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(11) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(10) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(9) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(8) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(7) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(6) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(5) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(4) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(3) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(2) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(1) -radix unsigned} {/generatorcontrol_tb/I_dut/I_PD/refPeriod(0) -radix unsigned}} -radixshowbase 0 -subitemconfig {/generatorcontrol_tb/I_dut/I_PD/refPeriod(15) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(14) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(13) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(12) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(11) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(10) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(9) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(8) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(7) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(6) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(5) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(4) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(3) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(2) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(1) {-height 17 -radix unsigned -radixshowbase 0} /generatorcontrol_tb/I_dut/I_PD/refPeriod(0) {-height 17 -radix unsigned -radixshowbase 0}} /generatorcontrol_tb/I_dut/I_PD/refPeriod
add wave -noupdate -expand -group {Frequency control} -radix unsigned -radixshowbase 0 /generatorcontrol_tb/I_dut/I_PD/fbPeriod
add wave -noupdate -expand -group {Frequency control} -radixshowbase 0 /generatorcontrol_tb/I_dut/phaseDataValid
add wave -noupdate -expand -group {Frequency control} -format Analog-Step -height 30 -max 2000.0000000000002 -min -20.0 -radix decimal -radixshowbase 0 /generatorcontrol_tb/I_dut/periodDifference
add wave -noupdate -expand -group {Frequency control} -format Analog-Step -height 50 -max 570.0 -min 510.0 -radix unsigned -radixshowbase 0 /generatorcontrol_tb/I_dut/I_fReg/controlAmplitudeI
add wave -noupdate -group {Phase control} /generatorcontrol_tb/I_dut/phaseDataValid
add wave -noupdate -group {Phase control} -radix decimal /generatorcontrol_tb/I_dut/phaseDifference
add wave -noupdate -group {Phase control} -format Analog-Step -height 50 -max 2000.0 -min -2000.0 -radix decimal /generatorcontrol_tb/I_dut/phaseDifference
add wave -noupdate -group {Phase control} /generatorcontrol_tb/I_dut/I_LEDs/levels
add wave -noupdate -group {RS232 control} /generatorcontrol_tb/I_dut/I_fReg/en
add wave -noupdate -group {RS232 control} -radix hexadecimal /generatorcontrol_tb/I_dut/periodDifference
add wave -noupdate -group {RS232 control} /generatorcontrol_tb/txD
add wave -noupdate -group {RS232 control} -radix ascii /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData
add wave -noupdate -group {RS232 control} -radix hexadecimal -childformat {{/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(7) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(6) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(5) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(4) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(3) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(2) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(1) -radix hexadecimal} {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(0) -radix hexadecimal}} -subitemconfig {/generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(7) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(6) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(5) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(4) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(3) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(2) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(1) {-radix hexadecimal} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData(0) {-radix hexadecimal}} /generatorcontrol_tb/I_dut/I_fReg/I_Uart/txData
add wave -noupdate -group {RS232 control} /generatorcontrol_tb/I_tester/txStart
add wave -noupdate -group {RS232 control} /generatorcontrol_tb/I_tester/txSend
add wave -noupdate -group {RS232 control} /generatorcontrol_tb/RxD
add wave -noupdate -group {RS232 control} -radix ascii /generatorcontrol_tb/I_dut/I_fReg/I_Uart/rxData
add wave -noupdate -group {RS232 control} -radix hexadecimal /generatorcontrol_tb/I_dut/I_fReg/I_Uart/rxData
add wave -noupdate -group {RS232 control} -radix hexadecimal /generatorcontrol_tb/I_tester/phaseDifference
add wave -noupdate -group {RS232 control} -radix hexadecimal /generatorcontrol_tb/I_tester/controlAmplitude
add wave -noupdate -radixshowbase 0 -subitemconfig {/generatorcontrol_tb/leds(1) {-radixshowbase 0} /generatorcontrol_tb/leds(2) {-radixshowbase 0} /generatorcontrol_tb/leds(3) {-radixshowbase 0} /generatorcontrol_tb/leds(4) {-radixshowbase 0} /generatorcontrol_tb/leds(5) {-radixshowbase 0} /generatorcontrol_tb/leds(6) {-radixshowbase 0} /generatorcontrol_tb/leds(7) {-radixshowbase 0} /generatorcontrol_tb/leds(8) {-radixshowbase 0}} /generatorcontrol_tb/leds
add wave -noupdate -expand -group {Motor and generator} -format Analog-Step -height 30 -max 570.0 -min 500.0 -radix unsigned -radixshowbase 0 /generatorcontrol_tb/I_dut/controlAmplitude
add wave -noupdate -expand -group {Motor and generator} /generatorcontrol_tb/pwm
add wave -noupdate -expand -group {Motor and generator} -format Analog-Step -height 30 -max 0.75 -min 0.25 /generatorcontrol_tb/I_tester/lowpassValue
add wave -noupdate -expand -group {Motor and generator} -format Analog-Step -height 30 -max 1.0 -min -1.0 /generatorcontrol_tb/I_tester/generatorVoltage
add wave -noupdate -group Analog-Step -height 30 -radix unsigned /generatorcontrol_tb/I_dut/controlAmplitude
add wave -noupdate -group Analog-Step -height 30 -radix unsigned /generatorcontrol_tb/I_dut/controlAmplitude
add wave -noupdate -group Analog-Step -height 30 -radix unsigned /generatorcontrol_tb/I_dut/controlAmplitude
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 314
configure wave -valuecolwidth 42
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {67830 us}
