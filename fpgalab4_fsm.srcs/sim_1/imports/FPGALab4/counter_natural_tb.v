module counter_natural_test;

    reg reset, pause, reverse;                           // these are inputs to "circuit under test"
    reg       clk = 0;
    always #5 clk = !clk;
    wire [3:0] out;                        // use "reg" not "wire" so can assign a value
                                            // wires for the outputs of "circuit under test"

    counter_natural cn(out, reverse, pause, clk, reset);                        // the circuit under test
    
    initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
        $dumpfile("counter_natural.vcd");                  // name of dump file to create
        $dumpvars(0, counter_natural_test);                 // record all signals of module "sc_test" and sub-modules
                                              // remember to change "sc_test" to the correct
                                              // module name when writing your own test benches
        
        // test all four input combinations
        // remember that 2 inputs means 2^2 = 4 combinations
        // 3 inputs would mean 2^3 = 8 combinations to test, and so on
        // this is very similar to the input columns of a truth table
        # 10;
        reverse = 1'b0;
        pause = 1'b0;
        reset = 1'b1;
        # 10;
        reverse = 1'b0;
        pause = 1'b0;
        reset = 1'b0;
        # 50
        pause = 1'b1;
        # 50
        pause = 1'b0;
        # 20
        reset = 1'b1;
        # 20
        reset = 1'b0;            
        # 200;
        reverse = 1'b1;
        # 200;


                     // set initial values and wait 10 time units
                     // change inputs and then wait 10 time units
                     // as above
        $finish;                              // end the simulation
    end                      
endmodule 