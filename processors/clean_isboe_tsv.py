import csv
import sys

from lib.models import *


def clean(filename, plural_modelname):
    modelname = plural_modelname[0:-1]
    with open(filename, 'r', encoding='latin-1') as inp:
        reader = csv.DictReader(inp, delimiter='\t', quoting=csv.QUOTE_NONE)
        writer = csv.DictWriter(sys.stdout, fieldnames=reader.fieldnames)
        writer.writeheader()
        for row in reader:
            try:
                klass = globals()[modelname]
                model = klass(row)
                writer.writerow(model.serialize())
            except Exception as e:
                print("BAD ROW: %s" % row, file=sys.stderr)
                print(e, file=sys.stderr)


if __name__ == '__main__':
    clean(sys.argv[1], sys.argv[2])
