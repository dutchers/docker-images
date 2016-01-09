# Jenkins Custom image

Files in this folder help you to build a custom `Jenkins` image for installing
specific plugins in your `Jenkins` server. Then you can run a *Docker* container
using that image.

We're using `nginx` as reverse proxy to `Jenkins`.

## How to build Jenkins custom image

```
$ docker-compose -f dev.yml build
```

The default container name running *Jenkins* is called *jenkins-server*.

## How to run Jenkins using a Docker container

```
$ docker-compose -f dev.yml up -d
```

## Persistent data

In order to persist data, our *Docker* container is going to use a shared folder
from *host* machine. By default, this folder is `jenkins_data`. However, you can
change `volumes` directive on `dev.yml` for using a different location.

## How to connect to Jenkins

Open your browser and go to the following URL:

```
http://<docker_ip>
```

## Git integration

Your *Jenkins* server will need SSH keys to connect to your git server.
You can add those to the `jenkis_data/.ssh` directory.

Also, make sure your *Jenkins* server can connect to your git server. You
can run the following command:

```
git ls-remote <git_server_repo_url>
```

After executing that command, *Jenkins* server will ask you for adding the git
server IP to the `.ssh/know_hosts` directory. Then, *Jenkins* will be ready
to pull code from your git server.

### Build script for deployment

Your new *Jenkins* job should include the execution of a specific script for
getting a new build. When you're configuring a new job, you should mark
*Poll SCM* checkbox on *Build Triggers* section. Also, you should add the name
of the script that will be executed after polling code from *git* repository.
You can do that adding the name of the mentioned script to *Command* textarea,
inside *Build* section. Don't forget to mark *Execute shell* checkbox first. The
value for the mentioned textarea should be `scripts/jenkins_build.sh`.

Due to each project is using a different *virtualenv* and different *npm* modules,
each project should include the mentioned script, which will be executed after
polling code from *git*. The next lines are an example for content of the
 `scripts/jenkins_build.sh` script:

```
#!/bin/bash
ENV_DIRECTORY='env'

if [ ! -d "$ENV_DIRECTORY" ]; then
 virtualenv --system-site-packages env
fi

. $ENV_DIRECTORY/bin/activate

sudo pip install -r deploy/requirements/base.txt

npm install
grunt build
```

Obviously, project we're configuring in *Jenkins* should contain
`scripts/jenkins_build.sh` script.


### Hooks

If you want to launch a new *Jenkins* build process every time someone push
to git server, you can add the following code to the `hooks/post-receive` file
on your git server:

```
curl http://<jenkins_server_ip>:<jenkins_server_port>/git/notifyCommit/?url=<git_server_repo_url>
```

## Log file

*Dockerfile* will create a new path for using a specific *log* file for *Jenkins*. If you
want to see *log* information there, you can run the following command:

```
$ docker exec jenkins-server tail -f /var/log/jenkins/jenkins.log
```

### How to get log file when Jenkins crashes

```
$ docker-compose -f dev.yml stop
$ docker cp jenkins-server:/var/log/jenkins/jenkins.log jenkins.log
```

After executing the commands above, you'll get `jenkins.log` file in your current host
machine folder.

## How to stop Jenkins

```
$ docker-compose -f dev.yml stop
```
