class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  mailbox gen2drv;
  mailbox mon2scb;
  virtual uart_if vif;
  
  function new(virtual uart_if vif);
    this.vif= vif;
    gen2drv=  new();
    mon2scb = new();
    gen = new(gen2drv);
    drv = new(gen2drv,vif.DRIVER);
    mon = new(vif.MONITOR , mon2scb);
    scb = new(mon2scb);
  endfunction
  
  task test_run();
    fork 
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
    
  endtask
endclass
