`timescale 1ns/1ns
module controller_tb ();

    logic clock;
    logic [3:0] event_addr;
    logic event_received;
    logic weight_w_en;

    controller uut (
        .*
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0; #1;
        event_addr = 4'd3; event_received = 1;
        for (int i = 0; i < 20; i++) begin
            $display("Current state: %d | weight_wen: %b | weight_cnt %d", uut.state, weight_w_en, uut.weight_cnt); #2;
        end
        $finish;
    end

endmodule