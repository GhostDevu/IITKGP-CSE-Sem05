module CLA_16_bit_lookahead (
    s,cout,cin,a,b,BP,BG
);

input [15:0] a,b;
input cin;

output [15:0] s;
output cout,BP,BG;

wire [3:0] C,P,G;

assign cout = C[3];

CLA_4_bit_augmented G1(.s(s[3:0]),.BP(P[0]),.BG(G[0]),.a(a[3:0]),.b(b[3:0]),.cin(cin));
CLA_4_bit_augmented G2(.s(s[7:4]),.BP(P[1]),.BG(G[1]),.a(a[7:4]),.b(b[7:4]),.cin(C[0]));
CLA_4_bit_augmented G3(.s(s[11:8]),.BP(P[2]),.BG(G[2]),.a(a[11:8]),.b(b[11:8]),.cin(C[1]));
CLA_4_bit_augmented G4(.s(s[15:12]),.BP(P[3]),.BG(G[3]),.a(a[15:12]),.b(b[15:12]),.cin(C[2]));

look_ahead_unit G5(.carrys(C[3:0]),.BP(BP),.BG(BG),.P(P[3:0]),.G(G[3:0]),.cin(cin));




endmodule