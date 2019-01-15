# espeak-ng

Lisp bindings for [espeak-ng/espeak-ng](https://github.com/espeak-ng/espeak-ng). More preciselly the version at [740291272/libespeak-ng](https://github.com/740291272/libespeak-NG) which is modified to work with voice singing synthesis.

## Example
### pcaudiolib
To ear the output directly from espeak with the helpers provided, you need to have installed [espeak-ng/pcaudiolib](https://github.com/espeak-ng/pcaudiolib) and have espeak-ng compiled against it beforehand with `./configure --with-pcaudiolib`.
```
> (smalltalk "hello world!)
> (talk "hello world!" :pitch 50 :range 100 :volume 100 :rate 90)
```
### incudine
Simple code to write back synthesized output back to a incudine buffer *TMPBUF*.
```
(defvar *max-samples* (* 22050 10))
(defvar *tmpbuf* (incudine:make-buffer *max-samples* :sample-rate 22050))
(defvar *n-samples* 0)
(cffi:defcallback wtest :int ((wav :pointer)
                              (n-samples :int)
                              (events :pointer))
  (declare (ignore events) (optimize (speed 3))
           (type fixnum *max-samples* *n-samples* n-samples)
           )
  (when (and wav (< *n-samples* *max-samples*))
    (dotimes (i n-samples)
      (setf (incudine:buffer-value *tmpbuf* (+ *n-samples* i))
            (* 1d0 (cffi:mem-aref wav :short i))))
    (incf *n-samples* n-samples))
  0)

(defun smalltalk-wav (&optional (text "this") (language "en"))
  "Renders given TEXT and returns samples back to callback function."
  (declare (type string text language))
  (setf *n-samples* 0)
  (with-espeak (:AUDIO_OUTPUT_SYNCHRONOUS 0 (cffi:null-pointer) 0)
    (espeak_setsynthcallback (cffi:callback wtest))
    (cffi:with-foreign-object (text-size 'size)
      (setf (cffi:mem-ref text-size 'size) (1+ (length text)))
      (cffi:with-foreign-strings ((lang language)
                                  (stext text))
        (espeak_setvoicebyname lang)
        (espeak_synth stext text-size 0 0 0 ESPEAKCHARS_AUTO
                      (cffi:null-pointer) (cffi:null-pointer)))))
  (incudine:normalize-buffer *tmpbuf* 1)
  (incudine:resize-buffer *tmpbuf* (min *max-samples* (+ 22050 *n-samples*)))
  (format T "~%Nr of samples generated: ~a" *n-samples*)
  T)
```

## TODO
* Indirect play the audio without pcaudiolib (ex: sdlmix, libout123)
* Store .wav file example
