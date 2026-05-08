{
	users = import ../users;
	default = import ./common.nix;
	harmonia-client = import ./harmonia.nix;
	locale = import ./locale.nix;
	firewall = import ./firewall.nix;
	nas-mounts = import ./mounts.nix;
	wireguard = import ./wireguard.nix;
	desktop = {
		common = import ./desktop;
		audio = import ./desktop/audio.nix;
		fonts = import ./desktop/fonts.nix;
		office = import ./desktop/office.nix;
		suspend = import ./desktop/suspend.nix;
		games = import ./desktop/games.nix;
		printing = import ./desktop/printing.nix;
		uxplay = import ./desktop/uxplay.nix;
		de = {
			gnome = import ./desktop/de/gnome.nix;
			niri = import ./desktop/de/niri.nix;
		};
		ime = {
			ibus-hangul = import ./desktop/ime/ibus.nix;
			kime = import ./desktop/ime/kime.nix;
		};
	};
	server = {
		common = import ./server;
		cloudflared = import ./server/cloudflared.nix;
		copyparty = import ./server/copyparty.nix;
		harmonia = import ./server/harmonia.nix;
		homebridge = import ./server/homebridge.nix;
		komga = import ./server/komga.nix;
		mylar3 = import ./server/mylar3.nix;
		samba = import ./server/samba.nix;
		ssh = import ./server/ssh.nix;
		traefik = import ./server/traefik.nix;
		webdav = import ./server/webdav.nix;
	};
}
