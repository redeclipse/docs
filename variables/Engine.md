The engine's own settings, and the values it reports.

## Engine settings

| Variable / Command | Description | Arguments / Fields |
| :--- | :--- | :--- |
| `maxfps` | caps the maximum framerate at the given value; note that vsync will cap at monitor refresh if enabled | `value` |
| `vsync` | toggles vertical synchronization (frame pacing to monitor refresh rate) | `boolean` |
| `screenres` | sets the gameplay render resolution | `x y` |
| `screenh` | sets the number of vertical pixels onscreen | `value` |
| `screenw` | sets the number of horizontal pixels onscreen | `value` |
| `fullscreen` | toggles fullscreen or windowed mode | `boolean` |
| `volumetric` | toggles rendering volumetric-tagged lights with volumetrics | `boolean` |
| `volsteps` | sets the number of intensity subdivisions for volumetric lights | `value` |
| `gi` | toggles use of global illumination for maps | `boolean` |
| `ao` | toggles use of ambient occlusion (obscurance) for maps; note that this is called "ambient obscurance" in the code but referred to by its common name of "ambient occlusion" in the UI | `boolean` |
| `fxaa` | toggles fast approximate antialiasing (grease filter) | `boolean` |
| `fxaaquality` | sets quality level of FXAA filter | `value` |
| `msaa` | sets level of multisampling antialiasing (usually in powers of 2) | `value` |
| `tqaa` | toggles temporal antialiasing | `boolean` |
| `smaa` | toggles morphological antialiasing | `boolean` |
| `smaaquality` | sets quality level of morphological AA | `value` |
| `bilinear` | toggles bilinear texture filtering | `boolean` |
| `trilinear` | toggles trilinear texture filtering | `boolean` |
| `aniso` | sets level of anisotropic filtering (usually in powers of 2) | `value` |
| `gscale` | sets engine render scale (percent of native resolution) | `value` |
| `texreduce` | factor by which to reduce the resolution of level textures by | `value` |
| `maxtexsize` | maximum resolution to which textures can be loaded into the game at | `value` |
| `envmapsize` | resolution (as a power of 2) for the environment maps on a level | `value` |
| `softparticles` | toggles smoothing of particle effects and weapon glows | `boolean` |
| `caustics` | toggles light caustic rendering for water volumes | `boolean` |
| `waterreflect` | toggles screenspace surface reflection for water volumes | `boolean` |
| `vertwater` | toggles surface height animation for water volumes | `boolean` |
| `filltjoints` | toggles whether to fix geometry t-joints (often visible as 'sparklies' in geometry); this should almost always be enabled | - |
| `stains` | toggles bloodstains on map geometry | `boolean` |
| `maxstaintris` | maximum amount of geometry devoted to blood stains | `value` |
| `smfilter` | shadow filtering level | `value` |
| `smsize` | resolution of shadow rendering | `value` |
| `smstaticdist` | distance from the camera beyond which pickups stop animating in cached light shadows | `value` |
| `smalpha` | enables shadows cast by alpha geometry (1 - sunlight, 2 - pointlights) | `value` |
| `rhtaps` | radiance hint taps; sets global illumination resolution | `value` |
| `aotaps` | number of ambient obscurance taps; sets ambient obscurance resolution | `value` |
| `aoiter` | iterations to smooth ambient obscurance over | `value` |
| `gamma` | sets the screen gamma (luminance curve) | `value` |
| `mapeffects` | sets the visibility of level-defined optional mapmodels, lights, particles, and other entities, from 1 (minimal) to 3 (show all) | `value` |
| `winddebug` | shows debug information for wind emitters | `boolean` |
| `windanimdist` | sets the maximum distance for drawing wind animations | `value` |
| `windanimfalloff` | sets the falloff distance for drawing wind animations | `value` |
| `windmaxemitters` | sets the maximum amount of active wind emitters | `value` |
| `particlewind` | toggles allowing particles to move with the wind (including map wind and explosions) | `boolean` |
| `fileredirect` | reads replacement in place of removed once removed can't be found anywhere; removed can use * and ? wildcards and \| between alternatives, and replacement fills in what they matched as $1 to $9 ($$ is a $);<br>a texture, sky box, model, sound or music a map names that's removed is ported to replacement when the map loads, so saving the map saves it, and colour (0xRRGGBB) tints a diffuse texture's slot;<br>an empty replacement drops removed, so a map slot loses that texture and its shader the part that used it;<br>example: fileredirect "textures/old/*" "textures/new/$1" | `removed replacement [colour]` |
| `fileredirectclear` | removes every redirect made with fileredirect | - |
| `fileredirectlist` | returns every redirect as a list of removed, replacement and colour triples | - |
| `fileredirectmatch` | returns what path is redirected to, one step on and whether or not it exists, or nothing | `path` |
| `fileredirectverbose` | logs each removed file the first time it's redirected | `boolean` |
| `fileredirectmissing` | logs each texture, composite, sound or required model that can't be found and has no redirect, once, to list what needs one | `boolean` |

## Engine values

| Variable / Command | Description | Arguments / Fields |
| :--- | :--- | :--- |
| `camerapitch` | returns the current camera's pitch as a float precise to seven digits | - |
| `cameraroll` | returns the current camera's roll as a float precise to seven digits | - |
| `camerayaw` | returns the current camera's yaw as a float precise to seven digits | - |
| `cameraposx` | returns the x coordinate of the camera's location as a float precise to seven digits | - |
| `cameraposy` | returns the y coordinate of the camera's location as a float precise to seven digits | - |
| `cameraposz` | returns the z coordinate of the camera's location as a float precise to seven digits | - |
| `getenginestat` | returns an engine value:<br>0:wtr     1:wtr%    2:wvt     3:wvt%    4:evt<br>5:eva     6:ond      7:va       8:gl       9:gb<br>10:oq     11:fps    12:best   13:worst  14:ents<br>15:entsel 16:wp     17:pvs    18:vel     19:m/s<br>20:km/h  21:posx  22:posy   23:posz   24:yaw<br>25:pitch  26:roll    27:selox  28:seloy  29:seloz<br>30:selsx  31:selsy  32:selsz  33:selcx  34:selcxs<br>35:selcy  36:selcys 37:cube   38:mat   39:corner<br>40:orient 41:grid | - |
