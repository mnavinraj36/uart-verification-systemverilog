module receiver(
    input clk,
    input reset,
    input rx_enable,
    input rx,

    output reg [7:0] data_out,
    output reg ready
);

parameter START = 2'b00,
          DATA  = 2'b01,
          STOP  = 2'b10;

reg [1:0] state;

reg [3:0] sample_count;
reg [2:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk or posedge reset) begin

    if(reset) begin
        state        <= START;
        sample_count <= 4'd0;
        bit_count    <= 3'd0;
        shift_reg    <= 8'd0;
        data_out     <= 8'd0;
        ready        <= 1'b0;
    end

    else begin

        ready <= 1'b0;         

        if(rx_enable) begin

            case(state)

          
            START: begin

                if(rx == 1'b0)
                    sample_count <= sample_count + 1;

                else
                    sample_count <= 4'd0;

              
                if(sample_count == 4'd7) begin

                    if(rx == 1'b1)
                        sample_count <= 4'd0;  

                end

               
                if(sample_count == 4'd15) begin

                    state        <= DATA;
                    sample_count <= 4'd0;
                    bit_count    <= 3'd0;
                    shift_reg    <= 8'd0;

                end

            end

            DATA: begin

                sample_count <= sample_count + 1;

             
                if(sample_count == 4'd7) begin

                    shift_reg[bit_count] <= rx;

                end

              
                if(sample_count == 4'd15) begin

                    sample_count <= 4'd0;

                    if(bit_count == 3'd7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1;

                end

            end

            STOP: begin

                sample_count <= sample_count + 1;

                
                if(sample_count == 4'd7) begin

                    if(rx) begin
                        data_out <= shift_reg;
                        ready    <= 1'b1;
                    end

                end

                if(sample_count == 4'd15) begin

                    state        <= START;
                    sample_count <= 4'd0;

                end

            end

            endcase

        end

    end

end

endmodule
