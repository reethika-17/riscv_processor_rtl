`ifndef FILE_INCL
`include "processor_defines.sv"
`endif

module load(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] imm,
    input logic [31:0] mem_data,
    input logic [4:0] rd_in,
    input logic [2:0] load_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic rd_write_control,
    output logic [4:0] rd_out,
    output logic [31:0] rd_write_val,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr
);

// Edit the code here begin ---------------------------------------------------

logic pending;

logic [4:0]  saved_rd;
logic [2:0]  saved_load;
logic [31:0] saved_addr;

logic [7:0]  byte_val;
logic [15:0] half_val;

always_ff @(posedge i_clk) begin
    if(!i_rst) begin
        pending    <= 1'b0;
        saved_rd   <= 5'd0;
        saved_load <= 3'd0;
        saved_addr <= 32'd0;
    end
    else begin
        if(!pending && (load_control != 3'd0)) begin
            pending    <= 1'b1;
            saved_rd   <= rd_in;
            saved_load <= load_control;
            saved_addr <= rs1_val + imm;
        end
        else begin
            pending <= 1'b0;
        end
    end
end

always_comb begin

    //-----------------------
    // Defaults (Idle)
    //-----------------------
    stall_pc         = 1'b0;
    ignore_curr_inst = 1'b0;
    rd_write_control = 1'b0;
    rd_out           = 5'd0;
    rd_write_val     = 32'd0;
    mem_rw_mode      = 1'b1;     // READ
    mem_addr         = 32'd0;

    //-----------------------
    // Cycle 1
    //-----------------------
    if(!pending && (load_control != 3'd0)) begin
        stall_pc         = 1'b1;
        ignore_curr_inst = 1'b0;
        rd_write_control = 1'b0;
        rd_out           = 5'd0;
        rd_write_val     = 32'd0;
        mem_rw_mode      = 1'b1;
        mem_addr         = rs1_val + imm;
    end

    //-----------------------
    // Cycle 2
    //-----------------------
    else if(pending) begin

        ignore_curr_inst = 1'b1;
        stall_pc         = 1'b0;
        rd_write_control = 1'b1;
        rd_out           = saved_rd;
        mem_rw_mode      = 1'b1;
        mem_addr         = 32'd0;

        //-----------------------
        // Byte Selection
        //-----------------------
        case(saved_addr[1:0])
            2'd0: byte_val = mem_data[7:0];
            2'd1: byte_val = mem_data[15:8];
            2'd2: byte_val = mem_data[23:16];
            default: byte_val = mem_data[31:24];
        endcase

        //-----------------------
        // Halfword Selection
        //-----------------------
        if(saved_addr[1:0] <= 2'd1)
            half_val = mem_data[15:0];
        else
            half_val = mem_data[31:16];

        //-----------------------
        // Load Types
        //-----------------------
        case(saved_load)

            `LB:
                rd_write_val = {{24{byte_val[7]}}, byte_val};

            `LH:
                rd_write_val = {{16{half_val[15]}}, half_val};

            `LW:
                rd_write_val = mem_data;

            `LBU:
                rd_write_val = {24'd0, byte_val};

            `LHU:
                rd_write_val = {16'd0, half_val};

            default:
                rd_write_val = 32'd0;

        endcase
    end
end

// Edit the code here end -----------------------------------------------------

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/load.vcd");
        $dumpvars(0, load);
    end
`endif

endmodule