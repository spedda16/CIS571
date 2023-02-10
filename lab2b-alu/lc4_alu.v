/* Sanjana Peddagorla, spedda */

`timescale 1ns / 1ps
`default_nettype none

module lc4_alu(input  wire [15:0] i_insn,
               input wire [15:0]  i_pc,
               input wire [15:0]  i_r1data,
               input wire [15:0]  i_r2data,
               output wire [15:0] o_result);


      /*** YOUR CODE HERE ***/
      // use bits of insn
      // 16:1 mux for output
      // use mux for cla input
      // use ternary operators for inputs
      wire [3:0] op_code;
      assign op_code = i_insn[15:12];
      
      //wire sub_op [2:0];
      wire is_nop;
      wire is_brp;
      wire is_brz;
      wire is_brzp;
      wire is_brn;
      wire is_brnp;
      wire is_brnz;
      wire is_brnzp;

      wire is_add;
      wire is_mul;
      wire is_sub;
      wire is_div;
      wire is_addi;

      wire is_cmp;
      wire is_cmpu;
      wire is_cmpi;
      wire is_cmpiu;

      wire is_jsrr;
      wire is_jsr;

      wire is_and;
      wire is_not;
      wire is_or;
      wire is_xor;
      wire is_andi;

      wire is_ldr;
      wire is_str;

      wire is_rti;
      wire is_trap;

      wire is_const;
      wire is_hiconst;

      wire is_sll;
      wire is_sra;
      wire is_srl;
      wire is_mod;

      wire is_jmpr;
      wire is_jmp;

      // always block

      // branch ops
      assign is_nop = ((op_code == 4'b0000) && (i_insn[11:9] == 3'b000)) ? (1'b1) : (1'b0);
      assign is_brp = (op_code == 4'b0000 && i_insn[11:9] == 3'b001) ? 1'b1 : 1'b0;
      assign is_brz = (op_code == 4'b0000 && i_insn[11:9] == 3'b010) ? 1'b1 : 1'b0;
      assign is_brzp = (op_code == 4'b0000 && i_insn[11:9] == 3'b011) ? 1'b1 : 1'b0;
      assign is_brn = (op_code == 4'b0000 && i_insn[11:9] == 3'b100) ? 1'b1 : 1'b0;
      assign is_brnp = (op_code == 4'b0000 && i_insn[11:9] == 3'b101) ? 1'b1 : 1'b0;
      assign is_brnz = (op_code == 4'b0000 && i_insn[11:9] == 3'b110) ? 1'b1 : 1'b0;
      assign is_brnzp = (op_code == 4'b0000 && i_insn[11:9] == 3'b111) ? 1'b1 : 1'b0;
      
      // alu ops
      assign is_add = (op_code == 4'b0001 && i_insn[5:3] == 3'b000) ? 1'b1 : 1'b0;
      assign is_mul = (op_code == 4'b0001 && i_insn[5:3] == 3'b001) ? 1'b1 : 1'b0;
      assign is_sub = (op_code == 4'b0001 && i_insn[5:3] == 3'b010) ? 1'b1 : 1'b0;
      assign is_div = (op_code == 4'b0001 && i_insn[5:3] == 3'b011) ? 1'b1 : 1'b0;
      assign is_addi = (op_code == 4'b0001 && i_insn[5] == 1'b1) ? 1'b1 : 1'b0;

      // cmp ops
      assign is_cmp = (op_code == 4'b0010 && i_insn[8:7] == 2'b00) ? 1'b1 : 1'b0;
      assign is_cmpu = (op_code == 4'b0010 && i_insn[8:7] == 2'b01) ? 1'b1 : 1'b0;
      assign is_cmpi = (op_code == 4'b0010 && i_insn[8:7] == 2'b10) ? 1'b1 : 1'b0;
      assign is_cmpiu = (op_code == 4'b0010 && i_insn[8:7] == 2'b11) ? 1'b1 : 1'b0;

      // jmp ops
      assign is_jsrr = (op_code == 4'b0100 && i_insn[11] == 1'b0) ? 1'b1 : 1'b0;
      assign is_jsr = (op_code == 4'b0100 && i_insn[11] == 1'b1) ? 1'b1 : 1'b0;
      assign is_jmpr = (op_code == 4'b1100 && i_insn[11] == 1'b0) ? 1'b1 : 1'b0;
      assign is_jmp = (op_code == 4'b1100 && i_insn[11] == 1'b1) ? 1'b1 : 1'b0;

      // logical ops
      assign is_and = (op_code == 4'b0101 && i_insn[5:3] == 3'b000) ? 1'b1 : 1'b0;
      assign is_not = (op_code == 4'b0101 && i_insn[5:3] == 3'b001) ? 1'b1 : 1'b0;
      assign is_or = (op_code == 4'b0101 && i_insn[5:3] == 3'b010)? 1'b1 : 1'b0;
      assign is_xor = (op_code == 4'b0101 && i_insn[5:3] == 3'b011) ? 1'b1 : 1'b0;
      assign is_andi = (op_code == 4'b0101 && i_insn[5] == 1'b1) ? 1'b1 : 1'b0;

      // ldr and str
      assign is_ldr = (op_code == 4'b0110) ? 1'b1 : 1'b0;
      assign is_str = (op_code == 4'b0111) ? 1'b1 : 1'b0;

      // rti and trap
      assign is_rti = (op_code == 4'b1000) ? 1'b1 : 1'b0;
      assign is_trap = (op_code == 4'b1111) ? 1'b1 : 1'b0;

      // const and hiconst
      assign is_const = (op_code == 4'b1001) ? 1'b1 : 1'b0;
      assign is_hiconst = (op_code == 4'b1101) ? 1'b1 : 1'b0;

      // shift ops
      assign is_sll = (op_code == 4'b1010 && i_insn[5:4] == 2'b00) ? 1'b1 : 1'b0;
      assign is_sra = (op_code == 4'b1010 && i_insn[5:4] == 2'b01) ? 1'b1 : 1'b0;
      assign is_srl = (op_code == 4'b1010 && i_insn[5:4] == 2'b10) ? 1'b1 : 1'b0;
      assign is_mod = (op_code == 4'b1010 && i_insn[5:4] == 2'b11) ? 1'b1 : 1'b0;
      
      // insns involving cla - add, sub, branch, jmp, str, ldr
      // for cmp can use verilog ops

      // for trap, rti, etc. return updated pc value
      

      wire [15:0] sximm5;
      assign sximm5 = ((is_addi == 1'b1) || (is_andi == 1'b1)) ? {{11{i_insn[4]}}, i_insn[4:0]} : 16'b0;

      wire [15:0] sximm6;
      assign sximm6 = ((is_ldr == 1'b1) ||(is_str == 1'b1)) ? 
      {{10{i_insn[5]}}, i_insn[5:0]} :
      16'b0;


      wire [15:0] sximm9;
      assign sximm9 = ((is_const == 1'b1) || 
      (is_brp == 1'b1) ||
      (is_brz == 1'b1) || 
      (is_brzp == 1'b1) ||
      (is_brn == 1'b1) ||
      (is_brnp == 1'b1) ||
      (is_brnz == 1'b1) ||
      (is_brnzp == 1'b1) ||
      (is_nop == 1'b1)) ? {{7{i_insn[8]}}, i_insn[8:0]} : 16'b0;

      wire [15:0] sximm11;
      assign sximm11 = (is_jmp == 1'b1) ? {{5{i_insn[10]}}, i_insn[10:0]} : 16'b0;

      wire [15:0] cla_out;

      wire [15:0] cla_in1;
      assign cla_in1 = ((is_add == 1'b1) || (is_sub == 1'b1) ||
      (is_addi == 1'b1) || (is_ldr == 1'b1) || (is_str == 1'b1)) ? (i_r1data) :
      ((is_brp == 1'b1) || (is_brz == 1'b1) ||
      (is_brzp == 1'b1) || (is_brn == 1'b1) ||
      (is_brnp == 1'b1) || (is_brnz == 1'b1) ||
      (is_brnzp == 1'b1) || (is_nop == 1'b1) || (is_jmp == 1'b1)) ? (i_pc) :
      16'b0;

      wire [15:0] cla_in2;
      assign cla_in2 = (is_add == 1'b1) ? (i_r2data) :
      (is_sub == 1'b1) ? (~i_r2data) :
      (is_addi) ? (sximm5) :
      ((is_brp == 1'b1) || (is_brz == 1'b1) ||
      (is_brzp == 1'b1) || (is_brn == 1'b1) ||
      (is_brnp == 1'b1) || (is_brnz == 1'b1) ||
      (is_brnzp == 1'b1) || (is_nop == 1'b1)) ? (sximm9) :
      ((is_ldr == 1'b1) || (is_str == 1'b1)) ? (sximm6) :
      (is_jmp == 1'b1) ? (sximm11) :
      16'b0;

      wire cla_cin;
      assign cla_cin = ((is_brp == 1'b1) || (is_brz == 1'b1) ||
      (is_brzp == 1'b1) || (is_brn == 1'b1) ||
      (is_brnp == 1'b1) || (is_brnz == 1'b1) ||
      (is_brnzp == 1'b1) || (is_jmp == 1'b1) || (is_nop == 1'b1)) ? (1'b1) :
      (is_sub == 1'b1) ? (8'h01) :
      1'b0;

      cla16 m(.a(cla_in1), .b(cla_in2), .cin(cla_cin), .sum(cla_out));

      wire [15:0] div_out;
      wire [15:0] rem_out;

      lc4_divider d(.i_dividend(i_r1data), .i_divisor(i_r2data), .o_remainder(rem_out), .o_quotient(div_out));

      wire [15:0] hiconst_temp1;
      assign hiconst_temp1 = (is_hiconst == 1'b1) ? (i_r1data & 8'hFF) :
      16'b0;

      wire [15:0] hiconst_temp2;
      assign hiconst_temp2 = (is_hiconst == 1'b1) ? (i_insn[7:0] << 4'd8) :
      16'b0;

      wire [15:0] jsr_temp1;
      assign jsr_temp1 = i_pc & 16'h8000;
      wire [15:0] jsr_temp2;
      assign jsr_temp2 = (i_insn[10:0]) << 4;
      // todo: jsr and jsrr

      wire signed [15:0] s_r1 = i_r1data;
      wire [15:0] o_sra = s_r1 >>> i_insn[3:0];

      assign o_result = (is_and == 1'b1) ? (i_r1data & i_r2data) :
      (is_not == 1'b1) ? (~i_r1data) :
      (is_or == 1'b1) ? (i_r1data | i_r2data) : 
      (is_xor == 1'b1) ? (i_r1data ^ i_r2data) :
      (is_andi == 1'b1) ? (i_r1data & sximm5) :
      (is_const == 1'b1) ? (sximm9) :
      (is_sll == 1'b1) ? (i_r1data << i_insn[3:0]) :
      (is_sra == 1'b1) ? (o_sra) :
      (is_srl == 1'b1) ? (i_r1data >> i_insn[3:0]) :
      (is_mul == 1'b1) ? (i_r1data * i_r2data) :
      (is_trap == 1'b1) ? (16'h8000 | i_insn[7:0]) :
      ((is_add == 1'b1) || (is_sub == 1'b1) ||
      (is_addi == 1'b1) || (is_brp == 1'b1) || 
      (is_brz == 1'b1) || (is_brzp == 1'b1) || 
      (is_brn == 1'b1) || (is_brnp == 1'b1) ||
      (is_brnz == 1'b1) || (is_brnzp == 1'b1) ||
      (is_nop == 1'b1) || (is_ldr == 1'b1) 
      || (is_str == 1'b1) || (is_jmp == 1'b1)) ? (cla_out) :
      (is_const == 1'b1) ? (sximm9) :
      (is_hiconst == 1'b1) ? (hiconst_temp1 | hiconst_temp2) :
      (is_cmp == 1'b1) ? (($signed(i_r1data) > $signed(i_r2data)) ? 1 : 
      ($signed(i_r1data) == $signed(i_r2data)) ? 0 : -1) :
      (is_cmpu == 1'b1) ? ((i_r1data > i_r2data) ? 1 : 
      (i_r1data == i_r2data) ? 0 : -1) :
      (is_cmpi == 1'b1) ? (($signed(i_r1data) > $signed(i_insn[6:0])) ? 1 : 
      ($signed(i_r1data) == $signed(i_insn[6:0])) ? 0 : -1) :
      (is_cmpiu == 1'b1) ? ((i_r1data > i_insn[6:0]) ? 1 : 
      (i_r1data == i_insn[6:0]) ? 0 : -1) :
      ((is_jsrr == 1'b1) || (is_rti == 1'b1) || (is_jmpr == 1'b1)) ? (i_r1data) :
      (is_div == 1'b1) ? (div_out) :
      (is_mod == 1'b1) ? (rem_out) :
      (is_jsr == 1'b1) ? (jsr_temp1 | jsr_temp2) :
      16'b0;
      
endmodule
