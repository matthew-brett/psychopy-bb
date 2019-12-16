# Run from IPython to source the master.cfg file into 'ns' dict.
import os

cwd = os.getcwd()
ns = {}
try:
    os.chdir('master')
    with open('master.cfg', 'rt') as fobj:
        contents = fobj.read()
    exec(contents, ns)
finally:
    os.chdir(cwd)
