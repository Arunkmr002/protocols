module baud_rate_generator #(
parameter clock_freq    = 50000000,
          baud_rate = 9600)(
input clk,
input rst,
output reg baud16_tick);

reg [15:0] counter;

localparam divisor = clock_freq /  (baud_rate * 16);

always@(posedge clk ) begin
if(rst)begin
   baud16_tick <= 0;
   counter     <= 0;
end
   else begin 
        if (counter == divisor - 1)begin
           counter     <= 0;
           baud16_tick <= 1;
        end
        else begin
            counter     <= counter + 1;
            baud16_tick <= 0;
    end
  end
 end
endmodule
