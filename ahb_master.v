`timescale 1ns / 1ps

module ahb_master(
        input Hclk,
        input Hresetn,
        input [31:0] Hrdata,
        input [1:0] Hresp,
        input [2:0] Hburst,
        input [2:0] Hsize,
        input Hreadyout,
        output reg Hwrite,
        output reg Hreadyin,
        output reg [1:0] Htrans,
        output reg [31:0] Haddr,
        output reg [31:0] Hwdata
        );
        parameter cycle = 20;
        reg [10:0] i;
        reg [1:0] Hsize_temp;
        parameter [2:0] SINGLE = 3'd0,INCR = 3'd1, WRAP4 = 3'd2, INCR4 = 3'd3, WRAP8 = 3'd4, INCR8 = 3'd5, WRAP16 = 3'd6, INCR16 = 3'd7;
        
        always@(*)
            case(Hsize)
                3'd0: Hsize_temp = 2'd1;
                3'd1: Hsize_temp = 2'd2;
                default: Hsize_temp = 2'd1;
            endcase

        
        task write;
            begin
                Hwrite = 1'b1;
                Hreadyin = 1'b1;
                Htrans = 2'b10; //Non Seq
                Haddr = 32'h88008080;
                #(cycle)
                case(Hsize)
                    3'd0: 	case(Hburst)
                                SINGLE: begin
                                            Hreadyin = 1'b0;
                                            Haddr = 32'bx;
                                            Hwdata = $random;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = Haddr + 1'b1;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:2],Haddr[1:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:2],Haddr[1:0] + 1'b1};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = Haddr + 1'b1;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[2:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:3],Haddr[2:0] + 1'b1};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = Haddr + 1'b1;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE	
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[3:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:3],Haddr[3:0] + 1'b1};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                            endcase
                    3'd1: 	case(Hburst)
                                SINGLE: begin
                                            Htrans = 2'b00; //Idle
                                            Hreadyin = 1'b0;
                                            Haddr = 32'bx;
                                            Hwdata = $random;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = Haddr + 2'd2;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[2:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:3],Haddr[2:1] + 1'b1,Haddr[0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = Haddr + 2'd2;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:4],Haddr[3:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:4],Haddr[3:1] + 1'b1,Haddr[0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = Haddr + 2'd2;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE	
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:5],Haddr[4:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:5],Haddr[4:1] + 1'b1,Haddr[0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                            endcase
                    3'd2:	case(Hburst)
                                SINGLE: begin
                                            Htrans = 2'b00; //Idle
                                            Hreadyin = 1'b0;
                                            Haddr = 32'bx;
                                            Hwdata = $random;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = Haddr + 3'd4;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:4],Haddr[3:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:4],Haddr[3:2] + 1'b1,Haddr[1:0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = Haddr + 3'd4;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:5],Haddr[4:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:5],Haddr[4:2] + 1'b1,Haddr[1:0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = Haddr + 3'd4;
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE	
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:6],Haddr[5:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            Hwdata = $random;
                                            #(cycle);
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                Haddr = {Haddr[31:6],Haddr[5:2] + 1'b1,Haddr[1:0]};
                                                Hwdata = $random;
                                                #(cycle)
                                                wait(Hreadyout);
                                            end
                                            #(cycle)
                                            wait(Hreadyout);
                                            Hwdata = $random;
                                            Haddr = 32'bx;
                                            Htrans = 2'b00; //IDLE
                                end
                            endcase
                endcase
                Htrans = 2'b00; //Idle
                #(cycle) Hwdata = 32'bx;
                #80;
            end
        endtask
        
        task read;
            begin
                Hwrite = 1'b0;
                Hreadyin = 1'b1;
                Htrans = 2'b10; //Non Seq
                Haddr = 32'h88008080;
                Hwdata = 32'bx;
                #(cycle)
                case(Hsize)
                    3'd0: 	case(Hburst)
                                SINGLE: begin
                                            Hreadyin = 1'b0;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 1'b1;
                                                #(cycle+1);
                                                
                                            end
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:2],Haddr[1:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:2],Haddr[1:0] + 1'b1};
                                                #(cycle+1);
                                            end
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 1'b1;
                                                #(cycle+1);
                                            end
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[2:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:3],Haddr[2:0] + 1'b1};
                                                #(cycle+1);
                                            end
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 1'b1;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 1'b1;
                                                #(cycle+1);
                                            end
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[3:0] + 1'b1};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:3],Haddr[3:0] + 1'b1};
                                                #(cycle+1);
                                            end
                                end
                            endcase
                    3'd1: 	case(Hburst)
                                SINGLE: begin
                                            Hreadyin = 1'b0;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 2'd2;
                                                #(cycle+1);
                                            end
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:3],Haddr[2:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:3],Haddr[2:1] + 1'b1,Haddr[0]};
                                                #(cycle+1);
                                            end
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 2'd2;
                                                #(cycle+1);
                                            end
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:4],Haddr[3:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:4],Haddr[3:1] + 1'b1,Haddr[0]};
                                                #(cycle+1);
                                            end
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 2'd2;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 2'd2;
                                                #(cycle+1);
                                            end
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:5],Haddr[4:1] + 1'b1,Haddr[0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:5],Haddr[4:1] + 1'b1,Haddr[0]};
                                                #(cycle+1);
                                            end
                                end
                            endcase
                    3'd2:	case(Hburst)
                                SINGLE: begin
                                            Hreadyin = 1'b0;
                                end
                                INCR: ;//Figuring out
                                INCR4: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 3'd4;
                                                #(cycle+1);
                                            end
                                end
                                WRAP4: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:4],Haddr[3:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<2;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:4],Haddr[3:2] + 1'b1,Haddr[1:0]};
                                                #(cycle+1);
                                            end
                                end
                                INCR8: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 3'd4;
                                                #(cycle+1);
                                            end
                                end
                                WRAP8: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:5],Haddr[4:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<6;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:5],Haddr[4:2] + 1'b1,Haddr[1:0]};
                                                #(cycle+1);
                                            end
                                end
                                INCR16: begin
                                            wait(Hreadyout);
                                            Haddr = Haddr + 3'd4;
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = Haddr + 3'd4;
                                                #(cycle+1);
                                            end
                                end
                                WRAP16: begin
                                            wait(Hreadyout);
                                            Haddr = {Haddr[31:6],Haddr[5:2] + 1'b1,Haddr[1:0]};
                                            Htrans = 2'b11; //Seq
                                            
                                            #(cycle+1)
                                            for(i=0;i<14;i=i+1)
                                            begin
                                                wait(Hreadyout);
                                                Haddr = {Haddr[31:6],Haddr[5:2] + 1'b1,Haddr[1:0]};
                                                #(cycle+1);
                                            end
                                end
                            endcase
                endcase
                #(cycle+1) Haddr = 32'bx;
                Htrans = 2'b00; //Idle
                #80;
                #80;
            end
        endtask
        
        task b2b;
            begin
                Hwrite = 1'b1;
                Hreadyin = 1'b1;
                Htrans = 2'b10; //Non Seq
                Haddr = 32'h88008080;
                #(cycle) Hwdata = $random;
                Haddr = 32'h88008088;
                Hwrite = 1'b0;
                #(cycle)
                Hwrite = 1'b1;
                Haddr = 32'h88008008;
                Hwdata = 32'bx;
                #(cycle)
                wait(Hreadyout);
                Hwrite = 1'b0;
                Haddr = 32'h88000088;
                Hwdata = $random;
                #(cycle+1);
                Htrans = 2'b00;
            end
        endtask
        
endmodule
