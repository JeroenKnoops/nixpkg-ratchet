{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config, taglib, zlib, nixosTests
}:

buildGoModule rec {
  pname = "ratchet";
  version = "0.9.2";
  src = fetchFromGitHub {
    owner = "sethvargo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gQ98uD9oPUsECsduv/lqGdYNmtHetU49ETfWCE8ft8U=";
  };

  nativeBuildInpuits = [ pkg-config ];
  buildInputs = [ taglib zlib ];
  vendorHash = "sha256-te0E3esX/+aGFgcEqJVcchClUgAfm5OywJ4MwMbDm0k=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sethvargo/ratchet/internal/version.name=ratchet"
    "-X=github.com/sethvargo/ratchet/internal/version.version=${version}"
    "-X=github.com/sethvargo/ratchet/internal/version.commit=${src.rev}"
  ];

  checkFlags =
    let
      skippedTests = [
        "TestResolve" # requires network access
        "TestLatestVersion" # requires network access
      ];
    in
    [ "-skip" (lib.concatStringsSep "|" skippedTests) ];

  meta = {
    homepage = "https://github.com/sethvargo/ratchet";
    description = "A tool for securing CI/CD workflows with version pinning.";
    license = "Apache-2.0"; 
    maintainers = with lib.maintainers; [ jeroenknoops ];
    mainProgram = "ratchet";
  };
}
