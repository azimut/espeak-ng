(in-package #:libespeak-ng)

(defun test ()
  (with-espeak (:audio_output_retrieval 10000 (cffi:null-pointer) 0)
    (cffi:with-foreign-strings ((lang "en")
                                (word "crazy"))
      (espeak_setsynthcallback (cffi:callback ctestr))      
      (espeak_setvoicebyname lang)
      (cffi:with-foreign-object (l 'size)
        (setf (cffi:mem-ref lang 'size) 6)
        (print
         (espeak_synth word l 0
                       :POS_CHARACTER
                       0
                       ESPEAKCHARS_UTF8
                       (cffi:null-pointer)
                       (cffi:null-pointer)))
        (sleep 3)))))

(defun test ()
  (espeak_initialize :AUDIO_OUTPUT_PLAYBACK
                     500
                     (cffi:null-pointer)
                     0)
  (espeak_setsynthcallback (cffi:callback ctest))
  (espeak_synchronize)
  (cffi:with-foreign-string (s "en") (espeak_setvoicebyname s))
  (espeak_setparameter :espeakrate 160 0)
  (espeak_setparameter :espeakvolume 50 0)
  (espeak_setparameter :espeakpitch 50 0)
  (espeak_setparameter :espeakwordgap 12 0)
  (cffi:with-foreign-object (l 'size)
    (setf (cffi:mem-ref l 'size) 5)
    (cffi:with-foreign-string (s "this")
      (print
       (espeak_synth s l 0 0 0 0 (cffi:null-pointer) (cffi:null-pointer)))))
  (espeak_terminate))




(defun test ()
  (espeak_initialize :AUDIO_OUTPUT_PLAYBACK
                     2048
                     (cffi:null-pointer)
                     0)
  ;;(espeak_setsynthcallback (cffi:callback ctest))
  ;;(espeak_synchronize)
  ;; (cffi:with-foreign-string (s "en")
  ;;   (espeak_setvoicebyname s))
  ;;(espeak_setparameter :espeakrate 175 0)
  ;; (espeak_setparameter :espeakvolume 50 0)
  ;; (espeak_setparameter :espeakpitch 50 0)
  ;; (espeak_setparameter :espeakwordgap 12 0)
  ;;(cffi:with-foreign-string (s "c") (espeak_char s))
  (cffi:with-foreign-object (l 'size)
    (setf (cffi:mem-ref l 'size) 100)
    (cffi:with-foreign-string (s "tralalalallala")
      (espeak_synth s l 0 0 0 0
                    (cffi:null-pointer)
                    (cffi:null-pointer))))
  ;;(espeak_terminate)
  )

