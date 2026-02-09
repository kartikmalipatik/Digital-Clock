//------------------------------------------------------------------------------
// File        : tb_digital_clock.sv
// Author      : Kartik Malipatil / 1BM23EC117
// Created     : 2026-02-03
// Module      : tb_digital_clock
// Project     : SystemVerilog and Verification (23EC6PE2SV)
// Faculty     : Prof. Ajaykumar Devarapalli
//------------------------------------------------------------------------------module tb_digital_clock;

logic clk;
logic rst;
logic [5:0] sec;
logic [5:0] min;

// DUT
digital_clock dut (
    .clk(clk),
    .rst(rst),
    .sec(sec),
    .min(min)
);

// Clock generation
always #5 clk = ~clk;

// Coverage
covergroup cg;
    sec_cp : coverpoint sec {
        bins wrap = (59 => 0);
    }
    min_cp : coverpoint min;
endgroup

cg cov = new();

initial begin
    // 👉 VCD dump (THIS FIXES THE ERROR)
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_digital_clock);

    clk = 0;
    rst = 1;
    #10 rst = 0;

    repeat (70) begin
        @(posedge clk);
        cov.sample();
        $display("TIME=%0t sec=%0d min=%0d", $time, sec, min);
    end

    $finish;
end

endmodule
