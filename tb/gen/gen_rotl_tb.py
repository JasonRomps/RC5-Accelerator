from random import choice, randint

prefix = """
`timescale 1ns / 1ps
module rotl_tb;

logic clk;
logic [15:0] data, shifted, n_shifts;

rotl ROTL(
    .data_i(data),
    .n_i(n_shifts),
    .data_o(shifted)
);

task test_shift(input logic [15:0] test_data, input logic [15:0] n, input logic [15:0] correct);
    data <= test_data;
    n_shifts <= n;
    #2;

    assert(shifted == correct)
        else begin
            $error("Bad Shift: 0x%x << 0x%x: 0x%x, Needed: 0x%x", data, n_shifts, shifted, correct);
            $finish;
        end
endtask


always begin
    clk = 1'b0;
    #1;
    clk = 1'b1;
    #1;
end


initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");
    data = 16'b0;

    #2;
"""

suffix = """
    $display("SUCCESS :: FINISH CALLED FROM END OF FILE!");
    $finish;

end


endmodule
"""

def leftrotate(s, d):
    n = d % 16
    tmp = s[n : ] + s[0 : n]
    return tmp

bits = ["0", "1"]
stimuli = ["".join([choice(bits) for _ in range(16)]) for _ in range(1000)]

if __name__ == "__main__":

    print(prefix)

    for stim in stimuli:
        n_s = randint(0, (2**16)-1)
        print(f"\ttest_shift(16'b{stim}, 16'd{n_s}, 16'b{leftrotate(stim, n_s)});")

    print(suffix)