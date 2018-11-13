
import os.path
import argparse
import json
import re
from collections import defaultdict

import sys
def make_unique(li):
    seen = set()
    seen_add = seen.add
    return [x for x in li if not (x in seen or seen_add(x))]

def make_unique_dict(d):
    for k in d.keys():
        d[k] = make_unique(d[k])
    return d

def merge_dicts_inplace(x, y):
    for k,v in y.items():
        x[k] = x[k] + v
    return x

def get_path_next(it, el):
    path = None
    try:
        path = next(it)
    except StopIteration:
        raise ValueError('Missing path spec for include directory flag')
    return path

def get_path_inplace(it, el):
    return el.group('path')

pathspec_flags=[
        {'pattern':'-isystem', 'type':'isystem', 'getPath':get_path_next},
        {'pattern':'-idirafter', 'type':'isystem', 'getPath':get_path_next},
        {'pattern':'-iquote', 'type':'i', 'getPath':get_path_next},
        {'pattern':r'-I(?P<path>.+)', 'type':'i', 'getPath':get_path_inplace},
        {'pattern':r'--sysroot=(?P<path>.+)', 'type':'sysroot',
            'getPath':get_path_inplace}
        ]

pathspec_builder={
        'isystem':{'prefix':'-isystem ', 'joiner':' -isystem '.join},
        'i':{'prefix':'-I', 'joiner':' -I'.join},
        'sysroot':{'prefix':'', 'joiner':lambda x: '--sysroot={}'.format(x[0])}
        }

def match_flag(flag):
    for p in pathspec_flags:
        m = re.match(p['pattern'], flag)
        if m:
            return m, p
    return None, None



def parse_compile_commands_json(fname):
    return json.loads(fname, encoding='UTF-8')

def extract_include_directories_from_flags(flags):
    flags_dict = defaultdict(list)
    flag_list = flags.split(' ')
    it = iter(flag_list)
    try:
        while True:
            cur_flag = next(it)
            m,p = match_flag(cur_flag)
            if m:
                path = p['getPath'](it, m)
                flags_dict[p['type']].append(path)
    except StopIteration:
        pass
    make_unique_dict(flags_dict)
    return flags_dict



def extract_include_directories(ccflags_db):
    flags_dict = defaultdict(list)
    for entry in ccflags_db:
        merge_dicts_inplace(flags_dict,
                extract_include_directories_from_flags(entry.get('command',
                    '')))
    return make_unique_dict(flags_dict)

def build_command_line(fdict):
    cmdline = str()
    for k,v in fdict.items():
        cmdline = cmdline + pathspec_builder[k]['prefix'] + pathspec_builder[k]['joiner'](v) + ' '
    return cmdline.strip(' ')

def load_flag_db(fname):
    with open(fname, 'r') as f:
        return json.load(f, encoding='UTF-8')

def make_default_flags(flagdb_content, ofile):
    flags_dict = extract_include_directories(flagdb_content)
    cmdline = build_command_line(flags_dict)
    with open(ofile, 'w+') if ofile else sys.stdout as fh:
        print(cmdline, file=fh)


def _main():
    parser = argparse.ArgumentParser(description='Parse a cmake compile_commands.json file to produce default compile flags')
    parser.add_argument('flagdb', help='The compiler flag database (usually named `compile_commands.json`)', type=str)
    parser.add_argument('--out-file','-o', dest='o', help='Output file for the compiler flags. Output to stdout if none is provided', default=None)
    ns = parser.parse_args()
    make_default_flags(load_flag_db(ns.flagdb), ns.o)


if __name__ == '__main__':
    _main()
