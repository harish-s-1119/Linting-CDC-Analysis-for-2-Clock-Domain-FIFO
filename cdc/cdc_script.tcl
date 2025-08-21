# Questa or SpyGlass CDC setup
set_clock wr_clk -name WR_CLK
set_clock rd_clk -name RD_CLK
set_reset rst_n

analyze -sv rtl/dual_clock_fifo.sv
elaborate
check_cdc
report_cdc > reports/cdc_report.txt
