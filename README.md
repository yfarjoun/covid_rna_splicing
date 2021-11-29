# project_template
A template for a project with CI and a docker image

# To use
After cloning this repo and using it as a template, you'll need to setup the two "secrets" (username and access token) for docker so that it will be able to push newly created docker images up to dockerhub for you. 

You'll also have to modify the dockerhub repository and image that the CI (continuous integration) will be pushing the newly minted images to. Currently it is setup to to go the "richardslab" repository and the "project_template" image. 

## Setting up your github secrets
1. go to hub.docker.com and log-in with the user you'd like to use for this purpose. 
2. click on your login at the top right corner and select "Account Settings"
3. Select "Security" and click on "New Access Token"
4. Give your token a descriton (something like, "An access token for the CI at the new-and-amazing-tool's repository")
5. Choose "Read & Write" as permissions
6. Click "Generate" 

7. WAIT, do not click "copy and close" yet!!!!

8. First, in a separate tab, go to github, to the repository you are setting up and go to "settings" => "secrets" and click "New repository secret"
9. Add a "DOCKERHUB_USERNAME" token with your dockerhub username
10. Add a "DOCKERHUB_TOKEN" token and for the value of the token switch back to the dockerhub tab, click "copy and close" and switch back to the github tab and paste the value.
11. Make sure that you see that there are two secrets as named above (you will not be able to verify their values...they are secret!)
12. If you need to, you can invalidate the token and put a new one in. Tokens are best used for one purpose each.

## Setting up the dockerhub repo and image 
1. Open the file "setup.json" in the root directory of the newly minted (git) repo. It should look like this:

```json
{
   "dockerhub_repo": "richardslab",
   "dockerhub_image": "project_template"
}


```
2. Edit the values (not keys) in this dictionary. make sure that there's a newline after the final `}` or you'll get strange errors. 
3. Save and file and commit it. 
4. Push your commits back to github and you should see in the "Actions" tab a few jobs starting up. Once they turn green you should be able to pull the docker image and use it!


## Personalizing the software
The current template contains an example of what one might want on in a dockerized conda environment, plus a few other things that cannot be easily installed via conda. Your project will probably want to have other things in it...

1. Update environment/environment.yml to include those packages/versions that you want. 
2. Update installation/03-post-conda-step.sh and use it to install/download software that you'd like installed but not via conda.
3. Add whatever other files you would like to have (analysis scripts, etc.)
4. Add some tests (for example as a github workflow, so that they will be run on every push.)
5. Commit and push often so you can see whether there are problems and try to fix them.

## Editing the entrypoint.sh
The file `entrypoint.sh` is currently set up to be run by docker with whatever arguments you give the docker command. It is currently setup to run the command you give it under the the conda environment. Please note that it takes about 5 seconds for the conda environment to be setup.

## Running docker.
To use the docker image you've created you'll need to pull it from dockerhub:
```bash
docker pull richardslab/project_template:latest
```
(You'll probably want to replace "richardslab" and "project_template" with the values you've put into the setup.json file. `latest` is a default tag that points to the last image that was uploaded. you can also use a specific tag if you want.)

and then run it. 

### Default Entrypoint
You can run it with the default entry point:
```bash
docker run --rm richardslab/project_template:latest echo hello world
```
which will (in this case) simply echo:

```
hello world
```

### Modify the Entrypoint
You can also change the entrypoint:
```bash
docker run  --rm --entrypoint=/bin/bash richardslab/project_template conda list 
```
in this case I've changed the entrypoint to bash which will not intialize the conda environment and so you'll only see the packages that are available in the "base" env. if you try to run bwa or java with this entrypoint, it will fail because it's not run inside the conda environment.

### Interactive mode
Finally if you are looking for an interactive session you can also get that:
```bash
docker run  --rm -it --entrypoint=/bin/bash richardslab/project_template 
```

Note that in this docker image, when bash is started up in an interative mode, it will initialize the analysis conda environment automatically, so (a) it takes several seconds to start-up, and (b) your prompt will show this:
```
(analysis) root@0fdbe03ad320:/app# 
```
at this point you should have access to all the software that you installed in the image.

### Mounting local drives
You probably want to use the docker image to analyse some data that you have on your local computer, and eventually have access to the results.... for this you'll have to mount one (or more) of your directories. For example, if you want to mount the current directory and have it available in the docker at location '/local' you can do it like so:

```bash
docker run  --rm -v$(pwd):/local richardslab/project_template -c 'echo test > /local/helloworld.txt'
```
now look for the file helloworld.txt in your current directory.

Or you coudl try to run soemthing from the conda environment:
```bash
docker run  --rm -v$(pwd):/local richardslab/project_template bwa mem '2>' /local/helloworld.txt
```

Note that the `2>` (redirecting the stderr to a file) needs to be escaped so that the current shell (the one in which you are invoking docker) doesn't interpret it....
