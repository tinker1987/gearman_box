# gearman_box
Gearman VM based on **_ubuntu/trusty64_** box

## Configuration

### Vagrantfile
Edit __config.vm.synced_folder__ parameter to set correct path to your project root
```
    config.vm.synced_folder "/path/to/your/project", "/home/vagrant/projects/app"
```

Feel free to edit any other parameters but leave __config.vm.provision__ untouched.
Provision scripts will install environment automatically.
You may add any other scripts that will install software that You need by adding new section to provision or by adding it to **_scripts/setup.sh_**
