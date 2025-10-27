# Credit: https://github.com/thursdaddy/nixos-config/blob/58b3afe03aaf5d8b76806106846223548f4a3ff6/lib/default.nix
{
  lib,
  ...
}:
{
  ## Create a NixOS module option.
  ##
  ## ```nix
  ## lib.mkOpt nixpkgs.lib.types.str "default" "Description"
  ## ```
  ##
  #@ Type -> Any -> String
  mkOpt =
    type: default: description:
    lib.mkOption { inherit type default description; };

  ## Create a NixOS module option with a null default.
  ##
  ## ```nix
  ## lib.mkOpt' nixpkgs.lib.types.str "Description"
  ## ```
  #@ Type -> String
  mkOpt' =
    type: description:
    lib.mkOption { inherit type description; };

  enabled = {
    ## Shorthand for enabling an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ true
    enable = true;
  };

  disabled = {
    ## Shorthand for disabling an option.
    ##
    ## ```nix
    ## services.nginx = disabled;
    ## ```
    ##
    #@ false
    enable = false;
  };
}
