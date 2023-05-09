`timescale 1ns/1ns
module controller_tb ();

    logic clock;
    logic [3:0] pe_addr;
    logic accum_en, spike_done;
    logic [7:0] pe_out;

    controller uut (
        .*
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0; #2;
        $finish;
    end

endmodule