# dev-machine


Mostly operates like the old dev-machine. Depends upon base-machine. Added some
tools to make deploying easier.  These are not complete but are most of the way
there in their naive form.

## Running docker on Joyent Triton

All commands in this section are executed inside the dev container. We've added
the base commands to /usr/local/bin and /usr/local/bin to the path. However except
for make_project_key all commands refer to /srv/active/bin  which from inside
the docker container is PROJECT_ROOT/bin so you'll need to get the actual
commands from https://stash.ff0000.com/projects/AD/repos/ad-manager/browse/bin?at=refs%2Fheads%2Fdevelop
then customize to your needs. Ultimately we'll add these to the boilerplate.

Joyent docs are here: https://apidocs.joyent.com/docker

In short what you are doing is telling your docker client to talk to Joyents
orchestration tools.

Create a project key. This will save you from copying your id into the
developer users .ssh/ everytime you want to rebuild your image. The command
should be in your path already if not, it's in /usr/local/bin/

<pre>
    make_project_key project_name
</pre>

Then add the key to the Joyent account.

You should now be able to run sdc-docker-setup.sh. make_project_key creates a key
with no password, so you'll only need to answer a few questions.

Bringing docker instance up in Triton requires a few things. Your images need to
be in a repository that Triton can access; we have a hub.docker.com account to
deal with this temporarily while we are exploring docker. You'll need to
request access to the FF0000 organization so that you can create and push to a
private repo. This will likely only be the app server instance. Hopefully in
the future it will rarely even be that.

## /bin

build.sh
   Runs webpack and copies production necessary python files to
   .build/<GIT_HASH> then tbz's them.
push.sh
    Send the tbz to manta and execute update_app on the production servers.
setup.sh
    Runs npm install and pip install. Manta will need to be installed on the
    server being run on Triton. pip install manta
