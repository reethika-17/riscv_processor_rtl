`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_imm_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rd,
    output logic [11:0] imm,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rd = instruction_code[11:7];
    assign imm = instruction_code[31:20];
    always @(*) begin
        if(instruction_code[14:12]==3'h0)
        alu_control= `ADDI;
        else if(instruction_code[14:12]==3'h4)
        alu_control= `XORI;
        else if(instruction_code[14:12]==3'h6)
        alu_control= `ORI;
        else if(instruction_code[14:12]==3'h7)
        alu_control= `ANDI;
        else if(instruction_code[14:12]==3'h1 && instruction_code[31:25]==7'h00)
        alu_control= `SLLI;
        else if(instruction_code[14:12]==3'h5 && instruction_code[31:25]==7'h00)
        alu_control= `SRLI;
        else if(instruction_code[14:12]==3'h5 && instruction_code[31:25]==7'h20)
        alu_control= `SRAI;
        else if(instruction_code[14:12]==3'h2)
        alu_control= `SLTI;
        else if(instruction_code[14:12]==3'h3)
        alu_control= `SLTIU;
        else
        alu_control = `ALU_NOP;
    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_imm_inst.vcd");
        $dumpvars(0, decode_imm_inst);
    end
`endif

endmodule