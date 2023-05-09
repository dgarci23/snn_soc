module fifo 

    (
        input logic clock,
        input logic wen,
        input logic ren,
        input logic [3:0] din,
        output logic [3:0] dout,
        output logic empty
    );

    logic [0:3] data [15:0];

    logic [3:0] raddr, waddr;

    initial begin
        raddr <= 0; waddr <= 0;
        for (int i = 0; i < 16; i++) begin
            data[i] <= 0;
        end
    end

    assign dout = data[raddr];

    assign empty = raddr == waddr;

    always_ff @(posedge clock ) begin
        if (wen) begin
            data[waddr] <= din;
            waddr <= waddr + 1;
        end

        if (ren) begin
            raddr <= raddr + 1;
        end
    end

endmodule