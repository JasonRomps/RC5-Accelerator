module rc5(
    input logic rst,
    input logic clk,

    input logic [4:0] num_rounds,
    input logic [127:0] key,

    input logic load_key,
    output logic key_ready,

    input logic start_encrypt,
    input logic start_decrypt,

    input logic [31:0] d_in,
    output logic [31:0] d_out,
    output logic done
);


logic [15:0] subkeys [0:33];

keygen Keygen(
    .start(load_key),
    .clk(clk),
    .rst(rst),
    .num_rounds(num_rounds),
    .key(key),
    .subkeys(subkeys),
    .ready(key_ready)
);

algo Algo(
    .clk(clk),
    .rst(rst),
    .encrypt(start_encrypt),
    .decrypt(start_decrypt),
    .num_rounds(num_rounds),
    .subkeys(subkeys),
    .d_in(d_in),
    .d_out(d_out),
    .done(done)
);

endmodule