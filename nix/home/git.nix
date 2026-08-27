{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Sungbae Jeong";
      user.email = "almagest0328@gmail.com";
      init.defaultBranch = "main";
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}
