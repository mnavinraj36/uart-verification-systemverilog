class generator;
  transaction tr ;
  mailbox gen2drv ;
  
  function  new (mailbox gen2drv);
   this.gen2drv = gen2drv;
  endfunction 
  
  task run();
    repeat(20)begin
      tr = new();
     if (!tr.randomize()) begin
    $error("RANDOMIZATION FAILED");
    end
    tr.display();
      gen2drv.put(tr);
    end 
   
  endtask
      
endclass    
  
