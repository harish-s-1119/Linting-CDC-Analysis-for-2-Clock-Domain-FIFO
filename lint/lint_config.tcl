# Questa Lint Config (can be adapted to SpyGlass)
set_option -check_synth true
set_option -check_cdc true
analyze -sv rtl/dual_clock_fifo.sv
elaborate
lint
report > reports/lint_report.txt
