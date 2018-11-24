import odexcrc
import zlib
import tempfile
import shutil

dex = 'testdata/classes.dex'
odex = 'testdata/classes.odex'


with open(dex, 'rb') as f:
    expected_crc = zlib.crc32(f.read(), 0)

tmp = tempfile.mktemp()
print tmp
shutil.copy(odex, tmp)

print 'exepcted_crc', hex(expected_crc)

mod_when, crc = odexcrc.get(tmp)
print 'mod_when', hex(mod_when), 'crc', hex(crc)

if expected_crc != crc:
    raise Exception("crc mismatch")
if 0x0 != mod_when:
    raise Exception("mod_when mismatch")



odexcrc.set(tmp, 0x12345678, 0x87654321)

mod_when, crc = odexcrc.get(tmp)
print 'mod_when', hex(mod_when), 'crc', hex(crc)

if 0x87654321 != crc:
    raise Exception("crc mismatch")
if 0x12345678 != mod_when:
    raise Exception("mod_when mismatch")
