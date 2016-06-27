Docker
--------------------

Docker on OS X requires a virtual machine manager, we use Virtualbox. The below
will walk you through the process of getting docker up and running on a computer
running OS X. The primary tool for set up is docker-machine.

docker-machine is used to manage virtual machines that can host docker
instances. It can be used to spin up docker hosts in Google Compute Engine, AWS,
and other platform providers. It's also useful for developers who want the
convenience of docker on OSes like Mac and Windows. docker-machine allows those
users to spin up one lightweight VM to host all their docker containers.


Download and Install for OS X
=============================

First install the latest verision of VirtualBox.

Each of the docker tools is installed individually on OS X.

:code:`brew install docker`
:code:`brew install docker-machine`
:code:`brew install docker-compose`
:code:`brew install docker-machine-nfs`

Next create a host to house your docker instances – we specifiy the host IP to avoid
network conflicts. If this IP conflicts with addresses on your network choose another:

:code:`docker-machine create --virtualbox-hostonly-cidr "192.168.240.1/24" --driver virtualbox dev`

You now have a VirtualBox instance running the boot2docker.iso. This instace has the docker
server tools installed and will accept commands from the docker client running your local
command line. To configure the local docker command to talk to the VirtualBox docker server
follow the output from the previous command, which tells you to do this:

:code:`eval "$(docker-machine env dev)"`

With that you can run docker images... but if you want them to work with local
files or provide access to users that on your computer - say for looking at webpage - you've
got a few more steps.

Let's mount your /Users directory into the VirtualBox instance. If you keep your
projects somewhere else you can substitue that directory. Don't worry, so long as
where you are running your docker-compose commands from is a subpath of the directory
it will work. If you'd like to mount a directory outside of /Users read the docs
here: https://github.com/adlogix/docker-machine-nfs otherwise execute the following:

:code:`docker-machine-nfs dev`

**Note:** If you are running a tool that supports kernel based filesystem
notifications you will need to change it's configuration to use polling instead.
webpack does this by default. Add the following to your webpack config:

.. code:: javascript

    watchOptions: {
        poll:true;
    }


Port Forwarding
###############

It's time to get GUI. Open VirtualBox in the UI.

.. figure:: screenshots/vb-main.png
    :width: 550px
    :align: center

Select the 'dev' machine on the left then click 'Settings'.

.. figure:: screenshots/vb-main-settings.png
    :width: 550px
    :align: center

Click 'Network' in the modal dialog that pops up.

.. figure:: screenshots/vb-main-settings-network.png
    :width: 550px
    :align: center

Click 'Port Forwarding' and ad a forward for 8000 to 8000 and any other ports you want
accessible to the world.

.. figure:: screenshots/vb-port-forward-initial.png
    :width: 550px
    :align: center



After completing this you'll need to get teh environment again.

:code:`eval "$(docker-machine env dev)"`
