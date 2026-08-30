#!/bin/bash
# Cross-compile the Dishonored VR proxy DLL (32-bit Windows) from Linux.
# Requires: g++-mingw-w64-i686, OpenVR SDK headers (../openvr or set OPENVR_DIR).
set -e
cd "$(dirname "$0")"
OPENVR_DIR="${OPENVR_DIR:-../openvr}"

mkdir -p out
i686-w64-mingw32-g++ -O2 -Wall -shared \
    -static -static-libgcc -static-libstdc++ \
    -I"$OPENVR_DIR/headers" \
    -I/root/OpenXR-SDK/include \
    -Iimgui -Iimgui/backends \
    -DIMGUI_IMPL_WIN32_DISABLE_GAMEPAD \
    src/dllmain.cpp \
    imgui/imgui.cpp imgui/imgui_draw.cpp \
    imgui/imgui_tables.cpp imgui/imgui_widgets.cpp \
    imgui/backends/imgui_impl_win32.cpp \
    imgui/backends/imgui_impl_dx11.cpp \
    -o out/d3d9.dll \
    -ld3dcompiler -limm32 -ladvapi32 -ldwmapi -lgdi32 -lole32 -luuid -lwindowscodecs \
    -Wl,--kill-at

cp "$OPENVR_DIR/bin/win32/openvr_api.dll" out/
echo "Built out/d3d9.dll"
i686-w64-mingw32-objdump -p out/d3d9.dll | grep -A16 "Export Table" | tail -14 || true
