{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "linux-id";
  version = "0-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "matejsmycka";
    repo = "linux-id";
    rev = "2486efdc53ed07033953807fea628c25dee2d0de";
    hash = "sha256-0lO4lIga/tYzXDOGxYREr2Bgu1P6/3GH67ijivl42D8=";
  };

  vendorHash = "sha256-vmWYSlCP09cVgQa7owAZeDzGfEdMHOqQlqDuzTkRjdI=";
  # Keep browsers waiting while the user reaches the fingerprint reader.
  patches = [ ./linux-id-keepalive.patch ];
  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TPM-backed FIDO2 passkeys with fingerprint verification";
    homepage = "https://github.com/matejsmycka/linux-id";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "linux-id";
  };
}
