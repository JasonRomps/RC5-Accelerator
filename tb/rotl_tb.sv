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

    data = 16'b1000000000000001;
    n_shifts = 16'h0001;
    assert(shifted == 16'b00000000000000011)
        else begin
            $error("Bad Shift: 0x%x << 0x%x: 0x%x", data, n_shifts, shifted);
            $finish;
        end

    #2;

    $finish;

end


endmodule