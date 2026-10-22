class scoreboard;
  mailbox mon2scb;
  transaction trans;
  
  function new( mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction 
  
  task run();
    forever begin 
      mon2scb.get(trans);
      if(trans.rx_ready)begin 
        if
        (trans.tx_data== trans.rx_data)
          $display("SCOREBOARD PASS: TX = %0h, RX = %0h",
                   trans.tx_data, trans.rx_data);
        else 
           $error("SCOREBOARD FAIL: TX = %0h, RX = %0h",
                 trans.tx_data, trans.rx_data);
          end
          end
     endtask
     endclass
            
            
      
