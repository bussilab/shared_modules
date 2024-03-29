# Group modules

These are instruction on how to use modules that are installed at SISSA, both on workstations and on hpc cluster, and are meant to be used within the group.
The [scripts](./scripts) directory contains the scripts that were used to install the modules.

## Enabling this set of modules

On workstations:
```
module use /u/b/bussi/shared_modules/modules
```

On cluster:
```
module use /home/bussi/shared_modules
```

## Available modules

### Python 3.9
```
module load python/3.9
```

Once loaded, other modules will become available and compatible with this python version.
Notice that executable is named `python3`, and not `python`!

#### Basic python modules
```
module load py-base
```
This is versioned according to the date on which the tools were packages were installed.
It contains a number of general purpose tools (numpy, pandas, jupyter, barnaba, etc).
Notice that, due to the way the PYTHONPATH environment variable work, it is easy to override
these modules with more recent versions if you need them.

When this module is installed first, a new file is written in the [scripts](./scripts) directory
documenting the exact version of each tool. For instance,
[this is the file](./scripts/py-base-2022.11.29-requirements.txt) corresponding to the module installed on Nov 29, 2022.

#### Group tools
```
module load py-bussilab
```
The tools documented [here](https://bussilab.github.io/doc-py-bussilab/bussilab/index.html).
I left them as a separate module so that I can update them more frequently than the `py-base`
module.

#### Cudamat
```
module load cudamat
```
Versioned according to the date and on the cuda drivers used.

#### JAX
```
module load jax
```
Versioned according to the version of both jax and jaxlib. Notice that, in order to use the cuda version
currently available on our machines, older jax/jaxlib versions are installed

### GROMACS
```
module load gromacs
```
Versioned according to the GROMACS version and possible modifications. Notice that one can load a different version of PLUMED by loading a suitable module. However, it is important to record which version of PLUMED was used for patching since patches themselves evolve with time:
- `gromacs/2020/2020.7-cr-p-2.8.1` version 2020.7, patched with plumed 2.8.1 (compatible with any plumed version) and with [crescale](https://github.com/bussilab/crescale) barostat (will be available by default in version 2021).

### PLUMED
```
module load plumed
```
Versioned according to PLUMED version. We might have more ad hoc versions in the future. It should be possible to combine any PLUMED version with any GROMACS version:
- `plumed/2.8/2.8.1` version 2.8.1, all external modules enabled
- `plumed/2.8/2.8.2` version 2.8.2, all external modules enabled

It is also recommended to setup [plumed command autocompletion](https://www.plumed.org/doc-v2.8/user-doc/html/_bash_autocompletion.html) and, if you are using VIM, [vim syntax](https://www.plumed.org/doc-v2.8/user-doc/html/_vim_syntax.html). This has to be done once in your `.bashrc` and `.vimrc` files.


### ViennaRNA
```
module load ViennaRNA
```
Versioned according to ViennaRNA and to the version of python for which the python wrappers were compiled.

### htop
```
module load htop
```
[htop](https://htop.dev/) is a better replacement of `top`.

### ncdu
```
module load ncdu
```
ncdu shows disk usage [graphically in the terminal](https://dev.yorhel.nl/ncdu/scr).
