`define W_size 16 // word size (PARAMETER)
`define K_size 128 // Key size (PARAMETER)
`define U 2 // W_size/2
`define T 34 // 2*(number of rounds + 1)
`define B 16 // key size in bytes
`define C 8 // c=b/u=16/2=8
`define P 0xb7e1
`define Q 0x9e37

module keygen
(
    input logic start,
    input logic clk,
    input logic rst,
    input logic[`K_size-1:0] key,
    output logic[`W_size-1:0] sub [T],
    output logic ready
);
logic [`W_size-1:0] S [T];
logic [`W_size-1:0] L [C];

// States
logic [2:0] state, next_state;
logic [5:0] s_counter, l_counter; // Keep track of where we are in the L and S gen loops

parameter IDLE = 3'b000;
parameter GEN_STAGE = 3'b001;
parameter L_DONE = 3'b010;
parameter S_DONE = 3'b011;
parameter MIX_STAGE  = 3'b100;

// top level logic
always_ff @(posedge clk) begin
    if(rst) begin
        s_counter <= 0;
        l_counter <= 0;
    end
    else begin
    end
end

//state machine
always_comb begin
    case(state)
        IDLE: begin
            
        end
        GEN_STAGE: begin
            
        end
        L_DONE: begin

        end
        S_DONE: begin

        end
        MIX_STAGE: begin

        end
    endcase
end


endmodule : keygen
