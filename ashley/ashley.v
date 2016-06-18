module ashley(
   input          clk, 
   output   reg   led_d1_top, 
   output   reg   led_d2_right, 
   output   reg   led_d3_bottom, 
   output   reg   led_d4_left, 
   output   reg   led_d5_middle
);

   reg   [33:0]   count;
   
   // 12 Mhz clock
   always@(posedge clk) begin
      count <= count + 1;
      case(count)
         34'd12000000:  begin
                           led_d5_middle  <= ~led_d5_middle;
                           led_d4_left    <= 1'b0;
                           led_d1_top     <= 1'b1;
                           count          <= 0;
                        end
         34'd3000000:   begin
                           led_d1_top     <= 1'b0;
                           led_d2_right   <= 1'b1;
                        end
          34'd6000000:  begin
                           led_d2_right   <= 1'b0;
                           led_d3_bottom  <= 1'b1;
                        end
         34'd9000000:   begin
                           led_d3_bottom  <= 1'b0;
                           led_d4_left    <= 1'b1;
                        end

      endcase
   end
   
endmodule 
