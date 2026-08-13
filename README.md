# Dishonored VR

A from-scratch VR mod for **Dishonored (2012)**, bringing true geometric
stereo rendering, head tracking, and motion controls to Arkane's classic —
a game with no native VR support, no source access, and a 32-bit D3D9
renderer that was never meant to do any of this.

**Status: work in progress.** Playable and in active testing on SteamVR
(Valve Index), with a native OpenXR path for Quest planned. No packaged
release yet — watch this repo.

## What works today

- **True per-eye stereo** — real geometric separation (not fake depth /
  reprojection), spliced draw-by-draw inside the renderer, ~227 fps flat
  on an RTX 4090
- **Head tracking** with 3-axis positional parallax
- **Motion controls** — sword swings from real swings, crossbow/gun aimed
  with your hand with its own reticle
- **Readable UI** — menus, powers wheel, and HUD render correctly in both
  eyes; videos and loading screens automatically drop to mono
- **Live calibration** — in-game overlay (F10) for world scale, convergence,
  and image fill, driven by your headset's actual IPD
- Correct FOV through cutscene zooms, auto-start into VR, and a virtual
  gamepad bridging VR input into the game

## How it works

The mod is two cooperating DLLs that sit between the game and your GPU:

```
Dishonored.exe
 └─ d3d9.dll ........... proxy: head/controller tracking, weapon drive,
     │                   input injection, OpenVR compositor submit, overlay
     └─ dxvk_d3d9.dll ... THIS REPO: DXVK fork translating D3D9→Vulkan,
                          with a stereo layer that replays world draws
                          per-eye and duplicates UI into both eyes
```

This repository is the renderer half: a fork of [DXVK](https://github.com/doitsujin/dxvk)
carrying the VR stereo layer. All modifications live in
`src/d3d9/d3d9_device.cpp` on the `VR-Main` branch. The proxy's source will
get its own repository as the project matures.

## Requirements

- Dishonored (2012, original — not the Definitive Edition) on Steam
- A SteamVR-compatible headset (developed on Valve Index; Quest works via
  Link/Virtual Desktop today, native OpenXR planned)
- A Vulkan-capable GPU with enough headroom to render the game twice

## Building (this repo)

32-bit MinGW cross-build, same as upstream DXVK:

```
git clone --recursive https://github.com/GingasVRFO/Dishonored-VR.git
cd Dishonored-VR
meson setup --cross-file build-win32.txt --buildtype release -Dbuild_id=false build.w32
ninja -C build.w32
# output: build.w32/src/d3d9/d3d9.dll → deploy beside Dishonored.exe as dxvk_d3d9.dll
```

Requires Meson, Ninja, glslang, and a MinGW-w64 toolchain built with
**posix threads** (on Debian/Ubuntu: `update-alternatives --config
i686-w64-mingw32-g++`, pick the posix variant).

## Roadmap

- 1:1 motion-tracked hands and weapons via skeletal bone drive
- Full 6DOF camera (roll, cutscene head-look)
- Native OpenXR runtime for standalone Quest support
- Per-eye water reflections

## Credits

- [DXVK](https://github.com/doitsujin/dxvk) by Philip Rebohle, Joshua
  Ashton, and contributors — the foundation this renderer stands on
- [bioshock-vr](https://github.com/mohamad-balouza/bioshock-vr) by Mohamad
  Balouza — generous guidance on UE3 VR internals from the nearest-kin
  project
- Dishonored is a trademark of Bethesda Softworks / Arkane Studios. This
  project is an unofficial fan mod, is not affiliated with or endorsed by
  them, and requires you to own the game.

## License

zlib/libpng, same as upstream DXVK — see [LICENSE](LICENSE).
