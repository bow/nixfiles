{
  inputs,
  ...
}:
let
  pkgsUnstableForSystem =
    system:
    import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
in
{
  additions = final: prev: {
    unstable = pkgsUnstableForSystem prev.system;
    local = import ../packages { pkgs = final; };
  };

  replacements = _final: prev: {
    inherit (pkgsUnstableForSystem prev.system)
      asdf-vm
      ghostty
      poetry
      polybar
      pyenv
      rofi
      rofi-pass
      rustup
      uv
      ;
  };

  modifications = _final: _prev: { };
}
