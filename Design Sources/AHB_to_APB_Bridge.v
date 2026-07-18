`timescale 1ns / 1ps

module AHB_to_APB_Bridge(
    //AHB SIGNALS
    input HCLK, HRESETn, HREADYin, HWRITE, HSELAPB, 
    input [31:0] HWDATA, HADDR,
    input [1:0] HTRANS,
    output reg HREADYout, HRESP,
    output reg [31:0] HRDATA,
    
    //APB SIGNALS
    input [31:0] PRDATA,
    output reg PENABLE, PWRITE, 
    output [3:0] PSELx,
    output reg [31:0] PWDATA, PADDR,
    output reg [2:0] state_in
    );
    
    //W => WRITE
    //R => READ
    //P => PIPLINED
    
    parameter       IDLE = 3'b000;  //state number 0
    parameter       READ = 3'b001;  //state number 1
    parameter   R_ENABLE = 3'b011;  //state number 2
    parameter      WRITE = 3'b111;  //state number 3
    parameter   W_ENABLE = 3'b110;  //state number 4
    
    //CHECKING SIGNAL VALIDITY
    reg valid;
    reg [31:0] HADDR_TEMP;
    
    //FSM
    reg [2:0] state = IDLE, next_state;
    reg AD_clk;         // ADDRESS DECODER CLK FOR CLK GATING
    
    always @(*)begin
        if(~HRESETn) state <= IDLE;
        else state <= next_state;
    end
    
    always @(posedge HCLK) begin
        case(state)
            IDLE : begin
                HREADYout <= 1'b1;
                HRESP <= 1'b0;
                PENABLE <= 1'b0;
                state_in <= 3'b0;
                    
                //NEXT STATE LOGIC
                if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b0)begin //READ TRANSFER
                    next_state <= READ;
                    AD_clk <= 1'b1;
                    HADDR_TEMP <= HADDR;
                    HREADYout <= 1'b0;
                end
                else if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b1)begin //WRITE TRANSFER
                    next_state <= WRITE;
                    AD_clk <= 1'b1;
                    HADDR_TEMP <= HADDR;
                    HREADYout <= 1'b0;
                end
                else begin                                      //NO TRANSFER
                    next_state <= IDLE;
                    AD_clk <= 1'b0;             //DISABLE THE CLK FOR ADDRESS DECODER
                end
            end
                
            READ : begin
                //STEUP PHASE
                HREADYout <= 1'b1;    //TELLING AHB MASTER, BRIDGE IS READY FOR NEXT TRANSFER
                PWRITE <= 1'b0;       //TELLING APB SLAVE, IT'S A READ TRANSER,
                PENABLE <= 1'b0;
                PADDR <= HADDR_TEMP;  //SENDING THE ADDRESS OF SLAVE TO APB'S ADDRESS DECODER  
                state_in <= 3'b01;
                    
                next_state <= R_ENABLE;
            end
                
            R_ENABLE : begin
                //ENABLE PHASE
                PENABLE <= 1'b1;                
                HRDATA <= PRDATA;   //SENDING DATA FROM APB TO AHB
                state_in <= 3'b010;
                    
                //NEXT STATE LOGIC
                if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b0)begin //READ TRANSFER
                    next_state <= READ;
                    HADDR_TEMP <= HADDR;
                    AD_clk <= 1'b1;
                    HREADYout <= 1'b0;
                end
                else if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b1)begin //WRITE TRANSFER
                    next_state <= WRITE;
                    HADDR_TEMP <= HADDR;
                    HREADYout <= 1'b0;
                end
                else begin                                      //NO TRANSFER
                    next_state <= IDLE;
                    AD_clk <= 1'b0;
                end
           end
                
           WRITE : begin
                HREADYout <= 1'b1;    //TELLING AHB MASTER, BRIDGE IS READY FOR NEXT TRANSFER
                PWRITE <= 1'b1;       //TELLING APB SLAVE, IT'S A WRITE TRANSFER
                PENABLE <= 1'b0;
                PADDR <= HADDR_TEMP;
                PWDATA <= HWDATA;
                state_in <= 3'b011;
                    
                next_state <= W_ENABLE;
           end
                
           W_ENABLE : begin
                PENABLE <= 1'b1;
                state_in <= 3'b100;
                    
                if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b0)begin //READ TRANSFER
                    next_state <= READ;
                    HADDR_TEMP <= HADDR;
                    HREADYout <= 1'b0;
                end
                else if(HSELAPB && HREADYin && (HTRANS == 2'b11 || HTRANS == 2'b10) && HWRITE == 1'b1)begin //WRITE TRANSFER
                    next_state <= WRITE;
                    HADDR_TEMP <= HADDR;
                    HREADYout <= 1'b0;
                end
                else begin
                    next_state <= IDLE;
                    AD_clk <= 1'b0;
                end
           end
        
        endcase
    end
    
    //ADDRESS DECODER MODULE WITH CLOCK GATING
    Address_Decoder AD(AD_clk & HCLK, HADDR_TEMP, PSELx);
    
endmodule
