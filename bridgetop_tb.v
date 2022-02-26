`timescale 1ns / 1ps

module bridgetop_tb();
        
        parameter [2:0] SINGLE = 3'd0,INCR = 3'd1, WRAP4 = 3'd2, INCR4 = 3'd3, WRAP8 = 3'd4, INCR8 = 3'd5, WRAP16 = 3'd6, INCR16 = 3'd7;
        
        reg Hclk;
        reg Hresetn;
        reg [2:0] Hburst;
        reg [2:0] Hsize;
        wire[31:0] Hrdata;
        wire[1:0] Hresp;
        wire Hreadyout;
        
        wire Hwrite;
        wire Hreadyin;
        wire [1:0] Htrans;
        wire [31:0] Haddr;
        wire [31:0] Hwdata;

        wire Pwrite;
        wire Penable;
        wire [2:0] Pselx;
        wire [31:0] Paddr;
        wire [31:0] Pwdata;
        wire [31:0] Prdata;
        
        wire [31:0] Paddr_out;
        wire [31:0] Pwdata_out;
        wire Pwrite_out;
        wire Penable_out;
        wire [2:0] Pselx_out;
        wire [31:0] Pdata;
        
        ahb_master MASTER (.Hclk(Hclk), .Hresetn(Hresetn), .Hresp(Hresp), .Hreadyout(Hreadyout), .Hrdata(Hrdata), .Hwrite(Hwrite), .Hreadyin(Hreadyin), .Htrans(Htrans), .Haddr(Haddr), .Hwdata(Hwdata), .Hburst(Hburst), .Hsize(Hsize));
        
        bridge_top BRIDGE_TOP(.Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin), .Htrans(Htrans), .Haddr(Haddr), .Hwdata(Hwdata), .Pwrite(Pwrite), .Penable(Penable), .Pselx(Pselx), .Paddr(Paddr), .Pwdata(Pwdata), .Hreadyout(Hreadyout), .Hresp(Hresp), .Hrdata(Hrdata), .Prdata(Prdata));

        apb_slaveinterface SLAVE(.Pwrite(Pwrite), .Penable(Penable), .Pselx(Pselx), .Paddr(Paddr), .Pwdata(Pwdata), .Prdata(Prdata), .Pwrite_out(Pwrite_out), .Penable_out(Penable_out), .Pselx_out(Pselx_out), .Paddr_out(Paddr_out), .Pwdata_out(Pwdata_out), .Pdata(Pdata));
        
        initial begin
        Hclk = 1'b0;
        Hresetn = 1'b1;
        forever #10 Hclk = ~Hclk;
        end
        
        initial begin 
        
            Hresetn = 1'b0;
            #20
            Hresetn = 1'b1;
            Hburst = SINGLE;
            Hsize = 3'd0;
            MASTER.write;
            #10
            Hburst = SINGLE;
            Hsize = 3'd0;
            MASTER.read;
            #10
            Hburst = INCR4;
            Hsize = 3'd1;
            MASTER.write;
            #10
            Hburst = INCR8;
            Hsize = 3'd1;
            MASTER.read;
            #10
            MASTER.b2b;
            #100 $finish;
        
        end 
        
        //If burst, addr will be sent only if hreadyout is 1      
        
endmodule
