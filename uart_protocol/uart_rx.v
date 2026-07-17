module uart_rx(
input clk,
input rst,
input rx,
input baud16_tick,
output reg [7:0]rx_data,
output reg rx_done);

parameter idle   = 2'b00,
          start  = 2'b01,
          data   = 2'b10,
          stop   = 2'b11;

reg [1:0] state;
reg [7:0]shift_reg;
reg [2:0]bit_index;
reg [3:0]bit_count;

always@(posedge clk)begin
if(rst)begin
   rx_data   <= 8'd0;
   rx_done   <= 1'b0;
   state     <= idle;
   bit_index <= 3'd0;
   shift_reg <= 8'd0;
   bit_count <= 4'd0;
end
else begin
       rx_done <= 1'b0;

//idle state 

 if(state == idle)begin
    if(rx == 0)begin
      bit_count <=0;
      state     <= start;
     end
  end
else if(baud16_tick) begin
    case(state)
            start  : begin
		      if (bit_count == 7 ) begin
			  bit_count <= 0;
			  if (rx == 0)begin
		           bit_index <= 3'd0;
                           state     <= data;
		          end
                         else 
			    state <= idle;
		      end
		      else begin
			bit_count <= bit_count + 1;
                     end
	           end
       
            data   : begin
		       if(bit_count ==15)begin
                          bit_count <= 0;

                         shift_reg [bit_index] <= rx;

                         if(bit_index == 3'd7)
                           state <= stop;
		         else
                            bit_index <= bit_index + 3'd1;
	              end
		      else
			bit_count <= bit_count + 1;
	              
                     end

            stop : begin
		    if(bit_count == 15)begin
			bit_count <= 0;
                        
			if(rx == 1) begin
                          rx_data <= shift_reg;
                          rx_done <= 1'b1;
		       end
                        state   <= idle;
		    end
                    else
	             bit_count <= bit_count + 1;
	           
                 end
          default : state <= idle;

       endcase
     end
   end
 end
endmodule                 
