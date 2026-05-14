{ inputs, outputs, ... }: let
	importWrapper = path: nixpkgs: import path { inherit nixpkgs inputs outputs; };
in with inputs; {
	minibook = importWrapper ./minibook nixpkgs;
	n5 = importWrapper ./n5 nixpkgs;
	ser8 = importWrapper ./ser8 nixpkgs;
	wsl = importWrapper ./wsl nixpkgs;
	x1c13 = importWrapper ./x1c13 nixpkgs;
}
