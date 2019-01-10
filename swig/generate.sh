#!/bin/bash
set -x
set -e

# cleanup
rm -f espeak.lisp

#     -includeall \
#    -module espeak-ng \
#     -noswig-lisp \    
swig -v \
     -cffi \
     espeak.i
sed -i 's/cl:defconstant/define-constant/g' espeak.lisp
mv espeak.lisp ../espeak-ng-cffi.lisp
