from gpapi.googleplay import GooglePlayAPI
import os
import config
import sys

# todo proxies
server = GooglePlayAPI('en_US', 'America/Los_Angeles')
server.login(None, None, config.gsfId, config.authSubToken)

apps = []
with open(sys.argv[1], "r")as f:
    for l in f.readlines():
        if not l.startswith("#"):
            apps += [l.strip()]

dst_dir = sys.argv[2]

for a in apps:
    try:
        dst_file = os.path.join(dst_dir,  a + ".apk")
        if not os.path.exists(dst_file):
            res = server.download(a)
            with open(dst_file, "w") as f:
                for chunk in res['file']['data']:
                    f.write(chunk)
            print a, "downloaded"
        else:
            print a, "already exists"
    except Exception as e:
        print a, "failed"