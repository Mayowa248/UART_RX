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

parameter [3:0] CYCLE_PER_BIT = 4'd10,
                HALF_CYCLE_PER_BIT = 4'd5;

always @(posedge clk, negedge rst_n) begin
    
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= 4'd0;
        index <= 3'd0;
        byte_ready <= 1'd0;
        new_byte <= 8'd0;
        final_byte <= 8'd0;
    end 

    else begin

        byte_ready <= 1'd0;
        new_byte <= new_byte;
        final_byte <= final_byte;
        current_state <= current_state;
        counter <= counter;
        index <= index;

        case (current_state)

            IDLE : begin
                counter <= 4'd0;
                index   <= 3'd0;

                if (rx == 1'd0) begin
                    current_state <= START;
                end
                else current_state <= IDLE;

            end 

            START : begin
                if (rx == 1'd0) begin
                    if (counter == HALF_CYCLE_PER_BIT - 4'd1) begin
                        current_state <= DATA;
                        counter <= 4'd0;
                    end
                    else counter <= counter + 4'd1;
                end
                else begin
                    counter <= 4'd0;
                    current_state <= IDLE;
                end 
            end

            DATA : begin
                if (counter == CYCLE_PER_BIT - 4'd1) begin
                    new_byte[index] <= rx;
                    counter <= 4'd0;
                    if(index == 3'd7) begin
                        current_state <= STOP;
                        index <= 3'd0;
                    end
                    else index <= index + 3'd1;
                end
                else counter <= counter + 4'd1;
            end

            STOP : begin
                if (counter == CYCLE_PER_BIT - 4'd1) begin
                    counter <= 4'd0;
                    if (rx == 1'd1) begin
                        final_byte <= new_byte;
                        byte_ready <= 1'b1;
                    end
                    current_state <= IDLE;
                end
                else counter <= counter + 4'd1;
            end


            default: current_state <= IDLE;

        endcase 

    end


end


endmodule