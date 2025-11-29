{
  inputs,
  ...
}:
{
  additions = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev) system;
      config.allowUnfree = true;
    };
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
