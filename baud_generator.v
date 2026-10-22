module baud_generator#(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 115200,
    parameter OVERSAMPLE = 16
) ( input clk, input reset , output reg tx_enable , output reg rx_enable );
  
  localparam tx_divide = CLK_FREQ / BAUD_RATE;
  localparam rx_divide = CLK_FREQ / (BAUD_RATE * OVERSAMPLE);
  
  reg [9:0] tx_counter;
  reg [5:0] rx_counter;
  
  always @(posedge clk , posedge reset)begin 
    if(reset)begin
      tx_counter <= 9'b0;
      tx_enable <= 1'b0;
      rx_counter <= 5'b0;
      rx_enable <= 1'b0;
    end 
      
    else begin
      
      if (tx_counter == tx_divide -1)
        begin 
          tx_counter<=9'b0;
          tx_enable<= 1'b1;
        end 
    
      else  
       begin
         tx_counter<= tx_counter + 1;
          tx_enable <=1'b0;
      end 
  
      if (rx_counter == rx_divide -1)
        begin
          rx_counter<=5'b0;
          rx_enable <=1'b1;
        end
      else
        begin
          rx_counter <= rx_counter + 1;
          rx_enable <= 1'b0;
        end
    end
  end 
endmodule
