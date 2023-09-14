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


logic [15:0] A, B, new_A, new_B;
logic [15:0] A_rot_out_enc, B_rot_out_enc, A_rot_out_dec, B_rot_out_dec;
logic [15:0] Subkeys [0:33];
logic [15:0] dec_a_s_val, dec_b_s_val;
logic [4:0] dec_counter, new_dec_counter; 

assign Subkeys = {16'd55048, 16'd43744, 16'd48559, 16'd27403, 16'd20374, 16'd33387, 16'd2062, 16'd61013, 16'd49237, 16'd33709, 16'd16278, 16'd65452, 16'd9968, 16'd4572, 16'd34933, 16'd35205, 16'd37470, 16'd42119, 16'd21025, 16'd13567, 16'd19718, 16'd1446, 16'd11664, 16'd40137, 16'd19576, 16'd15720, 16'd15720,16'd15720,16'd15720,16'd15720,16'd15720,16'd15720,16'd15720,16'd15720};

rotl A_Rotl(
	.data_i(A^B),
	.n_i(B),
	.data_o(A_rot_out_enc)
);

rotl B_Rotl(
	.data_i(B^new_A),
	.n_i(new_A),
	.data_o(B_rot_out_enc)
);

rotr B_Rotr(
	.data_i(B - dec_b_s_val),
	.n_i(A),
	.data_o(B_rot_out_dec)
);

rotr A_Rotr(
	.data_i(A - dec_a_s_val),
	.n_i(new_B),
	.data_o(A_rot_out_dec)
);

//TOP LEVEL STATE TRANSITION
always_ff @ (posedge clk) begin
    if(~rst) begin
        algo_state <= IDLE;
		dec_counter <= 5'd0;
		A <= 16'd0;
		B <= 16'd0;

		// for(int i = 0; i < 34; i++) begin
		// 	Subkeys[i] <= 0;
		// end
    end
    else begin
        algo_state <= algo_next_state;
		dec_counter <= new_dec_counter;
		A <= new_A;
		B <= new_B;
    end
end

//TOP LEVEL COMBO LOGIC
always_comb begin 

    // Defaults
    done = 1'b0;
	d_out = 32'd0;
	dec_a_s_val = 16'd0;
	dec_b_s_val = 16'd0;

	new_dec_counter = dec_counter - 1;

    case(algo_state)

        IDLE: begin
			new_A = A; // Hold Value in temp registers
			new_B = B;
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
				new_A = d_in[15:0] + Subkeys[0];
				new_B = d_in[31:16] + Subkeys[1];
            end
            else if(decrypt) begin
				algo_next_state = DECRYPT_1;
				new_A = d_in[15:0];
				new_B = d_in[31:16];
				new_dec_counter <= num_rounds;
			end
        end

        ENCRYPT_DONE: begin
            done = 1'b1;
            algo_next_state = IDLE;
			d_out = {B, A};
        end

        DECRYPT_DONE: begin
            done = 1'b1;
            algo_next_state = IDLE;
			d_out = {B - Subkeys[1], A - Subkeys[0]};
        end

		ENCRYPT_1: begin
			algo_next_state = (num_rounds == 1) ? ENCRYPT_DONE : ENCRYPT_2;
			new_A = A_rot_out_enc + Subkeys[2 * 1]; // 1 Because of Round 1
			new_B = B_rot_out_enc + Subkeys[(2 * 1) + 1];
			//encryption logic
		end
		ENCRYPT_2: begin
			algo_next_state = (num_rounds == 2) ? ENCRYPT_DONE : ENCRYPT_3;
			new_A = A_rot_out_enc + Subkeys[2 * 2]; // 2 Because of Round 2
			new_B = B_rot_out_enc + Subkeys[(2 * 2) + 1];
			//encryption logic
		end
		ENCRYPT_3: begin
			algo_next_state = (num_rounds == 3) ? ENCRYPT_DONE : ENCRYPT_4;
			new_A = A_rot_out_enc + Subkeys[2 * 3]; // 3 Because of Round 3
			new_B = B_rot_out_enc + Subkeys[(2 * 3) + 1];
			//encryption logic
		end
		ENCRYPT_4: begin
			algo_next_state = (num_rounds == 4) ? ENCRYPT_DONE : ENCRYPT_5;
			new_A = A_rot_out_enc + Subkeys[2 * 4]; // 4 Because of Round 4
			new_B = B_rot_out_enc + Subkeys[(2 * 4) + 1];
			//encryption logic
		end
		ENCRYPT_5: begin
			algo_next_state = (num_rounds == 5) ? ENCRYPT_DONE : ENCRYPT_6;
			new_A = A_rot_out_enc + Subkeys[2 * 5]; // 5 Because of Round 5
			new_B = B_rot_out_enc + Subkeys[(2 * 5) + 1];
			//encryption logic
		end
		ENCRYPT_6: begin
			algo_next_state = (num_rounds == 6) ? ENCRYPT_DONE : ENCRYPT_7;
			new_A = A_rot_out_enc + Subkeys[2 * 6]; // 6 Because of Round 6
			new_B = B_rot_out_enc + Subkeys[(2 * 6) + 1];
			//encryption logic
		end
		ENCRYPT_7: begin
			algo_next_state = (num_rounds == 7) ? ENCRYPT_DONE : ENCRYPT_8;
			new_A = A_rot_out_enc + Subkeys[2 * 7]; // 7 Because of Round 7
			new_B = B_rot_out_enc + Subkeys[(2 * 7) + 1];
			//encryption logic
		end
		ENCRYPT_8: begin
			algo_next_state = (num_rounds == 8) ? ENCRYPT_DONE : ENCRYPT_9;
			new_A = A_rot_out_enc + Subkeys[2 * 8]; // 8 Because of Round 8
			new_B = B_rot_out_enc + Subkeys[(2 * 8) + 1];
			//encryption logic
		end
		ENCRYPT_9: begin
			algo_next_state = (num_rounds == 9) ? ENCRYPT_DONE : ENCRYPT_10;
			new_A = A_rot_out_enc + Subkeys[2 * 9]; // 9 Because of Round 9
			new_B = B_rot_out_enc + Subkeys[(2 * 9) + 1];
			//encryption logic
		end
		ENCRYPT_10: begin
			algo_next_state = (num_rounds == 10) ? ENCRYPT_DONE : ENCRYPT_11;
			new_A = A_rot_out_enc + Subkeys[2 * 10]; // 10 Because of Round 10
			new_B = B_rot_out_enc + Subkeys[(2 * 10) + 1];
			//encryption logic
		end
		ENCRYPT_11: begin
			algo_next_state = (num_rounds == 11) ? ENCRYPT_DONE : ENCRYPT_12;
			new_A = A_rot_out_enc + Subkeys[2 * 11]; // 11 Because of Round 11
			new_B = B_rot_out_enc + Subkeys[(2 * 11) + 1];
			//encryption logic
		end
		ENCRYPT_12: begin
			algo_next_state = (num_rounds == 12) ? ENCRYPT_DONE : ENCRYPT_13;
			new_A = A_rot_out_enc + Subkeys[2 * 12]; // 12 Because of Round 12
			new_B = B_rot_out_enc + Subkeys[(2 * 12) + 1];
			//encryption logic
		end
		ENCRYPT_13: begin
			algo_next_state = (num_rounds == 13) ? ENCRYPT_DONE : ENCRYPT_14;
			new_A = A_rot_out_enc + Subkeys[2 * 13]; // 13 Because of Round 13
			new_B = B_rot_out_enc + Subkeys[(2 * 13) + 1];
			//encryption logic
		end
		ENCRYPT_14: begin
			algo_next_state = (num_rounds == 14) ? ENCRYPT_DONE : ENCRYPT_15;
			new_A = A_rot_out_enc + Subkeys[2 * 14]; // 14 Because of Round 14
			new_B = B_rot_out_enc + Subkeys[(2 * 14) + 1];
			//encryption logic
		end
		ENCRYPT_15: begin
			algo_next_state = (num_rounds == 15) ? ENCRYPT_DONE : ENCRYPT_16;
			new_A = A_rot_out_enc + Subkeys[2 * 15]; // 11 Because of Round 15
			new_B = B_rot_out_enc + Subkeys[(2 * 15) + 1];
			//encryption logic
		end

        ENCRYPT_16: begin
            algo_next_state = ENCRYPT_DONE;
			new_A = A_rot_out_enc + Subkeys[2 * 16]; // 16 Because of Round 16
			new_B = B_rot_out_enc + Subkeys[(2 * 16) + 1];
            //encryption logic
        end

		DECRYPT_1: begin
			algo_next_state = (num_rounds == 1) ? DECRYPT_DONE : DECRYPT_2;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];
			
			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_2: begin
			algo_next_state = (num_rounds == 2) ? DECRYPT_DONE : DECRYPT_3;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_3: begin
			algo_next_state = (num_rounds == 3) ? DECRYPT_DONE : DECRYPT_4;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_4: begin
			algo_next_state = (num_rounds == 4) ? DECRYPT_DONE : DECRYPT_5;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_5: begin
			algo_next_state = (num_rounds == 5) ? DECRYPT_DONE : DECRYPT_6;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_6: begin
			algo_next_state = (num_rounds == 6) ? DECRYPT_DONE : DECRYPT_7;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_7: begin
			algo_next_state = (num_rounds == 7) ? DECRYPT_DONE : DECRYPT_8;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_8: begin
			algo_next_state = (num_rounds == 8) ? DECRYPT_DONE : DECRYPT_9;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_9: begin
			algo_next_state = (num_rounds == 9) ? DECRYPT_DONE : DECRYPT_10;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_10: begin
			algo_next_state = (num_rounds == 10) ? DECRYPT_DONE : DECRYPT_11;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_11: begin
			algo_next_state = (num_rounds == 11) ? DECRYPT_DONE : DECRYPT_12;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_12: begin
			algo_next_state = (num_rounds == 12) ? DECRYPT_DONE : DECRYPT_13;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_13: begin
			algo_next_state = (num_rounds == 13) ? DECRYPT_DONE : DECRYPT_14;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_14: begin
			algo_next_state = (num_rounds == 14) ? DECRYPT_DONE : DECRYPT_15;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end
		DECRYPT_15: begin
			algo_next_state = (num_rounds == 15) ? DECRYPT_DONE : DECRYPT_16;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
			//decryption logic
		end

        DECRYPT_16: begin
            algo_next_state = DECRYPT_DONE;
			dec_b_s_val = Subkeys[(2*dec_counter)+1];
			dec_a_s_val = Subkeys[(2*dec_counter)];

			new_B = B_rot_out_dec ^ A;
			new_A = A_rot_out_dec ^ new_B;
            //decryption logic
        end



    endcase    
    
end




endmodule