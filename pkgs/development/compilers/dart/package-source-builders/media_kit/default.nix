{
  lib,
  stdenv,
  mpv-unwrapped,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "media_kit";
  inherit version src;
  inherit (src) passthru;

  dontBuild = true;

  postPatch = ''
    # in git pubs, we're at the root of the repo, so we need to move into media_kit/
    # but in pub.dev-fetched ones, media_kit/ is already the root, so don't move
    pushd media_kit || true
      substituteInPlace lib/src/player/native/core/native_library.dart \
        --replace-fail 'libmpv.so' '${lib.getLib mpv-unwrapped}/lib/libmpv.so'
    popd || true
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./ -T $out/

    runHook postInstall
  '';
}
