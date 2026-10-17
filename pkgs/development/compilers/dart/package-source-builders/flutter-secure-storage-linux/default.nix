{
  stdenv,
  libgcrypt,
  libgpg-error,
  libsecret,
  jsoncpp,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter-secure-storage-linux";
  inherit version src;
  inherit (src) passthru;

  propagatedBuildInputs = [
    libsecret
    jsoncpp

    # hack: these are dependencies of libsecret and ideally shouldn't be here,
    #       but they're currently required for dumb nix reasons
    libgcrypt
    libgpg-error
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';
}
