__author__ = 'Sumanth Srinivasan'

import librosa as l
import numpy as np
import matplotlib.pyplot as plt
import time

y,sr = l.load('BeatlesHelpMono.wav')

o_env = l.onset.onset_strength(y, sr=sr,hop_length=512)
onset_frames = l.onset.onset_detect(y=y,sr=sr,hop_length=512)

# Converts onsets from frame to milliseconds and finds first order diff
onset_ms = 1000*(onset_frames*512)/float(sr)
beat_ms = np.diff(onset_ms)
print onset_ms
print beat_ms


# DEBUG PLOTS
# plt.figure()
# plt.plot(o_env, label='Onset strength')
# plt.vlines(onset_frames, 0, o_env.max(), color='r', alpha=0.9, linestyle='--', label='Onsets')
# plt.axis('tight')
# plt.legend(frameon=True, framealpha=0.75)
# plt.show()


