local:
	ln -sf ${PWD}/local_private.toml master/private_config.toml
	buildbot restart master

psychopy:
	ln -sf ${PWD}/psychopy_private.toml master/private_config.toml
	buildbot restart master

reconfig: bb-reconfig

restart: bb-restart

stop: bb-stop

start: bb-start

bb-%:
	buildbot $* master

master:
	buildbot create-master master
	ln -sf ${PWD}/master.cfg master/master.cfg

clean-master:
	rm -rf master
