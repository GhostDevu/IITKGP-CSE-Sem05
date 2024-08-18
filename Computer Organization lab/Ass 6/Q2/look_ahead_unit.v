module look_ahead_unit (
    C, BP, BG, P, G, cin
);

input [3:0] P,G;
output [3:0] C;

input cin;
output BP,BG;

assign C[0] = G[0] | (P[0] & cin);
assign C[1] = G[1] | (P[1] & (G[0] | (P[0] & cin)));
assign C[2] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & cin)))));
assign C[3] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & cin)))))));

assign BP = P[0] & P[1] & P[2] & P[3];
assign BG = G[3] | (P[3] & ( G[2] | (P[2]  & (G[1] | (P[1] & G[0])))));
    
endmodule