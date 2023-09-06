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

parameter IDLE = 3'b000;
parameter ENCRYPT_START = 3'b001;
parameter ENCRYPT_DONE = 3'b010;
parameter DECRYPT_START = 3'b100;
parameter DECRYPT_DONE = 3'b101;

logic [2:0] top_level_curr_state, top_level_next_state;


logic counter_active;

logic [4:0] round_counter;



//TOP LEVEL STATE TRANSITION
always_ff @ (posedge clk) begin
    if(~rst)
        top_level_curr_state <= IDLE;
    else begin
        top_level_curr_state <= top_level_next_state;
        if(counter_active) begin
            round_counter <= round_counter + 1;
        end

    end
end

//TOP LEVEL COMBO LOGIC
always_comb begin 

    case(top_level_curr_state)

        IDLE: begin
            done = 0;
            round_counter = 5'b00000;
            counter_active = 0;
            if(rst == 0) begin
                top_level_next_state = IDLE;
            end
            else if(encrypt)
                top_level_next_state = ENCRYPT_START;
            else if(decrypt)
                top_level_next_state = DECRYPT_START;
        end

        ENCRYPT_START: begin
            counter_active = 1;
            done = 0;
            if(round_counter == num_rounds) begin
                top_level_next_state = ENCRYPT_DONE;
            end
            else if(round_counter == 5'b00000) begin
                d_out = d_in;
            end
            else begin
                //algo logic here
                



            end
        end

        ENCRYPT_DONE: begin
            done = 1;
            top_level_next_state = IDLE; 
        end



    
        //DECRYPT STATES
        DECRYPT_START: begin

        
        end

        DECRYPT_DONE: begin

        
        end



    endcase    
    
end



//encrypt SM
always_ff @ (posedge clk) begin
    if(round_counter == num_rounds) begin
        done <= 1; //d_out is ready
    end
    else begin
        round_counter <= round_counter + 1;
    end

end


always_comb begin

    if(~rst || encrypt_begin) begin
        done = 0;
        round_counter = 0;
    end
    else begin
        
    end



end


endmodule