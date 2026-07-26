# TODO / Deferred decisions

Items intentionally punted during the crunch build starting 2026-07-26.
Revisit if time remains after the skill + falling-target loop is playable.

## Needs a decision from the user
- **`follow_me` / `unfollow_me` are still bound-but-dead.** No proposed use
  yet — open question whether they're in scope at all for this jam build.
  (`together_skill` is now implemented — see below.)
- **`skill3` is an inert placeholder on all 4 characters.** It has a cooldown
  that recovers and a HUD bar that fills, but `skillEffect()` does nothing
  for it (no `path_shock_wave_node_2d`, not a subclass). Either give it an
  effect or consider hiding the third HUD slot.
- **The per-character `power_ProgressBar` in the HUD is still unused.**
  Declared in `CharacterUiController` and present in `player-ui-layout.tscn`,
  never written to. The shared JUNTOS meter deliberately went in the main HUD
  instead. If you want per-character contribution visible, this is the bar
  to drive.

## Resolved this session
- **WIP shockwave effect on `SkillController.gd`** — decision made: kept and
  finished (not discarded, not refactored into a subclass). It remains a
  data-driven base-class effect gated on `path_shock_wave_node_2d` being set,
  extended to also destroy any `falling_debris`-group node within
  `shockwave_radius` when it fires. Two latent bugs fixed alongside it: a
  null-guard crash in `_ready()` that would have hit skill nodes without the
  path set, and a timer that never reset (making the visual effect show once
  and then stay stuck visible forever). Later given a real visual
  (`ShockwaveVisual.gd`, a growing/fading ring) since the original toggle
  target node had nothing to draw.
- **Ranged shot skill** — implemented as
  `skills-controller/RangedShotSkill.gd` (renamed from `ShieldGuardSkill.gd`
  once it stopped being one character's exclusive), a genuine
  `SkillController` subclass. Destroys the nearest `falling_debris`-group
  node within `skillRange` (200.0 px).
- **Scope change: every character has both skills.** Originally shockwave
  was VDD-only (skill1) and the ranged shot was Shield Guard-only (skill1).
  Changed to: all 4 characters get **skill1 = shockwave**, **skill2 =
  ranged shot**, skill3 still inert. This meant moving Shield Guard's ranged
  shot from `skill1_player4_Node2D` to `skill2_player4_Node2D` and giving
  player4 a shockwave on `skill1_player4_Node2D` instead.
- **Falling debris system** — new `falling-debris/` directory:
  `FallingDebris.gd` (destructible, group `"falling_debris"`, emits
  `destroyed`/`landed`), `DebrisSpawner.gd` (timer-based spawner), and a
  placeholder `falling-debris.tscn` (a plain colored `Polygon2D`, no
  dedicated art exists yet).
- **Two independently-built "end of run" systems, merged.** While this
  session was building a `runTimer`/`win_panel` pair, a teammate pushed
  their own `endPlay_Node/Timer` → `endgame_container_PanelContainer` +
  `PlayerController.endGame` (input freeze) system to the same files.
  Decision: kept the teammate's system as canonical (it has the input-freeze
  and an Exit button, which this session's version didn't), dropped
  `runTimer`/`win_panel` entirely, and added a `resultLabel` into their
  previously-empty `CenterContainer` that `on_end_game_listener()` now
  populates with the final score before showing the panel.
- **Debug tools** — `_commons/debug/InputDebugOverlay.gd` (top-right,
  per-action pressed/not-pressed) and
  `skills-controller/ShockwaveRadiusDebug.gd` (always-on radius ring, debug
  builds only).
- **TOGETHER/JUNTOS theme mechanic — built.** A single shared charge meter in
  the main HUD (`togetherHBoxContainer`) fills by `togetherChargePerKill`
  (default 10.0, `@export` on `LevelJamController`) for **every** debris
  destroyed by **any** character — the whole party feeds one resource. At full
  (100.0) the label reads `JUNTOS! [SPACE]` and pressing **Space** destroys
  every falling debris on screen at once, then empties the meter. Space was
  added as a second event on the existing `together_skill` action, so `L`
  still works too. Input is routed the conventional way: `PlayerController`
  emits `on_together_skill_requested` → `LevelJamController` decides whether
  the meter is full. Note it's gated behind the existing pause/endGame early
  returns in `PlayerController._process`, so it can't fire while paused or
  after the run ends.
- **Selected-character highlight** — a `ReferenceRect` (`selectionHighlight`)
  over each portrait in `player-ui-layout.tscn`, toggled by
  `CharacterUiController.set_selected()`. This required connecting
  `PlayerController.on_current_character_change`, which existed and was
  emitted but had **never been wired to anything** — so before this there was
  no on-screen indication of which character you were controlling.
- **Untested** — no Godot binary was available in the environment this was
  built in; every change above needs a manual run-through in the editor
  before this counts as actually working, not just plausible on a static
  read.

## Two working copies exist — know which one you're in
- `repos/juntosggm/juntos-game-jam` — **the current/canonical one.** HEAD at
  the teammate's latest (`feat: show endgame panel`), containing both their
  work (endgame panel, music, main-menu nav) and this session's
  debris/skill/score work, reconciled.
- `repos/juntosggm/juntos-game-jam-main` — an **older clone** stuck at HEAD
  `87f1ed2` (pre-teammate-push). It holds the pre-merge version of this
  session's work: identical debris/shockwave/ranged-shot code, but with the
  now-abandoned `runTimer`/`win_panel` end-of-run instead of the teammate's
  panel, and none of the teammate's commits. Kept as a reference/backup;
  **don't develop in it** and don't merge it forward wholesale — its
  `level-jam.tscn`, `level-jam-controller.gd`, and `PlayerController.gd`
  would regress the teammate's work.
- Nothing was lost when the canonical directory was re-cloned mid-merge; the
  original was preserved under the `-main` name. Verified by diffing the two:
  all 9 core gameplay files (`SkillController.gd`, `RangedShotSkill.gd`,
  `ShockwaveVisual.gd`, `ShockwaveRadiusDebug.gd`, `FallingDebris.gd`,
  `DebrisSpawner.gd`, `falling-debris.tscn`, `InputDebugOverlay.gd`,
  `characteUiController.gd`) are byte-for-byte identical, and all 12 skill
  nodes carry identical scripts and tuning values across both copies.
- Still true and still worth doing: **this session's work is entirely
  uncommitted.** Commit it so it isn't resting on one working directory.

## Known pre-existing issues (not caused by this session's work)
- `level-jam/level-jam.tscn91616243952.tmp` — stray Godot scene backup file
  sitting in the repo; likely safe to delete but not touched without asking.
- Several read-but-unused inputs in `PlayerController` (`togetherSkill`,
  `upgradeCurrentSkill`, `basicSkill`, `followme`, `unfollowme`) were dead
  scaffolding before this session.
- `endPlay_Node/Timer.wait_time` is currently `3.0` (seconds) — a deliberate
  local test value, kept for fast iteration. **Bump it up before submitting**,
  and note that at 3s the JUNTOS meter can't reach full (needs ~10 debris
  kills), so the together skill is untestable until you either raise the timer
  or lower `togetherChargePerKill` in the editor.

## Explicitly out of scope for this build
- Wave escalation / enemy AI.
- Skills for VDD, Scorpio, Enigma beyond whatever already exists.
- Any WFP/WFP USA branding (disallowed by jam rules — see `docs/JAM_BRIEF.md`).
