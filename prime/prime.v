`timescale 1ns/1ps
module prime(
	input				         i_clk,
	input				         i_nrst,
   input                   i_valid,
	output	reg            o_accept,
	output	reg	[31:0]   o_prime
);


   parameter      SM_IDLE     = 0,
                  SM_NEW      = 1,
                  SM_TEST_A   = 2,
                  SM_TEST_B   = 3;

   reg   [1:0]    state;
   reg   [31:0]   a, b;
   wire  [31:0]   new_prime;
   wire  [63:0]   multiply;

   assign new_prime = o_prime + 2;
   assign multiply = a * b;


	always@(posedge i_clk or negedge i_nrst) begin
		if(!i_nrst) begin
         o_accept <= 1'b0;
		   o_prime  <= 'h1;
         state    <= SM_IDLE;
      end else begin
		   case(state)
            SM_IDLE: begin
                        o_accept <= 1'b0;
                        if(i_valid)
                           state    <= SM_NEW;
                     end
            SM_NEW: begin 
                        o_prime  <= new_prime; 
                        a        <= 1;
                        b        <= 1;
                        state    <= SM_TEST_B;
                     end
            SM_TEST_A:  begin
                           a     <= a + 1;
                           state <= SM_TEST_B; 
                        end
            SM_TEST_B:  begin
                           if(a == o_prime) begin          // Prime found
                              state    <= SM_IDLE;
                              o_accept <= 1'b1;
                           end else begin
                              if(multiply == o_prime) begin
                                 state <= SM_NEW;
                              end 
                              if(b == (o_prime - 1)) begin
                                 a = a + 1;
                                 b = 1;
                              end else begin
                                 b = b + 1;
                              end 
                           end

                        end

         endcase
      end
	end
endmodule
