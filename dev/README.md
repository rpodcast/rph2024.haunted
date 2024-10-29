# R/Pharma 2024 Haunted Places Quiz Application Developer Guide

This document contains additional details on setting up a development environment for building the Haunted Places Quiz application as well as information on additional services utilized in the backend. 

## Development Environment

Refer to these [instructions](https://github.com/rpodcast/r_dev_projects/blob/main/.devcontainer/README.md) for how to set up your environment to use this container setup.

## Environment Variables

Each of the services discussed in this document require authentication keys stored as environment variables. The `.Renviron.example` file contains the variables alongside placeholder keys. Contact the author of this application for the real values of these variables and create a new `.Renviron` file in the root of this repository with the correct values. Note that this file will not be version-controlled. 

## Authentication

The production version of the haunted places quiz app uses the [Auth0](https://auth0.com/) service in order to track a user's questions and answers for their personalized quiz. When executing the application in development mode, the Auth0 portal is bypassed and a test user is automatically tracked in the application. If you want to execute the Auth0 login portal in a development context, edit the `dev/run_dev.R` script and set `options(auth0_disable = FALSE)`. Make sure to switch it back to `options(auth0_disable = TRUE)` after finishing your ad-hoc testing.

Note: When using the Auth0 feature, you must open the application in a web browser tab. The RStudio viewer tab as well as Visual Studio Code's internal app viewer tab are not able to render the application correctly. 

At the time of this writing, the Auth0 login portal supports the following social logins:

* Amazon
* Bitbucket
* Discord
* Dropbox
* GitHub
* Slack

In addition, the user can create a login with an email address and password. 

## Deployment container instructions

### Initialize Docker Files

In the `dev/03_deploy.R` script, run the `golem::add_dockerfile_with_renv(output_dir = 'dev/deploy')` function that will produce a directory with two docker build files corresponding to two images:

* `Dockerfile_base`: Image that installs required system dependencies and R packages using `renv`.
* `Dockerfile`: Image that adds on top of the image created in `Dockerfile_base` to restore the package library from `renv`, install the app's package tar file, and run the app process in a command line call to R itself.

Note: Need to add another option declaration in the run app line: 

```
auth0_config_file = system.file('app/_auth0.yml', package = 'rph2023.breakapp')

auth0_disable = FALSE
```

Hence the run line looks like this:

```
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0',auth0_config_file = system.file('app/_auth0.yml', package = 'rph2023.breakapp'),auth0_disable = FALSE);library(rph2023.breakapp);rph2023.breakapp::run_app()"
```

### Build Docker Images on Local System

To build the Docker images, navigate to the `dev/deploy` directory and run the following build commands:

```
# First image
docker build -f Dockerfile_base --progress=plain -t rpodcast/rph2024.haunted_base .

# Second image
docker build -f Dockerfile --progress=plain -t rpodcast/rph2024.haunted:latest .
```

Verify that the container version of the application runs correctly on your local development system. Note the port number you map from the host OS to the container needs to be registered in the Auth0 list of callback URLs. Also, note that the `.env` file reference in the command contains the credentials necessary for the application to authenticate to the required services. In this example, the environment file has been copied to the `dev/deploy` directory (without being version-controlled):

```
docker run --env-file .env -p 7771:80 rpodcast/rph2024.haunted:latest
```

In a web browser, visit `http://localhost:7771`.

**SIDE NOTE**: If you encounter errors or other issues with the app, here's a general procedure for debugging:

* Stop the docker container

```
# find the container friendly name
docker ps

docker stop <container_friendly_name>
```

* Modify source code of application as needed. Ensure that you bump the package version in `DESCRIPTION` either manually or running `usethis::use_version("dev", push = FALSE)`.
* Run these snippets from `dev/03_deploy.R` to refresh package build

```r
# dev/03_deploy.R
unlink("dev/deploy/*.tar.gz")
devtools::build(path = "dev/deploy")
```

* Re-build the second Docker container image

```
docker build -f Dockerfile --progress=plain -t rpodcast/rph2024.haunted:latest .
```

* Run the container again

```
docker run --env-file .env -p 7771:80 rpodcast/rph2024.haunted:latest
```

### Push Docker Images to Dockerhub

Ensure that you are able to push to Docker Hub by running the following command to log in to the service and set credentials for future operations:

```
docker login -u rpodcast
```

Once the login is successful run the following:

```
# Push first container image
docker push rpodcast/rph2024.haunted_base

# Push second container image
docker push rpodcast/rph2024.haunted
```

## App Deployment

Procedure adapted from <https://hosting.analythium.io/make-your-shiny-app-fly/>

1. Install the `flyctl` command line tool
1. Authenticate to the service using this command:

```
flyctl auth login
```

1. Launch application on service

```
flyctl launch --image rpodcast/rph2024.haunted:latest
```

2. After deployment is complete, you need to add the environment variables using following commands (repeat for each variable until I find a better way):

```
fly secrets set OPENAI_API_KEY=changeme
fly secrets set AUTH0_USER=changeme
fly secrets set AUTH0_KEY=changeme
fly secrets set AUTH0_SECRET=changeme
```