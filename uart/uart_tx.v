module uart_tx(
input clk,
input rst,
input tx_start,
input baud16_tick,
input [7:0] tx_data,
output reg tx,
output reg busy);

parameter idle   = 2'b00,
          start  = 2'b01,
          data   = 2'b10,
          stop   = 2'b11;

reg [7:0] shift_reg;
reg [1:0] state;
reg [2:0] bit_index;
reg [3:0] bit_count;

always@(posedge clk) begin
  if(rst)begin
      state     <= idle;
      tx        <= 1'd1;
      busy      <= 1'd0;
      shift_reg <= 8'd0;
      bit_index <= 3'd0;
      bit_count <= 4'b0;
  end
  else begin
      
      case(state)
             idle  :  begin
                          tx        <= 1'b1;
                          busy      <= 1'b0;
			  bit_count <= 4'd0;

                        if(tx_start)begin
                           shift_reg <= tx_data;
                           busy      <= 1'b1;
                           bit_index <= 3'd0;
                           state     <= start;
                         end
		       end
                   
              start : begin
                           tx    <= 1'b0;
			   if(baud16_tick)begin
			    if(bit_count == 15) begin
	                        bit_count <= 4'd0;
                                state <= data;
			    end
                            else
			        bit_count <= bit_count + 1;
		        end
                       end
               
              data  : begin 
                           tx <= shift_reg[bit_index];

			   if(baud16_tick)begin
			    if(bit_count == 15) begin
	                       bit_count <= 4'd0;
                                                     
                             if(bit_index == 3'd7)
                                state <= stop;
                             

                             else
                               bit_index <= bit_index + 3'd1;
		             end
			   else
		            bit_count <= bit_count + 1;
		       end
                      end
             
             stop  : begin
		      tx   <= 1'b1;
                       
		    if(baud16_tick)begin
		      if(bit_count == 15) begin
	                  bit_count <= 4'd0;
                          busy      <= 1'b0;
                          state     <= idle;
                     end
		     else
			bit_count <= bit_count + 1;
		     end
	            end
		default : state <= idle;
             endcase
          end
       end    
endmodule
