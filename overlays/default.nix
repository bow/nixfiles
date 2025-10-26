{
  inputs,
  pkgs-unstable,
  ...
}:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };
  replacements = _final: _prev: {
    ghostty = pkgs-unstable.ghostty;
  };
  modifications = final: prev: { };
}
