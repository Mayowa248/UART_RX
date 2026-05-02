module UART_RX(
    input wire clk, rst_n, rx,
    output reg [7:0] final_byte,
    output reg byte_ready
);


reg  [3:0] counter;
reg [2:0] index;
reg [1:0] current_state;
reg [7:0] new_byte;

localparam [1:0]  IDLE = 2'b00,
                  START = 2'b01,
                  DATA = 2'b10,
                  STOP = 2'b11;



always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= 0;
        index <= 0;
        byte_ready <= 0;
    end 

    else begin

        byte_ready <= 0;

        case (current_state)

            IDLE : begin
                if (rx == 0) begin
                    current_state <= START;
                end

            end 

            START : begin
                if (rx == 0) begin
                    counter <= counter + 1;
                    if (counter == 5) begin
                        current_state <= DATA;
                        counter <= 0;
                    end
                end
                else begin
                    counter <= 0;
                    current_state <= IDLE;
                end 
            end

            DATA : begin
                if (counter == 10) begin
                    new_byte[index] <= rx;
                    counter <= 0;
                    if(index == 7) begin
                        current_state <= STOP;
                        index <= 0;
                    end
                    else index <= index + 1;
                end
                else counter <= counter + 1;
            end

            STOP : begin
                if (counter == 10) begin
                    counter <= 0;
                    if (rx == 1) begin
                        final_byte <= new_byte;
                        byte_ready <= 1'b1;
                    end
                    current_state <= IDLE;
                end
                else counter <= counter + 1;
            end


            default: current_state <= IDLE;

        endcase 

    end








end


endmodule