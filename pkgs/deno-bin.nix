{
	stdenv,
	lib,
	fetchzip,
	autoPatchelfHook,
	makeBinaryWrapper
}: let
	urls = version: let
		commonPath = "https://github.com/denoland/deno/releases/download/v${version}/";
	in {
		x86_64-linux = commonPath + "deno-x86_64-unknown-linux-gnu.zip";
		aarch64-linux = commonPath + "deno-aarch64-unknown-linux-gnu.zip";
	};
	hashes = {
		x86_64-linux = "sha256-+dx+Z9JDL5eW8mc/7oclQvXycTAxcYpnVfyAoiHj994=";
		aarch64-linux = "sha256-kWCo8wO8dvJiu5nTogJEdhzobTHyZvImsbe1a06JMEw=";
	};
in stdenv.mkDerivation (finalAttrs: {
	pname = "deno-bin";
	version = "2.9.6";

	src = fetchzip {
		url = (urls finalAttrs.version).${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
		hash = hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
	};

	nativeBuildInputs = [
		autoPatchelfHook
		stdenv.cc.cc.lib
		makeBinaryWrapper
	];

	installPhase = ''
		mkdir -p "$out/bin"
		install -m755 -D deno $out/bin/deno
		makeBinaryWrapper $out/bin/deno $out/bin/dx --add-flags "x"
	'';

	meta = {
		changelog = "https://github.com/denoland/deno/releases/tag/v${finalAttrs.version}";
		description = "Secure runtime for JavaScript and TypeScript";
		longDescription = ''
			Deno aims to be a productive and secure scripting environment for the modern programmer.
			Deno will always be distributed as a single executable.
			Given a URL to a Deno program, it is runnable with nothing more than the ~15 megabyte zipped executable.
			Deno explicitly takes on the role of both runtime and package manager.
			It uses a standard browser-compatible protocol for loading modules: URLs.
			Among other things, Deno is a great replacement for utility scripts that may have been historically written with
			bash or python.
		'';
		license = lib.licenses.mit;
		mainProgram = "deno";
		maintainers = [ lib.importJSON ../maintainer.json ];
		platforms = [
			"x86_64-linux"
			"aarch64-linux"
		];
	};
})

