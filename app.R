# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
options( "golem.app.prod" = TRUE)
options("shiny.port" = 2556)
options(auth0_disable = TRUE)
options(auth0_config_file = "inst/app/_auth0.yml")
run_app() # add parameters here (if any)
