onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /phasedetector_tb/reset
add wave -noupdate /phasedetector_tb/clock
add wave -noupdate -divider frequencies
add wave -noupdate /phasedetector_tb/refPhase
add wave -noupdate /phasedetector_tb/fbPhase
add wave -noupdate -divider {Period counters}
add wave -noupdate -format Analog-Step -height 30 -max 2000.0 -radix unsigned /phasedetector_tb/I_DUT/refCount
add wave -noupdate -format Analog-Step -height 30 -max 2000.0 -radix unsigned /phasedetector_tb/I_DUT/fbCount
add wave -noupdate -format Analog-Step -height 30 -max 2000.0 -radix unsigned /phasedetector_tb/I_DUT/fbCountSampled
add wave -noupdate -divider Periods
add wave -noupdate -radix unsigned /phasedetector_tb/I_DUT/refPeriod
add wave -noupdate -radix unsigned /phasedetector_tb/I_DUT/fbPeriod
add wave -noupdate -divider {Phase difference}
add wave -noupdate -format Analog-Step -height 50 -max 800.0 -min -800.0 -radix decimal -radixshowbase 0 /phasedetector_tb/I_DUT/phaseDiffwrapped
add wave -noupdate -radix decimal -radixshowbase 0 /phasedetector_tb/I_DUT/unwrapOffset
add wave -noupdate -format Analog-Step -height 100 -max 5000.0 -radix decimal /phasedetector_tb/phaseDifference
add wave -noupdate /phasedetector_tb/phaseDiffValid
add wave -noupdate -divider {Period difference}
add wave -noupdate -radix decimal /phasedetector_tb/periodDifference
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {150647 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 260
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
WaveRestoreZoom {0 ns} {1050 us}
