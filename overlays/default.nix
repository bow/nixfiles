{
  inputs,
  pkgs-unstable,
  pkgs-local,
  ...
}:
{
  additions = final: _prev: {
    unstable = pkgs-unstable;
    local = pkgs-local;
  };

  replacements = _final: _prev: {
    inherit (pkgs-unstable)
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

  modifications = final: prev: { };
}
