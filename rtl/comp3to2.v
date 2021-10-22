// Title: 3 to 2 Compressor 1.0 (No Changelog)
// Created: Septmeber 11, 2021
// Updated: 
//---------------------------------------------------------------------------
// This is a Verilog file that define a 3 to 2 Compression for 106-bit inputs
// 
//
//---------------------------------------------------------------------------
module comp3to2 (
    input   [105:0] in_a,
    input   [105:0] in_b,
    input   [105:0] in_c,
    output  [105:0] sum,
    output  [105:0] carry
);
    // 3 to 2 Reduction
    fullAdder fa1 (.a(in_a[0]), .b(in_b[0]), .c_in(in_c[0]), .s(sum[0]), .c_out(carry[0]));
    fullAdder fa2 (.a(in_a[1]), .b(in_b[1]), .c_in(in_c[1]), .s(sum[1]), .c_out(carry[1]));
    fullAdder fa3 (.a(in_a[2]), .b(in_b[2]), .c_in(in_c[2]), .s(sum[2]), .c_out(carry[2]));
    fullAdder fa4 (.a(in_a[3]), .b(in_b[3]), .c_in(in_c[3]), .s(sum[3]), .c_out(carry[3]));
    fullAdder fa5 (.a(in_a[4]), .b(in_b[4]), .c_in(in_c[4]), .s(sum[4]), .c_out(carry[4]));
    fullAdder fa6 (.a(in_a[5]), .b(in_b[5]), .c_in(in_c[5]), .s(sum[5]), .c_out(carry[5]));
    fullAdder fa7 (.a(in_a[6]), .b(in_b[6]), .c_in(in_c[6]), .s(sum[6]), .c_out(carry[6]));
    fullAdder fa8 (.a(in_a[7]), .b(in_b[7]), .c_in(in_c[7]), .s(sum[7]), .c_out(carry[7]));
    fullAdder fa9 (.a(in_a[8]), .b(in_b[8]), .c_in(in_c[8]), .s(sum[8]), .c_out(carry[8]));
    fullAdder fa10 (.a(in_a[9]), .b(in_b[9]), .c_in(in_c[9]), .s(sum[9]), .c_out(carry[9]));
    fullAdder fa11 (.a(in_a[10]), .b(in_b[10]), .c_in(in_c[10]), .s(sum[10]), .c_out(carry[10]));
    fullAdder fa12 (.a(in_a[11]), .b(in_b[11]), .c_in(in_c[11]), .s(sum[11]), .c_out(carry[11]));
    fullAdder fa13 (.a(in_a[12]), .b(in_b[12]), .c_in(in_c[12]), .s(sum[12]), .c_out(carry[12]));
    fullAdder fa14 (.a(in_a[13]), .b(in_b[13]), .c_in(in_c[13]), .s(sum[13]), .c_out(carry[13]));
    fullAdder fa15 (.a(in_a[14]), .b(in_b[14]), .c_in(in_c[14]), .s(sum[14]), .c_out(carry[14]));
    fullAdder fa16 (.a(in_a[15]), .b(in_b[15]), .c_in(in_c[15]), .s(sum[15]), .c_out(carry[15]));
    fullAdder fa17 (.a(in_a[16]), .b(in_b[16]), .c_in(in_c[16]), .s(sum[16]), .c_out(carry[16]));
    fullAdder fa18 (.a(in_a[17]), .b(in_b[17]), .c_in(in_c[17]), .s(sum[17]), .c_out(carry[17]));
    fullAdder fa19 (.a(in_a[18]), .b(in_b[18]), .c_in(in_c[18]), .s(sum[18]), .c_out(carry[18]));
    fullAdder fa20 (.a(in_a[19]), .b(in_b[19]), .c_in(in_c[19]), .s(sum[19]), .c_out(carry[19]));
    fullAdder fa21 (.a(in_a[20]), .b(in_b[20]), .c_in(in_c[20]), .s(sum[20]), .c_out(carry[20]));
    fullAdder fa22 (.a(in_a[21]), .b(in_b[21]), .c_in(in_c[21]), .s(sum[21]), .c_out(carry[21]));
    fullAdder fa23 (.a(in_a[22]), .b(in_b[22]), .c_in(in_c[22]), .s(sum[22]), .c_out(carry[22]));
    fullAdder fa24 (.a(in_a[23]), .b(in_b[23]), .c_in(in_c[23]), .s(sum[23]), .c_out(carry[23]));
    fullAdder fa25 (.a(in_a[24]), .b(in_b[24]), .c_in(in_c[24]), .s(sum[24]), .c_out(carry[24]));
    fullAdder fa26 (.a(in_a[25]), .b(in_b[25]), .c_in(in_c[25]), .s(sum[25]), .c_out(carry[25]));
    fullAdder fa27 (.a(in_a[26]), .b(in_b[26]), .c_in(in_c[26]), .s(sum[26]), .c_out(carry[26]));
    fullAdder fa28 (.a(in_a[27]), .b(in_b[27]), .c_in(in_c[27]), .s(sum[27]), .c_out(carry[27]));
    fullAdder fa29 (.a(in_a[28]), .b(in_b[28]), .c_in(in_c[28]), .s(sum[28]), .c_out(carry[28]));
    fullAdder fa30 (.a(in_a[29]), .b(in_b[29]), .c_in(in_c[29]), .s(sum[29]), .c_out(carry[29]));
    fullAdder fa31 (.a(in_a[30]), .b(in_b[30]), .c_in(in_c[30]), .s(sum[30]), .c_out(carry[30]));
    fullAdder fa32 (.a(in_a[31]), .b(in_b[31]), .c_in(in_c[31]), .s(sum[31]), .c_out(carry[31]));
    fullAdder fa33 (.a(in_a[32]), .b(in_b[32]), .c_in(in_c[32]), .s(sum[32]), .c_out(carry[32]));
    fullAdder fa34 (.a(in_a[33]), .b(in_b[33]), .c_in(in_c[33]), .s(sum[33]), .c_out(carry[33]));
    fullAdder fa35 (.a(in_a[34]), .b(in_b[34]), .c_in(in_c[34]), .s(sum[34]), .c_out(carry[34]));
    fullAdder fa36 (.a(in_a[35]), .b(in_b[35]), .c_in(in_c[35]), .s(sum[35]), .c_out(carry[35]));
    fullAdder fa37 (.a(in_a[36]), .b(in_b[36]), .c_in(in_c[36]), .s(sum[36]), .c_out(carry[36]));
    fullAdder fa38 (.a(in_a[37]), .b(in_b[37]), .c_in(in_c[37]), .s(sum[37]), .c_out(carry[37]));
    fullAdder fa39 (.a(in_a[38]), .b(in_b[38]), .c_in(in_c[38]), .s(sum[38]), .c_out(carry[38]));
    fullAdder fa40 (.a(in_a[39]), .b(in_b[39]), .c_in(in_c[39]), .s(sum[39]), .c_out(carry[39]));
    fullAdder fa41 (.a(in_a[40]), .b(in_b[40]), .c_in(in_c[40]), .s(sum[40]), .c_out(carry[40]));
    fullAdder fa42 (.a(in_a[41]), .b(in_b[41]), .c_in(in_c[41]), .s(sum[41]), .c_out(carry[41]));
    fullAdder fa43 (.a(in_a[42]), .b(in_b[42]), .c_in(in_c[42]), .s(sum[42]), .c_out(carry[42]));
    fullAdder fa44 (.a(in_a[43]), .b(in_b[43]), .c_in(in_c[43]), .s(sum[43]), .c_out(carry[43]));
    fullAdder fa45 (.a(in_a[44]), .b(in_b[44]), .c_in(in_c[44]), .s(sum[44]), .c_out(carry[44]));
    fullAdder fa46 (.a(in_a[45]), .b(in_b[45]), .c_in(in_c[45]), .s(sum[45]), .c_out(carry[45]));
    fullAdder fa47 (.a(in_a[46]), .b(in_b[46]), .c_in(in_c[46]), .s(sum[46]), .c_out(carry[46]));
    fullAdder fa48 (.a(in_a[47]), .b(in_b[47]), .c_in(in_c[47]), .s(sum[47]), .c_out(carry[47]));
    fullAdder fa49 (.a(in_a[48]), .b(in_b[48]), .c_in(in_c[48]), .s(sum[48]), .c_out(carry[48]));
    fullAdder fa50 (.a(in_a[49]), .b(in_b[49]), .c_in(in_c[49]), .s(sum[49]), .c_out(carry[49]));
    fullAdder fa51 (.a(in_a[50]), .b(in_b[50]), .c_in(in_c[50]), .s(sum[50]), .c_out(carry[50]));
    fullAdder fa52 (.a(in_a[51]), .b(in_b[51]), .c_in(in_c[51]), .s(sum[51]), .c_out(carry[51]));
    fullAdder fa53 (.a(in_a[52]), .b(in_b[52]), .c_in(in_c[52]), .s(sum[52]), .c_out(carry[52]));
    fullAdder fa54 (.a(in_a[53]), .b(in_b[53]), .c_in(in_c[53]), .s(sum[53]), .c_out(carry[53]));
    fullAdder fa55 (.a(in_a[54]), .b(in_b[54]), .c_in(in_c[54]), .s(sum[54]), .c_out(carry[54]));
    fullAdder fa56 (.a(in_a[55]), .b(in_b[55]), .c_in(in_c[55]), .s(sum[55]), .c_out(carry[55]));
    fullAdder fa57 (.a(in_a[56]), .b(in_b[56]), .c_in(in_c[56]), .s(sum[56]), .c_out(carry[56]));
    fullAdder fa58 (.a(in_a[57]), .b(in_b[57]), .c_in(in_c[57]), .s(sum[57]), .c_out(carry[57]));
    fullAdder fa59 (.a(in_a[58]), .b(in_b[58]), .c_in(in_c[58]), .s(sum[58]), .c_out(carry[58]));
    fullAdder fa60 (.a(in_a[59]), .b(in_b[59]), .c_in(in_c[59]), .s(sum[59]), .c_out(carry[59]));
    fullAdder fa61 (.a(in_a[60]), .b(in_b[60]), .c_in(in_c[60]), .s(sum[60]), .c_out(carry[60]));
    fullAdder fa62 (.a(in_a[61]), .b(in_b[61]), .c_in(in_c[61]), .s(sum[61]), .c_out(carry[61]));
    fullAdder fa63 (.a(in_a[62]), .b(in_b[62]), .c_in(in_c[62]), .s(sum[62]), .c_out(carry[62]));
    fullAdder fa64 (.a(in_a[63]), .b(in_b[63]), .c_in(in_c[63]), .s(sum[63]), .c_out(carry[63]));
    fullAdder fa65 (.a(in_a[64]), .b(in_b[64]), .c_in(in_c[64]), .s(sum[64]), .c_out(carry[64]));
    fullAdder fa66 (.a(in_a[65]), .b(in_b[65]), .c_in(in_c[65]), .s(sum[65]), .c_out(carry[65]));
    fullAdder fa67 (.a(in_a[66]), .b(in_b[66]), .c_in(in_c[66]), .s(sum[66]), .c_out(carry[66]));
    fullAdder fa68 (.a(in_a[67]), .b(in_b[67]), .c_in(in_c[67]), .s(sum[67]), .c_out(carry[67]));
    fullAdder fa69 (.a(in_a[68]), .b(in_b[68]), .c_in(in_c[68]), .s(sum[68]), .c_out(carry[68]));
    fullAdder fa70 (.a(in_a[69]), .b(in_b[69]), .c_in(in_c[69]), .s(sum[69]), .c_out(carry[69]));
    fullAdder fa71 (.a(in_a[70]), .b(in_b[70]), .c_in(in_c[70]), .s(sum[70]), .c_out(carry[70]));
    fullAdder fa72 (.a(in_a[71]), .b(in_b[71]), .c_in(in_c[71]), .s(sum[71]), .c_out(carry[71]));
    fullAdder fa73 (.a(in_a[72]), .b(in_b[72]), .c_in(in_c[72]), .s(sum[72]), .c_out(carry[72]));
    fullAdder fa74 (.a(in_a[73]), .b(in_b[73]), .c_in(in_c[73]), .s(sum[73]), .c_out(carry[73]));
    fullAdder fa75 (.a(in_a[74]), .b(in_b[74]), .c_in(in_c[74]), .s(sum[74]), .c_out(carry[74]));
    fullAdder fa76 (.a(in_a[75]), .b(in_b[75]), .c_in(in_c[75]), .s(sum[75]), .c_out(carry[75]));
    fullAdder fa77 (.a(in_a[76]), .b(in_b[76]), .c_in(in_c[76]), .s(sum[76]), .c_out(carry[76]));
    fullAdder fa78 (.a(in_a[77]), .b(in_b[77]), .c_in(in_c[77]), .s(sum[77]), .c_out(carry[77]));
    fullAdder fa79 (.a(in_a[78]), .b(in_b[78]), .c_in(in_c[78]), .s(sum[78]), .c_out(carry[78]));
    fullAdder fa80 (.a(in_a[79]), .b(in_b[79]), .c_in(in_c[79]), .s(sum[79]), .c_out(carry[79]));
    fullAdder fa81 (.a(in_a[80]), .b(in_b[80]), .c_in(in_c[80]), .s(sum[80]), .c_out(carry[80]));
    fullAdder fa82 (.a(in_a[81]), .b(in_b[81]), .c_in(in_c[81]), .s(sum[81]), .c_out(carry[81]));
    fullAdder fa83 (.a(in_a[82]), .b(in_b[82]), .c_in(in_c[82]), .s(sum[82]), .c_out(carry[82]));
    fullAdder fa84 (.a(in_a[83]), .b(in_b[83]), .c_in(in_c[83]), .s(sum[83]), .c_out(carry[83]));
    fullAdder fa85 (.a(in_a[84]), .b(in_b[84]), .c_in(in_c[84]), .s(sum[84]), .c_out(carry[84]));
    fullAdder fa86 (.a(in_a[85]), .b(in_b[85]), .c_in(in_c[85]), .s(sum[85]), .c_out(carry[85]));
    fullAdder fa87 (.a(in_a[86]), .b(in_b[86]), .c_in(in_c[86]), .s(sum[86]), .c_out(carry[86]));
    fullAdder fa88 (.a(in_a[87]), .b(in_b[87]), .c_in(in_c[87]), .s(sum[87]), .c_out(carry[87]));
    fullAdder fa89 (.a(in_a[88]), .b(in_b[88]), .c_in(in_c[88]), .s(sum[88]), .c_out(carry[88]));
    fullAdder fa90 (.a(in_a[89]), .b(in_b[89]), .c_in(in_c[89]), .s(sum[89]), .c_out(carry[89]));
    fullAdder fa91 (.a(in_a[90]), .b(in_b[90]), .c_in(in_c[90]), .s(sum[90]), .c_out(carry[90]));
    fullAdder fa92 (.a(in_a[91]), .b(in_b[91]), .c_in(in_c[91]), .s(sum[91]), .c_out(carry[91]));
    fullAdder fa93 (.a(in_a[92]), .b(in_b[92]), .c_in(in_c[92]), .s(sum[92]), .c_out(carry[92]));
    fullAdder fa94 (.a(in_a[93]), .b(in_b[93]), .c_in(in_c[93]), .s(sum[93]), .c_out(carry[93]));
    fullAdder fa95 (.a(in_a[94]), .b(in_b[94]), .c_in(in_c[94]), .s(sum[94]), .c_out(carry[94]));
    fullAdder fa96 (.a(in_a[95]), .b(in_b[95]), .c_in(in_c[95]), .s(sum[95]), .c_out(carry[95]));
    fullAdder fa97 (.a(in_a[96]), .b(in_b[96]), .c_in(in_c[96]), .s(sum[96]), .c_out(carry[96]));
    fullAdder fa98 (.a(in_a[97]), .b(in_b[97]), .c_in(in_c[97]), .s(sum[97]), .c_out(carry[97]));
    fullAdder fa99 (.a(in_a[98]), .b(in_b[98]), .c_in(in_c[98]), .s(sum[98]), .c_out(carry[98]));
    fullAdder fa100 (.a(in_a[99]), .b(in_b[99]), .c_in(in_c[99]), .s(sum[99]), .c_out(carry[99]));
    fullAdder fa101 (.a(in_a[100]), .b(in_b[100]), .c_in(in_c[100]), .s(sum[100]), .c_out(carry[100]));
    fullAdder fa102 (.a(in_a[101]), .b(in_b[101]), .c_in(in_c[101]), .s(sum[101]), .c_out(carry[101]));
    fullAdder fa103 (.a(in_a[102]), .b(in_b[102]), .c_in(in_c[102]), .s(sum[102]), .c_out(carry[102]));
    fullAdder fa104 (.a(in_a[103]), .b(in_b[103]), .c_in(in_c[103]), .s(sum[103]), .c_out(carry[103]));
    fullAdder fa105 (.a(in_a[104]), .b(in_b[104]), .c_in(in_c[104]), .s(sum[104]), .c_out(carry[104]));
    fullAdder fa106 (.a(in_a[105]), .b(in_b[105]), .c_in(in_c[105]), .s(sum[105]), .c_out(carry[105]));

endmodule