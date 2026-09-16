`timescale 1ns/100ps

module top();
bit clk;
always #5 clk = ~clk;

interf i(clk);
game_counter g(i.dut);
test t(i.tb);

endmodule
