class monitor;
   virtual uart_if.MONITOR vif;
   mailbox mon2scb;  
   transaction trans;
  
 covergroup cg;
  cover_reset : coverpoint vif.cb_monitor.reset;
  cover_start : coverpoint vif.cb_monitor.tx_start;
  cover_busy : coverpoint vif.cb_monitor.tx_busy;
  cover_ready : coverpoint vif.cb_monitor.rx_ready;
  cross cover_reset , cover_start;
  cross cover_start , cover_busy;
 endgroup

  function new (virtual uart_if.MONITOR vif, mailbox mon2scb);
    this.mon2scb = mon2scb;
    this.vif = vif;
    cg= new();
  endfunction 
  
  task run ();
    forever begin 
      @(vif.cb_monitor);
      trans = new();
      trans.reset    = vif.cb_monitor.reset;
      trans.tx_start = vif.cb_monitor.tx_start;
      trans.tx_data  = vif.cb_monitor.tx_data;
      trans.rx_data  = vif.cb_monitor.rx_data;
      trans.rx_ready = vif.cb_monitor.rx_ready;
       trans.tx_busy  = vif.cb_monitor.tx_busy;
       //trans.display();
       cg.sample();
       mon2scb.put(trans);
    end
  endtask
endclass
      
      
      
    
