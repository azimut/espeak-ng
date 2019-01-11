;;;; libespeak-ng.lisp

(in-package #:libespeak-ng)

;;--------------------------------------------------
;; Callbacks
;; returns: 0=continue synthesis,  1=abort synthesis.
(cffi:defcallback ctest :int ((wav :pointer) (num :int) (pev :pointer))
  (declare (ignore wav num pev))
  0)
(cffi:defcallback ctestr :int ((wav :pointer) (num :int) (pev :pointer))
  (declare (ignore wav pev))
  (if (null num) 0 1))

;;--------------------------------------------------

(defmacro with-espeak ((output buflength path options) &body body)
  "Kind of useful to initialize espeak and make sure is terminated
   once after finished. Keep in mind that if you call terminate twice
   it will get blocked."
  `(unwind-protect
        (when (plusp (espeak_initialize ,output ,buflength ,path ,options))
          ,@body)
     (espeak_terminate)))

;;--------------------------------------------------

(cffi:defctype size :unsigned-int)

(defun espeak-info ()
  "> (espeak-info)
   \"1.49.3-dev\""
  (with-espeak (:audio_output_synchronous 0 (cffi:null-pointer)
                                          ESPEAKINITIALIZE_DONT_EXIT)
    (espeak_info (cffi:null-pointer))))

(defun espeak-list-voices ()
  "fIXME: returns and array of voices structs"
  (with-espeak (:audio_output_synchronous 0 (cffi:null-pointer)
                                          ESPEAKINITIALIZE_DONT_EXIT)
    (espeak_listvoices (cffi:null-pointer))))

;; https://github.com/samy280497/ASG/blob/master/endsem/final%20presentation/tts%20in%20c/tts.c
(defun talk (&optional (text "this") (language "en"))
  "Plays the given string in TEXT directly on the speaker. Needs espeak-ng
   compiled with pcaudiolib."
  (declare (string text))
  (with-espeak (:AUDIO_OUTPUT_SYNCH_PLAYBACK 0 (cffi:null-pointer) 0)
    (espeak_setsynthcallback (cffi:callback ctest))
    (cffi:with-foreign-object (text-size 'size)
      (setf (cffi:mem-ref text-size 'size) (1+ (length text)))
      (cffi:with-foreign-strings ((lang language)
                                  (stext text))
        (espeak_setvoicebyname lang)
        (espeak_synth stext text-size 0 0 0 ESPEAKCHARS_AUTO
                      (cffi:null-pointer) (cffi:null-pointer))))))
