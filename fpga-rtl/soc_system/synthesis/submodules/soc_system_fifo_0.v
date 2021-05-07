//Legal Notice: (C)2021 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0_dual_clock_fifo (
                                           // inputs:
                                            aclr,
                                            data,
                                            rdclk,
                                            rdreq,
                                            wrclk,
                                            wrreq,

                                           // outputs:
                                            q,
                                            rdempty,
                                            rdfull,
                                            rdusedw,
                                            wrfull
                                         )
  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */ ;

  output  [ 31: 0] q;
  output           rdempty;
  output           rdfull;
  output  [  9: 0] rdusedw;
  output           wrfull;
  input            aclr;
  input   [ 31: 0] data;
  input            rdclk;
  input            rdreq;
  input            wrclk;
  input            wrreq;


wire             int_rdfull;
wire             int_wrfull;
wire    [ 31: 0] q;
wire             rdempty;
wire             rdfull;
wire    [  9: 0] rdusedw;
wire             wrfull;
wire    [  9: 0] wrusedw;
  assign wrfull = (wrusedw >= 1024-3) | int_wrfull;
  assign rdfull = (rdusedw >= 1024-3) | int_rdfull;
  dcfifo dual_clock_fifo
    (
      .aclr (aclr),
      .data (data),
      .q (q),
      .rdclk (rdclk),
      .rdempty (rdempty),
      .rdfull (int_rdfull),
      .rdreq (rdreq),
      .rdusedw (rdusedw),
      .wrclk (wrclk),
      .wrfull (int_wrfull),
      .wrreq (wrreq),
      .wrusedw (wrusedw)
    );

  defparam dual_clock_fifo.add_ram_output_register = "OFF",
           dual_clock_fifo.clocks_are_synchronized = "FALSE",
           dual_clock_fifo.intended_device_family = "CYCLONEV",
           dual_clock_fifo.lpm_hint = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT",
           dual_clock_fifo.lpm_numwords = 1024,
           dual_clock_fifo.lpm_showahead = "OFF",
           dual_clock_fifo.lpm_type = "dcfifo",
           dual_clock_fifo.lpm_width = 32,
           dual_clock_fifo.lpm_widthu = 10,
           dual_clock_fifo.overflow_checking = "ON",
           dual_clock_fifo.rdsync_delaypipe = 4,
           dual_clock_fifo.read_aclr_synch = "ON",
           dual_clock_fifo.underflow_checking = "ON",
           dual_clock_fifo.use_eab = "ON",
           dual_clock_fifo.write_aclr_synch = "ON",
           dual_clock_fifo.wrsync_delaypipe = 4;


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0_dcfifo_with_controls (
                                                // inputs:
                                                 data,
                                                 rdclk,
                                                 rdclk_control_slave_address,
                                                 rdclk_control_slave_read,
                                                 rdclk_control_slave_write,
                                                 rdclk_control_slave_writedata,
                                                 rdreq,
                                                 rdreset_n,
                                                 wrclk,
                                                 wrreq,
                                                 wrreset_n,

                                                // outputs:
                                                 q,
                                                 rdclk_control_slave_readdata,
                                                 rdempty,
                                                 wrfull
                                              )
;

  output  [ 31: 0] q;
  output  [ 31: 0] rdclk_control_slave_readdata;
  output           rdempty;
  output           wrfull;
  input   [ 31: 0] data;
  input            rdclk;
  input   [  2: 0] rdclk_control_slave_address;
  input            rdclk_control_slave_read;
  input            rdclk_control_slave_write;
  input   [ 31: 0] rdclk_control_slave_writedata;
  input            rdreq;
  input            rdreset_n;
  input            wrclk;
  input            wrreq;
  input            wrreset_n;


wire    [ 31: 0] q;
reg              rdclk_control_slave_almostempty_n_reg;
wire             rdclk_control_slave_almostempty_pulse;
wire             rdclk_control_slave_almostempty_signal;
reg     [ 10: 0] rdclk_control_slave_almostempty_threshold_register;
reg              rdclk_control_slave_almostfull_n_reg;
wire             rdclk_control_slave_almostfull_pulse;
wire             rdclk_control_slave_almostfull_signal;
reg     [ 10: 0] rdclk_control_slave_almostfull_threshold_register;
reg              rdclk_control_slave_empty_n_reg;
wire             rdclk_control_slave_empty_pulse;
wire             rdclk_control_slave_empty_signal;
reg              rdclk_control_slave_event_almostempty_q;
wire             rdclk_control_slave_event_almostempty_signal;
reg              rdclk_control_slave_event_almostfull_q;
wire             rdclk_control_slave_event_almostfull_signal;
reg              rdclk_control_slave_event_empty_q;
wire             rdclk_control_slave_event_empty_signal;
reg              rdclk_control_slave_event_full_q;
wire             rdclk_control_slave_event_full_signal;
reg              rdclk_control_slave_event_overflow_q;
wire             rdclk_control_slave_event_overflow_signal;
wire    [  5: 0] rdclk_control_slave_event_register;
reg              rdclk_control_slave_event_underflow_q;
wire             rdclk_control_slave_event_underflow_signal;
reg              rdclk_control_slave_full_n_reg;
wire             rdclk_control_slave_full_pulse;
wire             rdclk_control_slave_full_signal;
reg     [  5: 0] rdclk_control_slave_ienable_register;
wire    [ 10: 0] rdclk_control_slave_level_register;
wire    [ 31: 0] rdclk_control_slave_read_mux;
reg     [ 31: 0] rdclk_control_slave_readdata;
reg              rdclk_control_slave_status_almostempty_q;
wire             rdclk_control_slave_status_almostempty_signal;
reg              rdclk_control_slave_status_almostfull_q;
wire             rdclk_control_slave_status_almostfull_signal;
reg              rdclk_control_slave_status_empty_q;
wire             rdclk_control_slave_status_empty_signal;
reg              rdclk_control_slave_status_full_q;
wire             rdclk_control_slave_status_full_signal;
reg              rdclk_control_slave_status_overflow_q;
wire             rdclk_control_slave_status_overflow_signal;
wire    [  5: 0] rdclk_control_slave_status_register;
reg              rdclk_control_slave_status_underflow_q;
wire             rdclk_control_slave_status_underflow_signal;
wire    [ 10: 0] rdclk_control_slave_threshold_writedata;
wire             rdempty;
wire             rdfull;
wire    [ 10: 0] rdlevel;
wire             rdoverflow;
wire             rdunderflow;
wire    [  9: 0] rdusedw;
wire             wrfull;
wire             wrreq_sync;
  //the_dcfifo, which is an e_instance
  soc_system_fifo_0_dual_clock_fifo the_dcfifo
    (
      .aclr    (~(rdreset_n && wrreset_n)),
      .data    (data),
      .q       (q),
      .rdclk   (rdclk),
      .rdempty (rdempty),
      .rdfull  (rdfull),
      .rdreq   (rdreq),
      .rdusedw (rdusedw),
      .wrclk   (wrclk),
      .wrfull  (wrfull),
      .wrreq   (wrreq)
    );

  altera_std_synchronizer wrdreq_sync_i
    (
      .clk (rdclk),
      .din (wrreq),
      .dout (wrreq_sync),
      .reset_n (rdreset_n)
    );

  defparam wrdreq_sync_i.depth = 4;

  assign rdlevel = {1'b0,
    rdusedw};

  assign rdoverflow = wrreq_sync & rdfull;
  assign rdunderflow = rdreq & rdempty;
  assign rdclk_control_slave_threshold_writedata = (rdclk_control_slave_writedata < 1) ? 1 :
    (rdclk_control_slave_writedata > 1020) ? 1020 :
    rdclk_control_slave_writedata[10 : 0];

  assign rdclk_control_slave_event_almostfull_signal = rdclk_control_slave_almostfull_pulse;
  assign rdclk_control_slave_event_almostempty_signal = rdclk_control_slave_almostempty_pulse;
  assign rdclk_control_slave_status_almostfull_signal = rdclk_control_slave_almostfull_signal;
  assign rdclk_control_slave_status_almostempty_signal = rdclk_control_slave_almostempty_signal;
  assign rdclk_control_slave_event_full_signal = rdclk_control_slave_full_pulse;
  assign rdclk_control_slave_event_empty_signal = rdclk_control_slave_empty_pulse;
  assign rdclk_control_slave_status_full_signal = rdclk_control_slave_full_signal;
  assign rdclk_control_slave_status_empty_signal = rdclk_control_slave_empty_signal;
  assign rdclk_control_slave_event_overflow_signal = rdoverflow;
  assign rdclk_control_slave_event_underflow_signal = rdunderflow;
  assign rdclk_control_slave_status_overflow_signal = rdoverflow;
  assign rdclk_control_slave_status_underflow_signal = rdunderflow;
  assign rdclk_control_slave_empty_signal = rdempty;
  assign rdclk_control_slave_empty_pulse = rdclk_control_slave_empty_signal & rdclk_control_slave_empty_n_reg;
  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_empty_n_reg <= 0;
      else 
        rdclk_control_slave_empty_n_reg <= !rdclk_control_slave_empty_signal;
    end


  assign rdclk_control_slave_full_signal = rdfull;
  assign rdclk_control_slave_full_pulse = rdclk_control_slave_full_signal & rdclk_control_slave_full_n_reg;
  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_full_n_reg <= 0;
      else 
        rdclk_control_slave_full_n_reg <= !rdclk_control_slave_full_signal;
    end


  assign rdclk_control_slave_almostempty_signal = rdlevel <= rdclk_control_slave_almostempty_threshold_register;
  assign rdclk_control_slave_almostempty_pulse = rdclk_control_slave_almostempty_signal & rdclk_control_slave_almostempty_n_reg;
  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_almostempty_n_reg <= 0;
      else 
        rdclk_control_slave_almostempty_n_reg <= !rdclk_control_slave_almostempty_signal;
    end


  assign rdclk_control_slave_almostfull_signal = rdlevel >= rdclk_control_slave_almostfull_threshold_register;
  assign rdclk_control_slave_almostfull_pulse = rdclk_control_slave_almostfull_signal & rdclk_control_slave_almostfull_n_reg;
  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_almostfull_n_reg <= 0;
      else 
        rdclk_control_slave_almostfull_n_reg <= !rdclk_control_slave_almostfull_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_almostempty_threshold_register <= 1;
      else if ((rdclk_control_slave_address == 5) & rdclk_control_slave_write)
          rdclk_control_slave_almostempty_threshold_register <= rdclk_control_slave_threshold_writedata;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_almostfull_threshold_register <= 1020;
      else if ((rdclk_control_slave_address == 4) & rdclk_control_slave_write)
          rdclk_control_slave_almostfull_threshold_register <= rdclk_control_slave_threshold_writedata;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_ienable_register <= 0;
      else if ((rdclk_control_slave_address == 3) & rdclk_control_slave_write)
          rdclk_control_slave_ienable_register <= rdclk_control_slave_writedata[5 : 0];
    end


  assign rdclk_control_slave_level_register = rdlevel;
  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_underflow_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[5])
          rdclk_control_slave_event_underflow_q <= 0;
      else if (rdclk_control_slave_event_underflow_signal)
          rdclk_control_slave_event_underflow_q <= -1;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_overflow_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[4])
          rdclk_control_slave_event_overflow_q <= 0;
      else if (rdclk_control_slave_event_overflow_signal)
          rdclk_control_slave_event_overflow_q <= -1;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_almostempty_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[3])
          rdclk_control_slave_event_almostempty_q <= 0;
      else if (rdclk_control_slave_event_almostempty_signal)
          rdclk_control_slave_event_almostempty_q <= -1;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_almostfull_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[2])
          rdclk_control_slave_event_almostfull_q <= 0;
      else if (rdclk_control_slave_event_almostfull_signal)
          rdclk_control_slave_event_almostfull_q <= -1;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_empty_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[1])
          rdclk_control_slave_event_empty_q <= 0;
      else if (rdclk_control_slave_event_empty_signal)
          rdclk_control_slave_event_empty_q <= -1;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_event_full_q <= 0;
      else if (rdclk_control_slave_write & 
                               (rdclk_control_slave_address == 2) &
                               rdclk_control_slave_writedata[0])
          rdclk_control_slave_event_full_q <= 0;
      else if (rdclk_control_slave_event_full_signal)
          rdclk_control_slave_event_full_q <= -1;
    end


  assign rdclk_control_slave_event_register = {rdclk_control_slave_event_underflow_q,
    rdclk_control_slave_event_overflow_q,
    rdclk_control_slave_event_almostempty_q,
    rdclk_control_slave_event_almostfull_q,
    rdclk_control_slave_event_empty_q,
    rdclk_control_slave_event_full_q};

  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_underflow_q <= 0;
      else 
        rdclk_control_slave_status_underflow_q <= rdclk_control_slave_status_underflow_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_overflow_q <= 0;
      else 
        rdclk_control_slave_status_overflow_q <= rdclk_control_slave_status_overflow_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_almostempty_q <= 0;
      else 
        rdclk_control_slave_status_almostempty_q <= rdclk_control_slave_status_almostempty_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_almostfull_q <= 0;
      else 
        rdclk_control_slave_status_almostfull_q <= rdclk_control_slave_status_almostfull_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_empty_q <= 0;
      else 
        rdclk_control_slave_status_empty_q <= rdclk_control_slave_status_empty_signal;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_status_full_q <= 0;
      else 
        rdclk_control_slave_status_full_q <= rdclk_control_slave_status_full_signal;
    end


  assign rdclk_control_slave_status_register = {rdclk_control_slave_status_underflow_q,
    rdclk_control_slave_status_overflow_q,
    rdclk_control_slave_status_almostempty_q,
    rdclk_control_slave_status_almostfull_q,
    rdclk_control_slave_status_empty_q,
    rdclk_control_slave_status_full_q};

  assign rdclk_control_slave_read_mux = ({32 {(rdclk_control_slave_address == 0)}} & rdclk_control_slave_level_register) |
    ({32 {(rdclk_control_slave_address == 1)}} & rdclk_control_slave_status_register) |
    ({32 {(rdclk_control_slave_address == 2)}} & rdclk_control_slave_event_register) |
    ({32 {(rdclk_control_slave_address == 3)}} & rdclk_control_slave_ienable_register) |
    ({32 {(rdclk_control_slave_address == 4)}} & rdclk_control_slave_almostfull_threshold_register) |
    ({32 {(rdclk_control_slave_address == 5)}} & rdclk_control_slave_almostempty_threshold_register) |
    ({32 {(~((rdclk_control_slave_address == 0))) && (~((rdclk_control_slave_address == 1))) && (~((rdclk_control_slave_address == 2))) && (~((rdclk_control_slave_address == 3))) && (~((rdclk_control_slave_address == 4))) && (~((rdclk_control_slave_address == 5)))}} & rdclk_control_slave_level_register);

  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          rdclk_control_slave_readdata <= 0;
      else if (rdclk_control_slave_read)
          rdclk_control_slave_readdata <= rdclk_control_slave_read_mux;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0_map_avalonst_to_avalonmm (
                                                    // inputs:
                                                     avalonst_data,

                                                    // outputs:
                                                     avalonmm_data
                                                  )
;

  output  [ 31: 0] avalonmm_data;
  input   [ 31: 0] avalonst_data;


wire    [ 31: 0] avalonmm_data;
  assign avalonmm_data[31 : 0] = avalonst_data[31 : 0];

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0_dual_clock_fifo_for_other_info (
                                                          // inputs:
                                                           aclr,
                                                           data,
                                                           rdclk,
                                                           rdreq,
                                                           wrclk,
                                                           wrreq,

                                                          // outputs:
                                                           q,
                                                           rdempty,
                                                           wrfull
                                                        )
  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */ ;

  output  [ 15: 0] q;
  output           rdempty;
  output           wrfull;
  input            aclr;
  input   [ 15: 0] data;
  input            rdclk;
  input            rdreq;
  input            wrclk;
  input            wrreq;


wire             int_wrfull;
wire    [ 15: 0] q;
wire             rdempty;
wire             wrfull;
wire    [  9: 0] wrusedw;
  assign wrfull = (wrusedw >= 1024-3) | int_wrfull;
  dcfifo dual_clock_fifo
    (
      .aclr (aclr),
      .data (data),
      .q (q),
      .rdclk (rdclk),
      .rdempty (rdempty),
      .rdreq (rdreq),
      .wrclk (wrclk),
      .wrfull (int_wrfull),
      .wrreq (wrreq),
      .wrusedw (wrusedw)
    );

  defparam dual_clock_fifo.add_ram_output_register = "OFF",
           dual_clock_fifo.clocks_are_synchronized = "FALSE",
           dual_clock_fifo.intended_device_family = "CYCLONEV",
           dual_clock_fifo.lpm_hint = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT",
           dual_clock_fifo.lpm_numwords = 1024,
           dual_clock_fifo.lpm_showahead = "OFF",
           dual_clock_fifo.lpm_type = "dcfifo",
           dual_clock_fifo.lpm_width = 16,
           dual_clock_fifo.lpm_widthu = 10,
           dual_clock_fifo.overflow_checking = "ON",
           dual_clock_fifo.rdsync_delaypipe = 4,
           dual_clock_fifo.read_aclr_synch = "ON",
           dual_clock_fifo.underflow_checking = "ON",
           dual_clock_fifo.use_eab = "ON",
           dual_clock_fifo.write_aclr_synch = "ON",
           dual_clock_fifo.wrsync_delaypipe = 4;


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0_map_avalonst_to_avalonmm_other_info (
                                                               // inputs:
                                                                avalonst_other_info,

                                                               // outputs:
                                                                avalonmm_other_info
                                                             )
;

  output  [ 31: 0] avalonmm_other_info;
  input   [ 15: 0] avalonst_other_info;


wire    [  7: 0] avalonmm_channel;
wire    [  5: 0] avalonmm_empty;
wire             avalonmm_eop;
wire    [  7: 0] avalonmm_error;
wire    [ 31: 0] avalonmm_other_info;
wire             avalonmm_sop;
  assign avalonmm_sop = 1'b0;
  assign avalonmm_eop = 1'b0;
  assign avalonmm_empty = 6'b0;
  assign avalonmm_channel = avalonst_other_info[7 : 0];
  assign avalonmm_error = avalonst_other_info[15 : 8];
  assign avalonmm_other_info = {8'b0,
    avalonmm_error,
    avalonmm_channel,
    avalonmm_empty,
    avalonmm_eop,
    avalonmm_sop};


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module soc_system_fifo_0 (
                           // inputs:
                            avalonmm_read_slave_address,
                            avalonmm_read_slave_read,
                            avalonst_sink_channel,
                            avalonst_sink_data,
                            avalonst_sink_error,
                            avalonst_sink_valid,
                            rdclk_control_slave_address,
                            rdclk_control_slave_read,
                            rdclk_control_slave_write,
                            rdclk_control_slave_writedata,
                            rdclock,
                            rdreset_n,
                            wrclock,
                            wrreset_n,

                           // outputs:
                            avalonmm_read_slave_readdata,
                            rdclk_control_slave_readdata
                         )
;

  output  [ 31: 0] avalonmm_read_slave_readdata;
  output  [ 31: 0] rdclk_control_slave_readdata;
  input            avalonmm_read_slave_address;
  input            avalonmm_read_slave_read;
  input   [  7: 0] avalonst_sink_channel;
  input   [ 31: 0] avalonst_sink_data;
  input   [  7: 0] avalonst_sink_error;
  input            avalonst_sink_valid;
  input   [  2: 0] rdclk_control_slave_address;
  input            rdclk_control_slave_read;
  input            rdclk_control_slave_write;
  input   [ 31: 0] rdclk_control_slave_writedata;
  input            rdclock;
  input            rdreset_n;
  input            wrclock;
  input            wrreset_n;


wire    [ 31: 0] avalonmm_map_data_out;
wire    [ 31: 0] avalonmm_other_info_map_out;
reg              avalonmm_read_slave_address_delayed;
reg              avalonmm_read_slave_read_delayed;
wire    [ 31: 0] avalonmm_read_slave_readdata;
wire    [ 31: 0] avalonst_map_data_in;
wire    [ 15: 0] avalonst_other_info_map_in;
wire    [ 31: 0] data;
wire    [ 31: 0] q;
wire             rdclk;
wire    [ 31: 0] rdclk_control_slave_readdata;
wire             rdempty;
wire             rdreq;
wire             rdreq_driver;
wire             wrclk;
wire             wrfull;
wire             wrreq;
  //the_dcfifo_with_controls, which is an e_instance
  soc_system_fifo_0_dcfifo_with_controls the_dcfifo_with_controls
    (
      .data                          (data),
      .q                             (q),
      .rdclk                         (rdclk),
      .rdclk_control_slave_address   (rdclk_control_slave_address),
      .rdclk_control_slave_read      (rdclk_control_slave_read),
      .rdclk_control_slave_readdata  (rdclk_control_slave_readdata),
      .rdclk_control_slave_write     (rdclk_control_slave_write),
      .rdclk_control_slave_writedata (rdclk_control_slave_writedata),
      .rdempty                       (rdempty),
      .rdreq                         (rdreq),
      .rdreset_n                     (rdreset_n),
      .wrclk                         (wrclk),
      .wrfull                        (wrfull),
      .wrreq                         (wrreq),
      .wrreset_n                     (wrreset_n)
    );

  //out, which is an e_avalon_slave
  //the_map_avalonst_to_avalonmm, which is an e_instance
  soc_system_fifo_0_map_avalonst_to_avalonmm the_map_avalonst_to_avalonmm
    (
      .avalonmm_data (avalonmm_map_data_out),
      .avalonst_data (avalonst_map_data_in)
    );

  assign wrclk = wrclock;
  assign rdclk = rdclock;
  assign rdreq_driver = (avalonmm_read_slave_address == 0) & avalonmm_read_slave_read;
  assign avalonst_map_data_in = q;
  assign rdreq = rdreq_driver;
  assign data = avalonst_sink_data;
  assign wrreq = avalonst_sink_valid;
  //the_dcfifo_other_info, which is an e_instance
  soc_system_fifo_0_dual_clock_fifo_for_other_info the_dcfifo_other_info
    (
      .aclr    (~(wrreset_n && rdreset_n)),
      .data    ({avalonst_sink_error,
avalonst_sink_channel}),
      .q       (avalonst_other_info_map_in),
      .rdclk   (rdclk),
      .rdempty (rdempty),
      .rdreq   ((avalonmm_read_slave_address == 0) & avalonmm_read_slave_read),
      .wrclk   (wrclk),
      .wrfull  (wrfull),
      .wrreq   (avalonst_sink_valid)
    );

  //the_map_avalonst_to_avalonmm_other_info, which is an e_instance
  soc_system_fifo_0_map_avalonst_to_avalonmm_other_info the_map_avalonst_to_avalonmm_other_info
    (
      .avalonmm_other_info (avalonmm_other_info_map_out),
      .avalonst_other_info (avalonst_other_info_map_in)
    );

  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          avalonmm_read_slave_address_delayed <= 0;
      else 
        avalonmm_read_slave_address_delayed <= avalonmm_read_slave_address;
    end


  always @(posedge rdclk or negedge rdreset_n)
    begin
      if (rdreset_n == 0)
          avalonmm_read_slave_read_delayed <= 0;
      else 
        avalonmm_read_slave_read_delayed <= avalonmm_read_slave_read;
    end


  assign avalonmm_read_slave_readdata = ({32 {((avalonmm_read_slave_address_delayed == 1) & avalonmm_read_slave_read_delayed)}} & avalonmm_other_info_map_out) |
    ({32 {((avalonmm_read_slave_address_delayed == 0) & avalonmm_read_slave_read_delayed)}} & avalonmm_map_data_out);

  //in, which is an e_atlantic_slave
  //out_csr, which is an e_avalon_slave

endmodule

