/* TODO: INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps
`default_nettype none

module lc4_divider(input  wire [15:0] i_dividend,
                   input  wire [15:0] i_divisor,
                   output wire [15:0] o_remainder,
                   output wire [15:0] o_quotient);

      /*** YOUR CODE HERE ***/
      wire [15:0] dividend_arr [16:0];
      wire [15:0] q_arr [16:0];
      wire [15:0] r_arr [16:0];
      assign dividend_arr[0] = i_dividend;
      assign q_arr[0] = 16'b0;
      assign r_arr[0] = 16'b0;
      genvar i;
            for (i = 0; i < 16; i = i+1) begin 
            lc4_divider_one_iter m(.i_dividend(dividend_arr[i]),
            .i_divisor(i_divisor),.i_remainder(r_arr[i]), .i_quotient(q_arr[i]), 
            .o_dividend(dividend_arr[i+1]), .o_remainder(r_arr[i+1]), .o_quotient(q_arr[i+1]));
      end

      assign o_remainder = (i_divisor == 0) ? 0 : r_arr[16];
      assign o_quotient = (i_divisor == 0) ? 0 : q_arr[16];
endmodule // lc4_divider

module lc4_divider_one_iter(input  wire [15:0] i_dividend,
                            input  wire [15:0] i_divisor,
                            input  wire [15:0] i_remainder,
                            input  wire [15:0] i_quotient,
                            output wire [15:0] o_dividend,
                            output wire [15:0] o_remainder,
                            output wire [15:0] o_quotient);

      /*** YOUR CODE HERE ***/
      wire [15:0] rem_ver_2 = {i_remainder[14:0], i_dividend[15]};
      assign o_quotient =  rem_ver_2 < i_divisor ? i_quotient << 1 : {i_quotient[14:0], 1'b1}; 
      assign o_remainder = rem_ver_2 < i_divisor ? rem_ver_2 : rem_ver_2 - i_divisor; 
      assign o_dividend = i_dividend << 1;
endmodule
