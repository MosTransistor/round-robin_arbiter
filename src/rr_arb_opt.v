// ----------------------------
// -author: W.A

`define RD 1ns

module rr_arb_opt #(
    parameter  REQ_NUM = 7
) (
    input   logic                    clk     ,
    input   logic                    rst_n   ,
    input   logic   [REQ_NUM-1:0]    req     ,
    output  logic   [REQ_NUM-1:0]    grant
);

localparam N = REQ_NUM;
localparam W = $clog2(REQ_NUM);

logic [N-1:0] req_masked;
logic [N-1:0] mask_flag;
logic [N-1:0] grant_masked;
logic [N-1:0] grant_unmasked;
logic         all_req_flag;
logic [W-1:0] ptr;
logic [W-1:0] hit_ptr;

// mask last hit bit and low bit
generate
    genvar i;
    for(i=0;i<N;i=i+1) begin: HIT_POINTER_RECORD
        assign mask_flag[i] = (i > ptr) ? 1'b1 : 1'b0;
    end
endgenerate

// only bits higher than last hit take part
assign req_masked = req & mask_flag;

// simple priority
assign grant_masked[N-1:0] = req_masked & (~(req_masked-1));

// simple priority, all request join
assign grant_unmasked[N-1:0] = req & (~(req-1));

// if higher bits are not valid, grant_mask will all zero, so all bits join arb
assign all_req_flag = ~(|req_masked);
assign grant = ({N{all_req_flag}} & grant_unmasked) | grant_masked;

assign hit_ptr = onehot2bin(grant);

// pointer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ptr <= #`RD N - 1;
    end 
    else if (|req) begin
        ptr <= #`RD hit_ptr;
    end
end

// covert onehot to binary
function integer onehot2bin(input integer onehot);
    integer i;
    onehot2bin = 0;
    for (i=0; i<N; i=i+1) begin
        if (onehot[i]) onehot2bin = i;
    end
endfunction

endmodule