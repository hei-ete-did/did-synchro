onerror {resume}
set NumericStdNoWarnings 1
quietly WaveActivateNextPane {} 0
add wave -noupdate /risingdetector_tb/clock
add wave -noupdate /risingdetector_tb/reset
add wave -noupdate -divider Input
add wave -noupdate /risingdetector_tb/sigin
add wave -noupdate -divider Output
add wave -noupdate /risingdetector_tb/rising
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 191
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {1050 ns}
