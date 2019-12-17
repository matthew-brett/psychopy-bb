#!/bin/bash
# Make example worker
# From: http://docs.buildbot.net/current/tutorial/firstrun.html#creating-a-worker
virtualenv bb-worker
. bb-worker/bin/activate
pip install buildbot-worker
buildbot-worker create-worker worker localhost example-worker pass
buildbot-worker start worker
