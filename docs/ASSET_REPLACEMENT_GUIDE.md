# Visual Asset Replacement Guide

How to swap every placeholder/current visual asset in this project for
final art, without breaking scene references. Read the "General workflow"
section first — it explains the two ways to replace a file and when each
applies, so you don't need to repeat that reasoning per asset below.

## Native resolution: 1280×720

The game now renders natively at **1280×720** (up from an original
640×360 canvas upscaled 2x). Every position, margin, collision shape, and
UI size in the project was doubled to match. The still-low-res placeholder
art (character sprites, debris, portrait, skill icon) is compensated with
a `scale = Vector2(2, 2)` override on the relevant node — the underlying
PNGs are still their original small size, just rendered bigger. **When you
drop in real higher-resolution art, remove that node's `scale` override**
(or adjust it) — doubling an already-correctly-sized new image via node
scale would make it twice as big as intended. Each section below flags
which nodes currently carry this `scale = Vector2(2, 2)` workaround.

## General workflow

Every visual resource in this project is referenced by **path** from a
`.tscn` scene file (as an `ext_resource`). There are two ways to swap one:

1. **Same filename, same folder, same dimensions** (recommended): just
   overwrite the file in place (e.g. replace
   `art-visuals/player_1/idle/idle_player1_frame_1.png` with your new PNG,
   same name). Godot re-imports it automatically next time the editor is
   open or the project runs — **zero code or scene changes needed**. This
   is the fastest path and the one to prefer whenever possible.
2. **Different filename/location**: open the relevant `.tscn` in the Godot
   editor, select the node using the old texture, and reassign its
   `texture`/`sprite_frames` property to the new file via the Inspector.
   Every asset section below lists the exact `.tscn` file and node(s) to
   touch if you go this route.

Godot generates a `<filename>.import` sidecar file per asset on first
import — don't delete these, and don't worry about editing them by hand.

**Format/size notes:**
- PNG is used everywhere for sprites/UI; keep transparency (RGBA) for
  anything that isn't a full-screen rectangular background.
- Match the **pixel dimensions** listed per asset below when possible.
  Godot will stretch a mismatched size to fit the node's configured
  region/frame, which can look distorted — resize your art to match, or
  update the corresponding node's `region`/frame size in the `.tscn` if
  you intentionally want a new size.
- All 4 characters currently reuse the exact same rig shape (idle: 4
  frames, walk: 4 frames) — keep new character art on the same frame count
  unless you're also updating `SpriteFrames` timing in the `.tscn`.

---

## 1. Character sprites (idle + walk animations)

**Current:** flat pixel-art frames, one folder per character, native size
32×64 px per frame — displayed at **2x** via `scale = Vector2(2, 2)` on
each character's `player_SpriteRender` `Sprite2D` node (the
`AnimatedSprite2D` is its child, so it inherits the same scale) to look
right-sized on the new 1280×720 canvas.
**Location pattern:** `art-visuals/player_<N>/idle/idle_player<N>_frame_<1-4>.png`
and `art-visuals/player_<N>/walk/walk_player<N>_frame_<1-4>.png`, for
`N` = 1 (VDD), 2 (Scorpio), 3 (Enigma), 4 (Shield Guard).

Same-filename replacement covers this automatically — all 32 files
(4 characters × 2 animations × 4 frames) are wired into `SpriteFrames`
sub-resources inside `level-jam/level-jam.tscn`. If you add new
animations (e.g. an attack animation) or change frame counts, you'll need
to edit the `SpriteFrames` resource for that character directly in the
editor (Animation panel on the character's `AnimatedSprite2D` node).

**Higher-resolution replacements (recommended path forward):** new art
already exists in `art-visuals/player_1/idle/EnigmaIdle-*.png` at native
303×606 — much higher-res than the 32×64 placeholders, sized to look
correct on the new canvas *without* the ×2 node scale. Once real art like
this is wired into a character's `SpriteFrames`, **remove that
character's `scale = Vector2(2, 2)` override** on its `player_SpriteRender`
node — leaving it in would double an already-correctly-sized image.

**Selection outline:** each character's `AnimatedSprite2D` has a
`ShaderMaterial` (`_commons/shaders/sprite_outline.gdshader`) that draws a
colored outline around the sprite's actual silhouette (based on alpha,
not a bounding box) when that character is the selected one. This works
automatically with new art as long as the new PNGs have real transparency
around the character — a fully opaque rectangular sprite will show no
outline, since there's no alpha edge to trace.

## 2. Character portraits (HUD)

**Current:** one shared placeholder image for all 4 characters.
**Dimensions:** 80×80 px native, displayed in a 64×96 max box (doubled
from 32×48) — provide art around 128×192 or larger for a crisp fit.
**Location:** `art-visuals/player_portrait.png`.
**Used by:** `level-jam/player-ui-layout.tscn` (`portrait_TextureRect` node).

All 4 HUD panels currently point at this **same file** — if you want a
unique portrait per character, you'll need to either (a) give each
character's `PlayerLayout` instance in `level-jam.tscn` its own texture
override on `portrait_TextureRect`, or (b) create 4 separate portrait
files and repoint each instance individually (the "different
filename" path above).

## 3. Skill icons

**Current:** one shared placeholder icon for all 3 skill slots, all 4
characters.
**Dimensions:** displayed in a 48×48 max box (doubled from 24×24) — provide
art around 96×96 for a crisp fit.
**Location:** `art-visuals/skill_place-holder.png`.
**Used by:** `level-jam/player-ui-layout.tscn` (`TextureRect` nodes under
each `skills_*_CenterContainer/PanelContainer`).

If each skill should get its own icon (shockwave / ranged shot / speed
boost), same-filename replacement won't work since they all share one
file today — repoint each of the 3 `TextureRect` nodes individually in
`player-ui-layout.tscn`.

## 4. Falling debris

**Current:** a flat brown `Polygon2D` diamond (16×16, displayed at
`scale = Vector2(2, 2)`) — **no PNG asset at all**.
**Location:** `falling-debris/falling-debris.tscn`.

To use real art here, replace the `Polygon2D` node with a `Sprite2D` (or
`AnimatedSprite2D`) pointing at your new texture (remove the `scale`
override if your new art is already sized correctly), keeping the node
name referenced by `FallingDebris.gd` intact (the script doesn't
reference the visual node directly, so this is a pure scene-file edit —
no code changes needed).

## 5. Ranged-shot VFX

**Current:** a yellow `Line2D` tracer (`ShotLine`) plus a small
`CPUParticles2D` impact burst (`ImpactVfx`), both procedural — no image
assets. Both live under each character's `skill2_player<N>` node in
`level-jam.tscn`.

If you want a sprite-based muzzle flash or impact effect instead of the
particle burst, add a new `AnimatedSprite2D`/`Sprite2D` alongside
`ImpactVfx` and trigger it from `RangedShotSkill._playImpactVfx()`
(`skills-controller/RangedShotSkill.gd`) the same way `impact_vfx.restart()`
is called today.

## 6. Shockwave visual

**Current:** procedural — a growing/fading ring drawn in code
(`skills-controller/ShockwaveVisual.gd`, `_draw()`/`draw_arc()`). No image
asset. If you want a sprite-based shockwave effect instead, replace the
`_draw()` call with an `AnimatedSprite2D` played on `skillEffect()`.

## 7. Backgrounds

| Asset | Native dimensions | Displayed at | Location | Used by |
|---|---|---|---|---|
| Gameplay background | 640×360 | 1280×720 (via `scale = Vector2(2, 2)` on `GamePlayHolder`) | `art-visuals/game-play-background.png` | `level-jam/level-jam.tscn` |
| Splash/loading background | 1920×1080 | fits a 1280×720 box (`stretch_mode` keeps aspect) | `art-visuals/splash_loading.png` | `splash-screen/splash-screen.tscn` |

Same-filename replacement covers both. If you replace the gameplay
background with a native 1280×720 (or larger) image, **remove the
`scale = Vector2(2, 2)` override on `GamePlayHolder`** so it isn't doubled
again. Main menu currently has **no** background image — it renders on
the default UI theme background only (see section 9).

## 8. Band-member end-screen slideshow (merged to `main`)

**Current:** flat-color placeholder squares (192×192 `ColorRect`, doubled
from 96×96), one per band member, defined entirely in code — **no image
files exist yet.**

To drop in a real photo per member, edit the `members` array at the top
of `band-slideshow/band-slideshow.gd` and add a `"photo"` key to that
member's dictionary, e.g.:
```gdscript
{"name": "VDD", "bio": "...", "color": Color(...), "photo": preload("res://art-visuals/band/vdd.png")}
```
No scene changes needed — the script automatically shows the photo
instead of the color placeholder once a `"photo"` key is present. Photos
should be square-ish (the placeholder box is 192×192) with transparency
if you want a non-rectangular crop.

## 9. Fonts / UI theme

**Current:** `assets/3rd Man.ttf` + `resources/themes/tema_menus.tres`
(a `Theme` resource defining Button/Label font, font size 32 for both —
doubled from Godot's 16px default — and button style states with
correspondingly doubled border widths/corner radii).
**Status: applied project-wide** via `gui/theme/custom` in `project.godot`,
so every scene's Buttons/Labels pick it up automatically — no per-scene
wiring needed.

To swap the font itself, replace `assets/3rd Man.ttf` (same filename) or
point `tema_menus.tres`'s `FontFile` ext_resource at a new file. To change
the global text size, edit `default_font_size` /
`Button|Label/font_sizes/font_size` in `tema_menus.tres`.

## 10. Debug-only visuals (safe to ignore for asset swaps)

`_commons/debug/InputDebugOverlay.gd` and
`skills-controller/ShockwaveRadiusDebug.gd` are plain-drawn debug aids,
auto-hidden in exported builds (`OS.is_debug_build()`) — no art assets,
nothing to replace.

---

## Quick reference: file → scene map

| Asset folder | Scene file(s) that reference it |
|---|---|
| `art-visuals/player_*/idle,walk/` | `level-jam/level-jam.tscn` |
| `art-visuals/player_portrait.png` | `level-jam/player-ui-layout.tscn` |
| `art-visuals/skill_place-holder.png` | `level-jam/player-ui-layout.tscn` |
| `art-visuals/game-play-background.png` | `level-jam/level-jam.tscn` |
| `art-visuals/splash_loading.png` | `splash-screen/splash-screen.tscn` |
| `assets/3rd Man.ttf` | `resources/themes/tema_menus.tres` |
| `band-slideshow/band-slideshow.gd` (`members` array) | `band-slideshow/band-slideshow.tscn` |
