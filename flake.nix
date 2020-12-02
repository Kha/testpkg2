{
  description = "My second Lean package";

  inputs.lean.url = github:leanprover/lean4;
  inputs.testpkg1.url = github:Kha/testpkg1;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, lean, testpkg1, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let leanPkgs = lean.packages.${system}; in rec {
      packages = {
        inherit (leanPkgs) lean;
      } // leanPkgs.buildLeanPackage {
        name = "TestPkg2";  # must match the name of the top-level .lean file
        src = ./.;
        deps = [ testpkg1.packages.${system} ];
      };

      defaultPackage = packages.modRoot;
    });
}
