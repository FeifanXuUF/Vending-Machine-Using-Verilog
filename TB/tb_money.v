module tb_money;

reg reset, CLK, M0, M1, M2, M3, M4, M5, ti , wi, ci, B1, B2, B3, C1, C2, C3, C4, rr;
wire [7:0] out;
wire To, Wo, Co;
wire [2:0]Bo;
wire [3:0]C;
wire [9:0]so;
wire [2:0]RRo;


//set CLK
always begin
    #5 CLK = ~CLK;
end

initial begin
    //$monitor("time=%d, reset = %b, clk = %b, M0=%b, M1=%b, M2=%b, M3=%b, ti=%b, wi=%b, ci=%b, B1=%b, B2=%b, B3=%b, C1=%b, C2=%b, C3=%b, C4=%b, out = %d, To = %b, rr = %b, RRo = %d",  $time, reset, CLK, M0, M1, M2, M3, ti , wi, ci, B1, B2, B3, C1, C2, C3, C4, out, To, rr, RRo);
    $monitor("time=%d,reset=%b,ti=%b,wi=%b,ci=%b,out=%d,To=%b,Wo=%b,Co=%b,rr=%d,RRo=%d,so=%b", $time, reset, ti, wi, ci, out, To, Wo, Co, rr, RRo, so);
    $dumpfile("mywave.vcd");
    $dumpvars(0);
    //initiate reg variables
    reset = 1'b1;
    CLK = 1'b0;
    M0 = 1'b0;
    M1 = 1'b0;
    M2 = 1'b0;
    M3 = 1'b0;
    M4 = 1'b0;
    M5 = 1'b0;
    ti = 1'b0;
    wi = 1'b0;
    ci = 1'b0;
    B1 = 1'b0;
    B2 = 1'b0;
    B3 = 1'b0;
    C1 = 1'b0;
    C2 = 1'b0;
    C3 = 1'b0;
    C4 = 1'b0;  
    rr = 1'b0;

    //test 1
    #10 reset = 0;
    #10 M1 = 1;
    #10 M1 = 0;
    #10 M2 = 1;
    #10 M2 = 0;
    #10 M2 = 1;
    #10 M2 = 0;
    #10 M3 = 1;
    #10 M3 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 wi = 1;
    #10 wi = 0;
    #10 ci = 1;
    #10 ci = 0;
    #10 rr = 1;
    #100 rr = 0;
    
    //test 2
    #10 reset = 1;
    #10 reset = 0;
    #10 M1 = 1;
    #10 M1 = 0;
    #10 M2 = 1;
    #10 M2 = 0;
    #10 M3 = 1;
    #10 M3 = 0;
    #10 M0 = 1;
    #10 M0 = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 rr = 1;
    #100 rr = 0; 


    //test 3
    #10 reset = 1;
    #10 reset = 0;
    #10 M4 = 1;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 M4 = 0;

    //test 4
    #10 reset = 1;
    #10 reset = 0;
    #10 M5 = 1;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 ti = 1;
    #10 ti = 0;
    #10 M5 = 0;

    #10 $finish;
end


money Money1 (
    .CLK(CLK),
    .M0(M0),
    .M1(M1),
    .M2(M2),
    .M3(M3),
    .M4(M4),
    .M5(M5),
    .ti(ti),
    .wi(wi),
    .ci(ci),
    .B1(B1),
    .B2(B2),
    .B3(B3),
    .C1(C1),
    .C2(C2),
    .C3(C3),
    .C4(C4),
    .out(out),
    .To(To),
    .Wo(Wo),
    .Co(Co),
    .Bo(Bo),
    .C(C),
    .so(so),
    .rr(rr),
    .RRo(RRo),
    .reset(reset)
);

endmodule