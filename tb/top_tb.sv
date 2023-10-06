`timescale 1ns / 1ps
module top_tb;


logic rst;
logic clk;
logic [4:0] num_rounds;
logic [127:0] key;
logic load_key;
logic key_ready;
logic start_encrypt;
logic start_decrypt;
logic [31:0] d_in;
logic [31:0] d_out;
logic done;

logic [31:0] temp_data;


rc5 RC5(.*);

default clocking ckb @(posedge clk);
    input d_out, done, key_ready;
    output rst, num_rounds, start_decrypt, start_encrypt, load_key, key, d_in;
endclocking


always begin
    clk <= 0;
    #1;
    clk <= 1;
    #1;
end

task reset();
    rst <= 1;
    ##5;
    rst <= 0;
    ##5;
endtask

task set_defaults();
    rst <= '1;
    start_encrypt <= '0;
    start_decrypt <= '0;
    num_rounds <= 12;
    load_key <= '0;
    key <= '0;
    d_in <= '0;
endtask

task load_new_key(input logic [127:0] key_new);
    key <= key_new;
    load_key <= 1'b1;
    ##1;
    load_key <= 1'b0;
    while(~key_ready) ##1;
endtask

task test_enc_dec(input logic [31:0] data);
    d_in <= data;
    start_encrypt <= '1;
    ##1;
    start_encrypt <= '0;
    while(~done) ##1;
    temp_data <= d_out;
    ##1;
    d_in <= temp_data;
    start_decrypt <= '1;
    ##1;
    start_decrypt <= '0;
    while(~done) ##1;

    assert (d_out == data) 
        else begin
            $error("Encryption/Decryption Failed: data in (0x%x) != data out (0x%x)", data, d_out);
            $finish;
        end

    ##1;
endtask

// function check_encryption(input logic [31:0] data_i);
// endfunction

class RandData;
    rand bit [31:0] data;
endclass : RandData

RandData rand_data = new; 
logic [31:0] r_data;

initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");

    set_defaults();
    reset();

    // Ensure encrypt state machine works
    load_new_key(128'hdeadbeefdeadbeefdeadbeefdeadbeef);
    for(int i = 8; i < 100000; i++) begin
        rand_data.randomize();
        r_data = rand_data.data;
        test_enc_dec(r_data);
    end
    

    $display("SUCCESS: TESTBENCH ENDED WITHOUT ERROR");
    $finish;

end


endmodule