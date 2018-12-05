from androguard.core.bytecodes import apk
import glob
import os
import sys
from lxml import etree

from lxml.etree import ElementTree


def find_rec(node, element, result):
    for item in node.findall(element):
        result.append(item)

    for c in node.getchildren():
        find_rec(c, element, result)

    return result


def android(it):
    return "{http://schemas.android.com/apk/res/android}" + it


def isblack(permission):
    if permission is None:
        return False
    bl = [
        "android.permission.INTERNET",
        "C2D_MESSAGE",
        'android.permission.BIND_JOB_SERVICE',
        'BIND_NETWORK_TASK_SERVICE',
        'REVOCATION_NOTIFICATION',
        'MANAGE_DOCUMENTS',
        'LAUNCH_FEDERATED_SIGN_IN',
        'com.google.firebase',
    ]

    for b in bl:
        if b in permission:
            return True
    return False


components = ['activity', 'service', 'reciever', 'provider']


def analyze_apk(apk_file):
    a = apk.APK(apk_file)
    manifest = a.get_android_manifest_xml()
    custom_perm = {}
    for perm in manifest.findall("permission"):
        name = perm.attrib.get(android("name"))
        prot = perm.attrib.get(android("protectionLevel"))
        if isblack(name):
            continue
        if prot is None:
            custom_perm[name] = 0
        else:
            custom_perm[name] = int(prot, 16)

    # we need :
    # exported components



    res = []
    for ct in components:
        rec = find_rec(manifest, ct, [])
        for c in rec:
            name = c.attrib.get(android("name"))
            exported = c.attrib.get(android("exported")) == "true"
            permission = c.attrib.get(android("permission"))
            # ifilter = c.findall("intent-filter")

            if isblack(permission) or isblack(name):
                continue

            t = etree.tostring(c, pretty_print=True)
            if exported :
                res += [{"name": c.tag + " " +  name, "exported": exported, "perm": permission, "str": t}]
            # elif permission is not None and permission in custom_perm:
            #
            #     res += [{"name": c.tag + " " +  name, "exported": exported, "perm": permission, "str": t}]

    return res


dst = sys.argv[1]

j = 0
for i in glob.glob(dst + "/**"):
    j += 1
    res = analyze_apk(i)

    if len(res) > 0:
        print os.path.basename(i)
        for p in res:

            print "    ", p['name']
            if p['perm'] is not None:
                print "         perm", p['perm']
            # s = p['str']
            # for l in s.splitlines():
            #     print "            ", l
            # print "    ", p
