import os
from random import choice
from tqdm import tqdm

prefix = """
`define W_size 16 // word size (PARAMETER)
`define K_size 128 // Key size (PARAMETER)
`define U 2 // W_size/2
`define T 26 // 2*(number of rounds + 1)
`define B 16 // key size in bytes
`define C 8 // c=b/u=16/2=8
`define P 16'hb7e1
`define Q 16'h9e37

// UNCOMMENT THIS DEFINE FOR ALL 10,000 TEST CASES!!!!
// `define FULL

`timescale 1ns / 1ps
module key_tb;

logic start;
logic clk;
logic rst;
logic [128:0] key;
logic [`W_size-1:0] sub [0:`T-1];
logic [4:0] num_rounds;
logic ready;

assign num_rounds = 12;

keygen Keygen(.*);

default clocking ckb @(posedge clk);
    input sub, ready;
    output rst, key, start;
endclocking

always begin
    clk = 1'b0;
    #1;
    clk = 1'b1;
    #1;
end

task reset();
    rst <= 1;
    ##1;
    rst <= 0;
    ##1;
endtask

task test_expansion(logic[`K_size-1:0] test_key, logic [`W_size-1:0] test_subkey [0:`T-1]);
    key <= test_key;

    ##1;

    reset();

    start <= 1;
    ##1;

    start <= 0;

    while(~ready) begin
        ##1;
    end

    for(int i = 0; i < `T; i++) begin
        assert(test_subkey[i] == sub[i])
            else begin
                $error("Bad Subkey Value: 0x%x at position %0d, should be 0x%x", sub[i], i, test_subkey[i]);
                $finish;
            end
    end
endtask

initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");
    key <= 0;
    rst <= 0;
    start <= 0;

    #2;

    reset();

    // Known Test Case
	test_expansion(128'hdeadbeefdeadbeefdeadbeefdeadbeef, {16'd55048, 16'd43744, 16'd48559, 16'd27403, 16'd20374, 16'd33387, 16'd2062, 16'd61013, 16'd49237, 16'd33709, 16'd16278, 16'd65452, 16'd9968, 16'd4572, 16'd34933, 16'd35205, 16'd37470, 16'd42119, 16'd21025, 16'd13567, 16'd19718, 16'd1446, 16'd11664, 16'd40137, 16'd19576, 16'd15720});

    // AUTO GENERATED TEST CASES
	`ifdef FULL
"""

suffix = """

	`endif

    $display("SUCCESS :: FINISH CALLED FROM END OF FILE!");
    $finish;

end


endmodule
"""

HEX_CHARS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]

def gen_subkey(key: str) -> list:
    assert len(key) == 32

    process = os.popen(f"./main subkey_show {key}")
    subkey_out = process.read()
    process.close()
    
    return subkey_out.rstrip().strip().split(" ")


def rand_hex(l: int) -> str:
    return "".join([choice(HEX_CHARS) for _ in range(l)])


if __name__ == "__main__":
    os.chdir("../software")

    # Ensure source is compiled
    process = os.popen("make")
    process.close()

    print(prefix)

    for _ in tqdm(range(10000)):
        key = rand_hex(32)
        subkeys = gen_subkey(key)
        subkeys_formatted = "{" + "".join([f"16'd{sk}{', ' if idx != len(subkeys)-1 else ''}" for idx, sk in enumerate(subkeys)]) + "}"
        print(f"\ttest_expansion(128'h{key}, {subkeys_formatted});")

    print(suffix)
