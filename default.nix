# This file was generated by the {rix} R package v0.12.4 on 2024-10-21
# with following call:
# >rix(r_ver = "frozen_edge",
#  > r_pkgs = c("dplyr",
#  > "dbplyr",
#  > "duckplyr",
#  > "duckdb",
#  > "shiny",
#  > "ggplot2",
#  > "plotly",
#  > "magick"),
#  > system_pkgs = c("vscodium"),
#  > git_pkgs = list(list(package_name = "shinychat",
#  > repo_url = "https://github.com/jcheng5/shinychat",
#  > commit = "de2e7f92284c426a5f058c40c2623f38803dd05e"),
#  > list(package_name = "elmer",
#  > repo_url = "https://github.com/hadley/elmer",
#  > commit = "f1907a7190c56f1a5ca3919779af15b56e18373e")),
#  > ide = "code",
#  > project_path = ".",
#  > overwrite = TRUE,
#  > print = TRUE)
# It uses the `rstats-on-nix` fork of `nixpkgs` which provides bleeding
# edge packages and R.
# Only use bleeding edge packages if absolutely needed!
# Read more on https://docs.ropensci.org/rix/articles/z-bleeding_edge.html
# Report any issues to https://github.com/ropensci/rix
let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2129d59191272dac59c4b6f45630d3d1d8876b68.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      dbplyr
      dplyr
      duckdb
      duckplyr
      ggplot2
      languageserver
      magick
      plotly
      dotenv
      leaflet
      auth0
      pool
      DBI
      bsicons
      base64enc
      reactable
      golem
      usethis
      devtools
      attachment
      shiny;
  };
 
  git_archive_pkgs = [
    (pkgs.rPackages.buildRPackage {
      name = "elmer";
      src = pkgs.fetchgit {
        url = "https://github.com/hadley/elmer";
        rev = "f1907a7190c56f1a5ca3919779af15b56e18373e";
        sha256 = "sha256-1PQSK9WmulwJEtgZ8heYpePhZsh2JH2FBiIqCyEEpjc=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          cli
          coro
          glue
          httr2
          jsonlite
          R6
          rlang
          S7;
      };
    })


    (pkgs.rPackages.buildRPackage {
      name = "shinychat";
      src = pkgs.fetchgit {
        url = "https://github.com/jcheng5/shinychat";
        rev = "de2e7f92284c426a5f058c40c2623f38803dd05e";
        sha256 = "sha256-F2V/SMiYEMaRD2lMoYfcDzAHbRMvTEZEdw6EyeP8olI=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          htmltools
          shiny
          coro;
      };
    })
   ];
   
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      glibcLocales
      nix
      R
      vscodium;
  };
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [ git_archive_pkgs rpkgs  system_packages   ];
  
}
