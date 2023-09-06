module algo(
    input logic clk,
    input logic rst,
    input logic encrypt,
    input logic decrypt,
    input logic [127:0] key,
    input logic [31:0] d_in,
    output logic [31:0] d_out
);

logic [1:0] top_level_curr_state, top_level_next_state;

logic encrypt_done;
logic decrypt_done;

parameter IDLE_TOP_LEVEL = 2'b00;
parameter ENCRYPT_TOP_LEVEL = 2'b10;
parameter DECRYPT_TOP_LEVEL = 2'b01;
parameter UNDEFINED_TOP_LEVEL = 2'b11;


//TOP LEVEL STATE TRANSITION
always_ff @ (posedge clk) begin
    if(~rst)
        top_level_curr_state <= IDLE;
    else
        top_level curr_state <= top_level_next_state;
end

//TOP LEVEL COMBO LOGIC
always_comb begin 

    case({encrypt,decrypt})

        IDLE_TOP_LEVEL: begin
            if(rst == 0) begin
                d_out = 32'b0;
            end

        end

        ENCRYPT_TOP_LEVEL: begin

        end


        DECRYPT_TOP_LEVEL: begin

        
        end

        UNDEFINED_TOP_LEVEL: begin

        
        end



    endcase    
    
end



endmodule