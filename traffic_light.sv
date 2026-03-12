module traffic_light(input logic clk,
input logic reset,
input logic TAORB,
output reg[5:0] led);

typedef enum bit[1:0]
{ S0_GREENRED = 2'b00,
  S1_YELLOWRED = 2'b01,
  S2_REDGREEN = 2'b10,
  S3_REDYELLOW = 2'b11} state_t;

  state_t state_reg, state_next;
  logic [2:0] timer_reg, timer_next;

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= S0_GREENRED;
        timer_reg <= timer_next;
    end
    else begin
        state_reg <= state_next;
        timer_reg <= timer_next;
    end
  end

  always_comb begin
    state_next = state_reg;
    timer_next = timer_reg;

    case(state_reg)
    S0_GREENRED : begin
        timer_next = 3'd0;
        if (~TAORB) state_next = S1_YELLOWRED;
        else state_next = S0_GREENRED;
    end

    S1_YELLOWRED :begin
        if (timer_reg < 3'd5) begin
            timer_next = timer_reg + 3'd1;
            state_next = S1_YELLOWRED;
        end
        else begin 
            timer_next = 3'd0;
            state_next = S2_REDGREEN;
        end
    end

    S2_REDGREEN : begin
        timer_next= 3'd0;
        if(TAORB) state_next = S3_REDYELLOW;
        else state_next = S2_REDGREEN;
        end

    S3_REDYELLOW : begin
        if (timer_reg < 3'd5) begin
            timer_next = timer_reg + 3'd1;
            state_next = S3_REDYELLOW;
        end
        else begin
            timer_next = 3'd0;
            state_next = S0_GREENRED;
        end
    end
    
    default : begin
        state_next = S0_GREENRED;
        timer_next = 3'd0;
    end
    endcase
end


always_comb begin
    case (state_reg)
    S0_GREENRED : led = 6'b001100;
    S1_YELLOWRED : led = 6'b010100;
    S2_REDGREEN : led = 6'b100001;
    S3_REDYELLOW : led = 6'b100010;
    default : led = 6'b001100;
    endcase
    end
endmodule