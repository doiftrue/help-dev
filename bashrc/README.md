Different useful settings for linux `.bashrc` file.

The settings moved from `~/.bashrc` to `~/.bashrc_config` folder where all the configuration structured in separated files.

To do that you need first create `~/.bashrc_config` in your home directory and copy current `.bashrc` file to `~/.bashrc_config/zero.sh`. Then you need to replace all code in original `.bashrc` file with that one command:

```sh
# See all logic in specified file 
source ~/.bashrc_config/zero.sh
```

Now, all the code will start from `~/.bashrc_config/zero.sh` file which will include separate config files. It's the main controller file now.


### Dev

	rsync -azvh --delete --exclude '.bashrc--original' ./bashrc/.bashrc_config/ ~/.bashrc_config/ --dry-run


