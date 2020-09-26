from mido import MidiFile

mid = MidiFile('midi/VampireKillerCV1.mid', clip=True)
print(mid)

for track in mid.tracks:
    print(track)
    for msg in mid.tracks[0]:
        print(msg)

