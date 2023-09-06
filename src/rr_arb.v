// ----------------------------
// -author: W.A

`define RD 1ns

module rr_arb #(
    parameter  REQ_NUM = 7
) (
    input   logic                    clk     ,
    input   logic                    rst_n   ,
    input   logic   [REQ_NUM-1:0]    req     ,
    output  logic   [REQ_NUM-1:0]    grant
);

localparam N = REQ_NUM;

logic [N-1:0] req_masked;
logic [N-1:0] mask_ptr;
logic [N-1:0] grant_masked;
logic [N-1:0] unmask_ptr;
logic [N-1:0] grant_unmasked;
logic         all_req_flag;
logic [N-1:0] mask_flag;

// only bits higher than last hit take part
assign req_masked = req & mask_flag;

// high bit set to 1, hit 1-bit and low set to 0
assign mask_ptr[0] = 1'b0;
assign mask_ptr[N-1:1] = mask_ptr[N-2: 0] | req_masked[N-2:0];

// change to one-hot
assign grant_masked[N-1:0] = req_masked[N-1:0] & ~mask_ptr[N-1:0];

// all request join arb
assign unmask_ptr[0] = 1'b0;
assign unmask_ptr[N-1:1] = unmask_ptr[N-2:0] | req[N-2:0];
assign grant_unmasked[N-1:0] = req[N-1:0] & ~unmask_ptr[N-1:0];

// if higher bits are not valid, grant_mask will all zero, so all bits join arb
assign all_req_flag = ~(|req_masked);
assign grant = ({N{all_req_flag}} & grant_unmasked) | grant_masked;

// Pointer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mask_flag <= #`RD {N{1'b1}};
    end 
    else if (|req_masked) begin
        mask_flag <= #`RD mask_ptr;
    end
    else if (|req) begin
        mask_flag <= #`RD unmask_ptr;
    end
end

endmodule