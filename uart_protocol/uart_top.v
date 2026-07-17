module uart_top(
input clk,
input rst,

//tx
input tx_start,
input [7:0]tx_data,
output  tx,
output  busy,

//rx
input rx,
output  rx_done,
output  [7:0]rx_data);

wire baud_connect;

baud_rate_generator  #(.clock_freq(160),.baud_rate(10))dut1 (.clk(clk),.rst(rst),.baud16_tick(baud_connect));

uart_tx dut2 (.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.baud16_tick(baud_connect),.tx(tx),.busy(busy));

uart_rx dut3(.clk(clk),.rst(rst),.rx(rx),.baud16_tick(baud_connect),.rx_done(rx_done),.rx_data(rx_data));

endmodule
