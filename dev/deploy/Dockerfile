FROM rph2024.haunted_base
COPY renv.lock.prod renv.lock
RUN R -e 'options(renv.config.pak.enabled = FALSE);renv::restore()'
COPY rph2024.haunted_*.tar.gz /app.tar.gz
RUN R -e 'remotes::install_local("/app.tar.gz",upgrade="never")'
RUN rm /app.tar.gz
EXPOSE 80
USER rstudio
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');library(rph2024.haunted);rph2024.haunted::run_app()"
