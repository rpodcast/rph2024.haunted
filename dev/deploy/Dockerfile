FROM rpodcast/rph2024.haunted_base
COPY renv.lock.prod renv.lock
RUN R -e 'options(renv.config.pak.enabled = FALSE);renv::restore()'
COPY rph2024.haunted_*.tar.gz /app.tar.gz
RUN R -e 'remotes::install_local("/app.tar.gz",upgrade="never")'
RUN rm /app.tar.gz
EXPOSE 80
EXPOSE 7771
USER rstudio
CMD R -e "options('shiny.port'=7771,shiny.host='0.0.0.0',auth0_config_file = system.file('app/_auth0.yml', package = 'rph2024.haunted'),auth0_disable = FALSE);library(rph2024.haunted);rph2024.haunted::run_app()"
