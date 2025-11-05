# Credit: https://github.com/thursdaddy/nixos-config/blob/58b3afe03aaf5d8b76806106846223548f4a3ff6/lib/default.nix
{
  lib,
  ...
}:
{
  /**
    Return the value if it is not-null. Otherwise return the default.

    # Example

    ```
    coalesce "foo" "bar"
    => "foo"
    coalesce null "bar"
    => "bar"
    ```

    # Type
    ```
    coalesce :: Any -> Any -> Any
    ```

    # Arguments

    **value**
    : The value to check for nullness.

    **default**
    : The return value if the earlier value is null.
  */
  coalesce = value: default: if value == null then default else value;

  /**
    Return the first item from the list or null if the list is empty.

    ```nix
    headOrNull [ ]
    => null
    headOrNull [ "foo" ]
    => "foo"
    ```

    # Type

    ```
    headOrNull :: [ Any ] -> Any
    ```

    # Arguments

    **list**
    : A list of items.
  */
  headOrNull = list: if list == [ ] then null else builtins.head list;

  /**
    Return the named attribute value from the attribute set, or the default value if the
    attribute set has no such named attribute.

    # Example

    ```nix
    getAttrOr "foo" { foo = 1; bar = 2; } 3
    => 1
    getAttrOr "baz" { foo = 1; bar = 2; } 3
    => 3
    ```

    # Type

    ```
    getAttrOr :: String -> AttrSet -> Any
    ```

    # Arguments

    **name**
    : The name of the attribute whose value we want to get.

    **attrs**
    : The attribute set to query.

    **default**
    : The return value if the attribute set does not contain the named attribute.
  */
  getAttrOr =
    name: attrs: default:
    if lib.hasAttr name attrs then lib.getAttr name attrs else default;

  /**
    Throw an error if the list has more than one items with the given message. Otherwise,
    return the list unchanged.

    # Example

    ```nix
    checkAtMostOne [ "bar" ] "more than one!"
    => [ "bar" ]
    checkAtMostOne [ "bar" "baz" ] "more than one!"
    error:
      ...
      error: more than one!
    ```

    # Type
    ```
    checkAtMostOne :: [ Any ] -> String -> [ Any ]
    ```

    # Arguments

    **list**
    : A list of items to check.

    **msg**
    : The error message if the list has more than one item.
  */
  checkAtMostOne = list: msg: if builtins.length list > 1 then throw msg else list;

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
