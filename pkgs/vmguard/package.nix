{
	lib,
	rustPlatform,
	fetchFromGitHub,
	systemd,
	pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
	pname = "vmguard";
	version = "260621-unstable";

	src = fetchFromGitHub {
		owner = "Cormoran96";
		repo = "vmguard";
		rev = "f58731e3be0f14bbacb00ef40e20286c2f752edb";
		hash = "sha256-ozNxURDdT66XvV6cAAfpWHk8u5AZaJYEDMtYKNr1AaE=";
	};

	cargoHash = "sha256-h8V4zMEBj7ATwckvpM3ntyMpBHGQgXGz5g0SPCezbIc=";

	buildInputs = [ systemd ];
	nativeBuildInputs = [ pkg-config ];

	postPatch = ''
		substituteInPlace src/main.rs --replace-fail \
			"const PID: u16 = 0x813f;" \
			"const PID: u16 = 0x813e;"
	'';

	meta = {
		description = "Fingerprint login on Linux for the Kensington VeriMark Guard FIDO2 key (CTAP2 + pam-u2f)";
		homepage = "https://github.com/Cormoran96/vmguard";
		downloadPage = "https://github.com/Cormoran96/vmguard";
		license = lib.licenses.mit;
		maintainers = [ lib.importJSON ../maintainer.json ];
		platforms = [
			"x86_64-linux"
		];
		mainProgram = "vmguard";
	};
})
