module pe 

    #(parameter THRESHOLD = 20)

    (
        input logic        clock,
        input logic [3:0]  pe_addr,
        input logic        accum_en,
        input logic        spike_done,
        output logic [7:0] pe_out
    );

    logic [7:0] weight [0:15];
    logic [7:0] memb_pot [0:15];

    initial begin
        for (int i = 0; i < 16; i++) begin
            weight[i] = i;
            memb_pot[i] = i;
        end
    end

    assign spike = memb_pot[pe_addr] > THRESHOLD;

    assign pe_out = memb_pot[pe_addr];

    always_ff @( posedge clock ) begin
        if (accum_en) begin
            memb_pot[pe_addr] <= memb_pot[pe_addr] + weight[pe_addr];
        end

        if (spike_done & spike) begin
            memb_pot[pe_addr] <= 0;
        end
    end

endmodule