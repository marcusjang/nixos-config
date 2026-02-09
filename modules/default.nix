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
			keyFile = "/home/${config.users.users."marcus".name}/.config/sops/age/keys.txt";
			sshKeyPaths = [
				"/etc/ssh/ssh_host_ed25519_key"
			];
			generateKey = true;
		};
		secrets = {
			"wireguard/wg0/privateKey" = {};
			"user/marcus/password" = {};
			"user/nas/password" = {};
		};
	};

	nixpkgs.overlays = [
		outputs.overlays.additions
		outputs.overlays.unstable-packages
	];
	
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
		nodejs_latest
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
		xorg.xprop
	];

	services.userborn.enable = true;
	users.mutableUsers = false;

	services.lorri.enable = true;

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
