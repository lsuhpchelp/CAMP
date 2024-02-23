#%Module

# =====================================================================
# Generated by CAMP (Containerized Application Modulekey Producer)
# Developer: Jason Li (jasonli3@lsu.edu)
# Description: 
#       1) This module template is compatible with:
#            - Environment Modules >= 4.5.2. 
#               See https://github.com/cea-hpc/modules
#            - Lmod >= 8.7.34. 
#               See https://github.com/TACC/Lmod
#          May not be compatible with different module systems.
#       2) This template generates wrapper scripts in users' 
#          environment, and works with MPI-enabled software packages.
#       3) This template is designed for NGC (or similarly designed
#          containers) which uses "singularity run" instead of 
#          "singularity exec".
# =====================================================================

# ---------------------------------------------------------------------
# Wrapper scripts path (Customize me)
# ---------------------------------------------------------------------

set WRAPPER_PATH /work/$env(USER)/.modulebin

# ---------------------------------------------------------------------
# Software specific information
# ---------------------------------------------------------------------

# Module information
module-whatis Name: $modName
module-whatis Version: $modVersion
module-whatis Description: $whatis

# Singularity options
set SINGULARITY_IMAGE "$singularity_image"
set SINGULARITY_BINDPATHS "$singularity_bindpaths"
set SINGULARITY_FLAGS "$singularity_flags"

# Conflicts
conflict $modName $conflict

# List of commands to overwrite
set CMDS {
$cmds_dummy
}

# Set environment varialbles
$envs

# ---------------------------------------------------------------------
# Module key setup
# ---------------------------------------------------------------------

# Combine Singularity exec command
set SINGULARITY_EXEC "singularity run -B $SINGULARITY_BINDPATHS $SINGULARITY_FLAGS --pwd \$PWD $SINGULARITY_IMAGE"

# Set wrapper directory
file mkdir $WRAPPER_PATH/$modName/$modVersion
prepend-path PATH $WRAPPER_PATH/$modName/$modVersion

# Create wrappers when the module is loaded
if { [ module-info mode load ] } {

    # If it is csh type shell
    if { [module-info shelltype] == "csh" } {
    
        # Create wrappers for each command
        foreach cmd $CMDS {
            puts "echo '#\\!/bin/bash' > $WRAPPER_PATH/$modName/$modVersion/$cmd;"
            puts "echo '$SINGULARITY_EXEC $cmd $@' >> $WRAPPER_PATH/$modName/$modVersion/$cmd;"
            puts "chmod u+x $WRAPPER_PATH/$modName/$modVersion/$cmd;"
        }
        
        # Refresh cache (only for csh type shell)
        puts "rehash;"
        
    # If it is sh type shell
    } elseif { [module-info shelltype] == "sh" } {
    
        # Create wrappers for each command
        foreach cmd $CMDS {
            puts "echo '#!/bin/bash' > $WRAPPER_PATH/$modName/$modVersion/$cmd;"
            puts "echo '$SINGULARITY_EXEC $cmd $@' >> $WRAPPER_PATH/$modName/$modVersion/$cmd;"
            puts "chmod u+x $WRAPPER_PATH/$modName/$modVersion/$cmd;"
        }
        
    }
}

# Currently, wrappers will not be deleted to avoid unwanted issues.

# Help information
proc ModulesHelp {} {
    global CMDS
    puts stderr "

\[ Help information \]

1. This module only works on computing nodes (not available on head nodes). Make sure you start a job!

2. Below executables are available:
$CMDS"
}
if { [ module-info mode load ] } {
    ModulesHelp
}
