{ pkgs, lib, outputs, config, ... }: 
{
	boot.loader.timeout = 2;

	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
		};

		gc = {
			automatic = lib.mkDefault true;
			dates = lib.mkDefault "weekly";
			options = lib.mkDefault "--delete-older-than 7d";
		};
	};

	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		defaultSopsFormat = "yaml";
		age = {
			keyFile = "${config.users.users."marcus".home}/.config/sops/age/keys.txt";
			sshKeyPaths = [
				"/etc/ssh/ssh_host_ed25519_key"
			];
			generateKey = true;
		};
	};

	boot.plymouth.enable = true;
	boot.kernelParams = [
		"quiet"
		"splash"
		"loglevel=4"
		"systemd.show_status=false"
		"rd.udev.lov_level=3"
		"udev.log_priority=3"
		"boot.shell_on_fail"
	];
	boot.consoleLogLevel = 0;
	boot.initrd.verbose = false;

	nixpkgs.overlays = [
		outputs.overlays.additions
		outputs.overlays.unstable-packages
		outputs.overlays.nixpkgs-patched
	];

	security.polkit.enable = true;
	security.polkit.extraConfig = ''
      polkit.addRule(function (action, subject) {
	    if (
	      subject.isInGroup("users") &&
	      [
	        "org.freedesktop.login1.reboot",
	        "org.freedesktop.login1.reboot-multiple-sessions",
	        "org.freedesktop.login1.power-off",
	        "org.freedesktop.login1.power-off-multiple-sessions",
	      ].indexOf(action.id) !== -1
	    )
	    { return polkit.Result.YES; }
	  });
	'';
	
	environment.systemPackages = with pkgs; [
		bat
		bat-extras.batman
		btop
		curl
		deno-bin
		direnv
		fd
		gcc_multi
		gh
		git
		mosh
		neovim
		nix-search-cli
		ripgrep
		starship
		stow
		tmux
		trashy
		tree-sitter
		unstable.carapace
		unstable.fzf
		unstable.lazygit
		unstable.nerdfetch
		unstable.nushell
		unzip
		vim
		wget
	];
	environment.variables.PATH = lib.mkForce [ "$PATH" "$HOME/scripts" ];

	programs = {
		neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
		};

		tmux = {
			enable = true;
			baseIndex = 1;
			keyMode = "vi";
		};
	};
}
