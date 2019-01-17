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

(defmacro with-sinsy (&body body)
  "Macro useful to initialize and terminate and cleanup
   sinsy/ecantorix state."
  `(unwind-protect
        (progn (sinsy_ng_init)
               ,@body)
     (sinsy_ng_term)))

(defmacro with-espeak ((output buflength path options) &body body)
  "Macro useful to initialize espeak and make sure is terminated
   once finished. Keep in mind that if you call terminate twice
   it will get blocked."
  `(unwind-protect
        (when (plusp (espeak_initialize ,output
                                        ,buflength
                                        ,path
                                        ,options))
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
                    (pitch 50) (range 50) (volume 100) (rate 175)
                    (wordgap -1) (punctuation -1) (capitals -1) (linelength -1))
  "Plays the given string in TEXT directly on the speaker.
   Needs espeak-ng compiled with pcaudiolib.
      espeakRATE:    speaking speed in word per minute.  Values 80 to 450.

      espeakVOLUME:  volume in range 0-200 or more.
                     0=silence, 100=normal full volume, greater values may produce amplitude compression or distortion

      espeakPITCH:   base pitch, range 0-100.  50=normal

      espeakRANGE:   pitch range, range 0-100. 0-monotone, 50=normal

      espeakPUNCTUATION:  which punctuation characters to announce:
         value in espeak_PUNCT_TYPE (none, all, some),
         see espeak_GetParameter() to specify which characters are announced.

      espeakCAPITALS: announce capital letters by:
         0=none,
         1=sound icon,
         2=spelling,
         3 or higher, by raising pitch.  This values gives the amount in Hz by which the pitch
            of a word raised to indicate it has a capital letter.

      espeakWORDGAP:  pause between words, units of 10mS (at the default speed)
"
  (declare (type string text language)
           (type (integer 0 100) pitch range)
           (type (integer 0 200) volume)
           (type (integer -1 1000) capitals)
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
        (when (>= wordgap 0) (espeak_setparameter :espeakwordgap wordgap 0))
        (when (>= punctuation 0) (espeak_setparameter :espeakpunctuation punctuation 0))
        (when (>= capitals 0) (espeak_setparameter :espeakcapitals capitals 0))
        (when (>= linelength 0) (espeak_setparameter :espeaklinelength linelength 0))
        (espeak_synth stext text-size 0 0 0 ESPEAKCHARS_AUTO
                      (cffi:null-pointer) (cffi:null-pointer))))))
