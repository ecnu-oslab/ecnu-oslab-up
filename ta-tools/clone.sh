#!/bin/bash

#############################################################
#
# This script is used to clone all repos in a github classroom assignment.
#
# Usage:
#     $ ./clone.sh assignment_title [token]
#
# A non-empty token implies you use HTTPS to clone github repos.
# Otherwise, an empty token implies you use SSH.
#
# Example:
#     $ ./clone.sh project0a aEb_OGE... # HTTPS
#     $ ./clone.sh project1b            # SSH
#
# Before you use this script:
#     Download classroom_roster.csv from github classroom
#     Put it here in the same directory
#
#############################################################


#############################################################
# Modify the following variables if you need to.

# Roster file name.
roster="classroom_roster.csv"

# Classroom organization account name.
classroom="ecnu-oslab-21-fall"

# Excluded identifier list, with no spaces in each entry.
# This list contains IDs that you don't want to clone.
# Another way is simply deleting the unwanted rows in csv.
exclude=(
    identifier          # exclude csv header
    RmZeta              # other excluded id
    ybwu
)

# Clone log file name
clone_log="clone.log"

#############################################################

# Assignment title.
assignment="$1"

# Github token used by HTTPS
token="$2"

# Check if roster exists.
if [ ! -f "$roster" ]; then
    echo "File '$roster' does not exist."
    echo "It can be downloaded from github classroom."
    exit 1
fi

# Choose clone protocol dynamically according to token.
if [ -n "$token" ]; then
    # non-empty token, HTTPS
    prefix="https://github.com/"

    # Use a shell script to enter your password.
    # See https://serverfault.com/a/912788
    helper=git-askpass-helper.sh
    export GIT_ASKPASS=../$helper
    # construct helper
    echo '#!/bin/bash' > $helper
    echo "exec echo '${token}'" >> $helper
    chmod +x $helper
else
    # empty token, SSH
    prefix="git@github.com:"
fi

# A regex pattern to match lines in roster and capture desired groups.
# It matches each line in a four-column csv, capturing the first two columns.
# Use https://regex101.com/ to see how this works.
pattern='^"([^"]*)","([^"]*)","[^"]*","[^"]*"$'

# Create assignment directory and cd into it
mkdir -p "$assignment" || exit
cd "${assignment}" || exit

# Read lines in $roster
# https://stackoverflow.com/a/1521498
while IFS="" read -r line || [ -n "$line" ]; do
    # Capturing regex groups in bash
    # https://stackoverflow.com/a/1892107
    if [[ $line =~ $pattern ]]; then

        # capture groups
        identifier="${BASH_REMATCH[1]}"
        username="${BASH_REMATCH[2]}"
        
        if echo "${exclude[@]}" | grep -wq "${identifier}"; then
            # is in the exclude list (grep success)
            continue
        fi

        echo "Cloning ${identifier}, Github: ${username}"
        clone_path="${prefix}${classroom}/${assignment}-${username}.git" 
        id_log="${identifier}.log" 

        # clone repo and rename the repo to identifier
        # the trailing '&' makes all git clones run in parallel
        git clone "${clone_path}" "${identifier}" > "${id_log}" 2> "${id_log}" &

    else
        echo "Format error: ${line}"
    fi
done < ../${roster} # now in assignment dir, roster is in dir above

wait # wait all clones to finish
echo "All clones have finished"
echo "Please check '${assignment}/${clone_log}' to see if any error occurs"

# Collect logs
echo "Clone log for ${assignment} $(date)" > ${clone_log}
while IFS="" read -r line || [ -n "$line" ]; do
    if [[ $line =~ $pattern ]]; then
        identifier="${BASH_REMATCH[1]}"
        if echo "${exclude[@]}" | grep -wq "${identifier}"; then
            continue
        fi
        echo "" >> ${clone_log}
        echo "Clone log: ${identifier}" >> ${clone_log}
        cat "${identifier}.log" >> ${clone_log}
        rm -f "${identifier}.log"
    fi
done < ../${roster}

# Clean up helper script
if [ -n "$helper" ]; then
    rm ../$helper # now in assignment dir
fi