module DSP48A1 #(
    // PARAMETERS 
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSSTYPE = "SYNC"
)(
   // INPUTS    
input  wire [17:0]A,B,D,
input  wire [47:0]C,
input  wire CLK,
input  wire CARRYIN,
input  wire [7:0]OPMODE,
input  wire [17:0]BCIN,
input  wire RSTA,
input  wire RSTB,
input  wire RSTM,
input  wire RSTP,
input  wire RSTC,
input  wire RSTD,
input  wire RSTCARRYIN,
input  wire RSTOPMODE,
input  wire CEA,
input  wire CEB,
input  wire CEM,
input  wire CEP,
input  wire CEC,
input  wire CED,
input  wire CECARRYIN,
input  wire CEOPMODE,
input  wire [47:0]PCIN,
// OUTPUTS
output wire [17:0]BCOUT,
output wire [47:0]PCOUT,
output wire [47:0]P,
output wire [35:0]M,
output wire CARRYOUT,
output wire CARRYOUTF
);
// stage 1
wire [17:0] A_r,B_r,D_r;
wire [47:0] C_r; 
wire [17:0] B_out;
wire [7:0]  opmode_r;
// stage 2
reg [17:0] out1_ADD_or_SUB;
wire [17:0] out_opmode4;
wire [17:0] out_A1REG;
wire [17:0] out_B1REG;
wire [35:0] mul_out;
wire [47:0] conc;
//stage 3 
wire [35:0] mul_out_reg;
reg [47:0] X;
reg [47:0] Z;
wire carry_cascade;
wire CIN;
// stage 4 
reg [48:0] out2_ADD_or_SUB;  // 1 bit for CIN
wire CY0; // COUT



//------------------- S T A G E 1 ------------------------
// (1) instantiate DREG
REGISTER #(.WIDTH(18),
           .RSSTYPE(RSSTYPE),
           .REG(DREG))
        u0 (.in(D),
            .CLK(CLK),
            .rst(RSTD),
            .en(CED),
            .out(D_r));
// (2) instantiate B0REG
REGISTER #(.WIDTH(18),
           .RSSTYPE(RSSTYPE),
           .REG(B0REG))
        u1 (.in(B_out),
            .CLK(CLK),
            .rst(RSTB),
            .en(CEB),
            .out(B_r));
// B_INPUT            
generate
    if (B_INPUT == "DIRECT")begin
      assign  B_out = B;
    end
    else if (B_INPUT == "CASCADE")begin
       assign B_out = BCIN;
    end
    else  
    assign B_out = 18'd0;
endgenerate
// (3) instantiate A1REG
REGISTER #(.WIDTH(18),        
           .RSSTYPE(RSSTYPE),
           .REG(A0REG))
        u2 (.in(A),
            .CLK(CLK),
            .rst(RSTA),
            .en(CEA),
            .out(A_r));
// (4) instantiate CREG
REGISTER #(           
           .RSSTYPE(RSSTYPE),
           .REG(CREG))
        u3 (.in(C),
            .CLK(CLK),
            .rst(RSTC),
            .en(CEC),
            .out(C_r));
// (5) instantiate OPMODEREG            
REGISTER #(.WIDTH(8),
           .RSSTYPE(RSSTYPE),
           .REG(OPMODEREG))
        u5(.in(OPMODE),
            .CLK(CLK),
            .rst(RSTOPMODE),
            .en(CEOPMODE),
            .out(opmode_r));

//------------------- S T A G E 2 ------------------------

// ADDER OR SUBTRACT 1 OPMODE[6]
always @(*) begin
    if (OPMODE[6] == 0)
    out1_ADD_or_SUB = D_r + B_r;
    else  
    out1_ADD_or_SUB = D_r - B_r;
end
assign out_opmode4 = (OPMODE[4] == 0)? B_r : out1_ADD_or_SUB ;
// (6) instantiate B1REG 
REGISTER #(.WIDTH(18),          
           .RSSTYPE(RSSTYPE),
           .REG(B1REG))
        u6 (.in(out_opmode4),
            .CLK(CLK),
            .rst(RSTB),
            .en(CEB),
            .out(out_B1REG));
// (7) instantiate A1REG 
REGISTER #(.WIDTH(18),  
           .RSSTYPE(RSSTYPE),
           .REG(A1REG))
        u7 (.in(A_r),
            .CLK(CLK),
            .rst(RSTA),
            .en(CEA),
            .out(out_A1REG));

// MULTIPLICATION 
assign mul_out = out_B1REG * out_A1REG;
// BCOUT
assign BCOUT = out_B1REG;
// CONCATINATION FOR WIRES D:A:B
assign conc = {D_r[11:0] , out_A1REG ,out_B1REG};

//------------------- S T A G E 3 ------------------------
// (8) instantiate MREG
REGISTER #(.WIDTH(36),  
           .RSSTYPE(RSSTYPE),
           .REG(MREG))
        u8 (.in(mul_out),
            .CLK(CLK),
            .rst(RSTM),
            .en(CEM),
            .out(mul_out_reg));

// BUFFER M 
assign M = mul_out_reg;

// MUX X 
always @(*) begin
    case (OPMODE[1:0])
    2'b01: X = mul_out_reg;
    2'b10: X = P;
    2'b11: X = conc;
    default : X = 48'd0;
    endcase
end

// MUX Z 
always @(*) begin
    case (OPMODE[3:2])
    2'b01: Z = PCIN;
    2'b10: Z = P;
    2'b11: Z = C_r;
    default: Z = 48'd0;
    endcase
end

// OPMODE 5 
generate
    if (CARRYINSEL == "OPMODE5") begin 
     assign carry_cascade = OPMODE[5];
    end
    else if(CARRYINSEL == "CARRYIN") begin 
    assign carry_cascade = CARRYIN;
    end
    else begin
    assign carry_cascade = 1'b0;  
    end
endgenerate

// (9) instantiate CY1 
 REGISTER #(.WIDTH(1),
           .RSSTYPE(RSSTYPE),
           .REG(CARRYINREG))
        u9 (.rst(RSTCARRYIN),
            .CLK(CLK),
            .en(CECARRYIN),
            .in(carry_cascade),
            .out(CIN));

//------------------- S T A G E 4 ------------------------

// ADDER OR SUBTRACT 2 OPMODE[7]
always @(*) begin
    if (OPMODE[7] == 0)begin 
    out2_ADD_or_SUB [48:0] = Z + X + CIN ;
    end
    else  begin 
    out2_ADD_or_SUB [48:0] = Z - X - CIN ;
    end
end
assign CY0 = out2_ADD_or_SUB[48];
// (10) instantiate CY0 
REGISTER #(.WIDTH(1),
           .RSSTYPE(RSSTYPE),
           .REG(CARRYOUTREG))
        u10 (.rst(RSTCARRYIN),
            .CLK(CLK),
            .en(CECARRYIN),
            .in(CY0),
            .out(CARRYOUT));
assign CARRYOUTF = CARRYOUT ; 

// (11) instantiate PREG 
REGISTER #(
           .RSSTYPE(RSSTYPE),
           .REG(PREG))
        u11 (.rst(RSTP),
            .CLK(CLK),
            .en(CEP),
            .in(out2_ADD_or_SUB[47:0]),
            .out(P));

// PCOUT 
assign PCOUT = P;

//-----------------------------DONE-------------------------------

endmodule //DSP48A1 