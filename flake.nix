{
  description = "Development flake for my Data Analytics Top Movies report";

  # Flake inputs
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Stable Nixpkgs

  # Flake outputs
  outputs =
    { self, ... }@inputs:
    let
      # The systems supported for this flake's outputs
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper for providing system-specific attributes
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            # Provides a system-specific, configured Nixpkgs
            pkgs = import inputs.nixpkgs {
              inherit system;
              # Enable using unfree packages
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      # Development environments output by this flake
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          # Run `nix develop` to activate this environment or `direnv allow` if you have direnv installed
          default = pkgs.mkShell {
            # The Nix packages provided in the environment
            packages = with pkgs; [
              texlive.combined.scheme-full
              pandoc
              (rWrapper.override {
                packages = with rPackages; [ tidyverse ggflowchart ];
              })
            ];

            # Set any environment variables for your development environment
            env = { };

            # Add any shell logic you want executed when the environment is activated
            shellHook = "echo activated";
          };
        }
      );
    };
}
