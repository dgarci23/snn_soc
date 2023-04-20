`timescale 1ns/1ns
module pe_tb ();

    logic clock, weight_w_en, accum_en, spike_done;
    logic [7:0] weight_in;
    logic spike;

    pe uut (
        .*
    );

    always #1 clock = ~clock;

    initial begin
        clock = 0; #2
        weight_in = 8'd10; weight_w_en = 1; #2;
        weight_w_en = 0; accum_en = 1; #2; #2; #2;
        $display("Weight Value: %d", uut.weight);
        $display("Membrane Potential Value: %d", uut.memb_pot);
        $display("Spike: %b", uut.spike);
        $finish;
    end

endmodule