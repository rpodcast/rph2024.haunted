library(rix)
rix(
  r_ver = "frozen_edge",
  r_pkgs = c("dplyr", "dbplyr", "duckplyr", "duckdb", "shiny", "ggplot2", "plotly",  "magick", "dotenv", "leaflet", "pool", "DBI", "bsicons", "base64enc", "reactable", "golem", "usethis", "devtools", "attachment"),
  system_pkgs = c("vscodium"),
    git_pkgs = list(
        list(
          package_name = "shinychat",
          repo_url = "https://github.com/jcheng5/shinychat",
          commit = "de2e7f92284c426a5f058c40c2623f38803dd05e"
       ),
    list(
        package_name = "elmer",
        repo_url = "https://github.com/hadley/elmer",
        commit = "f1907a7190c56f1a5ca3919779af15b56e18373e"
     )
    ),
  ide = "code",
  project_path = ".",
  print = TRUE,
  overwrite = TRUE
)
