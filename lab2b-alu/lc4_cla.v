/* TODO: INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps
`default_nettype none

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals 
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits collectively generate a carry (ignoring cin)
 * @param pout whether these 4 bits collectively would propagate an incoming carry (ignoring cin)
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);
   assign pout = &pin;

   assign gout = (gin[3]) | (pin[3] & gin[2]) | (pin[3] & pin[2] & gin[1]) 
   | (pin[3] & pin[2] & pin[1] & gin[0]);

   assign cout[0] = (pin[0] & cin) | gin[0];
   assign cout[1] = (pin[0] & pin[1] & cin) | (gin[0] & pin[1]) | gin[1];
   assign cout[2] = (pin[0] & pin[1] & pin[2] & cin) | 
   (gin[0] & pin[1] & pin[2]) | (gin[1] & pin[2]) | gin[2];
endmodule

/**
 * 16-bit Carry-Lookahead Adder
 * @param a first input
 * @param b second input
 * @param cin carry in
 * @param sum sum of a + b + carry-in
 */
module cla16
  (input wire [15:0]  a, b,
   input wire         cin,
   output wire [15:0] sum);
   
   wire pout1, pout2, pout3, pout4;
   wire g1, g2, g3, g4;
   wire [2:0] cout1;
   wire [2:0] cout2;
   wire [2:0] cout3;
   wire [2:0] cout4;
   wire gout_5;
   wire pout_5;
   wire [2:0] cout5;
   wire gp_1_g1, gp_1_g2, gp_1_g3, gp_1_g4; 
   wire gp_1_g5, gp_1_g6, gp_1_g7, gp_1_g8; 
   wire gp_1_g9, gp_1_g10, gp_1_g11, gp_1_g12; 
   wire gp_1_g13, gp_1_g14, gp_1_g15, gp_1_g16; 
   wire gp_1_p1, gp_1_p2, gp_1_p3, gp_1_p4; 
   wire gp_1_p5, gp_1_p6, gp_1_p7, gp_1_p8; 
   wire gp_1_p9, gp_1_p10, gp_1_p11, gp_1_p12; 
   wire gp_1_p13, gp_1_p14, gp_1_p15, gp_1_p16;
   gp1 gp1_1 (a[0], b[0], gp_1_g1, gp_1_p1);
   gp1 gp1_2 (a[1], b[1], gp_1_g2, gp_1_p2);
   gp1 gp1_3 (a[2], b[2], gp_1_g3, gp_1_p3);
   gp1 gp1_4 (a[3], b[3], gp_1_g4, gp_1_p4);
   gp1 gp1_5 (a[4], b[4], gp_1_g5, gp_1_p5);
   gp1 gp1_6 (a[5], b[5], gp_1_g6, gp_1_p6);
   gp1 gp1_7 (a[6], b[6], gp_1_g7, gp_1_p7);
   gp1 gp1_8 (a[7], b[7], gp_1_g8, gp_1_p8);
   gp1 gp1_9 (a[8], b[8], gp_1_g9, gp_1_p9);
   gp1 gp1_10 (a[9], b[9], gp_1_g10, gp_1_p10);
   gp1 gp1_11 (a[10], b[10], gp_1_g11, gp_1_p11);
   gp1 gp1_12 (a[11], b[11], gp_1_g12, gp_1_p12);
   gp1 gp1_13 (a[12], b[12], gp_1_g13, gp_1_p13);
   gp1 gp1_14 (a[13], b[13], gp_1_g14, gp_1_p14);
   gp1 gp1_15 (a[14], b[14], gp_1_g15, gp_1_p15);
   gp1 gp1_16 (a[15], b[15], gp_1_g16, gp_1_p16);

   gp4 gp4_1 ({gp_1_g4,gp_1_g3, gp_1_g2, gp_1_g1}, {gp_1_p4,gp_1_p3, gp_1_p2, gp_1_p1}, cin, g1, pout1, cout1);
   gp4 gp4_2 ({gp_1_g8,gp_1_g7, gp_1_g6, gp_1_g5}, {gp_1_p8,gp_1_p7, gp_1_p6, gp_1_p5}, cout5[0], g2, pout2, cout2);
   gp4 gp4_3 ({gp_1_g12,gp_1_g11, gp_1_g10, gp_1_g9}, {gp_1_p12,gp_1_p11, gp_1_p10, gp_1_p9}, cout5[1], g3, pout3, cout3);
   gp4 gp4_4 ({gp_1_g16,gp_1_g15, gp_1_g14, gp_1_g13}, {gp_1_p16,gp_1_p15, gp_1_p14, gp_1_p13}, cout5[2], g4, pout4, cout4);
   gp4 gp4_5 ({g4, g3, g2, g1}, {pout4, pout3, pout2, pout1}, cin, gout_5, pout_5, cout5);
   wire[15:0] c = {cout4, cout5[2], cout3, cout5[1], cout2,cout5[0], cout1, cin};
   assign sum = a ^ b ^ c;

endmodule


/** Lab 2 Extra Credit, see details at
  https://github.com/upenn-acg/cis501/blob/master/lab2-alu/lab2-cla.md#extra-credit
 If you are not doing the extra credit, you should leave this module empty.
 */
module gpn
  #(parameter N = 4)
  (input wire [N-1:0] gin, pin,
   input wire  cin,
   output wire gout, pout,
   output wire [N-2:0] cout);
 
endmodule
