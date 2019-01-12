;;;; espeak-ng.lisp

(in-package #:espeak-ng)

;;--------------------------------------------------
;; Type
(cffi:defctype size :unsigned-int)

;;--------------------------------------------------
;; Callbacks
;; returns: 0=continue synthesis,  1=abort synthesis.
(cffi:defcallback ctest :int ((wav :pointer) (num :int) (pev :pointer))
  (declare (ignore wav num pev))
  0)

;;--------------------------------------------------

(defmacro with-espeak ((output buflength path options) &body body)
  "Macro useful to initialize espeak and make sure is terminated
   once finished. Keep in mind that if you call terminate twice
   it will get blocked."
  `(unwind-protect
        (when (plusp (espeak_initialize ,output ,buflength ,path ,options))
          ,@body)
     (espeak_terminate)))

;;--------------------------------------------------

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
(defun smalltalk (&optional (text "this") (language "en"))
  "Plays the given string in TEXT directly on the speaker. Needs espeak-ng
   compiled with pcaudiolib."
  (declare (type string text language))
  (with-espeak (:AUDIO_OUTPUT_SYNCH_PLAYBACK 0 (cffi:null-pointer) 0)
    (espeak_setsynthcallback (cffi:callback ctest))
    (cffi:with-foreign-object (text-size 'size)
      (setf (cffi:mem-ref text-size 'size) (1+ (length text)))
      (cffi:with-foreign-strings ((lang language)
                                  (stext text))
        (espeak_setvoicebyname lang)
        (espeak_synth stext text-size 0 0 0 ESPEAKCHARS_AUTO
                      (cffi:null-pointer) (cffi:null-pointer))))))

(defun talk (text &key (language "en")
                          (pitch 50) (range 50) (volume 100) (rate 180))
  "Plays the given string in TEXT directly on the speaker.
   Needs espeak-ng compiled with pcaudiolib."
  (declare (type string text language)
           (type (integer 0 100) pitch range)
           (type (integer 0 200) volume)
           (type (integer 80 450) rate))
  (with-espeak (:AUDIO_OUTPUT_SYNCH_PLAYBACK 0 (cffi:null-pointer) 0)
    (espeak_setsynthcallback (cffi:callback ctest))
    (cffi:with-foreign-object (text-size 'size)
      (setf (cffi:mem-ref text-size 'size) (1+ (length text)))
      (cffi:with-foreign-strings ((lang language)
                                  (stext text))
        (espeak_setvoicebyname lang)
        (espeak_setparameter :espeakpitch pitch 0)
        (espeak_setparameter :espeakrate rate 0)
        (espeak_setparameter :espeakvolume volume 0)
        (espeak_setparameter :espeakrange range 0)
        (espeak_synth stext text-size 0 0 0 ESPEAKCHARS_AUTO
                      (cffi:null-pointer) (cffi:null-pointer))))))
