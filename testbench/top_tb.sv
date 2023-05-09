`timescale 1ns/1ns
module top_tb ();

    logic clock;

    top uut(
        .*
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0; #100;
        $finish;
    end

endmodule