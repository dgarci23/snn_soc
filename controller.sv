module controller

    ( 
        input  logic clock,
        input  logic [3:0] event_addr,
        input  logic       event_received,
        output logic        accum_en,
        output logic        weight_w_en,
        output logic [7:0]  weight_addr,
        output logic [15:0] spike_done
    );

    enum logic[1:0] {IDLE, WEIGHT_LOAD, ACCUM, SPIKE} state, next_state;
    always_ff @(posedge clock ) begin
        state <= next_state;
    end

    logic [3:0] neuron_cnt;
    logic neuron_cnt_en, neuron_cnt_rst;

    logic [5:0] spike_trigger_cnt;
    logic spike_trigger_cnt_en, spike_trigger_cnt_rst;

    assign weight_addr = {event_addr, neuron_cnt};

    always_ff @(posedge clock ) begin
        if (neuron_cnt_rst) begin
            neuron_cnt <= 0;
        end else begin
            if (neuron_cnt_en) begin
                neuron_cnt <= neuron_cnt + 1;
            end
        end
    end

    always_ff @(posedge clock ) begin
        if (spike_trigger_cnt_rst) begin
            spike_trigger_cnt <= 0;
        end else begin
            if (spike_trigger_cnt != 6'b11_1111) begin
                spike_trigger_cnt <= spike_trigger_cnt + 1;
            end
        end
    end
    

    always_comb begin
        weight_w_en = 0;
        neuron_cnt_en = 0;
        neuron_cnt_rst = 0;
        spike_trigger_cnt_en = 0;
        spike_trigger_cnt_rst = 0;
        accum_en = 0;
        spike_done = 16'h0000;
        next_state = IDLE;
        case (state)
            IDLE: begin
                if (spike_trigger_cnt == 6'b11_1111) begin
                    next_state = SPIKE;
                end else if (event_received) begin
                    next_state = WEIGHT_LOAD;
                end
            end 
            WEIGHT_LOAD: begin
                neuron_cnt_en = 1;
                next_state = WEIGHT_LOAD;
                weight_w_en = 1;
                if (neuron_cnt == 4'd15) begin
                    neuron_cnt_rst = 1;
                    next_state = ACCUM;
                end
            end
            ACCUM: begin
                next_state = IDLE;
                accum_en = 1;
            end
            SPIKE: begin
                spike_trigger_cnt_rst = 1;
                spike_done = 16'hFFFF;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    initial begin
        state <= 0; neuron_cnt <= 0; spike_trigger_cnt <= 0;
    end

endmodule
