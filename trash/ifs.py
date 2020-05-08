import os
import re
import sys
db_miss = set()
class Cls:
    def __init__(self, fqn, parent_fqn, ifs, data):
        self.fqn = fqn
        self.parent_fqn = parent_fqn
        self.ifs = ifs
        self.data = data

class Db:
    def __init__(self, dir):
        self.dir = dir
        self.db = {}





    def parse_data(self, data):
        cls = re.findall('\\.class.*\\s(L.*;)\n', data)[0]
        parent = re.findall('\\.super.*\\s(L.*;)\n', data)[0]
        ifs = re.findall('\\.implements.*\\s(L.*;)\n', data)
        # print cls, parent, ifs
        self.db[cls] = Cls(cls, parent, ifs, data)


    def parse_dir(self):
        sys.stdout.write('parsing %s ... ' %(self.dir))
        cnt = 0
        for root, dirs, files in os.walk(self.dir):
            for file in files:
                if file.endswith(".smali"):
                    cnt += 1
                    it = os.path.join(root, file)
                    with open(it) as f:
                        data = f.read()
                    self.parse_data(data)
                    if cnt % 1000 == 0:
                        sys.stdout.write('.')
                        sys.stdout.flush()
        sys.stdout.write(' done ! %d\n' %( len(self.db)))
        sys.stdout.flush()




    def gather_interfaces(self, fqn, interafces, classes):
        # print fqn
        if fqn not in self.db:
            db_miss.add(fqn)
            return
        it = self.db[fqn]
        for i in it.ifs:
            interafces.add(i)
        classes.add(fqn)
        classes.add(it.parent_fqn)
        self.gather_interfaces(it.parent_fqn, interafces, classes)

    def grep_source(self, classes, regex):
        res = []
        for j in classes:
            if j in self.db:
                findall = re.findall(regex, self.db[j].data)
                res += findall
        return res

    def analyze(self):

        self.parse_dir()

        for i in self.db:
            interfaces = set()
            classes = set()
            self.gather_interfaces(i, interfaces, classes)
            if 'Ljava/io/Serializable;' in interfaces or 'Landroid/os/Parcelable;' in interfaces:
                native = self.grep_source(classes, '.method.* native .*\n')
                finalize = self.grep_source(classes, ' finalize\\(\\)V')
                if native and finalize:
                    print '------------------'
                    print '\t', i
                    print '\t', interfaces
                    print '\t', classes
                    for n in native:
                        print '\t\t n:', n.strip()




targetd  = sys.argv[1]
for i in os.listdir(targetd):
    f = targetd + '/' + i
    if os.path.isdir(f):
        d = Db(f)
        d.analyze()


