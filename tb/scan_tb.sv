`timescale 1ns / 1ps
module scan_tb;

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
logic scan_en;
logic scan_in;
logic begin_validate;
logic scan_out;

logic [31:0] temp_data;

logic [167:0] scan_in_data;
logic [32:0] scan_out_data;


rc5 RC5(
    .rst(rst),
    .clk(clk),

    .num_rounds(num_rounds),
    .key(key),

    .load_key(load_key),
    .key_ready(key_ready),

    .start_encrypt(start_encrypt),
    .start_decrypt(start_decrypt),

    .d_in(d_in),
    .d_out(d_out),
    .done(done),

    //validation signals
    .scan_en(scan_en),
    .scan_in(scan_in),
    .begin_validate(begin_validate),
    .scan_out(scan_out)
    );

default clocking ckb @(posedge clk);
    input d_out, done, key_ready, scan_out;
    output rst, num_rounds, start_decrypt, start_encrypt, load_key, key, d_in, scan_en, scan_in, begin_validate;
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


task set_scan_in_key(); //use inputs for each value in future
  //[127:0] key
  //[159:128] d_in
  //[164:160] num_rounds
  //[165] load_key
  //[166] start_encrypt
  //[167] start_decrypt

  scan_in_data[127:0] <= 128'h2B7E151628AED2A6ABF7158809CF4F3C; //hardcoded key value for now
  scan_in_data[159:128] <= 32'h0; //hardcoded data in for now
  scan_in_data[164:160] <= 5'b01111;
  scan_in_data[165] <= 1;
  scan_in_data[166] <= 0;
  scan_in_data[167] <= 0;
endtask

task set_scan_in_data(); //use inputs for each value in future
  //[127:0] key
  //[159:128] d_in
  //[164:160] num_rounds
  //[165] load_key
  //[166] start_encrypt
  //[167] start_decrypt

  scan_in_data[127:0] <= 128'h0; //hardcoded key value for now
  scan_in_data[159:128] <= 32'hD87FAB42; //hardcoded data in for now
  scan_in_data[164:160] <= 5'b01111;
  scan_in_data[165] <= 0;
  scan_in_data[166] <= 1;
  scan_in_data[167] <= 0;
endtask

task feed_scan_in_data();
    scan_en = 1;

    for(int i = 167; i >= 0; i--) begin
        scan_in = scan_in_data[i];
        ##1;
    end
    scan_en = 0;
endtask

task feed_scan_out_data();
    scan_en = 1;

    for(int i = 32; i >= 0; i--) begin
        scan_out_data[i] = scan_out;
        ##1;
    end
    scan_en = 0;
endtask

task set_scan_in_decrypt_data(); //use inputs for each value in future
  //[127:0] key
  //[159:128] d_in
  //[164:160] num_rounds
  //[165] load_key
  //[166] start_encrypt
  //[167] start_decrypt

  scan_in_data[127:0] <= 128'h0; //hardcoded key value for now
  scan_in_data[159:128] <= 32'hE460BA1B; //hardcoded data in for now
  scan_in_data[164:160] <= 5'b01111;
  scan_in_data[165] <= 0;
  scan_in_data[166] <= 0;
  scan_in_data[167] <= 1;
endtask

task set_defaults();
    rst <= '1;
    start_encrypt <= '0;
    start_decrypt <= '0;
    num_rounds <= 5'b01111;
    load_key <= '0;
    key <= '0;
    d_in <= '0;
    scan_en <= '0;
    scan_in <= '0;
    begin_validate <= '0;
endtask

initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");

    set_defaults();
    reset();

    ##1;

    set_scan_in_key();

    ##1;

    feed_scan_in_data();

    ##10;

    begin_validate = 1;

    ##100;

    begin_validate = 0;

    ##1;

    set_scan_in_data();

    ##1;

    feed_scan_in_data();

    ##10;

    begin_validate = 1;

    ##100;

    feed_scan_out_data();

    ##10;

    begin_validate = 0;

    ##100;   

    set_scan_in_decrypt_data();

    ##1;

    feed_scan_in_data();

    ##10 

    begin_validate = 1;

    ##100;

    feed_scan_out_data();

    ##10;

    begin_validate = 0;

    #50;

    $display("SUCCESS: TESTBENCH ENDED WITHOUT ERROR");
    $finish;

end


endmodule