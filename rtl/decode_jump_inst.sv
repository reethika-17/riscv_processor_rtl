`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_jump_inst(
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [31:0] imm,
    output logic [1:0] jump_control
);

// Edit the code here begin ---------------------------------------------------

    assign rd  = instruction_code[11:7];

    always @(*) begin
        case (instruction_code[6:0])
            7'b1101111: begin
                jump_control = `JAL;
                imm[31:21] = {11{instruction_code[31]}};
                imm[20] = instruction_code[31];
                imm[19:12] = instruction_code[19:12];
                imm[11] = instruction_code[20];
                imm[10:1] = instruction_code[30:21];
                imm[0] = 1'b0;
                rs1 = 5'd0;
            end 
            7'b1100111: begin
                if(instruction_code[14:12] == 3'b000) begin
                    jump_control = `JALR;
                    rs1 = instruction_code[19:15];
                    imm[31:12] = {20{instruction_code[31]}};
                    imm[11:0]  = instruction_code[31:20];
                end 
                else begin
                    jump_control = `JMP_NOP;
                    rs1 = 0;
                    imm = 0;
                end
            end
            default: begin
                jump_control = `JMP_NOP;
                rs1 = 0;
                imm = 0;
            end
        endcase
    end

    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_jump_inst.vcd");
        $dumpvars(0, decode_jump_inst);
    end
`endif

endmodule