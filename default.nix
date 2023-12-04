{ crystal
, mkYarnPackage
, fetchYarnDeps
}:

let
  version = "1.0.0";

  ui = mkYarnPackage {
    pname = "scribe-ui";
    inherit version;
    src = ./.;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = ./yarn.lock;
      sha256 = "sha256-PuxfuqgqJHh6NnyrQiFCxixGry9yGBSeSIPpa4jamKw=";
    };

    configurePhase = ''
      runHook preConfigure
      cp -r $node_modules node_modules
      chmod +w node_modules
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      export HOME=$(mktemp -d)
      OUTPUT_DIR=$out yarn --offline prod
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p "$out"
      mv public "$out/public"
    '';
    distPhase = "true";
  };
in
crystal.buildCrystalPackage rec {
  pname = "scribe";
  inherit version;

  src = ./.;
  shardsFile = ./shards.nix;

  preBuild = ''
    cp -a ${ui}/public/mix-manifest.json public/mix-manifest.json
  '';

  doCheck = false;
  doInstallCheck = false;
  format = "shards";
  postInstall = ''
    cp -r ${ui}/public "$out/public"
  '';
}
