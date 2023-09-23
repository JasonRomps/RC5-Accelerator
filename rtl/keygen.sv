`define W_size 16 // word size (PARAMETER)
`define K_size 128 // Key size (PARAMETER)
`define U 2 // W_size/2
`define T 26 // 2*(number of rounds + 1)
`define B 16 // key size in bytes
`define C 8 // c=b/u=16/2=8
`define P 16'hb7e1
`define Q 16'h9e37

module keygen
(
    input logic start,
    input logic clk,
    input logic rst,
    input logic [4:0] num_rounds,
    input logic [128:0] key,
    output logic [`W_size-1:0] sub [0:`T-1],
    output logic ready
);
logic [`W_size-1:0] S [0:`T-1];
logic [`W_size-1:0] L [0:`C-1];

logic [7:0] key_form [0:`B-1];
assign key_form = {key[7:0],key[15:8],key[23:16],key[31:24],key[39:32],key[47:40],key[55:48],key[63:56],key[71:64],key[79:72],key[87:80],key[95:88],key[103:96],key[111:104],key[119:112],key[127:120]};

// States
logic [2:0] state, next_state;
logic [6:0] l_over_counter;
logic [5:0] s_counter, l_counter; // Keep track of where we are in the L and S gen loops
logic [6:0] T;

assign T = (num_rounds + 1) << 2;

assign l_counter = l_over_counter[6:1];

parameter IDLE = 3'b000;
parameter L_GEN_STATE = 3'b001;
parameter S_GEN_STATE = 3'b010;
parameter MIX_STAGE  = 3'b011;
parameter DONE = 3'100;

assign sub = S;

// top level logic
always_ff @(posedge clk) begin
    if(rst) begin
        s_counter <= 0;
        l_over_counter <= 6'b001111;
        state <= IDLE;

        // Reset L array to 0 on rst
        for(int i = 0; i < `C; i++) begin
            L[i] <= 0;
        end
        for(int i = 0; i < `T; i++) begin
            S[i] <= 0;
        end
    end
    else begin
        case(state)
            L_GEN_STATE: begin
                L[l_counter] <= (L[l_counter] << 8) + key_form[l_over_counter];
                l_over_counter--;
            end
            S_GEN_STATE: begin
                if(s_counter == 0) begin
                    S[0] <= `P;
                end else begin
                    S[s_counter] <= S[s_counter-1] + `Q;
                end
                s_counter++;
            end
        endcase
        state <= next_state;
    end
end

//state machine
always_comb begin
    ready = 0;
    case(state)
        IDLE: begin
            next_state = (start == 1) ? L_GEN_STATE : IDLE;
        end
        L_GEN_STATE: begin
            next_state = (l_over_counter == 0) ? S_GEN_STATE : L_GEN_STATE;
        end
        S_GEN_STATE: begin
            next_state = (s_counter == T)  ? MIX_STAGE : S_GEN_STATE;
        end
        MIX_STAGE: begin
            
        end
        DONE: begin
            ready = 1;
            next_state = IDLE;
        end
    endcase
end


endmodule : keygen