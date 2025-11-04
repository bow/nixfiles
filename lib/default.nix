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
    Enable a module option with the specified attributes.

    # Example

    ```nix
    enabledWith { foo = "bar"; baz = { x = 100; }; }
    => {
      enable = true;
      foo = "bar";
      baz = {
        x = 100;
      };
    }
    ```

    # Type

    ```
    enabledWith :: AttrSet -> AttrSet
    ```

    # Arguments

    **attrs**
    : The attribute set that will be used for the enabled module.
  */
  enabledWith = attrs: { enable = true; } // attrs;

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

  /**
    Return a list of absolute string paths to all default.nix files that are children of the given directory.

    # Example

    ```nix
    lookupDefaultNixFiles ./.
    => [
      ".../modules/nixos/default.nix"
      ".../modules/nixos/users/default.nix"
    ]
    ```

    # Type

    ```
    defaultNixFilesIn :: Path -> [String]
    ```

    # Arguments

    **dir**
    : The starting path from which the lookup starts.
  */
  # Credit: https://github.com/thursdaddy/nixos-config/blob/1ac56531349c75dc69eadee6f99e2a2006e1246e/modules/nixos/import.nix
  lookupDefaultNixFiles =
    let
      inherit (lib)
        collect
        concatStringsSep
        isString
        mapAttrsRecursive
        mapAttrs
        ;

      # Recursively collect all files from a starting dir.
      walkDir =
        dir:
        mapAttrs (file: type: if type == "directory" then walkDir "${dir}/${file}" else type) (
          builtins.readDir dir
        );

      # Create a list of file paths that are children of the given dir.
      lookupFiles =
        dir: collect isString (mapAttrsRecursive (path: _type: concatStringsSep "/" path) (walkDir dir));

      # Create a list of list paths with the given name that are children of the given dir.
      lookupFilesNamed =
        name: dir:
        builtins.map (file: dir + "/${file}") (
          builtins.filter (file: builtins.baseNameOf file == name) (lookupFiles dir)
        );
    in
    dir: lookupFilesNamed "default.nix" dir;

  /**
    Create an attribute set from a list of attribute sets, keyed by the `name` attribute of each item.
    If there are multiple items with the same name, this function throws an error.

    # Example

    ```nix
    attrsByName [ { name = "foo"; x = 1; y = true; } { name = "bar"; x = 2; y = true; } ]
    => {
      foo = { ... };
      bar = { ... };
    }
    ```

    # Type

    ```
    attrsByName :: [ AttrSet ] -> AttrSet
    ```

    # Arguments

    **list**
    : The list containing attribute sets to transform.
  */
  attrsByName =
    list:
    let
      grouped = builtins.groupBy (item: item.name) list;
      dups = builtins.attrNames (lib.filterAttrs (_: v: builtins.length v > 1) grouped);
    in
    if builtins.length dups > 0 then
      throw "found duplicates with names: ${dups}"
    else
      builtins.listToAttrs (
        builtins.map (item: {
          name = item.name;
          value = item;
        }) list
      );
}
