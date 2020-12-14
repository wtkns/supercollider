#/bin/sh

cd YOUR-SUPERCOLLIDER-DIR/SuperCollider3/build/

export SC_JACK_DEFAULT_INPUTS="alsa_pcm:capture_1,alsa_pcm:capture_2"
export SC_JACK_DEFAULT_OUTPUTS="alsa_pcm:playback_1,alsa_pcm:playback_2"

scsynth -u 57110 $@