module algo(
    input logic clk,
    input logic rst,
    input logic encrypt,
    input logic decrypt,
    input logic [127:0] key,
    input logic [31:0] d_in,
    output logic [31:0] d_out
);

logic [4:0] top_level_curr_state, top_level_next_state;

logic encrypt_done;
logic decrypt_done;

parameter IDLE = 5'b00000;
parameter ENCRYPT_START_round_1 = 5'b10000;
parameter ENCRYPT_round_2 = 5'b10001;
parameter ENCRYPT_round_3 = 5'b10010;
parameter ENCRYPT_round_4 = 5'b10011;
parameter ENCRYPT_round_5 = 5'b10100;
parameter ENCRYPT_round_6 = 5'b10101;
parameter ENCRYPT_round_7 = 5'b10110;
parameter ENCRYPT_round_8 = 5'b10111;
parameter ENCRYPT_round_9 = 5'b11000;
parameter ENCRYPT_round_10 = 5'b11001;
parameter ENCRYPT_round_11 = 5'b11010;
parameter ENCRYPT_round_12 = 5'b11011;
parameter ENCRYPT_round_13 = 5'b11100;
parameter ENCRYPT_round_14 = 5'b11101;
parameter ENCRYPT_round_15 = 5'b11110;
parameter ENCRYPT_round_16 = 5'b11111;

parameter DECRYPT_START_round_1 = 5'b00001;
parameter DECRYPT_round_2 = 5'b00010;
parameter DECRYPT_round_3 = 5'b00011;
parameter DECRYPT_round_4 = 5'b00100;
parameter DECRYPT_round_5 = 5'b00101;
parameter DECRYPT_round_6 = 5'b00110;
parameter DECRYPT_round_7 = 5'b00111;
parameter DECRYPT_round_8 = 5'b01000;
parameter DECRYPT_round_9 = 5'b01001;
parameter DECRYPT_round_10 = 5'b01010;
parameter DECRYPT_round_11 = 5'b01011;
parameter DECRYPT_round_12 = 5'b01100;
parameter DECRYPT_round_13 = 5'b01101;
parameter DECRYPT_round_14 = 5'b01110;
parameter DECRYPT_round_15 = 5'b01111;
parameter DECRYPT_round_16 = 5'b11111;



parameter DECRYPT_TOP_LEVEL = 5'b00001;



//STATE TRANSITION
always_ff @ (posedge clk) begin
    if(~rst)
        top_level_curr_state <= IDLE;
    else
        top_level curr_state <= top_level_next_state;
end

//COMBO LOGIC
always_comb begin 

    case({encrypt,decrypt})

        IDLE_TOP_LEVEL: begin
            if(rst == 0) begin
                d_out = 0;
            end

        end

        ENCRYPT_START_round_1: begin

        end


        DECRYPT_START_round_1: begin

        
        end

        UNDEFINED_TOP_LEVEL: begin

        
        end



    endcase    
    
end



endmodule