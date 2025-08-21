property no_overflow;
  @(posedge wr_clk) disable iff (!rst_n)
  wr_en && full |-> ##1 $error("FIFO overflow!");
endproperty
assert property (no_overflow);

property no_underflow;
  @(posedge rd_clk) disable iff (!rst_n)
  rd_en && empty |-> ##1 $error("FIFO underflow!");
endproperty
assert property (no_underflow);
