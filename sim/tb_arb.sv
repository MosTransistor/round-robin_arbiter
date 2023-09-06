`timescale 1ns/1ps

module tb_arb();

    initial begin
        $dumpfile("rr_arb.vcd");
        $dumpvars(0, tb_arb );
    end

    logic           t_clk=0;
    logic           t_rst_n=0;
    logic   [6:0]   t_req=0;
    logic   [6:0]   rr_grant;
    logic   [6:0]   tt_grant;

    always #5 t_clk = ~t_clk;

    initial begin
        $display("--- simulation begin");
        repeat (2) @(negedge t_clk);
        t_rst_n = 1;

        repeat (1) @(posedge t_clk);
        #1;
        t_req = 'b1010;
        repeat (1) @(posedge t_clk);
        #1;
        t_req = 'b1001;
        repeat (1) @(posedge t_clk);
        #1;
        t_req = 'b1101;
        repeat (20) begin
            repeat (1) @(posedge t_clk);
            #1;
            t_req = $urandom;
            //t_req = 'hf;
        end

        repeat (4) @(posedge t_clk);
        $finish;
    end   

    rr_arb      i_rr_arb(.clk(t_clk), .rst_n(t_rst_n), .req(t_req), .grant(rr_grant));
    rr_arb_opt  i_rr_arb_opt(.clk(t_clk), .rst_n(t_rst_n), .req(t_req), .grant(tt_grant));

endmodule