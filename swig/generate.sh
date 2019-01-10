#!/bin/bash
set -x
set -e

# cleanup
rm -f libespeak.lisp

#     -includeall \
#    -module espeak-ng \
#     -noswig-lisp \    
swig -v \
     -cffi \
     libespeak.i
sed -i 's/cl:defconstant/define-constant/g' libespeak.lisp
mv libespeak.lisp ../libespeak-ng-cffi.lisp
