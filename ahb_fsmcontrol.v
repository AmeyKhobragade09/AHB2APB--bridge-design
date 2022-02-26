`timescale 1ns / 1ps

module ahb_fsmcontrol(
            input Hclk,
            input Hresetn,
            input Hwrite,
            input Hwritereg,
            input valid,
            input [31:0] H_addr1,
            input [31:0] H_addr2,
            input [31:0] H_addrw,
            input [31:0] H_wdata1,
            input [31:0] H_wdata2,
            input wire [31:0] Prdata,
            input [2:0] Temp_selx,
            output reg [1:0] Hresp,
            output reg Hreadyout,
            output reg Pwrite,
            output reg Penable,
            output reg [2:0] Pselx,
            output reg [31:0] Paddr,
            output reg [31:0] Pwdata,
            output [31:0] Hrdata
            );

    parameter [2:0] ST_IDLE =3'd0,ST_READ=3'd1,ST_RENABLE=3'd2,ST_WWAIT=3'd3,ST_WRITE=3'd4,ST_WRITEP=3'd5,ST_WENABLEP=3'd6,ST_WENABLE=3'd7;
    reg [2:0] state,next_state;
    reg [2:0] Pselx_w,Pselx_we,Pselx_f,Pselx_f1;
    reg b2b;
    
    always@(posedge Hclk,negedge Hresetn)
    if(~Hresetn)
        state<=0;
    else
        state<=next_state;
    
    always@(posedge Hclk)
        Hresp = 2'd0;

    always@(*)
        case(state)
            ST_IDLE: if(valid == 1'b1 && Hwrite == 1'b1)
                        next_state = ST_WWAIT;
                     else if(valid == 1'b1 && Hwrite == 1'b0)
                        next_state = ST_READ;
                     else
                        next_state = ST_IDLE;
                        
            ST_READ: next_state =ST_RENABLE;
            
            ST_RENABLE: if(valid == 1'b1 && Hwrite == 1'b0)
                            next_state = ST_READ;
                        else if(valid == 1'b1 && Hwrite == 1'b1)
                            next_state = ST_WWAIT;
                        else
                            next_state = ST_IDLE;
                            
            ST_WWAIT: next_state = (valid)?ST_WRITEP:ST_WRITE;
            
            ST_WRITE: next_state = (valid)?ST_WENABLEP:ST_WENABLE;
            
            ST_WRITEP: next_state = ST_WENABLEP;
            
            ST_WENABLEP: next_state = (Hwritereg)?((valid)?ST_WRITEP:ST_WRITE):ST_READ;
            
            ST_WENABLE: next_state = (valid)?((Hwrite)?ST_WWAIT:ST_READ):ST_IDLE;
            
        endcase  

    always@(posedge Hclk,negedge Hresetn)
        if(~Hresetn)
            begin
                Pselx<=3'd0;
                Penable<=1'b0;
                Pwrite<=1'bx;
                Pselx_w<=3'd0;
                Pselx_f<=3'd0;
                Pselx_f1<=3'd0;
                
            end
        else
            case(state)
                ST_IDLE:    begin
                                Pselx <= 3'd0;
                                Penable <= 1'b0;
                                Pwrite <= 1'bx;
                                Pselx_w<=Temp_selx;
                                Pselx_f<=3'd0;
                                Pselx_f1<=3'd0;
                                Paddr<=32'dx;
                                Pwdata<=32'dx;
                            //Check for Pwrite
                            end 
                ST_READ:    begin
                                Pwrite <= 1'b0;
                                Pselx<=Pselx_w;
                                Pselx_f <= Pselx_w;
                                if(b2b)
                                    Paddr<=H_addr2;
                                else
                                    Paddr<=H_addr1;
                                Pselx_f1<=3'd0;
                                Pselx_w<=Temp_selx;
                                Penable <= 1'b0;
                                Pwdata<=32'dx;
                               
                            end
                ST_RENABLE: begin
                                Penable <= 1'b1;
                                Pselx<=Pselx_f;
                                Pselx_f<=Pselx_w;
                                Pwrite <= 1'b0;
                                Pselx_w<=Temp_selx;
                                Pselx_f1<=3'd0;
                                //Modification for burst 
                            end
                ST_WWAIT:   begin
                                Penable <= 1'b0;  //Wait State for getting Hwdata
                                Pselx <= 3'd0;
                                Pselx_f<=Pselx_w;
                                Pselx_f1<=3'd0;
                                Pselx_w<=3'd0;
                                Pwrite <= 1'bx;
                                Paddr<=32'dx;
                                Pwdata<=32'dx;
                            end
                ST_WRITE:   begin
                                Pselx <= Pselx_f;
                                Pselx_f1<=Pselx_f;
                                Pselx_f<=3'd0;
                                Pselx_w<=3'd0;
                                Pwrite <= 1'b1;
                                Penable <= 1'b0;
                                Paddr<=H_addr2;
                                Pwdata<=H_wdata1;
                            end
                ST_WRITEP:  begin
                                Pselx <= Temp_selx;
                                Pselx_f1<=3'd0;
                                Pselx_f<=3'd0;
                                Pselx_w<=Temp_selx;
                                Pwrite <= 1'b1;
                                Penable <= 1'b0;
                                Paddr<=H_addr2;
                                Pwdata<=H_wdata1;
                                //Padd pdata and haddr logic for burst
                            end
                ST_WENABLE: begin
                                Penable <= 1'b1;
                                Pselx <= Pselx_f1;
                                Pselx_f<=3'd0;
                                Pselx_f1<=3'd0;
                                Pselx_w<=3'd0;
                                Pwrite <= 1'b1;
                            end
                ST_WENABLEP:begin
                                Penable <= 1'b1;
                                Pselx <= Pselx_w;
                                Pselx_f<=Pselx_w;
                                Pselx_w<=0;
                                Pwrite <= 1'b1;
                                //Pselx paddr pwdata haddr and hwdata logic for burst
                            end
            endcase
        
   always@(posedge Hclk)
        if(state == ST_WRITE | state == ST_WRITEP |state == ST_READ | (state == ST_WENABLEP && next_state == ST_READ) | (state == ST_WRITE && Hwritereg == 1'b0))
            begin//if(state == ST_IDLE | state == ST_RENABLE | state == ST_WENABLE | state == ST_WENABLEP)
            Hreadyout <= 1'b0;
            if(state == ST_WENABLEP && next_state == ST_READ)
                b2b <= 1'b1;
            else
                b2b <= 1'b0;
            end
        else
            {Hreadyout,b2b} <= {1'b1,1'b0};
   
   assign Hrdata = Prdata;
   

    
endmodule
