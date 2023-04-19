module spiOverJtag (
	input  jtag_1_CAPTURE,
	input  jtag_1_DRCK,
	input  jtag_1_RESET,
	input  jtag_1_RUNTEST,
	input  jtag_1_SEL,
	input  jtag_1_SHIFT,
	input  jtag_1_TCK,
	input  jtag_1_TDI,
	input  jtag_1_TMS,
	input  jtag_1_UPDATE,
	output jtag_1_TDO,
         
	output csn,
	output sck,
	output sdi_dq0,
	input  sdo_dq1,
	output wpn_dq2,
	output hldn_dq3
);

	wire capture, drck, sel, update;
	wire runtest;
	wire tdi;
	reg fsm_csn;

	assign wpn_dq2  = 1'b1;
	assign hldn_dq3 = 1'b1;
	// jtag -> spi flash
	assign sdi_dq0 = tdi;
	wire tdo = (sel) ? sdo_dq1 : tdi;
	assign  csn = fsm_csn;

	wire tmp_cap_s = capture && sel;
	wire tmp_up_s = update && sel;

	always @(posedge drck, posedge runtest) begin
		if (runtest) begin
			fsm_csn <= 1'b1;
		end else begin
			if (tmp_cap_s) begin
				fsm_csn <= 1'b0;
			end else if (tmp_up_s) begin
				fsm_csn <= 1'b1;
			end else begin
				fsm_csn <= fsm_csn;
			end
		end
	end

	assign sck        = drck;
	assign capture    = jtag_1_CAPTURE;
	assign drck       = jtag_1_DRCK;
	assign runtest    = jtag_1_RUNTEST;
	assign sel        = jtag_1_SEL;
	assign tdi        = jtag_1_TDI;
	assign update     = jtag_1_UPDATE;
	assign jtag_1_TDO = tdo;
	//BSCANE2 #(
	//	.JTAG_CHAIN(1)  // Value for USER command.
	//) bscane2_inst (
	//	.CAPTURE(capture), // 1-bit output: CAPTURE output from TAP controller.
	//	.DRCK	(drck),    // 1-bit output: Gated TCK output. When SEL
	//					   //               is asserted, DRCK toggles when
	//					   //               CAPTURE or SHIFT are asserted.
	//	.RESET  (),        // 1-bit output: Reset output for TAP controller.
	//	.RUNTEST(runtest), // 1-bit output: Output asserted when TAP
	//					   //               controller is in Run Test/Idle state.
	//	.SEL	 (sel),    // 1-bit output: USER instruction active output.
	//	.SHIFT   (),       // 1-bit output: SHIFT output from TAP controller.
	//	.TCK     (),       // 1-bit output: Test Clock output.
	//	                   //               Fabric connection to TAP Clock pin.
	//	.TDI     (tdi),    // 1-bit output: Test Data Input (TDI) output
	//	                   //               from TAP controller.
	//	.TMS     (),       // 1-bit output: Test Mode Select output.
	//	                   //               Fabric connection to TAP.
	//	.UPDATE  (update), // 1-bit output: UPDATE output from TAP controller
	//	.TDO     (tdo)     // 1-bit input: Test Data Output (TDO) input
	//	                   //              for USER function.
	//);

endmodule
