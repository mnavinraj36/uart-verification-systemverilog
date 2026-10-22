class driver;
  transaction tr ;
  mailbox gen2drv;
  virtual uart_if.DRIVER vif ;
  
 function new(mailbox gen2drv, virtual uart_if.DRIVER vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  task run();
    forever begin
    gen2drv.get(tr);
    if (tr.reset)begin
     vif.cb_driver.reset    <= 1'b1;
     vif.cb_driver.tx_start <= 1'b0;
      vif.cb_driver.tx_data  <= 8'd0;
      
      @(vif.cb_driver);
      vif.cb_driver.reset <= 1'b0;
      
    end
    else begin
       vif.cb_driver.reset    <= 1'b0;
       vif.cb_driver.tx_data  <=  tr.tx_data;
        vif.cb_driver.tx_start <= tr.tx_start;
     
      @(vif.cb_driver);
      vif.cb_driver.tx_start <=1'b0;
      
      if (tr.tx_start)begin
        wait(vif.cb_driver.tx_busy == 1'b1);
        wait(vif.cb_driver.tx_busy == 1'b0);
      end
    end
    end
  endtask
endclass
     
      

    
