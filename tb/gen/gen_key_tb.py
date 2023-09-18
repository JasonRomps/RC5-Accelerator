import os
from random import choice

prefix = """
`define K_size 128 // Key size (PARAMETER)
`define W_size 16 // word size (PARAMETER)
`define T 26 // 2*(number of rounds + 1)

`timescale 1ns / 1ps
module key_tb;

logic start;
logic clk;
logic rst;
logic[`K_size-1:0] key;
logic[`W_size-1:0] sub [`T];
logic ready;

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

task test_expansion(logic[`K_size-1:0] test_key, logic [`W_size-1:0] test_subkey [`T]);
    key <= test_key;
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
"""

suffix = """
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

    for _ in range(10000):
        key = rand_hex(32)
        subkeys = gen_subkey(key)
        subkeys_formatted = "{" + "".join([f"16'd{sk}{', ' if idx != len(subkeys)-1 else ''}" for idx, sk in enumerate(subkeys)]) + "}"
        print(f"\ttest_expansion(128'h{key}, {subkeys_formatted});")

    print(suffix)
