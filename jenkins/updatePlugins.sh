#!/bin/bash -e

pluginDir=/var/lib/jenkins/plugins

# go to plugin directory
cd ${pluginDir}

# remove old backups
sudo rm -f ./*.bak

files="*.jpi"
for file in ${files}
  do
    echo "${file}"

    if [ -f "${file}.pinned" ]; then
        echo "This plugin is pinned, unpin in the Jenkins interface if you want to update it"
        continue
    fi

    if [ -f "role-strategy.jpi" ]; then
        echo "Skipping role based authorization plugin"
        continue
    fi

    # backup plugin
    filename=$(basename "${file}")
    sudo cp "${file}" "${file}.bak"

    # remove old version
    sudo rm "${file}"

    sudo curl -O http://updates.jenkins-ci.org/download/plugins/"${file}"
done

# make sure jenkins owns the contents of the plugin directory
sudo chown -R jenkins:jenkins "${pluginDir}"

# Restart Jenkins when we're done
sudo service jenkins restart
