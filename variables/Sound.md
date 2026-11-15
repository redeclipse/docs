Volume, music, the sound device and footsteps.

| Variable / Command | Description | Arguments / Fields |
| :--- | :--- | :--- |
| `soundmastervol` | sets master sound volume (0=mute) | `value` |
| `soundeffectvol` | sets effect sound volume (0=mute) | `value` |
| `soundmusicmenuvol` | sets the music volume on the main menu (0=mute) | `value` |
| `soundmusicprogressvol` | sets the music volume on loading screens (0=mute) | `value` |
| `soundmusicintermissionvol` | sets the music volume during intermission (0=mute) | `value` |
| `soundmusicgamevol` | sets the music volume in game (0=mute) | `value` |
| `soundmusiceditvol` | sets the music volume in edit mode (0=mute) | `value` |
| `sounddevice` | sets the name of the sound device to be used | `value` |
| `soundlimiter` | keeps a loud mix from clipping by briefly turning it down | `value` |
| `footstepsounds` | determines which players' sounds are played, bitwise OR;<br>1: own footsteps<br>2: all other players' footsteps | `value` |
| `footstepsoundmin` | speed at which lower velocities take on the `footstepsoundmingain` value (scales linearly to `footstepsoundmaxgain` above this) | `value` |
| `footstepsoundmax` | speed at which higher velocities are capped at the `footstepsoundmaxgain` (scales linearly down below this) | `value` |
| `footstepsoundlevel` | scale of footstep sounds | `value` |
| `footstepsoundfocus` | scale of the player's own footstep sounds | `value` |
| `footstepsoundlight` | scale of footstep sounds while moving quietly (e.g. crouching) | `value` |
| `footstepsoundmaxgain` | gain of footsteps while at or above `footstepsoundmax` speed | - |
| `footstepsoundmingain` | gain of footsteps while at or below `footstepsoundmin` speed | - |
| `musictheme` | sets the music to play while not in a game | `file` |
| `musicintermission` | sets the music to play during intermission | `file` |
