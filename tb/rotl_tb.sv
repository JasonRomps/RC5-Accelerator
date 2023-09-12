`timescale 1ns / 1ps
module rotl_tb;

logic clk;
logic [15:0] data, shifted, n_shifts;

rotl ROTL(
    .data_i(data),
    .n_i(n_shifts),
    .data_o(shifted)
);


always begin
    clk = 0;
    #1;
    clk = 1;
    #1;
end


initial begin
    $fsdbDumpfile("dump.fsdb");
	$fsdbDumpvars(0, "+all");
    data = 0;

    ##1;

    data = 16'b0101010101010101;
    n_shifts = 16'h0001;
    assert(shifted == 16'b1010101010101010)
        else begin
            $error("Bad Shift: %0x << %0x: %0x", data, n_shifts, shifted);
            $finish;
        end

    ##1;

    $finish;

end


endmodule