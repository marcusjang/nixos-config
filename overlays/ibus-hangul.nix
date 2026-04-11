final: prev: with final; {
	ibus-engines.hangul = prev.ibus-engines.hangul.overrideAttrs (finalAttrs: prevAttrs: {
		pname = prevAttrs.pname;
		version = "1.5.5-dev";
		src = fetchFromGitHub {
			owner = "libhangul";
			repo = "ibus-hangul";
			rev = "9ee4419ebca803a4f7f2d9c31550abb2c8017de0";
			hash = "sha256-eBnwOlo8g2aaATZHB8RqPxsHwWz8KVSjf1bBwl9zO1Q=";
		};
	});
}
