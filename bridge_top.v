`timescale 1ns / 1ps

module bridge_top(
        input Hclk,
        input Hresetn,
        input Hwrite,
        input Hreadyin,
        input [1:0] Htrans,
        input [31:0] Haddr,
        input [31:0] Hwdata,
        input [31:0] Prdata,
        output Pwrite,
        output Penable,
        output [2:0] Pselx,
        output [31:0] Paddr,
        output [31:0] Pwdata,
        output Hreadyout,
        output [1:0] Hresp,
        output [31:0] Hrdata
        );
        
        wire [31:0] H_addr1,H_addr2,H_wdata1,H_wdata2,H_addrw;
        wire Hwritereg,valid;
        wire [2:0] Temp_selx;
        
        ahb_slave AHB_SLAVE(.Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin), .Htrans(Htrans), .Haddr(Haddr), .valid(valid), .Hwdata(Hwdata), .H_addr1(H_addr1), .H_addr2(H_addr2), .H_wdata1(H_wdata1), .H_wdata2(H_wdata2), .H_addrw(H_addrw), .Hwritereg(Hwritereg), .Temp_selx(Temp_selx), .Hreadyout(Hreadyout));
        ahb_fsmcontrol AHB_FSMCONTROL(.Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hwritereg(Hwritereg), .valid(valid), .H_addr1(H_addr1), .H_addr2(H_addr2), .H_wdata1(H_wdata1), .H_wdata2(H_wdata2), .H_addrw(H_addrw), .Prdata(Prdata), .Temp_selx(Temp_selx), .Hresp(Hresp), .Hreadyout(Hreadyout), .Pwrite(Pwrite), .Penable(Penable), .Pselx(Pselx), .Paddr(Paddr), .Pwdata(Pwdata), .Hrdata(Hrdata));
        
endmodule
