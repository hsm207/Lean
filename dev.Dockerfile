FROM ubuntu:xenial-20210114

RUN apt-get update && \
    rm -rf /var/lib/apt/lists/* && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb http://download.mono-project.com/repo/ubuntu stable-xenial/snapshots/5.12.0.226 main" > /etc/apt/sources.list.d/mono-xamarin.list && \
    apt-get update && \
    apt-get install -y binutils \
        git \
        mono-complete \
        ca-certificates-mono \
        mono-vbnc \
        nuget \
        referenceassemblies-pcl && \
    apt-get install -y fsharp && \
    rm -rf /var/lib/apt/lists/* /tmp/*