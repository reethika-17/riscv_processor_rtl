`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_reg_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rs2 = instruction_code[24:20];
    assign rd = instruction_code[11:7];
    
// Edit the code here end -----------------------------------------------------
always @(*) begin
    if(instruction_code[14:12]==3'h0 && instruction_code[31:25]==7'h00)
        alu_control= `ADD;
    else if(instruction_code[14:12]==3'h0 && instruction_code[31:25]==7'h20)
        alu_control= `SUB;
    else if(instruction_code[14:12]==3'h4 && instruction_code[31:25]==7'h00)
        alu_control= `XOR;
    else if(instruction_code[14:12]==3'h6 && instruction_code[31:25]==7'h00)
        alu_control= `OR;
    else if(instruction_code[14:12]==3'h7 && instruction_code[31:25]==7'h00)
        alu_control= `AND;
    else if(instruction_code[14:12]==3'h1 && instruction_code[31:25]==7'h00)
        alu_control= `SLL;
    else if(instruction_code[14:12]==3'h5 && instruction_code[31:25]==7'h00)
        alu_control= `SRL;
    else if(instruction_code[14:12]==3'h5 && instruction_code[31:25]==7'h20)
        alu_control= `SRA;
    else if(instruction_code[14:12]==3'h2 && instruction_code[31:25]==7'h00)
        alu_control= `SLT;
    else if(instruction_code[14:12]==3'h3 && instruction_code[31:25]==7'h00)
        alu_control= `SLTU;
    else 
        alu_control= `ALU_NOP;
end
/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_reg_inst.vcd");
        $dumpvars(0, decode_reg_inst);
    end
`endif

endmodule