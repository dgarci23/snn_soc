module pe 

    #(parameter THRESHOLD = 20)

    (
        input  logic       clock,
        input  logic       weight_w_en, // Weight Write Enable
        input  logic       accum_en,    // Accumulator Write Enable
        input  logic [7:0] weight_in,   // Weight Input
        input  logic       spike_done,
        output logic       spike        // Spike Output
    );

    logic [7:0] weight;
    logic [7:0] memb_pot;

    initial begin
        weight <= 0; memb_pot <= 0;
    end

    assign spike = memb_pot > THRESHOLD;

    always_ff @(posedge clock ) begin

        // Write the new weight value
        if (weight_w_en) begin
            weight <= weight_in;
        end

        // Accumulate the weight
        if (accum_en) begin
            memb_pot <= memb_pot + weight;
        end

        // Reset the membrane potential when spikes
        if (spike_done & spike) begin
            memb_pot <= 0;
        end
    end

endmodule