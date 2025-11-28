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

  modifications = _final: prev: {
    # To speed up builds.
    terraform = prev.terraform.overrideAttrs (_: {
      doCheck = false;
    });
    unstable = prev.unstable // {
      terraform = prev.unstable.terraform.overrideAttrs (_: {
        doCheck = false;
      });
    };
  };
}
