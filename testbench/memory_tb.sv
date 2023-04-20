`timescale 1ns/1ns
module memory_tb ();

    parameter WIDTH = 16;
    parameter DEPTH = 8;

    logic clock;
    logic [$clog2(WIDTH)-1:0] waddr;
    logic [$clog2(WIDTH)-1:0] raddr;
    logic w_en;
    logic [DEPTH-1:0] data_in;
    logic [DEPTH-1:0] data_out;

    memory uut (
        .*
    );

    always #1 clock = ~clock;

    initial begin
        clock = 0; #1;
        waddr = 0; data_in = 4'd5; w_en = 1; raddr = 0; #2;
        $display("Value at memory location %d: %d", raddr, data_out);
        $finish;
    end

endmodule