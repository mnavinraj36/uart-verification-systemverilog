module baud_assertions #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 115200,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input reset,
    input tx_enable,
    input rx_enable,
    input [9:0] tx_counter,
    input [5:0] rx_counter
);

    localparam tx_divide = CLK_FREQ / BAUD_RATE;
    localparam rx_divide = CLK_FREQ / (BAUD_RATE * OVERSAMPLE);
  
  property p_reset;
    @(posedge clk)
     reset |->(tx_counter == 0 && rx_counter==0 && tx_enable ==0 && rx_enable ==0);
  endproperty 
    
  property p_enable;
    @(posedge clk)
    $past(tx_counter)== tx_divide-1 |->tx_enable;
  endproperty 
  
  property p_enable1;
    @(posedge clk)
    $past(rx_counter)== rx_divide-1|->rx_enable;
  endproperty 
  
  property en;
    @(posedge clk)
    tx_enable |=> !tx_enable;
  endproperty
  
  property en1;
    @(posedge clk)
   rx_enable |=> !rx_enable;
  endproperty
  
     property inc;
    @(posedge clk)
        disable iff (reset)
       !$past(reset) &&  $past(tx_counter)!= tx_divide-1 |->tx_counter == $past(tx_counter) +1'b1;
  endproperty 
  
  property inc1;
    @(posedge clk)
     disable iff (reset)
    !$past(reset) &&  $past(rx_counter)!= rx_divide-1 |-> rx_counter ==  $past(rx_counter) +1'b1;
  endproperty
  
  property tx_wrap;
  @(posedge clk)
    $past(tx_counter) == tx_divide-1
    |-> tx_counter == 0;
endproperty

property rx_wrap;
  @(posedge clk)
    $past(rx_counter) == rx_divide-1
    |-> rx_counter == 0;
endproperty
  assert property(p_reset);
  assert property (p_enable);
  assert property (p_enable1);
  assert property (en);
  assert property (en1);
  assert property (inc);
  assert property (inc1);
  assert property (tx_wrap);
  assert property (rx_wrap);
        
  endmodule 
    
module transmitter_assertions (
    input clk,
    input reset,
    input tx_enable,
    input enable,
    input [7:0] datain,

    input busy,
    input tx,

    input [2:0] bitcount,
    input [1:0] state,
    input [1:0] next_state,
    input [7:0] shift_reg
);
   localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;
  
  property st;
    @(posedge clk)
    state ==IDLE && enable |-> next_state == START;
  endproperty 
  
  property nst;
    @(posedge clk)
    state ==IDLE && !enable |-> next_state == IDLE;
  endproperty
  
   property state1;
    @(posedge clk)
    state ==START && tx_enable |-> next_state == DATA;
  endproperty
  
  property nstate1;
    @(posedge clk)
    state ==START && !tx_enable |-> next_state == START;
  endproperty
  
   property state2;
    @(posedge clk)
    state ==DATA && tx_enable && bitcount==3'd7 |-> next_state == STOP;
  endproperty
  
   property nstate2;
    @(posedge clk)
    state ==DATA && !tx_enable  |-> next_state == DATA;
  endproperty
  
   property state3;
    @(posedge clk)
    state ==DATA && tx_enable && bitcount!=3'd7 |-> next_state == DATA;
  endproperty
  
  property state4;
    @(posedge clk)
    state== STOP && tx_enable |->next_state == IDLE;
  endproperty 
  
  property nstate4;
    @(posedge clk)
    state== STOP && !tx_enable |->next_state == STOP;
  endproperty 
  
  property s1;
    @(posedge clk)
    ( (state ==IDLE)||(state==STOP)) |-> tx==1'b1;
  endproperty 
  
  property s2;
    @(posedge clk)
    state == START |-> tx==1'b0;
  endproperty 
  
  property s3;
    @(posedge clk)
    state == DATA |-> tx==shift_reg[0];
  endproperty 
  
  property s4;
    @(posedge clk)
    state == DATA && tx_enable
      |=> shift_reg == ($past(shift_reg) >> 1);
endproperty
  
  property s5;
    @(posedge clk)
    state ==IDLE && enable |=> shift_reg ==$past(datain)&& bitcount == 3'd0;
  endproperty 
   
  property s6;
    @(posedge clk)
    reset |->
    shift_reg == 8'd0  && bitcount ==3'd0;
  endproperty 
    
  property s7;
    @(posedge clk )
     reset |->state == IDLE ;
  endproperty 
  
  property s8;
  @(posedge clk)
  (state == DATA && tx_enable && bitcount != 3'd7)
  |=> bitcount == $past(bitcount) + 1;
endproperty
  
  property s9;
  @(posedge clk)
  (state == DATA && tx_enable && bitcount == 3'd7)
  |=> bitcount == 3'd7;
  endproperty
  
  property p_busy;
  @(posedge clk)
  busy == (state != IDLE);
endproperty
  
  assert property(s1);
  assert property(s2);
  assert property(s3);       
  assert property(s4);
  assert property(s5);
  assert property(s6);
  assert property(s7);
  assert property(s8);
  assert property(s9);
  assert property(st);
  assert property(nst);
  assert property(state1);
  assert property(nstate1);
  assert property(state2);
  assert property(nstate2);
  assert property(state3);
  assert property(state4);
   assert property(nstate4);
   assert property(p_busy);
     

 cover property (
    @(posedge clk)
    state == START ##1 state == DATA
);

    cover property (
    @(posedge clk)
    state == DATA && tx_enable && bitcount == 3'd7
    ##1 state == STOP
);
    cover property (
    @(posedge clk)
    state == IDLE
    ##1 state == START
    ##[1:$] state == DATA
    ##[1:$] state == STOP
    ##1 state == IDLE
);
      endmodule 
      
module receiver_assertions (
    input clk,
    input reset,
    input rx_enable,
    input rx,

    input [7:0] data_out,
    input ready,

    input [1:0] state,
    input [3:0] sample_count,
    input [2:0] bit_count,
    input [7:0] shift_reg
);
  
    localparam START = 2'b00;
    localparam DATA  = 2'b01;
    localparam STOP  = 2'b10;


property p1;
  @(posedge clk)
  reset |->
  sample_count == 4'd0 &&bit_count==3'd0 && shift_reg == 8'd0 && data_out ==8'd0 && ready == 1'b0;
endproperty 
  
  property p2;
    @(posedge clk )
    reset |->
    state == START;
  endproperty 
  
  property p3;
    @(posedge clk)
    state == START && rx_enable &&rx==1'b0 |=> sample_count == $past(sample_count)+ 1'b1;
  endproperty
  
  property p4;
    @(posedge clk)
    state == START && rx_enable &&rx |=> sample_count ==4'd0;
  endproperty
  
  property p5;
    @(posedge clk)
    state == START && rx && rx_enable && (sample_count)==4'd7 |=> sample_count == 4'd0;
  endproperty 
  
  property p6;
    @(posedge clk)
    state == START &&rx_enable && sample_count ==4'd15 |=> state == DATA && sample_count == 4'd0 && bit_count == 3'd0 && shift_reg == 8'd0;
  endproperty 
  
 property p7;
  @(posedge clk)
  (state == DATA && rx_enable && sample_count == 4'd7)
  |=> shift_reg[$past(bit_count)] == $past(rx);
endproperty
  
  property p8;
    @(posedge clk )
    state==DATA && rx_enable &&sample_count ==4'd15 && bit_count==3'd7  |=> sample_count == 4'd0 && state == STOP;
  endproperty
  
  property p9;
    @(posedge clk)
    state ==DATA && rx_enable && sample_count == 4'd15 && bit_count != 3'd7 |=> sample_count == 4'd0 && bit_count == $past(bit_count)+1'b1;
  endproperty 
    
  property p10;
    @(posedge clk)
    state ==DATA && rx_enable && sample_count!= 4'd15 |=> sample_count == $past(sample_count)+1'b1;
  endproperty 
  
  property p11;
    @(posedge clk)
    state == STOP && rx_enable && sample_count != 4'd15 |=> sample_count == $past(sample_count)+1'b1;
  endproperty 
  
  property p12;
    @(posedge clk )
    state == STOP && rx_enable && sample_count == 4'd7 &&  rx |=> data_out == $past(shift_reg) && ready == 1'b1;
  endproperty 
  
  property p13;
    @(posedge clk)
    state == STOP && rx_enable && sample_count == 4'd15 |=> state == START && sample_count ==4'd0;
  endproperty 
  
 property p14;
  @(posedge clk)
  ready |=> !ready;
endproperty 
  

  assert property(p1);
  assert property(p2);
  assert property(p3);       
  assert property(p4);
  assert property(p5);
  assert property(p6);
  assert property(p7);
  assert property(p8);
  assert property(p9);       
  assert property(p10);
  assert property(p11);
  assert property(p12);
  assert property(p13);
  assert property(p14);
   
cover property (
  @(posedge clk)
  state == START ##1 state == DATA
);
  
  cover property (
  @(posedge clk)
  state == DATA && rx_enable && sample_count == 4'd7
  ##1 state == DATA && rx_enable && sample_count == 4'd15
);
    
  cover property (
  @(posedge clk)
  state == DATA &&
  rx_enable &&
  sample_count == 4'd15 &&
  bit_count == 3'd7
  ##1 state == STOP
);
      
 cover property (
  @(posedge clk)
  state == START
  ##[1:$] state == DATA
  ##[1:$] state == STOP
  ##[1:$] state == START
);
        
endmodule      
     
bind baud_generator baud_assertions #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE),
    .OVERSAMPLE(OVERSAMPLE)
) baud_assertions_inst (
    .clk(clk),
    .reset(reset),
    .tx_enable(tx_enable),
    .rx_enable(rx_enable),
    .tx_counter(tx_counter),
    .rx_counter(rx_counter)
);
        
        
bind transmitter transmitter_assertions transmitter_assertions_inst (
    .clk(clk),
    .reset(reset),
    .tx_enable(tx_enable),
    .enable(enable),
    .datain(datain),
    .busy(busy),
    .tx(tx),
    .bitcount(bitcount),
    .state(state),
    .next_state(next_state),
    .shift_reg(shift_reg)
);
        
bind receiver receiver_assertions receiver_assertions_inst (
    .clk(clk),
    .reset(reset),
    .rx_enable(rx_enable),
    .rx(rx),
    .data_out(data_out),
    .ready(ready),
    .state(state),
    .sample_count(sample_count),
    .bit_count(bit_count),
    .shift_reg(shift_reg)
);
        
        
