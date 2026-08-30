# Dishonored VR

A from-scratch VR conversion of **Dishonored (2012)** — true stereo
rendering, 6DOF head tracking, motion controls, roomscale, and a
hand-aimed Blink — built as a `d3d9.dll` proxy plus a forked version of DXVK.

Works with **Vive / Index (SteamVR)** and **Quest via Virtual Desktop
(OpenXR)** The mod picks the backend automatically.

## Features
- Full stereo rendering at 4032×2268 (2016×2268 per eye), 6DOF head
  tracking with lean/peek, seated-friendly
- Motion controls: both hands on Arkane's own animation rig, calibrated
  once, with per-stance trims — sword swings, blocking, the power wheel
- **Blink aims with your controller**, with a distance-by-hand-pitch mode
  and a bright landing marker
- Roomscale: walking physically moves Corvo through the game's own
  collision, with automatic recentering
- Crouch under furniture naturally; real-life ducking crouches Corvo
- Wrist-mounted HUD (health/mana on your arm), conversations bring the UI
  front-and-center automatically
- Hand-aimed projectile weapons (crossbow, pistol, grenades)
- Per-eye character shadows, sunshafts, and water reflections
- In-headset settings overlay (F10)

## Requirements
- Dishonored (2012) on Steam — the original, not the Definitive Edition
- A VR headset: SteamVR-native (Vive/Index/etc.), or Quest with Virtual
  Desktop
- A GPU comfortable rendering ~4K flat Dishonored (developed on an
  RTX 4090; the game is CPU-bound in places)

## Install
1. Download `DishonoredVR-alpha.zip` from the
   [Releases page](../../releases/latest) and open the `DishonoredVR-alpha`
   folder inside it. Copy its two folders into your Dishonored install
   folder (`<Steam>\steamapps\common\Dishonored\`), merging when asked:
   - `Binaries\Win32\` → 6 files (the mod, incl. `openvr_api.dll`)
   - `DishonoredGame\Movies\` → skips the unskippable intro videos
2. Run `setup_resolution.bat` (also in that folder) once. It sets
   `ResX=4032 ResY=2268 Fullscreen=False` in your per-user
   `Documents\My Games\Dishonored\...\DishonoredEngine.ini` (backed up
   first). If the file doesn't exist yet, run the game once normally.
3. **Launch through Steam** — a direct .exe launch crashes at the menu
   (the game needs the Steam context).

**Vive/Index:** SteamVR running, launch through Steam. Done.
**Quest:** Virtual Desktop streaming, SteamVR NOT running, launch through
Steam. VD at 72 Hz, SSW Auto. `steam_appid.txt` must be present (it is,
in the package).

 `F5` recenters and sets your standing height. `F10` opens
the overlay to adjust settings. Turn off Motion Blur in the game's video options.


## Controls

Attack with the sword by swinging or use right Trigger
Crouch by crouching Physically or Press Right A
Use Blink with right trigger and aim with your left hand
Use the gun, crossbow etc with left hand trigger and aim with your hand
Interact with left X or A button (index)
Weapon wheel (on Index press left trackpad) on quest use left grip, then use joystick
To get health open the weapon wheel and use B on right hand


## Adjusting Hands
You can adjust your hand location by pressing F10 then calibrate hands, then use the trim settings at the bottom to place where you want them

## Known issues (alpha)
- Hands will rotate with your Head - currently no way to fix this, it's a locked animation from Arkane, they will still track position in 6d0f by your controllers.
- Some dynamic lights render per-eye inconsistently 
- Some Fast-swinging thin objects (hanging chains) can shimmer between eyes
- A few vents refuse crouch entry — slide in (sprint, then crouch)
- Possession / Devouring Swarm / Windblast aim with the head (Blink is
  hand-aimed) - Will eventually work with Hand.
- Cutscene cameras are fixed (no head-look during cinematics)

## Building from source
Two components:

**The proxy (`d3d9.dll`)** — `src/dllmain.cpp`, cross-compiled from Linux
with MinGW (`i686-w64-mingw32-g++`). Needs the OpenVR SDK headers, the
OpenXR SDK headers, and Dear ImGui (docking branch works). `src/build.sh`
has the exact invocation.

**The DXVK fork (`dxvk_d3d9.dll`)** — DXVK v3.0.2 at commit `3a4c6fa3`
plus the patch series in `fork-patches/` (52 patches: the stereo splicer,
per-eye light/shadow work, the wrist-HUD redirect, and the frame-dump
diagnostics). Apply with `git am`, build DXVK's 32-bit d3d9 target per
DXVK's own docs (meson + MinGW), rename the output to `dxvk_d3d9.dll`.
The shipped release uses the state after patch 49 (M8.2); patches 50–52
are M8.3 (superseded — patch 51 reverts it) and M8.4 (not in the shipped
build) — see the release notes before building past patch 49.

## Credits
- Arkane Studios / Bethesda — Dishonored
- [DXVK](https://github.com/doitsujin/dxvk) (zlib license) — the D3D9
  translation layer this project forks
- Dear ImGui (MIT), OpenVR SDK (BSD-3), OpenXR SDK (Apache-2.0)

This is a fan project. It contains no game assets; you need to own
Dishonored on Steam.
