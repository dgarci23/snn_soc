`timescale 1ns/1ns
module pe_tb ();

    logic clock, accum_en, spike_done;
    logic [3:0] pe_addr;
    logic [7:0] pe_out;

    pe uut (
        .*
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0; pe_addr = 4'h1; accum_en = 0; spike_done = 0; #2
        accum_en = 1; #50;
        spike_done = 1; #4;
        $finish;
    end

endmodule