# gearman_box
Gearman VM based on **_ubuntu/trusty64_** box

## Configuration

### Vagrantfile
Edit **`config.vm.synced_folder`** parameter to set correct path to your project root

```
config.vm.synced_folder "/path/to/your/project", "/home/vagrant/projects/app"
```

## In addition

* Feel free to edit any other parameters but leave **`config.vm.provision`** untouched.
* Provision scripts will install environment automatically.
* You may add any other scripts that will install software that You need by adding new section to provision or by adding it to **`scripts/setup.sh`**
