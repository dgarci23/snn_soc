`timescale 1ns/1ns
module top_tb ();

    logic clock;

    top uut(
        .clock(clock)
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0;
        #200;
        $display(uut.genblk1[2].pe.weight);
        $finish;
    end

endmodule