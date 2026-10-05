{
  description = "Collab Agent Week 1 workstation toolset";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Terraform is BSL-licensed
      }));
    in {
      devShells = forAll (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            openssh
            openstackclient
            terraform
            ansible
            kubeseal
            wireguard-tools
          ];
        };
      });
    };
}
