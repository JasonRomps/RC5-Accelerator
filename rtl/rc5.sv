module rc5(
    input logic rst,
    input logic clk,

    input logic [4:0] num_rounds,
    input logic [127:0] key,

    input logic load_key,
    output logic key_ready,

    input logic start_encrypt,
    input logic start_decrypt,

    input logic [31:0] d_in,
    output logic [31:0] d_out,
    output logic done,

    //validation signals
    input logic scan_en,
    input logic scan_in,
    input logic begin_validate,
    output logic scan_out
);


logic [15:0] subkeys [0:33];

logic [167:0] scan_values;

logic [4:0] num_rounds_in;
logic [127:0] key_in;
logic load_key_in;
logic start_encrypt_in;
logic start_decrypt_in;
logic [31:0] d_in_in;
logic [31:0] d_out_out;
logic done_out;


keygen Keygen(
    .start(load_key_in),
    .clk(clk),
    .rst(rst),
    .num_rounds(num_rounds_in),
    .key(key_in),
    .subkeys(subkeys),
    .ready(key_ready)
);

algo Algo(
    .clk(clk),
    .rst(rst),
    .encrypt(start_encrypt_in),
    .decrypt(start_decrypt_in),
    .num_rounds(num_rounds_in),
    .subkeys(subkeys),
    .d_in(d_in_in),
    .d_out(d_out_out),
    .done(done_out),
    .begin_validate(begin_validate)
);

//validation procedure:
//set scan_en high for 168 clock cycles while serially feeding data in
//set begin_validate high for entire validation period
//wait desired amount of time
//set scan_en high for 33 clock cycles to serially feed data out
//deassert begin_validate signal

logic [167:0] shift_reg_inputs;
  //[127:0] key
  //[159:128] d_in
  //[164:160] num_rounds
  //[165] load_key
  //[166] start_encrypt
  //[167] start_decrypt

logic [32:0] shift_reg_outputs;
    //[31:0] d_out
    //[32] done


  
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      shift_reg_inputs <= 168'd0;
      shift_reg_outputs <= 33'b0;
    end
    else if (scan_en) begin
      shift_reg_inputs <= {shift_reg_inputs[166:0], scan_in};
      shift_reg_outputs <= {shift_reg_outputs[31:0], 1'b0};
    end
    else if(begin_validate & ~scan_en) begin
        shift_reg_outputs[31:0] <= d_out_out;
        shift_reg_outputs[32] <= done_out;
    end
  end

  assign scan_out = scan_en ? shift_reg_outputs[32] : 1'b0;

always_comb begin
    if(begin_validate & ~scan_en) begin
        key_in = shift_reg_inputs[127:0];
        d_in_in = shift_reg_inputs[159:128];
        num_rounds_in = shift_reg_inputs[164:160];
        load_key_in = shift_reg_inputs[165];
        start_encrypt_in = shift_reg_inputs[166];
        start_decrypt_in = shift_reg_inputs[167];
        d_out = 32'd0;
        done = 1'b0;
    end
    else begin
        key_in = key;
        d_in_in = d_in;
        num_rounds_in = num_rounds;
        load_key_in = load_key;
        start_encrypt_in = start_encrypt;
        start_decrypt_in = start_decrypt;
        d_out = d_out_out;
        done = done_out;
    end


end

endmodule