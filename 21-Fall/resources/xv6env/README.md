# xv6 lab environments

## install qemu from scratch

Since we won't use the latest qemu, some additional work are required:
we need to install it from source files. 
Basically, we follow three steps,

```bash
% cd the/source/file/directory

# configure the install environments, check whether all dependencies are available ...
% ./configure

# compile source files with Makefile
% make

# copy the compiled binaries (object files, libs) to configured locations
# specified by ./configure
% make install
```

Here, we take installing qemu as an example of above process.

```bash

% cd path/to/the/unzipped/qemu/source/file


# we will install qemu binaries in the build directory 
% mkdir build 

% cd build


# configure qemu to only build the i386 simulator and 
# specify the correct python version.
# After this step, you will see some directories and files created in build 
% ../configure --disable-kvm --disable-werror --target-list="i386-softmmu" --python=/usr/bin/python2.7

# compile source files with Makefile. If it successes, you will find a binary file 
# build/i386-softmmu/qemu-system-i386/qemu-system-i386
# and that is the qemu simulator we will use.
% make

# here make install is optional. We could manually specify 
# the qemu location in the xv6 makefile.
# Otherwise, you can either install qemu binaries to a specifified location with
# % make DESTDIR=/path/to/another/directory install
# or simply make a global install with
# % sudo make install

```


Finally, installing qemu may require some old dependencies 
(libglib2.0-dev, libpixman-1-dev, libfdt-dev).
If you encounter dependencies errors during make, 
try to install those packages and recompile.



## install qemu in Docker

We also find that qemu compiled with some new gcc versions (say >10) may not host xv6 correctly.
To workaround, you may try our docker image which jails an older building environment
(the image is roughly 600M, please make sure you have enough space.)

```bash

% mkdir xv6env && cd

# copy qemu, xv6 and Dockerfile
% cp /path/to/qemu/tarball /path/to/xv6/source/tarball Dockerfile .

# build your docker image 
% docker build -t your_image_name .

# start the docker container. 
# The current directory (xv6env) is mount to /home/alice of the image,
# thus you can persist your modification of xv6 in the container on the directory xv6env
% docker run -v $PWD:/home/alice -it your_image_name

# build qemu and xv6 in the container
```








