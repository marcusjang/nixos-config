final: prev: with final; {
	ibus = prev.ibus.overrideAttrs (finalAttrs: prevAttrs: {
		pname = prevAttrs.pname;
		version = "1.5.34";
		src = fetchFromGitHub {
			owner = "ibus";
			repo = "ibus";
			tag = finalAttrs.version;
			hash = "sha256-MCxzMnG+g2FC4pZtDOP2c7vSRG5Zk6EfrkGnEyFvBfQ=";
		};
		patches = builtins.filter (
			patches: !(lib.hasInfix "vala-parallelism.patch" patches)
		) prevAttrs.patches;
	});
}
