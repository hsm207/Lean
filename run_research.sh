#!/usr/bin/env bash

# remember to make this script executable! chmod +x
# if something breaks, check DockerfileJupyter for required changes

# process the in-line arguments
for arg in "$@"; do
    eval "$arg"
done

mkdir -p /root/.ipython/profile_default/startup/ &&
    cp -f /workspaces/Lean/Research/start.py /root/.ipython/profile_default/startup/ && 
    cd /workspaces/Lean/PythonToolbox && \
    python setup.py install

# copy the build to a separate location
rm -rf /Lean
mkdir -p /Lean/Launcher/bin/Debug &&
    cp -r /workspaces/Lean/Launcher/bin/Debug /Lean/Launcher/bin

mkdir -p /Lean/Optimizer.Launcher/bin/Debug &&
    cp -r /workspaces/Lean/Optimizer.Launcher/bin/Debug/ /Lean/Optimizer.Launcher/bin

WORK=/Lean/Launcher/bin/Debug
mkdir $WORK/pythonnet && \
    mv -f $WORK/Python.Runtime.dll $WORK/pythonnet/Python.Runtime.dll && \
    mv -f $WORK/jupyter/* $WORK && \
    chmod -R 777 $WORK

# define the config file
cat << EOF > $NOTEBOOK_DIR/config.json
{
    "data-folder":"$DATA_DIR",
    "composer-dll-directory":"$WORK",
    "algorithm-language":"Python",
    "messaging-handler":"QuantConnect.Messaging.Messaging",
    "job-queue-handler":"QuantConnect.Queues.JobQueue",
    "api-handler":"QuantConnect.Api.Api",
    "job-user-id":"$QC_API_USER_ID",
    "api-access-token":"$QC_API_TOKEN"
}
EOF

export PYTHONPATH=$WORK:$PYTHONPATH

# Work around for https://github.com/pythonnet/clr-loader/issues/8
pip install clr-loader==0.1.5
cp /workspaces/Lean/Research/fix_ffi_mono.py /opt/miniconda3/lib/python3.6/site-packages/clr_loader/ffi/mono.py
cp /workspaces/Lean/Research/fix_mono.py /opt/miniconda3/lib/python3.6/site-packages/clr_loader/mono.py

export LD_LIBRARY_PATH=/lib/
ln -s /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so


jupyter lab \
    --ip='0.0.0.0' \
    --port=8889 \
    --no-browser \
    --allow-root \
    --notebook-dir=$NOTEBOOK_DIR \
    --LabApp.token=''