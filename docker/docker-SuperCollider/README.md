plan: 
authentication > udp (OSC) > scsynth (audio) > jack > ffmpeg > stream (rtp) > youtube/web/vlc broadcast (incl. authentication)

### SuperCollider Docker build

Docker Build command:
docker build -t scdock .

Docker run command:
docker run -t -i --publish 1234:1234 --name scdock scdock:0.01


use ffmpeg to create a writable jack client: ffmpeg -f jack -i <client_name> -strict -2 -y <output_file_name>

looks like apk:ffmpeg is built without jack?
rebuild from src?


<!-- was `docker run -it --rm --device /dev/snd -p 57150:57150/udp orbsmiv/supercollider-rpi` -->
<!-- on sh: ffmpeg -re -f lavfi -i aevalsrc="sin(400*2*PI*t)" -ar 8000 -f mulaw -f rtp rtp://192.168.1.129:1234 -->
from: https://trac.ffmpeg.org/wiki/StreamingGuide#StreamingasimpleRTPaudiostreamfromFFmpeg




Note that you must install the python-dbus package to use jack_control. 




use vlc > media > open network stream > network url "rtp://@:1234"






Order in which to execute (wrap in entrypoint.sh):
- jackd
- scsynth
- jack_connect

Put all of the user-varoable params into Env vars which can be specified as part of the docker run command.


Jack command:
`jackd -m -r -p 32 -T -d alsa -d hw:0 -n 3 -o 2 -p 2048 -P -r 48000 -s &`



Scsynth command:
`scsynth -u 57150 -m 131072 -D 0 -R 0 -o 2 -z 128 &`


Jack_connect commands:
`jack_connect SuperCollider:out_1 system:playback_1 && jack_connect SuperCollider:out_2 system:playback_2`



#### Notes

From SonicPi:
`jackd -R -p 32 -d alsa -d hw:#{audio_card} -n 3 -p 2048 -o2 -r 44100&`


SonicPi scsynth config:
```
      boot_and_wait("scsynth",
                    "-u", @port.to_s,
                    "-m", "131072",
                    "-a", num_audio_busses_for_current_os.to_s,
                    "-D", "0",
                    "-R", "0",
                    "-l", "1",
                    "-i", "2",
                    "-o", "2",
                    "-z", block_size.to_s,
                    "-c", "128",
                    "-U", "/usr/lib/SuperCollider/plugins:#{native_path}/extra-ugens/",
                    "-b", num_buffers_for_current_os.to_s,
                    "-B", "127.0.0.1")

```
