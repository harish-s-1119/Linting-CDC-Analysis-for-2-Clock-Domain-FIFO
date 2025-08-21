module dual_clock_fifo #(parameter WIDTH = 8, parameter DEPTH = 16) (
    input  logic              wr_clk, rd_clk, rst_n,
    input  logic              wr_en, rd_en,
    input  logic [WIDTH-1:0]  din,
    output logic [WIDTH-1:0]  dout,
    output logic              full, empty
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] wr_ptr, rd_ptr;
    logic [$clog2(DEPTH):0] wr_ptr_gray, rd_ptr_gray;
    logic [$clog2(DEPTH):0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    logic [$clog2(DEPTH):0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;

    always_ff @(posedge wr_clk or negedge rst_n)
        if (!rst_n) begin wr_ptr <= 0; wr_ptr_gray <= 0; end
        else if (wr_en && !full) begin
            mem[wr_ptr[$clog2(DEPTH)-1:0]] <= din;
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= (wr_ptr >> 1) ^ wr_ptr;
        end

    always_ff @(posedge wr_clk or negedge rst_n)
        if (!rst_n) begin rd_ptr_gray_sync1 <= 0; rd_ptr_gray_sync2 <= 0; end
        else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end

    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[$clog2(DEPTH)], rd_ptr_gray_sync2[$clog2(DEPTH)-1:0]});

    always_ff @(posedge rd_clk or negedge rst_n)
        if (!rst_n) begin rd_ptr <= 0; rd_ptr_gray <= 0; dout <= 0; end
        else if (rd_en && !empty) begin
            dout <= mem[rd_ptr[$clog2(DEPTH)-1:0]];
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= (rd_ptr >> 1) ^ rd_ptr;
        end

    always_ff @(posedge rd_clk or negedge rst_n)
        if (!rst_n) begin wr_ptr_gray_sync1 <= 0; wr_ptr_gray_sync2 <= 0; end
        else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end

    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule
