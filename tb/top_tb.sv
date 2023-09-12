`timescale 1ns / 1ps
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


algo Algo(
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

default clocking ckb @(posedge clk);
    input d_out, done;
    output rst, encrypt, decrypt, num_rounds, key, d_in;
endclocking


always begin
    clk <= 0;
    #1;
    clk <= 1;
    #1;
end


initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");
    rst <= 1;
    encrypt <= 0;
    decrypt <= 0;
    num_rounds <= 16;
    key <= 0;
    d_in <= 0;

    ##1;

    rst <= 0;

    ##1;

    rst <= 1;

    ##1;

    encrypt <= 1'b1;
     
    ##1;

    while(done != 1'b1) begin
        $display("%b", Algo.algo_state);
        ##1;
    end

    $finish;

end


endmodule