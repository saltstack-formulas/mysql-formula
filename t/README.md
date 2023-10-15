Scripts to test SLS changes in podman containers
-------------------

The goal is to cover following workflow:

* Change files related to an individual state.
* Spawn a container with a local standalone salt node and apply the states.
* Check basic bash commands to verify outcome.

The test is set of bash commands.
The script relies on shebang to prepare an image and spawn a container with the sls files.
It is also ready to test salt states using set of commands `salt-call --local`.

###### Example: Run test for mysql states:

```bash
cd t
./01-smoke-server.sh
```

#### Challenge 1: By default, a container is destroyed when the test finishes.

This is to simplify re-run of tests and do not flood machine with leftover containers after tests.
To make sure container stays around after faiure - set environment variable *T_PAUSE_ON_FAILURE* to 1

###### Example: Connect to the container after test failure

```bash
> # terminal 1
> echo fail >> 01-smoke-server.sh
> T_PAUSE_ON_FAILURE=1 ./01-smoke-server.sh
...
bash: line 18: fail: command not found
Test failed, press any key to finish
```
The terminal will wait for any input to finish the test and clean up the container.
Now use another terminal window to check the running podman container and get into it for eventual troubleshooting:

```bash
> # terminal 2
> podman ps
CONTAINER ID  IMAGE                                                                     COMMAND     CREATED        STATUS            PORTS       NAMES
2a37d23503fa  localhost/mysql.formula.t38c8b1d778efa61c676f1aa99b2aded5.image:latest              4 minutes ago  Up 4 minutes ago              mysql.formula.t38c8b1d778efa61c676f1aa99b2aded5.01-smoke-server.sh
> # use copy container id to start bash in it (hint: or bash completion should work for container name as well)
> podman exec -it mysql.formuls.t38c8b1d778efa61c676f1aa99b2aded5.01-smoke-server.sh bash
2a37d23503fa:/opt/project # ls
bin  encrypted_pillar_recipients  ENCRYPTION.md  FORMULAS.yaml	gpgkeys  pillar  README.md  salt  t  test
2a37d23503fa:/opt/project # # now we are inside the container and can troubleshoot outcome of salt commands
2a37d23503fa:/opt/project # rcmysql status
* mariadb.service - MariaDB database server
     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-03-17 12:45:24 UTC; 10min ago
```

#### Challenge 2: Vary OS in container.

Create new file Dockerfile.%osname% similar to existing Docker files in t/lib.
Use environment variable T_IMAGE=%osname% to let scripts use corresponding Dockerfile.
By default tests are run with t/Dockerfile.opensuse.leap

#### Challenge 3: Cache packages inside test image.

(Currently works only with default docker image, i.e. T_IMAGE is empty).
Downloading and installing packages may be time consuming, so sometimes it may be advantageous to have an option to pre-install required packages inside image, in which the test will be run. (So the test will concentrate on verifying other aspects of salt states, without spending time on installing packages).
At the same time the CI needs to verify salt states related to installation, so it must run the test without such caching.
Such caching is implemented as optional parameters to shebang command in the test scripts. These parameters are ignored unless global variable *T_CACHE_PACKAGES* is set to 1.

```bash
> # check parameter in shebang:
> head -n 1 01-smoke-server.sh
#!lib/test-in-container-systemd.sh mariadb
> # run the test in a container with preinstalled mariadb package as specified above:
> T_CACHE_PACKAGES=1 ./01-smoke-server.sh
> # run the test in a container without preinstalled mariadb package (will take longer, but will verify package installation as part of test)
> ./01-smoke-server.sh
```

