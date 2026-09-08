module REGISTER #( 
    parameter WIDTH =48,
    parameter RSSTYPE ="SYNC",
    parameter REG =1
)(
input CLK,rst,en,
input [WIDTH-1:0] in,
output reg [WIDTH-1:0] out
);
 generate
    if (REG == 1) begin
        if (RSSTYPE == "SYNC")begin 
        always @(posedge CLK) begin
            if (rst == 1)
            out <= {WIDTH{1'b0}};
        else if(en)
        out <= in;
        end
        end
        else begin 
        always @(posedge CLK or posedge rst) begin
            if (rst == 1)
            out <= {WIDTH{1'b0}};
        else if(en)
        out <= in;  
        end
        end
        end
    else begin
            always @(*) begin
                out<=in;
            end
        end
    endgenerate


endmodule //REGISTER