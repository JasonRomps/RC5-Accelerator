`define W_size 16 // word size (PARAMETER)
`define K_size 128 // Key size (PARAMETER)
`define U 2 // W_size/2
`define T 34 // 2*(number of rounds + 1)
`define B 16 // key size in bytes
`define C 16'd8 // c=b/u=16/2=8
`define C_INT 16
`define P 16'hb7e1
`define Q 16'h9e37

module keygen
(
    input logic start,
    input logic clk,
    input logic rst,
    input logic [4:0] num_rounds,
    input logic [127:0] key,
    output logic [`W_size-1:0] subkeys [0:`T-1],
    output logic ready
);
logic [`W_size-1:0] S [0:`T-1];
logic [`W_size-1:0] L [0:`C-1];

logic [7:0] key_form [0:`B-1];
assign key_form = '{key[127:120], key[119:112], key[111:104], key[103:96], key[95:88], key[87:80], key[79:72], key[71:64], key[63:56], key[55:48], key[47:40], key[39:32], key[31:24], key[23:16], key[15:8], key[7:0]};

// States
logic [2:0] state, next_state;
logic [6:0] l_over_counter, mix_counter;
logic [5:0] s_counter, l_counter; // Keep track of where we are in the L and S gen loops
logic [6:0] T;

assign T = (num_rounds + 7'b1) << 7'b1;

assign l_counter = l_over_counter[6:1];

logic [`W_size-1:0] i, j, i_new, j_new, A, B, A_new, B_new;

rotl A_Rotl(
    .data_i(S[i] + (A+B)),
    .n_i(16'd3),
    .data_o(A_new)
);

rotl B_Rotl(
    .data_i(L[j] + (A_new+B)),
    .n_i(A_new + B),
    .data_o(B_new)
);

parameter IDLE = 3'b000;
parameter INIT = 3'b101;
parameter L_GEN_STATE = 3'b001;
parameter S_GEN_STATE = 3'b010;
parameter MIX_STAGE  = 3'b011;
parameter DONE = 3'b100;

assign subkeys = S;

// top level logic
always_ff @(posedge clk) begin
    if(rst) begin
        s_counter <= 6'b0;
        l_over_counter <= 7'b0001111;
        mix_counter <= 7'b0;
        state <= IDLE;

        A <= 16'b0;
        B <= 16'b0;
        j <= 16'b0;
        i <= 16'b0;

        // Reset L array to 0 on rst
        for(int i = 0; i < `C; i++) begin
            L[i] <= 16'b0;
        end
        for(int i = 0; i < `T; i++) begin
            S[i] <= 16'b0;
        end
    end
    else begin
        case(state)
            INIT: begin
                s_counter <= 6'b0;
                l_over_counter <= 7'b0001111;
                mix_counter <= 7'b0;
                A <= 16'b0;
                B <= 16'b0;
                j <= 16'b0;
                i <= 16'b0;
                for(int i = 0; i < `C; i++) begin
                    L[i] <= 16'b0;
                end
                for(int i = 0; i < `T; i++) begin
                    S[i] <= 16'b0;
                end
            end
            L_GEN_STATE: begin
                L[l_counter] <= (L[l_counter] << 8) + key_form[l_over_counter];
                l_over_counter<=l_over_counter-7'b1;
            end
            S_GEN_STATE: begin
                if(s_counter == 0) begin
                    S[0] <= `P;
                end else begin
                    S[s_counter] <= S[s_counter-1] + `Q;
                end
                s_counter<=s_counter+6'b1;
            end
            MIX_STAGE: begin
                // Preform Array Updates Here
                mix_counter <= mix_counter + 7'b1;
                S[i] <= A_new;
                L[j] <= B_new;
                A <= A_new;
                B <= B_new;
                i <= i_new;
                j <= j_new;
            end
        endcase
        state <= next_state;
    end
end

//state machine
always_comb begin
    ready = 1'b0;
    j_new = 16'b0;
    i_new = 16'b0;

    next_state = IDLE;

    case(state)
        IDLE: begin
            next_state = (start == 1) ? INIT : IDLE;
            ready = 1'b0;
        end
        INIT: begin
            next_state = L_GEN_STATE;
        end
        L_GEN_STATE: begin
            next_state = (l_over_counter == 0) ? S_GEN_STATE : L_GEN_STATE;
        end
        S_GEN_STATE: begin
            next_state = (s_counter == T[5:0])  ? MIX_STAGE : S_GEN_STATE;
        end
        MIX_STAGE: begin
            next_state = (mix_counter == ((7'd3*T)-7'b1)) ? DONE : MIX_STAGE;
            i_new = (i+16'b1) % T;
            j_new = (j+16'b1) % `C;
        end
        DONE: begin
            ready = 1'b1;
            next_state = (start == 1) ? DONE : IDLE;
        end
    endcase
end


endmodule : keygen
