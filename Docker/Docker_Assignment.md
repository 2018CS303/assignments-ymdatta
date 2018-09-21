# Docker Case Study - Automating Infrastructure Allocation.

## Problem Statement:

- Allocation of independent Linux Systems for users.
- Each Linux system should have specific training environments.
- User should not have privilege properties(like accessing other containers etc).
- Ability to monitor the independent Linux Systems for deployer.
- Automate the Linux Systems creation and deletion.

## Docker:
- We will be using ``Containers`` technology(``Docker``) to achieve this. ``Containers`` are a method of operating system virtualization that allow you to run an application and its dependencies in resource-isolated processes. 
- We will be using ``ubuntu`` docker image as starting point.

# Creation of Training Environment:
- The ``Ubuntu`` container we will get using docker is a very light one and it doesn't have necessary features in it. So, we will create a new container upon that and we will use it.

- First, create a bare-metal ``Ubuntu`` container and use it's shell by running `docker run --name barecont -it ubuntu /bin/bash`. ``-it`` flag opens the container in **interactive terminal** mode.
- Add Packages that may be needed by the individuals who will be using it. Ex: Compilers like gcc, debuggers like gdb etc to run **C** language programs.
- Now, exit from the shell by typing exit`` on the container's command line.
- Now, the **important** part, we can create a new container upon the ``barecont`` container by running `docker commit barecont infra:v1` (``infra`` is the image name with ``v1`` tag).
- The ``infra:v1`` image will be used to create containers for individuals. We can also push our custom containers to docker hub and pull from it whenever required.

# Allocation of Container for each user:
Our container image is ready and we can create a container for each user. We provide unique container name to refer it afterwards.

Ex: To create a container for say user ``pepsi`` the command to use is:
`docker create -it --name pepsi infra:v1 /bin/bash`. This creates the container with name pepsi using the infra:v1 image.

If we are given a list of user id's, then we can automate the allocation of containers using shell script. Let the file containing user id's be `usernames`:
```
user_1
user_2
user_3
user_4
user_5
```

The script that automates container allocation is `allocate.sh`
```bash
#!/bin/bash

echo -n "Enter users file: "
read file
while read user || [[ -n "$user" ]]
do 
        docker create -it --name $user infra:v1 /bin/bash
        done < "$file"
```
We can execute the allocate.sh script to allocate the containers to users.

# Using the allocated Containers:
Now that we have crated a container for each user, we need to start it and attach the container to local standard input, output and error streams.

The container for user with id `pepsi` can be used by running the following commands:
```bash
docker start pepsi
docker attach pepsi
```
If the user runs the above commands, he gets access to the shell of the "container". The user can use `exit` to come out of the container, the state is preserved and when the container is started next time, it reloads the previous state.

# Important feature of container created in this way:
Since the Docker creates a UNIX Socket and the commands actually communicate with the docker daemon via the socket. The user cannot access the hosts systems docker daemon even though he installs the docker package using the socket.

# Monitoring Containers:
We can view the resource usage of container `pepsi` by running the command `docker stats pepsi`.
So the script is Monitor.sh
```bash
echo -n "Enter username: "
read user
docker stats $user
```

It returns ouput in this format:
```
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT   MEM %               NET I/O             BLOCK I/O           PIDS
7ca60625b2fd        pepsi               0.00%               0B / 0B             0.00%               0B / 0B             0B / 0B             0
```

We can also get the real time logs of the container using `docker logs -f pepsi'. 

# Deleting Containers:
If we exit from a container, it only stops the container and it's state is preserved and next time when it is attached again state is reloaded again.

To remove the stopped container permanently, we can use the `docker rm pepsi` command.

If we have file which contains usernames(this can be the file with user id's, which we used to create the containers in the first place), we can create a shell script to delete the containers.

```bash
#!/bin/bash

echo -n "Enter users file: "
read file
while read user || [[ -n "$user" ]]
    do
      docker stop $user
      docker rm $user
    done < $file
```

By executing the above script, we can delete the containers permanently.
# Note:
We need to give execute permission to .sh files before executing, it can be done using:
```chmod 777 filename.sh```.
# Conclusion:

We have seen how easy it is to create seperate environments for individuals and ease with which we can monitor them. All these can be done without causing any harm host-systems and other docker containers. 