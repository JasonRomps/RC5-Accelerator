module algo(
    input logic clk,
    input logic rst,
    input logic encrypt,
    input logic decrypt,
    input logic [3:0] num_rounds,   //when the user specifies num_rounds it is not 0 indexed
    input logic [127:0] key,
    input logic [31:0] d_in,
    output logic [31:0] d_out,
    output logic done
);

logic [5:0] algo_state, algo_next_state;


parameter IDLE = 6'b000000;
parameter ENCRYPT_DONE = 6'b000001;
parameter DECRYPT_DONE = 6'b000010;

parameter ENCRYPT_1 = 6'b100000;
parameter ENCRYPT_2 = 6'b100001;
parameter ENCRYPT_3 = 6'b100010;
parameter ENCRYPT_4 = 6'b100011;
parameter ENCRYPT_5 = 6'b100100;
parameter ENCRYPT_6 = 6'b100101;
parameter ENCRYPT_7 = 6'b100110;
parameter ENCRYPT_8 = 6'b100111;
parameter ENCRYPT_9 = 6'b101000;
parameter ENCRYPT_10 = 6'b101001;
parameter ENCRYPT_11 = 6'b101010;
parameter ENCRYPT_12 = 6'b101011;
parameter ENCRYPT_13 = 6'b101100;
parameter ENCRYPT_14 = 6'b101101;
parameter ENCRYPT_15 = 6'b101110;
parameter ENCRYPT_16 = 6'b101111;

parameter DECRYPT_1 = 6'b110000;
parameter DECRYPT_2 = 6'b110001;
parameter DECRYPT_3 = 6'b110010;
parameter DECRYPT_4 = 6'b110011;
parameter DECRYPT_5 = 6'b110100;
parameter DECRYPT_6 = 6'b110101;
parameter DECRYPT_7 = 6'b110110;
parameter DECRYPT_8 = 6'b110111;
parameter DECRYPT_9 = 6'b111000;
parameter DECRYPT_10 = 6'b111001;
parameter DECRYPT_11 = 6'b111010;
parameter DECRYPT_12 = 6'b111011;
parameter DECRYPT_13 = 6'b111100;
parameter DECRYPT_14 = 6'b111101;
parameter DECRYPT_15 = 6'b111110;
parameter DECRYPT_16 = 6'b111111;

//logic counter_active;

//logic [4:0] round_counter;



//TOP LEVEL STATE TRANSITION
always_ff @ (posedge clk) begin
    if(~rst) begin
        algo_state <= IDLE;
    end
    else begin
        algo_state <= algo_next_state;
    end
end

//TOP LEVEL COMBO LOGIC
always_comb begin 

    case(top_level_curr_state)

        IDLE: begin
            done = 0;
            if(rst == 0) begin
                algo_next_state = IDLE;
            end
            else if(encrypt && num_rounds == 0) begin
                algo_next_state = ENCRYPT_DONE;
            end
            else if(decrypt && num_rounds == 0) begin
                algo_next_state = ENCRYPT_DONE;
            end
            else if(encrypt) begin
                algo_next_state = ENCRYPT_1;
            end
            else if(decrypt)
                algo_next_state = DECRYPT_1;
        end



        ENCRYPT_DONE: begin
            done = 1;
            algo_next_state = IDLE; 
        end

        DECRYPT_DONE: begin
            done = 1;
            algo_next_state = IDLE;
        
        end

        ENCRYPT_1: begin
            if(num_rounds == 1)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_2: begin
            if(num_rounds == 2)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_3: begin
            if(num_rounds == 3)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_4: begin
            if(num_rounds == 4)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_5: begin
            if(num_rounds == 5)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_6: begin
            if(num_rounds == 6)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_7: begin
            if(num_rounds == 7)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_8: begin
            if(num_rounds == 8)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_9: begin
            if(num_rounds == 9)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_10: begin
            if(num_rounds == 10)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_11: begin
            if(num_rounds == 11)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_12: begin
            if(num_rounds == 12)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_13: begin
            if(num_rounds == 13)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_14: begin
            if(num_rounds == 14)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_15: begin
            if(num_rounds == 15)
                algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end

        ENCRYPT_16: begin
            algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end


        //DECRYPTION LOGIC

        DECRYPT_1: begin
            if(num_rounds == 1)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_2: begin
            if(num_rounds == 2)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_3: begin
            if(num_rounds == 3)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_4: begin
            if(num_rounds == 4)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_5: begin
            if(num_rounds == 5)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_6: begin
            if(num_rounds == 6)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_7: begin
            if(num_rounds == 7)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_8: begin
            if(num_rounds == 8)
                algo_next_state = DECRYPT_DONE;
           //decryption logic
        end

        DECRYPT_9: begin
            if(num_rounds == 9)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_10: begin
            if(num_rounds == 10)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_11: begin
            if(num_rounds == 11)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_12: begin
            if(num_rounds == 12)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_13: begin
            if(num_rounds == 13)
                algo_next_state = DECRYPT_DONE;
           //decryption logic
        end

        DECRYPT_14: begin
            if(num_rounds == 14)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_15: begin
            if(num_rounds == 15)
                algo_next_state = DECRYPT_DONE;
            //decryption logic
        end

        DECRYPT_16: begin
            algo_next_state = DECRYPT_DONE;
            //decryption logic
        end



    endcase    
    
end




endmodule