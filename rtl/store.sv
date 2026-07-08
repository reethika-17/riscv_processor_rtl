`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module store(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [31:0] imm,
    input logic [2:0] store_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_write_data,
    output logic [3:0] mem_byte_en
);

// Edit the code here begin ---------------------------------------------------

    
    always @(*) begin

    stall_pc       = 1'b0;
    mem_rw_mode    = 1'b1;      // idle state
    mem_addr       = 32'b0;
    mem_write_data = 32'b0;
    mem_byte_en    = 4'b0000;

    case(store_control)

        // Store Byte
        `SB: begin
            mem_addr       = rs1_val + imm;
            mem_rw_mode    = 1'b0;
            stall_pc       = 1'b1;

            case(mem_addr[1:0])
                2'b00: begin
                    mem_write_data = {24'b0, rs2_val[7:0]};
                    mem_byte_en    = 4'b0001;
                end

                2'b01: begin
                    mem_write_data = {16'b0, rs2_val[7:0], 8'b0};
                    mem_byte_en    = 4'b0010;
                end

                2'b10: begin
                    mem_write_data = {8'b0, rs2_val[7:0], 16'b0};
                    mem_byte_en    = 4'b0100;
                end

                2'b11: begin
                    mem_write_data = {rs2_val[7:0], 24'b0};
                    mem_byte_en    = 4'b1000;
                end
            endcase
        end

        // Store Halfword
        `SH: begin
            mem_addr       = rs1_val + imm;
            mem_rw_mode    = 1'b0;
            stall_pc       = 1'b1;

            if(mem_addr[1] == 1'b0) begin
                mem_write_data = {16'b0, rs2_val[15:0]};
                mem_byte_en    = 4'b0011;
            end
            else begin
                mem_write_data = {rs2_val[15:0], 16'b0};
                mem_byte_en    = 4'b1100;
            end
        end

        // Store Word
        `SW: begin
            mem_addr       = rs1_val + imm;
            mem_rw_mode    = 1'b0;
            stall_pc       = 1'b1;

            mem_write_data = rs2_val;
            mem_byte_en    = 4'b1111;
        end

    endcase
end


always @(posedge i_clk or negedge i_rst) begin
    if(!i_rst)
        ignore_curr_inst <= 1'b0;
    else if(stall_pc)
        ignore_curr_inst <= 1'b1;
    else
        ignore_curr_inst <= 1'b0;
end
/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/store.vcd");
        $dumpvars(0, store);
    end
`endif

endmodule