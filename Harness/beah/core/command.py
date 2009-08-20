#!/usr/bin/env python

# Beah - Test harness. Part of Beaker project.
#
# Copyright (C) 2009 Marian Csontos <mcsontos@redhat.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

import exceptions

"""\
Commands are used to send instructions from Backend to Controller (and
eventually Task.)"""

################################################################################
# PUBLIC INTERFACE:
################################################################################
def ping(message=None):
    if message:
        return command('ping', message=message)
    return command('ping')

def PING(message=None):
    if message:
        return command('PING', message=message)
    return command('PING')

def run(file, id=None, name=None):
    # FIXME: Should I set the id globally - i.e. in Controller?
    if name is None:
        name = file
    if id is None:
        run.id += 1
        id = run.id
    return command('run', task_info={'file':file, 'backend_id':id, 'name':name})
run.id = 0

def kill():
    return command('kill')

def no_input():
    return command('no_input')

def no_output():
    return command('no_output')

################################################################################
# IMPLEMENTATION:
################################################################################
def command(cmd, **kwargs):
    return Command(cmd, **kwargs)

def mkcommand(cmd, __doc__="", **kwargs):
    def cmdf(**kwargs):
        return command(cmd)
    cmdf.__name__ = cmd
    cmdf.__doc__ = __doc__ or "Command %s" % cmd
    return cmdf

class Command(list):
    def __init__(self, cmd, **kwargs):
        list.__init__(self, ['Command',None,None]) # is this backwards compatible? Even with Python 2.3?
        if isinstance(cmd, list):
            if cmd[0] != 'Command' or not isinstance(cmd[1], str) or not isinstance(cmd[2], dict):
                raise exceptions.TypeError('%r not permitted. Has to be [\'Command\', str, dict]' % cmd)
            self[1] = str(cmd[1])
            self[2] = dict(cmd[2])
        elif isinstance(cmd, str):
            self[1] = str(cmd)
            self[2] = dict(kwargs)
        else:
            raise exceptions.TypeError('%s not permitted as command, it has to be an instance of list or str' % cmd.__class__.__name__)

    def command(self):
        return self[1]
    def args(self):
        return self[2]
    def arg(self, name, val=None):
        return self.args().get(name, val)

################################################################################
# TESTING:
################################################################################
if __name__=='__main__':
    import traceback, sys
    def test(expected, cmd, **kwargs):
        try:
            answ = list(Command(cmd, **kwargs))
            if answ != expected:
                print >> sys.stderr, "--- ERROR: Command(%r, %r) == %r != %r" % (cmd,
                        kwargs, answ, expected)
        except:
            answ = sys.exc_type.__name__
            if answ != expected:
                print >> sys.stderr, "--- ERROR: Command(%r, %r) raised %r != %r" % (cmd,
                        kwargs, answ, expected)
    test(['Command', 'ping', {}], 'ping')
    test('TypeError', 1)
    test(['Command', 'ping', {}], cmd='ping')
    test('TypeError', cmd=1)
    test(['Command', 'ping', {'value':1}], cmd='ping', value=1)
    test(['Command', 'ping', {'value':1}], **{'cmd':'ping', 'value':1})
    test(['Command', 'ping', {'value':1}], value=1, cmd='ping')
    test(['Command', 'ping', {'value':1}], **{'value':1, 'cmd':'ping'})
