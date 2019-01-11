# libespeak-ng

Lisp bindings for [espeak-ng/espeak-ng](https://github.com/espeak-ng/espeak-ng). More preciselly the version at [740291272/libespeak-ng](https://github.com/740291272/libespeak-NG) which is modified to work with voice singing synthesis.

## Example
To ear the output directly from espeak with the helpers provided, you need to have installed [espeak-ng/pcaudiolib](https://github.com/espeak-ng/pcaudiolib).
```
> (smalltalk "hello world!)
> (talk "hello world!" :pitch 50 :range 100 :volume 100 :rate 90)
```
