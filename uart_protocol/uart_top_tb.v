module uart_top_tb;
reg clk;
reg rst;

//tx
reg tx_start;
reg[7:0]tx_data;
wire tx;
wire busy;

//rx
reg rx;
wire [7:0]rx_data;
wire rx_done;


uart_top dut (.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.busy(busy),.rx(tx),.rx_data(rx_data),.rx_done(rx_done));

initial begin
clk=0;
forever #10 clk = ~clk;
end

initial begin
$display("simulation started");


$dumpfile("wave.vcd");
$dumpvars(0,uart_top_tb);

$monitor ("time=%0t clk=%b baud_tick=%b tx_state=%b rx_state=%b tx_start=%b tx_data=%b tx=%b send_bit=%b  busy=%b  rx=%b rx_data=%b rx_done=%b",$time,clk,dut.baud_connect,dut.dut2.state,dut.dut3.state,tx_start,tx_data,tx,dut.dut2.bit_index,dut.dut2.shift_reg,busy,rx,rx_data,rx_done);

#20;

clk=0;
rst=1;
tx_start=0;
tx_data=8'h0;
rx=0;
//data 1
#20;
rst=0;
@(posedge clk); 
tx_start=1;
tx_data=8'b11001011;
 
@(posedge clk);
tx_start=0;


wait(rx_done);

if(rx_data == 8'b11001011)
     $display("pass : received = %b ",rx_data);
else
     $display("fail : received = %b",rx_data);
wait(busy == 0);
#200;

//data 2
#10;
@(posedge clk); 
tx_start=1;
tx_data=8'b11001111;
 
@(posedge clk);
tx_start=0;


wait(rx_done);

if(rx_data == 8'b11001111)
     $display("pass : received = %b ",rx_data);
else
     $display("fail : received = %b",rx_data);
wait(busy == 0);
#100;
$finish;
end
endmodule

