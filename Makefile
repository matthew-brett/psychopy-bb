local:
	ln -sf ${PWD}/local.toml master/config.toml
	ln -sf ${PWD}/local_private.toml master/private_config.toml
	buildbot restart master

psychopy:
	ln -sf ${PWD}/psychopy.toml master/config.toml
	ln -sf ${PWD}/psychopy_private.toml master/private_config.toml
	buildbot restart master

bb-reconfig:

bb-restart:

bb-%:
	buildbot $* master

master:
	buildbot create-master master
	ln -sf ${PWD}/master.cfg master/master.cfg

clean-master:
	rm -rf master