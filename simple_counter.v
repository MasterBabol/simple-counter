`timescale 1ns/1ps

module simple_counter
#
(
    parameter integer axi_addr_width    = 32
)
(
    clk                 ,
    srstn               ,
    enable              ,
    s_axi_ctl_awaddr    ,
    s_axi_ctl_awvalid   ,
    s_axi_ctl_awready   ,
    s_axi_ctl_wdata     ,
    s_axi_ctl_wstrb     ,
    s_axi_ctl_wvalid    ,
    s_axi_ctl_wready    ,
    s_axi_ctl_bresp     ,
    s_axi_ctl_bvalid    ,
    s_axi_ctl_bready    ,
    s_axi_ctl_araddr    ,
    s_axi_ctl_arvalid   ,
    s_axi_ctl_arready   ,
    s_axi_ctl_rdata     ,
    s_axi_ctl_rvalid    ,
    s_axi_ctl_rready    ,
    s_axi_ctl_rresp     ,
    probe
);
    input                           clk                 ;
    input                           srstn               ;
    input                           enable              ;

    input   [axi_addr_width - 1:0]  s_axi_ctl_awaddr    ;
    input                           s_axi_ctl_awvalid   ;
    output                          s_axi_ctl_awready   ;
    input   [32 - 1:0]              s_axi_ctl_wdata     ;
    input   [32/8 - 1:0]            s_axi_ctl_wstrb     ;
    input                           s_axi_ctl_wvalid    ;
    output                          s_axi_ctl_wready    ;
    output  [1:0]                   s_axi_ctl_bresp     ;
    output                          s_axi_ctl_bvalid    ;
    input                           s_axi_ctl_bready    ;

    input   [axi_addr_width - 1:0]  s_axi_ctl_araddr    ;
    input                           s_axi_ctl_arvalid   ;
    output                          s_axi_ctl_arready   ;
    output  [32 - 1:0]              s_axi_ctl_rdata     ;
    output                          s_axi_ctl_rvalid    ;
    input                           s_axi_ctl_rready    ;
    output  [1:0]                   s_axi_ctl_rresp     ;

    input                           probe               ;

    wire    [axi_addr_width - 1:0]  w_ctl_waddr         ;
    wire    [32 - 1:0]              w_ctl_wdata         ;
    wire    [32/8 - 1:0]            w_ctl_wstrb         ;
    wire                            w_ctl_wvalid        ;
    wire                            w_ctl_wready        ;
    wire    [axi_addr_width - 1:0]  w_ctl_raddr         ;
    reg     [32 - 1:0]              r_ctl_rdata         ;
    wire                            w_ctl_rvalid        ;
    wire                            w_ctl_rready        ;

    axi4l_sif
    #
    (
        .axi4l__addr_width  (axi_addr_width     ),
        .axi4l__data_width  (32                 )
    )
    inst_axi4l_sif_ctl
    (
        .sys__clk           (clk                ),
        .sys__srstn         (srstn              ),
        .axi4l__s_awaddr    (s_axi_ctl_awaddr   ),
        .axi4l__s_awprot    (                   ),
        .axi4l__s_awvalid   (s_axi_ctl_awvalid  ),
        .axi4l__s_awready   (s_axi_ctl_awready  ),
        .axi4l__s_wdata     (s_axi_ctl_wdata    ),
        .axi4l__s_wstrb     (s_axi_ctl_wstrb    ),
        .axi4l__s_wvalid    (s_axi_ctl_wvalid   ),
        .axi4l__s_wready    (s_axi_ctl_wready   ),
        .axi4l__s_bresp     (s_axi_ctl_bresp    ),
        .axi4l__s_bvalid    (s_axi_ctl_bvalid   ),
        .axi4l__s_bready    (s_axi_ctl_bready   ),
        .axi4l__s_araddr    (s_axi_ctl_araddr   ),
        .axi4l__s_arprot    (                   ),
        .axi4l__s_arvalid   (s_axi_ctl_arvalid  ),
        .axi4l__s_arready   (s_axi_ctl_arready  ),
        .axi4l__s_rdata     (s_axi_ctl_rdata    ),
        .axi4l__s_rresp     (s_axi_ctl_rresp    ),
        .axi4l__s_rvalid    (s_axi_ctl_rvalid   ),
        .axi4l__s_rready    (s_axi_ctl_rready   ),
        .acc__waddr         (w_ctl_waddr        ),
        .acc__wdata         (w_ctl_wdata        ),
        .acc__wstrb         (w_ctl_wstrb        ),
        .acc__wvalid        (w_ctl_wvalid       ),
        .acc__wready        (w_ctl_wready       ),
        .acc__raddr         (w_ctl_raddr        ),
        .acc__rdata         (r_ctl_rdata        ),
        .acc__rvalid        (w_ctl_rvalid       ),
        .acc__rready        (w_ctl_rready       )
    );

    reg [31:0] r_counter;

    assign w_ctl_wready = 1'b1;
    assign w_ctl_rready = 1'b1;
    assign r_ctl_rdata = r_counter;

    always @ (posedge clk)
        if (!srstn || !enable)
            r_counter <= 'b0;
        else
            if (probe)
                r_counter <= r_counter + 1;

endmodule
