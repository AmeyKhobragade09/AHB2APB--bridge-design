`timescale 1ns / 1ps

module ahb_slave(
        input Hclk,
        input Hresetn,
        input Hwrite,
        input Hreadyin,
        input [1:0] Htrans,
        input [31:0] Haddr,
        input [31:0] Hwdata,
        input Hreadyout,
        output valid,
        output reg [31:0] H_addr1,
        output reg [31:0] H_wdata1,
        output reg [31:0] H_addr2,
        output reg [31:0] H_wdata2,
        output reg [31:0] H_addrw,
        output reg Hwritereg,
        output reg [2:0] Temp_selx
        );
        reg Hwrite1;
        // SEQ BLOCK: This block implements the pipelinning stage of address and data phases.
        always@(posedge Hclk,negedge Hresetn)
            if(!Hresetn)
            begin
                H_addr1<=0;
                H_addr2<=0;
                H_wdata1<=0;
                H_wdata2<=0;
                Hwritereg<=0;
                H_addrw<=0;
            end
            else
            begin
                if(Hreadyout)
                begin
                    H_addr1<=Haddr;
                    H_addr2<=H_addr1;
                    H_wdata1<=Hwdata;
                    H_wdata2<=H_wdata1;
                    Hwrite1<=Hwrite;
                    Hwritereg<=Hwrite1;
                    H_addrw<=H_addr2;
                end
            end
        //Combo Block: Valid Logic    
        assign valid = ( (Haddr[31:24] >= 8'h80 && Haddr[31:24]<=8'h8C) && Htrans[1] == 1'b1 && Hreadyin )?1'b1:1'b0;

        //Combo Block: Temp_Sel Logic
        always@(Haddr)
            if(Haddr[31:24]>=8'h80 && Haddr[31:24]<8'h84)
                Temp_selx = 3'b001;
            else if(Haddr[31:24]>=8'h84 && Haddr[31:24]<8'h88)
                Temp_selx = 3'b010;
            else if(Haddr[31:24]>=8'h88 && Haddr[31:24]<8'h8C)
                Temp_selx = 3'b100; 
            else
                Temp_selx = 3'b000;
        
endmodule
