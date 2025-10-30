## Installation for development

Create your repository from template.

Clone/git pull the repo into any local directory e.g. like it is shown below (here I show all the examples related to this repository, but I assume you have your own derived from the template):

```
$ git clone git@github.com:intersystems-community/iris-rest-api-template.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d --build
```

## Checking out the Swagger Specs

Once you have the docker container running, you can navigate to the Swagger UI using `Ctrl+Shift+p > ObjectScript: Server Actions > Swagger`. The username is "\_SYSTEM" and the password is "SYS".
You can get more specific documentation of the demo api that I built if you type in `http://localhost:52773/crud/patient/_spec` and `http://localhost:52773/crud/record/_spec` in the Swagger url input.

## Exporting impl.cls files after compiling spec files

After compiling a spec file, the `impl` and `disp` are compiled and saved on the docker server. You can export them into your project files using `Ctrl+Shift+p > ObjectScript: Export Code from Server`. Make sure to uncheck all the files except the `impl` file you want. InterSystems preserves edits on `impl` classes when regenerated.
