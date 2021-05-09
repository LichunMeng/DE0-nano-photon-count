/* Quartus Prime Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA4) Path("/home/lm/Documents/Code/git_code/DE0-nano Photon count/DE0-nano-photon-count/fpga-rtl/jic file/") File("Pls_fifo.jic") MfrSpec(OpMask(1) SEC_Device(EPCS128) Child_OpMask(1 1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
