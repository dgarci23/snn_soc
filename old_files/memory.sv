module memory

    #(parameter WIDTH = 16, parameter DEPTH = 8, parameter MEM_FILE = "weight.mem")

    (
        input logic clock,
        input logic [$clog2(WIDTH)-1:0] waddr,
        input logic [$clog2(WIDTH)-1:0] raddr,
        input logic w_en,
        input logic [DEPTH-1:0] data_in,
        output logic [DEPTH-1:0] data_out
    );

    logic [0:DEPTH-1] memory_data [WIDTH-1:0];

    assign data_out = memory_data[raddr];

    initial begin
        $readmemh(MEM_FILE, memory_data, 0, WIDTH-1);
    end

    always_ff @(posedge clock ) begin
        if (w_en) begin
            memory_data[waddr] <= data_in;
        end     
    end


endmodule