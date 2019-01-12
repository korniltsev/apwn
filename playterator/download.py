from gpapi.googleplay import GooglePlayAPI
import os
import config
import sys

# todo proxies
# server = GooglePlayAPI('en_US', 'America/Los_Angeles', device_codename='t00q')
server = GooglePlayAPI('en_US', 'America/Los_Angeles')
server.login(None, None, config.gsfId, config.authSubToken)
# server.login('apptica.test@gmail.com', 'NWCneo666')
print server.gsfId
print server.authSubToken
apps = [
    "com.x8bit.bitwarden",
    "com.airbnb.android",
    "com.alibaba.aliexpresshd",
    "com.ayopop",
    "im.delight.letters",
    "com.dropbox.android",
    "com.dropbox.paper",
    "com.duolingo",
    "com.fitbit.FitbitMobile",
    "com.getsomeheadspace.android",
    "com.irccloud.android",
    "cn.wps.moffice_eng",
    "jp.naver.line.android",
    "com.opera.browser",
    "com.opera.mini.native",
    "com.opera.touch",
    "com.pandora.android",
    "com.paypal.android.p2pmobile",
    "com.paypal.here",
    "com.paypal.merchant.client",
    "com.xoom.android.app",
    "com.venmo",
    "com.quvideo.xiaoying",
    "com.quvideo.slideplus",
    "com.shopee.tw",
    "com.shopee.ph",
    "com.shopee.my",
    "com.shopee.sg",
    "com.shopee.vn",
    "com.shopee.id",
    "com.shopify.pos",
    "com.shopify.mobile",
    "com.showmax.app",
    "com.smule.singandroid.*",
    "com.snapchat.android",
    "com.spotify.music",
    "com.spotify.tv.android",
    "com.spotify.s4a",
    "org.telegram.messenger",
    "com.teslamotors.tesla",
    "com.tinder",
    "com.vkontakte.android",
    "com.vk.admin",
    "com.vk.quiz",
    "org.videolan.vlc",
    "com.application.zomato",
    "ru.yandex.disk",
    "ru.yandex.taxi",
    "ru.yandex.metro",
    "ru.yandex.music",
    "ru.yandex.mail",
    "ru.yandex.weatherplugin",
    "ru.yandex.searchplugin",
    "ru.yandex.yandexmaps",
    "ru.yandex.market",
    "com.yandex.browser",
    "ru.yandex.yandexnavi",
    "ru.mail.cloud",
    "ru.mail.auth.totp",
    "ru.mail.mailapp",
    "com.my.mail",
    "ru.mail.calendar",
    "ru.yandex.mail.beta",

]

dst_dir = 'download_dst'

for a in apps:
    try:
        dst_file = os.path.join(dst_dir, a + ".apk")
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
        print e
