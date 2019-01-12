from androguard.core.bytecodes import apk
from gpapi.googleplay import GooglePlayAPI
import os
import config
import sys
import shutil
from lxml import etree


# todo proxies

class Playterator:
    def __init__(self):
        self.server = GooglePlayAPI('en_US', 'America/Los_Angeles')
        self.server.login(None, None, config.gsfId, config.authSubToken)

    def playterate(self, dst=None, n=20, functor=None):
        if dst is None:
            dst = 'out'

        res = set()
        categories = self.server.browse()
        for c in categories:
            catId = c['catId']
            print catId
            subcats = self.server.list(catId)
            for s in subcats:
                apps = self.server.list(catId, s, nb_results=str(n))
                for a in apps:
                    docid = a['docId']
                    print '    ', docid
                    res.add(docid)

        if not os.path.exists(dst):
            os.mkdir(dst)

        print len(res), "total"
        for i in res:
            print i
        self.download(dst, [i for i in res], functor)

    def download(self, dst, app_list, functor=None):
        counter = 0
        for a in app_list:
            counter+=1
            sys.stdout.write("* " + str(counter) + " " + a + " downloading\n")
            sys.stdout.flush()

            try:
                appdir = os.path.join(dst, a)
                appfile = os.path.join(appdir, a + ".apk")
                if not os.path.exists(appdir):
                    os.mkdir(appdir)
                incremental_marker = appfile + ".downloaded"
                incremental_marker_transform = appfile + ".transformed"
                incremental_marker_failed = appfile + ".failed"
                if os.path.exists(incremental_marker_failed):
                    continue
                if not os.path.exists(incremental_marker):

                    purchased_app = self.server.download(a)
                    dot = 0

                    with open(appfile, "w") as apk:
                        for chunk in purchased_app['file']['data']:
                            dot += 1
                            if dot % 30 == 0:
                                sys.stdout.write(".")
                            if dot % 600 == 0:
                                sys.stdout.write("\n")
                            sys.stdout.flush()
                            apk.write(chunk)
                else:
                    print a, 'already downloaded'

                with open(incremental_marker, 'w') as f:
                    f.write('downloaded')
                print "\n", a, 'done'
                if functor is not None:
                    if not os.path.exists(incremental_marker_transform):
                        print "transforming", a
                        try:
                            functor(appfile)
                            print "done transforming", a
                        except Exception as e:
                            print e
                            print "failed transforming", a
                        with open(incremental_marker_transform, 'w') as f:
                            f.write('transformed')
                    else:
                        print 'already transformed', a
            except Exception as e:
                print e
                print "failed downloading", a
                with open(incremental_marker_failed, 'w') as f:
                    f.write('failed')


def transform_print(apk):
    print apk

def extract_manifest_and_delete(apk_file):
    a = apk.APK(apk_file)
    manifest = a.get_android_manifest_xml()
    d = os.path.abspath(os.path.join(apk_file, os.path.pardir))
    manifest_file = os.path.join(d, "AndroidManifest.xml")

    manifeststr = etree.tostring(manifest, pretty_print=False).replace('\n', '')
    import xml.dom.minidom

    xml = xml.dom.minidom.parseString(manifeststr)  # or xml.dom.minidom.parseString(xml_string)
    manifeststr = xml.toprettyxml()

    with open(manifest_file, "w") as f:
        f.write(manifeststr)
    os.remove(apk_file)


p = Playterator()
p.playterate(functor=extract_manifest_and_delete)
