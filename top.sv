module top 

    (
        input logic clock,
        input logic snn_ren,
        output logic snn_event_n,
        output logic [3:0] neuron_addr_out
    );

    parameter WIDTH = 16*16;
    parameter DEPTH = 8;

    // Input to the weight memory
    logic [$clog2(WIDTH)-1:0] weight_mem_waddr;
    logic weight_mem_w_en;
    logic [DEPTH-1:0] weight_mem_in;

    // Output from the weight memory
    logic [DEPTH-1:0] weight_mem_out;

    // From the sensors FIFO
    logic [3:0] sensor_event_addr = 4'd1;
    logic       sensor_event_received = 1'b1;

    // From the controller
    logic weight_pe_w_en;
    logic accum_en;
    logic [$clog2(WIDTH)-1:0] weight_ctr_raddr;
    logic spike_done;

    // To the PEs
    logic [3:0] spike_encoded;

    // From the PEs
    logic [15:0] spike;

    memory #(.WIDTH(WIDTH), .DEPTH(DEPTH)) weight_mem (
        .data_in(weight_mem_in),
        .data_out(weight_mem_out),
        .raddr(weight_ctr_raddr),
        .waddr(weight_mem_waddr),
        .w_en(weight_mem_w_en),
        .clock(clock)
    );

    controller controller ( 
        .event_received(sensor_event_received),
        .weight_w_en(weight_pe_w_en),
        .weight_addr(weight_ctr_raddr),
        .event_addr(sensor_event_addr),
        .spike(spike),
        .accum_en(accum_en),
        .spike_done(spike_done),
        .clock(clock)
    );
    
    priority_encoder encoder (
        .i(spike),
        .y(spike_encoded)
    );

    genvar i;
    generate
        for (i=0; i < 16; i++) begin
            pe pe (
                .weight_in(weight_mem_out),
                .accum_en(accum_en),
                .weight_w_en(weight_pe_w_en && (weight_ctr_raddr[3:0] == i)),
                .spike(spike[i]),
                .spike_done(spike_done&(spike_encoded==i)),
                .clock(clock)
            );
        end
    endgenerate

    fifo out_fifo (
        .clock(clock),
        .wen(spike_done),
        .ren(snn_ren),
        .din(spike_encoded),
        .dout(neuron_addr_out),
        .empty(snn_event_n)
    );

endmodule