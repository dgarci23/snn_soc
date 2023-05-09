module priority_encoder

    (
        input logic [15:0] i,
        output logic [3:0] y
    );

    always_comb begin
        if(i[15]==1) y=4'hF;
        else if(i[14]==1) y=4'he;
        else if(i[13]==1) y=4'hd;
        else if(i[12]==1) y=4'hc;
        else if(i[11]==1) y=4'hb;
        else if(i[10]==1) y=4'ha;
        else if(i[9]==1) y=4'h9;
        else if(i[8]==1) y=4'h8;
        else if(i[7]==1) y=4'h7;
        else if(i[6]==1) y=4'h6;
        else if(i[5]==1) y=4'h5;
        else if(i[4]==1) y=4'h4;
        else if(i[3]==1) y=4'h3;
        else if(i[2]==1) y=4'h2;
        else if(i[1]==1) y=4'h1;
        else if(i[0]==1) y=4'h0;
        else y=4'h0;
    end
endmodule