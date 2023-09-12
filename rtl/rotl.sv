module rotl
#(
    W = 16
)
(
    input logic[W-1:0] data_i,   // Data to be rotated
    input logic[W-1:0] n_i,      // Number of times to rotate
    output logic[W-1:0] data_o   // Rotated output
);

logic[W-1:0] n
assign n = n_i % W;
assign data_o = (((data_i)<<(n)) | ((data_i)>>(W-n)));

endmodule : rotl
