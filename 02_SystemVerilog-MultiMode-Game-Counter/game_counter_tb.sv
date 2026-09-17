`timescale 1ns/100ps

module test (interf.tb i);
    import game_pkg::*;

    task wait_cycles(int cycles);
        repeat(cycles) @(i.cb);
    endtask

    initial begin
        $display("==================================================");
        $display("= STARTING COMPREHENSIVE DIRECTED TESTS          =");
        $display("==================================================");

        // ---------------------------------------------------------
        // TEST 1: Asynchronous Reset Check
        // ---------------------------------------------------------
        $display("\n[TEST 1] Applying Asynchronous Reset...");
        @(i.cb);
        i.rst = 1'b1; 
        i.init = 1'b0; 
        i.s = count_up;
        wait_cycles(2);
        
        i.rst = 1'b0;
        wait_cycles(1);
        assert (i.cb.count == 4'd0) 
            $display("--> PASS: Reset works. cb.count = 0"); 
        else 
            $error("--> FAIL: TEST 1 Reset, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 2: Parallel Load (INIT = 10)
        // ---------------------------------------------------------
        $display("\n[TEST 2] Testing Parallel Load (INIT = 10)...");
        @(i.cb);
        i.init = 1'b1; 
        i.init_value = 4'd10;
        wait_cycles(1); 
        
        i.init = 1'b0;
        wait_cycles(1);
        assert (i.cb.count == 4'd10) 
            $display("--> PASS: INIT works. cb.count loaded with 10"); 
        else 
            $error("--> FAIL: TEST 2 INIT, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 3: count_up2 edge case (14 -> 15) & WINNER flag
        // ---------------------------------------------------------
        $display("\n[TEST 3] Testing count_up2 logic (14 -> 15)...");
        @(i.cb);
        i.init = 1'b1; 
        i.init_value = 4'd14;
        wait_cycles(1);
        
        i.init = 1'b0; 
        i.s = count_up2;
        wait_cycles(1); 
        
        assert (i.winner == 1'b1) 
            $display("--> PASS: WINNER flag is HIGH for one cycle"); 
        else 
            $error("--> FAIL: TEST 3 WINNER flag did not rise");
            
        wait_cycles(1);
        assert (i.cb.count == 4'd15) 
            $display("--> PASS: count_up2 safely reached 15"); 
        else 
            $error("--> FAIL: TEST 3 count_up2 logic, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 4: Overflow Protection (15 -> 0)
        // ---------------------------------------------------------
        $display("\n[TEST 4] Testing Overflow Protection (No LOSER on 15->0)...");
        @(i.cb);
        i.init = 1'b1; 
        i.init_value = 4'd15;
        wait_cycles(1);

        i.init = 1'b0;
        i.s = count_up; 
        wait_cycles(1); 
        
        assert (i.loser == 1'b0) 
            $display("--> PASS: LOSER flag remained LOW during overflow"); 
        else 
            $error("--> FAIL: TEST 4 False LOSER flag triggered");
            
        wait_cycles(1);
        assert (i.cb.count == 4'd0) 
            $display("--> PASS: Count successfully overflowed to 0"); 
        else 
            $error("--> FAIL: TEST 4 Overflow count, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 5: count_down2 edge case (1 -> 0) & LOSER flag
        // ---------------------------------------------------------
        $display("\n[TEST 5] Testing count_down2 logic (1 -> 0)...");
        @(i.cb);
        i.init = 1'b1; 
        i.init_value = 4'd1;
        wait_cycles(1);
        
        i.init = 1'b0; 
        i.s = count_down2;
        wait_cycles(1); 
        
        assert (i.loser == 1'b1) 
            $display("--> PASS: LOSER flag is HIGH for one cycle"); 
        else 
            $error("--> FAIL: TEST 5 LOSER flag did not rise");
            
        wait_cycles(1);
        assert (i.cb.count == 4'd0) 
            $display("--> PASS: count_down2 safely reached 0"); 
        else 
            $error("--> FAIL: TEST 5 count_down2 logic, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 6: Underflow Protection (0 -> 15)
        // ---------------------------------------------------------
        $display("\n[TEST 6] Testing Underflow Protection (No WINNER on 0->15)...");
        @(i.cb);
        i.init = 1'b1; 
        i.init_value = 4'd0;
        wait_cycles(1);

        i.init = 1'b0;
        i.s = count_down; 
        wait_cycles(1); 
        
        assert (i.winner == 1'b0) 
            $display("--> PASS: WINNER flag remained LOW during underflow"); 
        else 
            $error("--> FAIL: TEST 6 False WINNER flag triggered");
            
        wait_cycles(1);
        assert (i.cb.count == 4'd15) 
            $display("--> PASS: Count successfully underflowed to 15"); 
        else 
            $error("--> FAIL: TEST 6 Underflow count, count = %0d", i.cb.count);

        // ---------------------------------------------------------
        // TEST 7: GAMEOVER & Synchronous Clear (15 Wins Simulation)
        // ---------------------------------------------------------
        $display("\n[TEST 7] Testing GAMEOVER and Sync Clear (15 Wins)...");
        @(i.cb);
        i.rst = 1'b1; 
        wait_cycles(2);
        i.rst = 1'b0;
        
        for (int j = 0; j < 15; j++) begin
            i.init = 1'b1; 
            i.init_value = 4'd14;
            wait_cycles(1);
            
            i.init = 1'b0; 
            i.s = count_up;
            wait_cycles(1); 
        end
        
        // Check GAMEOVER immediately (No wait_cycles here to prevent auto-clear)
        assert (i.gameover == 1'b1) 
            $display("--> PASS: GAMEOVER flag is HIGH"); 
        else 
            $error("--> FAIL: TEST 7 GAMEOVER flag");
            
        assert (i.who == 2'b10) 
            $display("--> PASS: WHO flag indicates WINNER (10)"); 
        else 
            $error("--> FAIL: TEST 7 WHO flag is %b", i.who);
        
        // Wait 1 cycle for Sync Clear to execute, then 1 cycle to sample it
        wait_cycles(2); 
        assert (i.cb.count == 4'd0 && i.cb.winner_count == 4'd0) 
            $display("--> PASS: Synchronous Clear executed perfectly"); 
        else 
            $error("--> FAIL: TEST 7 Synchronous Clear");

        // ---------------------------------------------------------
        // TEST 8: Bounce Scenario (14 -> 15 -> 14 -> 15)
        // ---------------------------------------------------------
        $display("\n[TEST 8] Testing Bounce Scenario (winner_count increments twice)...");
        @(i.cb);
        i.rst = 1'b1; 
        wait_cycles(2);
        i.rst = 1'b0;

        i.init = 1'b1;
        i.init_value = 4'd14;
        wait_cycles(1);
        
        i.init = 1'b0;
        i.s = count_up; 
        wait_cycles(1);
        assert(i.winner == 1'b1) 
            $display("--> PASS: First WINNER flag is HIGH"); 
        else 
            $error("--> FAIL: TEST 8 First WINNER flag");
            
        wait_cycles(1); 

        i.s = count_down; 
        wait_cycles(2); 

        i.s = count_up; 
        wait_cycles(1);
        assert(i.winner == 1'b1) 
            $display("--> PASS: Second WINNER flag is HIGH"); 
        else 
            $error("--> FAIL: TEST 8 Second WINNER flag");
            
        wait_cycles(1); 
        assert(i.cb.winner_count == 4'd2) 
            $display("--> PASS: winner_count successfully incremented to 2"); 
        else 
            $error("--> FAIL: TEST 8 winner_count is %0d", i.cb.winner_count);

        // ---------------------------------------------------------
        // TEST 9: GAMEOVER by LOSER (15 Losses Simulation)
        // ---------------------------------------------------------
        $display("\n[TEST 9] Testing GAMEOVER by LOSER (15 Losses)...");
        @(i.cb);
        i.rst = 1'b1; 
        wait_cycles(2);
        i.rst = 1'b0;
        
        for (int j = 0; j < 15; j++) begin
            i.init = 1'b1; 
            i.init_value = 4'd1;
            wait_cycles(1);
            
            i.init = 1'b0; 
            i.s = count_down;
            wait_cycles(1); 
        end
        
        assert (i.gameover == 1'b1) 
            $display("--> PASS: GAMEOVER flag is HIGH"); 
        else 
            $error("--> FAIL: TEST 9 GAMEOVER flag");
            
        assert (i.who == 2'b01) 
            $display("--> PASS: WHO flag indicates LOSER (01)"); 
        else 
            $error("--> FAIL: TEST 9 WHO flag is %b", i.who);
        
        wait_cycles(2); 
        assert (i.cb.count == 4'd0 && i.cb.loser_count == 4'd0) 
            $display("--> PASS: Synchronous Clear executed perfectly"); 
        else 
            $error("--> FAIL: TEST 9 Synchronous Clear");

        $display("\n==================================================");
        $display("= ALL 9 TESTS FINISHED SUCCESSFULLY              =");
        $display("==================================================");
        $stop;
    end

endmodule
