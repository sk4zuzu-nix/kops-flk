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

        velero_ver = "1.5.4";
        velero_src = fetchurl {
          url = "https://github.com/vmware-tanzu/velero/releases/download/v${velero_ver}/velero-v${velero_ver}-linux-amd64.tar.gz";
          sha256 = "sha256-U2d2XliKWaD72kPrJ1eWI+ZsIbb/3ZoQ/rN5FIok/b0=";
          executable = false;
        };

        restic_ver = "0.12.0";
        restic_src = fetchurl {
          url = "https://github.com/restic/restic/releases/download/v${restic_ver}/restic_${restic_ver}_linux_amd64.bz2";
          sha256 = "sha256-Y9E9U4NOqKpNRh8L/jKonHDsR+I5uR8CntEL2IuPS4A=";
          executable = false;
        };

        rclone_ver = "1.55.0";
        rclone_src = fetchurl {
          url = "https://github.com/rclone/rclone/releases/download/v${rclone_ver}/rclone-v${rclone_ver}-linux-amd64.zip";
          sha256 = "sha256-e/QDw/Js0dRyiQVzilAdwTeXMifFtk65pU8yTJZmQQc=";
          executable = false;
        };

        nativeBuildInputs = [ installShellFiles unzip ];

        dontPatch     = true;
        dontConfigure = true;
        dontBuild     = true;
        dontFixup     = true;

        installPhase = ''
          install -d $out/

          install -m+x $kops_src $out/kops

          tar xf $velero_src --strip-components=1 -C $out/ velero-v${velero_ver}-linux-amd64/velero && chmod +x $out/velero

          bzcat $restic_src > $out/restic && chmod +x $out/restic

          unzip -p $rclone_src rclone-v${rclone_ver}-linux-amd64/rclone > $out/rclone && chmod +x $out/rclone
        '';
      };
  };
}
