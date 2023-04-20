module controller

    ( 
        input  logic clock,
        input  logic [3:0] event_addr,
        input  logic       event_received,
        output logic        accum_en,
        output logic        weight_w_en,
        output logic [7:0]  weight_addr
    );

    enum logic[1:0] {IDLE, WEIGHT_LOAD, ACCUM} state, next_state;
    always_ff @(posedge clock ) begin
        state <= next_state;
    end

    logic [3:0] weight_cnt;
    logic weight_cnt_en, weight_cnt_rst;

    assign weight_addr = {event_addr, weight_cnt};

    always_ff @(posedge clock ) begin
        if (weight_cnt_rst) begin
            weight_cnt <= 0;
        end else begin
            if (weight_cnt_en) begin
                weight_cnt <= weight_cnt + 1;
            end
        end
    end
    

    always_comb begin
        weight_w_en = 0;
        weight_cnt_en = 0;
        weight_cnt_rst = 0;
        accum_en = 0;
        next_state = IDLE;
        case (state)
            IDLE: begin
                if (event_received) begin
                    next_state = WEIGHT_LOAD;
                end
            end 
            WEIGHT_LOAD: begin
                weight_cnt_en = 1;
                next_state = WEIGHT_LOAD;
                weight_w_en = 1;
                if (weight_cnt == 4'd15) begin
                    weight_cnt_rst = 1;
                    next_state = ACCUM;
                end
            end
            ACCUM: begin
                next_state = IDLE;
                accum_en = 1;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    initial begin
        state <= 0; weight_cnt <= 0;
    end

endmodule