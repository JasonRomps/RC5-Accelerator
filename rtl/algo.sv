module algo(
    input logic clk,
    input logic rst,
    input logic encrypt,
    input logic decrypt,
    input logic [4:0] num_rounds,   //when the user specifies num_rounds it is not 0 indexed
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

    // Defaults
    done = 1'b0;

    case(algo_state)

        IDLE: begin
            if(rst == 0) begin
                algo_next_state = IDLE;
            end
            else if(encrypt && num_rounds == 0) begin
                algo_next_state = ENCRYPT_DONE;
            end
            else if(decrypt && num_rounds == 0) begin
                algo_next_state = DECRYPT_DONE;
            end
            else if(encrypt) begin
                algo_next_state = ENCRYPT_1;
            end
            else if(decrypt)
                algo_next_state = DECRYPT_1;
        end



        ENCRYPT_DONE: begin
            done = 1'b1;
            algo_next_state = IDLE; 
        end

        DECRYPT_DONE: begin
            done = 1'b1;
            algo_next_state = IDLE;
        
        end

		ENCRYPT_1: begin
			algo_next_state = (num_rounds == 1) ? ENCRYPT_DONE : ENCRYPT_2;

			//encryption logic
		end
		ENCRYPT_2: begin
			algo_next_state = (num_rounds == 2) ? ENCRYPT_DONE : ENCRYPT_3;

			//encryption logic
		end
		ENCRYPT_3: begin
			algo_next_state = (num_rounds == 3) ? ENCRYPT_DONE : ENCRYPT_4;

			//encryption logic
		end
		ENCRYPT_4: begin
			algo_next_state = (num_rounds == 4) ? ENCRYPT_DONE : ENCRYPT_5;

			//encryption logic
		end
		ENCRYPT_5: begin
			algo_next_state = (num_rounds == 5) ? ENCRYPT_DONE : ENCRYPT_6;

			//encryption logic
		end
		ENCRYPT_6: begin
			algo_next_state = (num_rounds == 6) ? ENCRYPT_DONE : ENCRYPT_7;

			//encryption logic
		end
		ENCRYPT_7: begin
			algo_next_state = (num_rounds == 7) ? ENCRYPT_DONE : ENCRYPT_8;

			//encryption logic
		end
		ENCRYPT_8: begin
			algo_next_state = (num_rounds == 8) ? ENCRYPT_DONE : ENCRYPT_9;

			//encryption logic
		end
		ENCRYPT_9: begin
			algo_next_state = (num_rounds == 9) ? ENCRYPT_DONE : ENCRYPT_10;

			//encryption logic
		end
		ENCRYPT_10: begin
			algo_next_state = (num_rounds == 10) ? ENCRYPT_DONE : ENCRYPT_11;

			//encryption logic
		end
		ENCRYPT_11: begin
			algo_next_state = (num_rounds == 11) ? ENCRYPT_DONE : ENCRYPT_12;

			//encryption logic
		end
		ENCRYPT_12: begin
			algo_next_state = (num_rounds == 12) ? ENCRYPT_DONE : ENCRYPT_13;

			//encryption logic
		end
		ENCRYPT_13: begin
			algo_next_state = (num_rounds == 13) ? ENCRYPT_DONE : ENCRYPT_14;

			//encryption logic
		end
		ENCRYPT_14: begin
			algo_next_state = (num_rounds == 14) ? ENCRYPT_DONE : ENCRYPT_15;

			//encryption logic
		end
		ENCRYPT_15: begin
			algo_next_state = (num_rounds == 15) ? ENCRYPT_DONE : ENCRYPT_16;

			//encryption logic
		end

        ENCRYPT_16: begin
            algo_next_state = ENCRYPT_DONE;
            //encryption logic
        end


        //DECRYPTION LOGIC
		DECRYPT_1: begin
			algo_next_state = (num_rounds == 1) ? DECRYPT_DONE : DECRYPT_2;

			//decryption logic
		end
		DECRYPT_2: begin
			algo_next_state = (num_rounds == 2) ? DECRYPT_DONE : DECRYPT_3;

			//decryption logic
		end
		DECRYPT_3: begin
			algo_next_state = (num_rounds == 3) ? DECRYPT_DONE : DECRYPT_4;

			//decryption logic
		end
		DECRYPT_4: begin
			algo_next_state = (num_rounds == 4) ? DECRYPT_DONE : DECRYPT_5;

			//decryption logic
		end
		DECRYPT_5: begin
			algo_next_state = (num_rounds == 5) ? DECRYPT_DONE : DECRYPT_6;

			//decryption logic
		end
		DECRYPT_6: begin
			algo_next_state = (num_rounds == 6) ? DECRYPT_DONE : DECRYPT_7;

			//decryption logic
		end
		DECRYPT_7: begin
			algo_next_state = (num_rounds == 7) ? DECRYPT_DONE : DECRYPT_8;

			//decryption logic
		end
		DECRYPT_8: begin
			algo_next_state = (num_rounds == 8) ? DECRYPT_DONE : DECRYPT_9;

			//decryption logic
		end
		DECRYPT_9: begin
			algo_next_state = (num_rounds == 9) ? DECRYPT_DONE : DECRYPT_10;

			//decryption logic
		end
		DECRYPT_10: begin
			algo_next_state = (num_rounds == 10) ? DECRYPT_DONE : DECRYPT_11;

			//decryption logic
		end
		DECRYPT_11: begin
			algo_next_state = (num_rounds == 11) ? DECRYPT_DONE : DECRYPT_12;

			//decryption logic
		end
		DECRYPT_12: begin
			algo_next_state = (num_rounds == 12) ? DECRYPT_DONE : DECRYPT_13;

			//decryption logic
		end
		DECRYPT_13: begin
			algo_next_state = (num_rounds == 13) ? DECRYPT_DONE : DECRYPT_14;

			//decryption logic
		end
		DECRYPT_14: begin
			algo_next_state = (num_rounds == 14) ? DECRYPT_DONE : DECRYPT_15;

			//decryption logic
		end
		DECRYPT_15: begin
			algo_next_state = (num_rounds == 15) ? DECRYPT_DONE : DECRYPT_16;

			//decryption logic
		end

        DECRYPT_16: begin
            algo_next_state = DECRYPT_DONE;
            //decryption logic
        end



    endcase    
    
end




endmodule