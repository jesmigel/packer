# packer
Packer template repository. Current templates are used to build vmware iso vm templates used for VMWare ESXi hosts or preferrably through vCenter.

### References
| Name | Comments |
| - | - |
| [Dependencies](https://github.com/jesmigel/ansible-role-common#dependencies) | Deployment Toolchain |
| [Make Commands](https://github.com/jesmigel/ansible-role-common#make-commands) | Deployment Shortcuts |
| [Preflight Steps](https://github.com/jesmigel/ansible-role-common#preflieght-steps) | Pre deployment configuration 
|||

### Ansible Roles
| Name | Status | Comments |
| - | - | - |
| [ansible-role-common](https://github.com/jesmigel/ansible-role-common) | [![CI](https://github.com/jesmigel/ansible-role-common/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/jesmigel/ansible-role-common/actions/workflows/build.yaml) | Baseline role |
| [ansible-role-hashicorp](https://github.com/jesmigel/ansible-role-hashicorp) | [![CI](https://github.com/jesmigel/ansible-role-hashicorp/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/jesmigel/ansible-role-hashicorp/actions/workflows/build.yaml) | Used to Bootstrap worker VM with Hashicorp tools |
| [ansible-role-packer](https://github.com/jesmigel/ansible-role-packer) | [![CI](https://github.com/jesmigel/ansible-role-packer/actions/workflows/build.yaml/badge.svg?branch=main)](https://github.com/jesmigel/ansible-role-packer/actions/workflows/build.yaml) | Includes a payload processor that builds packer configurations. |
|||

### Usage
1. Initialise library dependencies.
    - Initialise a virtualenv directory and installs the contents of requirements.txt
    - Initialise ansible role directory and downloads the contents of requirements.yaml
```bash
make init
```

2. Validate the vagrant configuration. Make sure to update relevant config. Refer to [Preflight Steps](https://github.com/jesmigel/ansible-role-common#preflieght-steps) for further details.
```bash
make validate
```

3. Deploy the worker VM and execute packer instructions. The process is summarised as follows:
    - ansible-role-common: updates the binary repo and installs required OS binaries.
    - ansible-role-hashicorp: Adds Hashicorp official binary repo and installs relevant tools.
    - ansible role-packer: Processes input payload, generates and validates packer build files.
    - ansible role-packer: Builds VM.
```bash
make up
```

###  Builds
| Name | Origin ISO | Comments |
| - | - | - |
| Ubuntu 20.4.2 | [Ubuntu](http://releases.ubuntu.com/20.04/) | Golden Image |
|||

### ToDo
- CentOS/Rocky Linux
- Documentation
- Diagrams
