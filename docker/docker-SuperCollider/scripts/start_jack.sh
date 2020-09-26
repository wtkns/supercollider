#!/bin/sh
# start_jack.sh


# Create a JACK writable client with name "ffmpeg".
ffmpeg -f jack -i ffmpeg -y out.wav

# Start the sample jack_metro readable client.
jack_metro -b 120 -d 0.2 -f 4000

# List the current JACK clients.
jack_lsp -c
system:capture_1
system:capture_2
system:playback_1
system:playback_2
ffmpeg:input_1
metro:120_bpm

# Connect metro to the ffmpeg writable client.
jack_connect metro:120_bpm ffmpeg:input_1