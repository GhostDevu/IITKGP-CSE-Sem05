module CLA_16_bit_RC (
    s,cout,cin,a,b
);

input [15:0] a,b;
input cin;
 
output cout;
output [15:0] s;

wire [3:0] carry;    

CLA_4_bit G1(.s(s[3:0]),.cout(carry[0]),.cin(cin),.a(a[3:0]),.b(b[3:0]));
CLA_4_bit G2(.s(s[7:4]),.cout(carry[1]),.cin(carry[0]),.a(a[7:4]),.b(b[7:4]));
CLA_4_bit G3(.s(s[11:8]),.cout(carry[2]),.cin(carry[1]),.a(a[11:8]),.b(b[11:8]));
CLA_4_bit G4(.s(s[15:12]),.cout(carry[3]),.cin(carry[2]),.a(a[15:12]),.b(b[15:12]));

assign cout = carry[3];

endmodule