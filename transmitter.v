module transmitter(
    input        clk,
    input        reset,
    input        tx_enable,
    input        enable,
    input  [7:0] datain,

    output       busy,
    output reg   tx
);

    reg [2:0] bitcount;
    reg [1:0] state, next_state;
    reg [7:0] shift_reg;

    parameter IDLE  = 2'b00,
              START = 2'b01,
              DATA  = 2'b10,
              STOP  = 2'b11;

   
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
      end

   
    always @(*) begin

        next_state = state;   
        tx = 1'b1;            

        case(state)

            IDLE: begin
                tx = 1'b1;

                if(enable)
                    next_state = START;
                  end

            START: begin
                tx = 1'b0;

                if(tx_enable)
                    next_state = DATA;
           end

            DATA: begin
                tx = shift_reg[0];

                if(tx_enable) begin
                    if(bitcount == 3'd7)
                        next_state = STOP;
                    else
                        next_state = DATA;
                end
            end

            STOP: begin
                tx = 1'b1;

                if(tx_enable)
                    next_state = IDLE;
              else 
                next_state = STOP;
            end
          

        endcase
    end

  
    always @(posedge clk or posedge reset) begin

        if(reset) begin
            shift_reg <= 8'd0;
            bitcount  <= 3'd0;
        end

        else begin

        
            if(state == IDLE && enable) begin
                shift_reg <= datain;
                bitcount  <= 3'd0;
            end

            else if(state == DATA && tx_enable) begin
                shift_reg <= shift_reg >> 1;

                if(bitcount != 3'd7)
                    bitcount <= bitcount + 1'b1;
            end

        end

    end

    
    assign busy = (state != IDLE);

endmodule
