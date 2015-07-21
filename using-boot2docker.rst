About boot2docker
-----------------

Linux Vs Mac
============

boot2docker provides an native-like-feeling for working with boot2docker. Rather then rolling a linux-kernel, you can sit behind a VM utilizing virtualbox to get started with docker.

Download and Install
====================

* https://github.com/boot2docker/osx-installer/releases/tag/v1.7.1

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



