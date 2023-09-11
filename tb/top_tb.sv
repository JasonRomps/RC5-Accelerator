module top_tb;


logic clk;
logic rst;
logic encrypt;
logic decrypt;
logic [4:0] num_rounds;   //when the user specifies num_rounds it is not 0 indexed
logic [127:0] key;
logic [31:0] d_in;
logic [31:0] d_out;
logic done;


algo algo(
    .clk(clk),
    .rst(rst),
    .encrypt(encrypt),
    .decrypt(decrypt),
    .num_rounds(num_rounds),
    .key(key),
    .d_in(d_in),
    .d_out(d_out),
    .done(done)
);


always begin
    clk = 0;
    #1;
    clk = 1;
    #1;
end


initial begin
    rst = 1;
    encrypt = 0;
    decrypt = 0;
    num_rounds = 0;
    key = 0;
    d_in = 0;
    d_out = 0;
    done = 0;

    #10;

    rst = 0;

    #10;

    rst = 1;

    #10;

    $finish;

end


endmodule