final: prev: {
	loupe = prev.loupe.overrideAttrs (finalAttrs: prevAttrs: {
		postPatch = prevAttrs.postPatch + ''
			substituteInPlace src/widgets/image.rs --replace-fail \
				"const BACKGROUND_COLOR_DEFAULT: gdk::RGBA = gdk::RGBA::new(34. / 255., 34. / 255., 38. / 255., 1.);" \
				"const BACKGROUND_COLOR_DEFAULT: gdk::RGBA = gdk::RGBA::new(0. / 255., 0. / 255., 0. / 255., 1.);"
		'';
	});
}
