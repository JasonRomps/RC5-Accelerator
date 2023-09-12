`define W 16

module rotl
(
    input logic[`W-1:0] data_i,   // Data to be rotated
    input logic[`W-1:0] n_i,      // Number of times to rotate
    output logic[`W-1:0] data_o   // Rotated output
);

assign data_o = ((data_i << n_i) | (data_i >> (`W-(n_i % 16'd16))));

endmodule : rotl
