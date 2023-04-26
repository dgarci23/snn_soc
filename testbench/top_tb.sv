`timescale 1ns/1ns
module top_tb ();

    logic clock;
    logic snn_ren;
    logic snn_event_n;
    logic [3:0] neuron_addr_out;

    top uut(
        .*
    );

    always #1 clock = ~clock;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,uut);
        clock = 0; snn_ren = 0; #1;
        for (int i = 0; i < 1000; i++) begin
            snn_ren = 0;
            if (!snn_event_n) begin
                snn_ren = 1;
                $display("Neuron %d Spiked.", neuron_addr_out);
            end
            #2;
        end
        $finish;
    end

endmodule