module UART_db;

reg clk, rst_n, rx;
wire [7:0] final_byte;
wire byte_ready;


UART_RX dut(
    .clk(clk),
    .rst_n(rst_n),
    .rx(rx),
    .final_byte(final_byte),
    .byte_ready(byte_ready)
);

initial clk = 0;
always #5 clk = ~clk;

localparam BIT_TIME = 100;



initial begin

    $dumpfile("UART.vcd");
    $dumpvars(0, UART_db);
    $monitor(" [time = %0t] rst_n = %b rx = %b byte_ready = %b final_byte = %b", $time, rst_n, rx, byte_ready, final_byte);

    rst_n = 0;
    rx = 1;


    #50;


    rst_n = 1;

    #50;

    rx = 0; #BIT_TIME;

    rx = 0; #BIT_TIME;

    rx = 0; #BIT_TIME;

    rx = 1; #BIT_TIME;

    rx = 0; #BIT_TIME;

    rx = 1; #BIT_TIME;

    rx = 1; #BIT_TIME;

    rx = 0; #BIT_TIME;

    rx = 1; #BIT_TIME;

    rx = 1; #BIT_TIME;

    $finish;

    
end


endmodule