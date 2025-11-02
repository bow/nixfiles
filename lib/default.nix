# Credit: https://github.com/thursdaddy/nixos-config/blob/58b3afe03aaf5d8b76806106846223548f4a3ff6/lib/default.nix
{
  lib,
  ...
}:
{
  /**
    Create a NixOS module option.

    # Example

    ```nix
    mkOpt nixpkgs.lib.types.str "value" "Description"
    => {
      _type = "option";
      default = "value";
      description = "Description";
      type = { ... };
    }
    ```

    # Type

    ```
    mkOpt :: Type -> Any -> String -> AttrSet
    ```

    # Arguments

    **type**
    : A nixpkgs.lib.types value.

    **default**
    : The default value for the function.

    **description**
    : A human-readable description of the option.
  */
  mkOpt =
    type: default: description:
    lib.mkOption { inherit type default description; };

  /**
    Create a NixOS module option with a null default.

    # Example

    ```nix
    mkOpt' nixpkgs.lib.types.str "Description"
    => {
      _type = "option";
      default = null;
      description = "Description";
      type = { ... };
    }
    ```

    # Type

    ```
    mkOpt :: Type -> String -> AttrSet
    ```

    # Arguments

    **type**
    : A nixpgs.lib.types value.

    **description**
    : A human-readable description of the option.
  */
  mkOpt' = type: description: lib.mkOption { inherit type description; };

  /**
    Shorthand for enabling a module option.

    # Example

    ```nix
    enabled
    => { enable = true; }
    ```

    # Type

    ```
    enabled :: AttrSet
    ```
  */
  enabled = {
    enable = true;
  };

  /**
    Shorthand for disabling a module option.

    # Example

    ```nix
    disabled
    => { enable = false; }
    ```

    # Type

    ```
    disabled :: AttrSet
    ```
  */
  disabled = {
    enable = false;
  };
}
