# based on https://github.com/ele7enxxh/FakeOdex
import mmap
import struct

ODEX_MAGIC = 'dey'.encode('utf-8')


def check_magic(file):
    if file[0:3] != ODEX_MAGIC:
        raise Exception("the file is not odex")


def get(file):
    """
    :return: mod_when, crc
    """
    with open(file, "r+b") as f:
        mm = mmap.mmap(f.fileno(), 0)
        check_magic(mm)
        deps_offset = struct.unpack("<I", mm[16:20])[0]
        res = struct.unpack("<II", mm[deps_offset:deps_offset + 8])
        mm.close()
        return res

def set(file, mod_when, crc, ):
    with open(file, "r+b") as f:
        mm = mmap.mmap(f.fileno(), 0)
        check_magic(mm)
        deps_offset = struct.unpack("<I", mm[16:20])[0]
        mm[deps_offset:deps_offset + 8] = struct.pack("<II", *[mod_when, crc])
        mm.flush()
        mm.close()
