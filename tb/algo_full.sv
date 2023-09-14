`timescale 1ns / 1ps

`define MULTI_ROUND

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

logic [31:0] temp_data;


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

task reset();
    rst <= 0;
    ##1;
    rst <= 1;
    ##1;
endtask

task set_defaults();
    rst <= 1;
    encrypt <= 0;
    decrypt <= 0;
    num_rounds <= 12;
    key <= 0;
    d_in <= 0;
endtask

task do_encrypt(input logic [31:0] data_i);
    d_in <= data_i;
    encrypt <= 1'b1;
    ##1;
    encrypt <= 1'b0;
    while(done != 1'b1) begin
        ##1;
    end
    temp_data <= d_out;
    ##1;
endtask

task do_decrypt(input logic [31:0] data_i); 
    d_in <= data_i;
    decrypt <= 1'b1;
    ##1;
    decrypt <= 1'b0;
    while(done != 1'b1) begin
        ##1;
    end
    temp_data <= d_out;
    ##1;
endtask

function check_encryption(input logic [31:0] data_i);
    assert (data_i == temp_data) 
        else begin
            $error("Encryption/Decryption Failed: data in (0x%x) != data out (0x%x)", data_i, temp_data);
            $finish;
        end
endfunction

initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");

    set_defaults();
    reset();

    `ifdef MULTI_ROUND
    for(int j = 1; j < 16; j++) begin
    num_rounds <= j[4:0];
    ##1;
    `endif
    for(int i = 0; i < 1000; i++) begin
        do_encrypt(i[31:0]*3413);
        do_decrypt(temp_data);
        check_encryption(i[31:0]*3413);
    end
    `ifdef MULTI_ROUND
    end
    `endif

    $display("SUCCESS: TESTBENCH ENDED WITHOUT ERROR");
    $finish;

end


endmodule