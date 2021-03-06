FROM quantconnect/lean:foundation

# debugger for VS Code
RUN pip install ptvsd

# gets autocomplete working...
RUN pip install quantconnect-stubs
RUN conda install -y -c conda-forge notebook=6.0.3
