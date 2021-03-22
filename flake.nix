{
  description = "A flake for Kops";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;

  outputs = { self, nixpkgs }: {
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };

      stdenv.mkDerivation rec {
        name = "kops_sk4zuzu";

        dontUnpack = true;

        kops_ver = "1.18.1";
        kops_src = fetchurl {
          url = "https://github.com/kubernetes/kops/releases/download/v${kops_ver}/kops-linux-amd64";
          sha256 = "sha256-xtvIH/bBtJKEvP9TxQhcPKtj3+Hs4uusjfGsp59Jsps=";
          executable = true;
        };

        nativeBuildInputs = [ installShellFiles ];

        dontPatch     = true;
        dontConfigure = true;
        dontBuild     = true;
        dontFixup     = true;

        installPhase = ''
          install -D $kops_src $out/kops
        '';
      };
  };
}
