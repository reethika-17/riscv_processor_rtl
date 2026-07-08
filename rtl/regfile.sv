module regfile(
    input logic i_clk,
    input logic i_rst,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic rd_write_control,
    input logic [31:0] rd_write_val,
    output logic [31:0] rs1_val,
    output logic [31:0] rs2_val
);

logic [31:0] regs [0:31];
always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
            for (int i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else begin
            if (rd_write_control && (rd != 5'd0))
                regs[rd] <= rd_write_val;

            regs[0] <= 32'b0;
        end
    end
// Edit the code here begin ---------------------------------------------------

    assign rs1_val =  (rs1 == 5'd0) ? 32'b0 : regs[rs1];
    assign rs2_val =  (rs2 == 5'd0) ? 32'b0 : regs[rs2];
    
// Edit the code here end -----------------------------------------------------


/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/regfile.vcd");
        $dumpvars(0, regfile);
    end
`endif

endmodule