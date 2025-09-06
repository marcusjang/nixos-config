{ pkgs, lib, outputs, config, ... }: 
{
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
		outputs.overlays.deno-latest
		outputs.overlays.unstable-packages
	];
	
	environment.systemPackages = with pkgs; [
		xorg.xprop
		git
		gh
		stow
		wget
		curl
		unzip
		gcc_multi
		vim
		neovim
		fd
		tree-sitter
		tmux
		starship
		btop
		bat
		mosh
		zsh-autosuggestions
		direnv
		deno
		nodejs_latest
		ripgrep
		unstable.fzf
		unstable.lazygit
		unstable.nerdfetch
	];

	services.userborn.enable = true;
	users.mutableUsers = false;

	services.lorri.enable = true;

	programs = {
		zsh = {
			enable = true;
			enableCompletion = true;
			autosuggestions.enable = true;
			ohMyZsh = {
				enable = true;
				plugins = [ "git" "fzf" ];
			};
		};

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
