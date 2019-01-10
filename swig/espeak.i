%module espeak
%{
/* Includes the header in the wrapper code */
#include "/usr/include/espeak-ng/speak_lib.h"
#include "/usr/include/espeak-ng/espeak_ng.h"
%}

%insert("lisphead") %{
(cffi:load-foreign-library "libespeak-ng.so") 
(in-package #:espeak-ng)
(defmacro define-constant (name value &optional doc)
  `(defconstant ,name (if (boundp ',name) (symbol-value ',name) ,value)
                      ,@(when doc (list doc))))
%}

%feature("export");
/* %feature("intern_function", "1"); */

/* Parse the header file to generate wrappers */
%include "/usr/include/espeak-ng/speak_lib.h"
%include "/usr/include/espeak-ng/espeak_ng.h"
