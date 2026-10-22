
program test(uart_if vif);
  environment env;
  initial begin 
    env= new(vif);
    env.test_run();
    #20ms;
    $finish;
    
  end
endprogram
