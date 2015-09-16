About docker-machine
--------------------

docker-machine is used to manage virtual machines which can host docker
instances. It can be used to spin up docker hosts in Google Compute Engine, AWS,
and other platform providers. While in general this the kind of idea only person
invested in bad technology would make, it's useful for developers who want the
convenience of docker on OS's like Mac and Windows. docker-machine allows those
users to spin up one lightweight VM to host all their docker containers.


Download and Install for OS X
=============================

docker-machine is distributed with docker 1.8+ which you should install with brew. If you
don't have brew you consider opening up Powerpoint and making presentations for a
living.

`brew install docker`

The other requirement is Virtualbox 4 so install that from
https://www.virtualbox.org/wiki/Download_Old_Builds_4_3.

Next create a host to house your docker instances:

`docker-machine create --virtualbox-hostonly-cidr "192.168.240.1/24" --driver virtualbox dev`

You now have a virtualbox instance running the boot2docker.iso. This instace has the docker
server tools installed and will accept commands from the docker client running your local
command line. To configure the local docker command tos talk to the virtualbox docker server
follow the output from the previous command, which tells you to this:

`eval "$(docker-machine env dev)"`

With that you can run docker images... but if you want to work use them to work with local
files or provide access to users that on your computer - say for looking at webpage - you've
got a few more steps.

Let's mount your /Users directory into the VirtualBox instance





Trouble Shooting
================

I can't access the project vi Chrome|FireFox|Safari
###################################################

You'll probably missing a few Port Forward settings

.. figure:: screenshots/vb-main.png
    :width: 550px
    :align: center

.. figure:: screenshots/vb-main-settings.png
    :width: 550px
    :align: center

.. figure:: screenshots/vb-main-settings-network.png
    :width: 550px
    :align: center

.. figure:: screenshots/vb-port-forward-initial.png
    :width: 550px
    :align: center

.. figure:: screenshots/vb-port-forward-tail.png
    :width: 550px
    :align: center


My Docker directory doesn't have anything in it
###############################################

VirtualBox requires you to share a local directory with the hypervisor so boot2docker can pass content from the local-filesystem into the remote filesystem inside the VM.

.. code-block:: bash

    sudo VBoxManage sharedfolder add boot2docker-vm --name /Users --hostpath /Users
    # Restart VirutalBox
    boot2docker stop && boot2docker delete && boot2docker init && boot2docker start


My Docker commands wont run
###########################

vi ~/.bash_profile

.. code-block:: bash

    # If docker fails, do the following:
    # https://github.com/boot2docker/boot2docker/issues/824
    # $ boot2docker stop && boot2docker delete && boot2docker init && boot2docker start
    export DOCKER_HOST=tcp://x.x.x.x:0000
    export DOCKER_CERT_PATH=/Users/<username>/.boot2docker/certs/boot2docker-vm
    export DOCKER_TLS_VERIFY=1
    alias docker_vm_bambam="boot2docker stop && boot2docker delete && boot2docker init && boot2docker start"
