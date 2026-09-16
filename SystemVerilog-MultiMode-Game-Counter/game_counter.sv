`timescale 1ns/100ps

module game_counter (interf.dut i);
	import game_pkg::*;

    logic [3:0] next_count;
    always_comb begin
        if (i.init) begin
            next_count = i.init_value;
        end else begin
            case (i.s)
                count_up:   next_count = i.count + 4'd1;
                count_up2:  begin 
								if(i.count==4'b1110)
							    	next_count = i.count + 4'd1;
								else
									next_count = i.count + 4'd2;
							end
                count_down:  next_count = i.count - 4'd1;
                count_down2: begin 
								if(i.count==4'b0001)
							    	next_count = i.count - 4'd1;
								else
									next_count = i.count - 4'd2;
							 end
                default:     next_count = i.count;
            endcase
        end
    end

    
    always_ff @(posedge i.clk or posedge i.rst) begin
        if (i.rst) begin
            // Asynchronous Reset
            i.count        <= 4'b0000;
            i.winner       <= 1'b0;
            i.loser        <= 1'b0;
            i.winner_count <= 4'b0000;
            i.loser_count  <= 4'b0000;
            i.gameover     <= 1'b0;
            i.who          <= 2'b00;
        end 
        else if (i.gameover) begin 
            // Synchronous Clear
            i.count        <= 4'b0000;
            i.winner       <= 1'b0;
            i.loser        <= 1'b0;
            i.winner_count <= 4'b0000;
            i.loser_count  <= 4'b0000;
            i.gameover     <= 1'b0;
            i.who          <= 2'b00; 
        end 
        else begin
            
            i.count <= next_count;
            
            
            i.winner <= (next_count == 4'b1111) && (i.count != 4'b1111) && (i.count != 4'b0000);
            i.loser  <= (next_count == 4'b0000) && (i.count != 4'b0000) && (i.count != 4'b1111);

           
            if ((next_count == 4'b1111) && (i.count != 4'b1111) && (i.count != 4'b0000)) begin
                i.winner_count <= i.winner_count + 1'b1;
                if (i.winner_count == 4'd14) begin 
                    i.gameover <= 1'b1;
                    i.who      <= 2'b10;
                end
            end
            
            if ((next_count == 4'b0000) && (i.count != 4'b0000) && (i.count != 4'b1111)) begin
                i.loser_count <= i.loser_count + 1'b1;
                if (i.loser_count == 4'd14) begin
                    i.gameover <= 1'b1;
                    i.who      <= 2'b01;
                end
            end
        end
    end

endmodule
