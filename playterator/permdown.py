# coding=utf-8
import logging

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


prefilter = [
    "yandex",  # wait for answer
    "com.viber.voip",  # openbugbounty
    "sberbank_sbbol",  # openbugbounty
    "dropbox",  # could not find
    "com.samsung",  # could not find
    "com.sec.android.app.sbrowser",  # minsdk < 21
    "com.oneapp.ma",  # not interested
    "ru.rian.reader",  # not found
    "com.lbe",  # not interested
    "push",  # not interested
    "com.tgelec.setracker",  # not interested
    "com.dci.magzter",  # not interested
    "com.hyperspeed",  # not interested
    "com.rocket.tools",  # not interested
    "com.colorphone",  # not interested
    "com.pinbonus2",  # not interested
    "com.colorphone.smooth",  # not interested
    "ru.hikisoft.calories",  # not interested
    "com.ipspirates",  # not interested
    "com.ticktick",  # not interested
    "org.kman",  # not interested
    "deezer.android.app",  # openbugbounty
    "com.whatsapp",  # not found
    "com.vk",  # pwned
    "com.mc.amazfit1",  # not interested
    "com.airwatch",  # not interested
    "com.ubercab",  # not interested
    "com.coloros.mcs",  # not interested
    "com.dailyselfie",  # not interested
    "org.videolan",  # not interested
    "com.mc.miband1Permission",  # not interested
    "tgelec",  # not interested
    "AUTH_SDK",  # not interested
    "INSTALL_SHORTCUT",  # not interested
    "superawesome",  # not interested
    "kakao",  # not interested
    "musically",  # not interested
    "anydo",  # not interested
    "camscanner",  # not interested
    "ninefolders",  # not interested

]

bl = prefilter + [

    "android.permission.INTERNET",
    "C2D_MESSAGE",
    'com.yandex.permission.READ_CREDENTIALS',
    'android.permission.MEDIA_CONTENT_CONTROL',
    'ADM_MESSAGE',
    'permission.MIPUSH_RECEIVE',
    'MAPS_RECEIVE',
    'com.samsung',
    'JPUSH_MESSAGE',
    'BIND_JOB_SERVICE',
    'android.permission.BIND',
    'BIND_NETWORK_TASK_SERVICE',
    'com.google.android.gms.',
    'PERMISSION_SAFE_BROADCAST',
    'com.google.android',
    'com.google.firebase',
    'com.facebook',
    'android.permissio',
    'com.amazon.devic',
    'com.nokia.pushnotifications',
]


def isblack(permission):
    for b in bl:
        if b in permission:
            return True
    return False


def analyze(manifest):
    # print manifest
    custom_signature_permissions = []
    other_custom_permission = []
    tree = etree.parse(manifest)
    # usesSdk = tree.findall('uses-sdk')[0]
    # minsdk = int(usesSdk.attrib[android('minSdkVersion')])
    # if minsdk >= 21:
    #     return
    for p in tree.findall('permission'):
        name = p.attrib[android('name')]
        prot = p.attrib[android('protectionLevel')] if p.attrib.has_key(android('protectionLevel')) else "normal"
        # prot = int(prot, 16)
        if isblack(name):
            continue
        if prot == "signature" or prot == "signatureOrSystem":
            custom_signature_permissions += [name]
        else:
            other_custom_permission += [name]
    guarded_components = []
    for c in ['activity', 'service', 'provider', 'receiver']:
        for ci in tree.findall('application')[0].findall(c):
            name = ci.attrib[android('name')]
            perm = ci.attrib[android('permission')] if ci.attrib.has_key(android('permission')) else None
            exported = ci.attrib[android('exported')] if ci.attrib.has_key(android('exported')) else "false"
            rperm = ci.attrib[android('readPermission')] if ci.attrib.has_key(android('readPermission')) else None
            wperm = ci.attrib[android('writePermission')] if ci.attrib.has_key(android('writePermission')) else None

            o = {
                'comp': c,
                'name': name,
                'exported': exported,
                'perms': []
            }
            if perm is not None:
                o['perms'] += [perm]
            if rperm is not None:
                o['perms'] += [rperm]
            if wperm is not None:
                o['perms'] += [wperm]
            if len(o['perms']) == 1 and o['perms'][0] == 'true':
                o['perms'] = []

            black = False
            for p in o['perms']:
                if isblack(p):
                    black = True

            if black:
                continue

            if exported and len(o['perms']) > 0:
                guarded_components += [o]

    if len(custom_signature_permissions) > 0 or len(other_custom_permission) > 0 or len(guarded_components) > 0:
        id = os.path.basename(os.path.abspath(manifest + "/.."))
        print id
        print "https://play.google.com/store/apps/details?id=" + id

        for p in custom_signature_permissions:
            print '    🔥', p

        for p in other_custom_permission:
            print '    💧', p

        for p in guarded_components:
            print '    🌎', p

        return True


# dst = sys.argv[1]
dst = 'out'

j = 0
left = 0
manifests = [
    "./com.x8bit.bitwarden/AndroidManifest.xml",
    "./org.telegram.messenger/AndroidManifest.xml",
    "./com.snapchat.android/AndroidManifest.xml",
    "./ru.yandex.yandexnavi/AndroidManifest.xml",
    "./cn.wps.moffice_eng/AndroidManifest.xml",
    "./com.application.zomato/AndroidManifest.xml",
    "./ru.yandex.music/AndroidManifest.xml",
    "./jp.naver.line.android/AndroidManifest.xml",
    "./com.spotify.music/AndroidManifest.xml",
    "./com.duolingo/AndroidManifest.xml",
    "./ru.yandex.mail/AndroidManifest.xml",
    "./com.ayopop/AndroidManifest.xml",
    "./com.ayopop/assets/AndroidManifest.xml",
    "./ru.yandex.metro/AndroidManifest.xml",
    "./com.getsomeheadspace.android/AndroidManifest.xml",
    "./com.tinder/AndroidManifest.xml",
    "./ru.yandex.yandexmaps/AndroidManifest.xml",
    "./com.shopify.pos/AndroidManifest.xml",
    "./com.paypal.android.p2pmobile/AndroidManifest.xml",
    "./ru.yandex.searchplugin/AndroidManifest.xml",
    "./ru.yandex.weatherplugin/AndroidManifest.xml",
    "./ru.mail.cloud/AndroidManifest.xml",
    "./com.quvideo.slideplus/AndroidManifest.xml",
    "./com.opera.browser/AndroidManifest.xml",
    "./org.videolan.vlc/AndroidManifest.xml",
    "./com.opera.touch/AndroidManifest.xml",
    "./com.quvideo.xiaoying/AndroidManifest.xml",
    "./com.dropbox.paper/AndroidManifest.xml",
    "./com.my.mail/AndroidManifest.xml",
    "./ru.mail.mailapp/AndroidManifest.xml",
    "./ru.yandex.disk/AndroidManifest.xml",
    "./com.irccloud.android/AndroidManifest.xml",
    "./com.yandex.browser/AndroidManifest.xml",
    "./com.vkontakte.android/AndroidManifest.xml",
    "./smule/AndroidManifest.xml",
    "./com.paypal.merchant.client/AndroidManifest.xml",
    "./com.shopify.mobile/AndroidManifest.xml",
    "./com.alibaba.aliexpresshd/AndroidManifest.xml",
    "./ru.mail.auth.totp/AndroidManifest.xml",
    "./ru.yandex.taxi/AndroidManifest.xml",
    "./com.airbnb.android/AndroidManifest.xml",
    "./com.vk.quiz/AndroidManifest.xml",
    "./ru.yandex.market/AndroidManifest.xml",
    "./com.vk.admin/AndroidManifest.xml",
    "./ru.mail.calendar/AndroidManifest.xml",
    "./com.opera.mini.native/AndroidManifest.xml",
    "./com.dropbox.android/AndroidManifest.xml",
]
# manifests = glob.glob(dst + "/**/*.xml")
for i in manifests:
    # print i
    j += 1
    try:
        res = analyze(i)
        if res is not None:
            left += 1
    except Exception as e:
        print e
        # print e.s
        # raise Exception(e)

print j, left
