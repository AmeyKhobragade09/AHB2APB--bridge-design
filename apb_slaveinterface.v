`timescale 1ns / 1ps

module apb_slaveinterface(
            input Pwrite,
            input Penable,
            input [2:0] Pselx,
            input [31:0] Paddr,
            input [31:0] Pwdata,
            inout [31:0] Pdata,         //Tristate Buffer for read and write bus
            output [31:0] Paddr_out,
            output [31:0] Pwdata_out,
            output Pwrite_out,
            output Penable_out,
            output [2:0] Pselx_out,
            output reg [31:0] Prdata
            );
            
            assign Pwrite_out = Pwrite;
            assign Penable_out = Penable;
            assign Paddr_out = Paddr;
            assign Pwdata_out = Pwdata;
            assign Pselx_out = Pselx;
            
            always@(*)
            if(Penable && !Pwrite)
                Prdata = $random;
            else
                Prdata = 32'bx;
            
            assign Pdata = (Pwrite)?Pwdata:Prdata;
                    
endmodule
