# TODO / Deferred decisions

Items intentionally punted during the crunch build starting 2026-07-26.
Revisit if time remains after the skill + falling-target loop is playable.

## Needs a decision from the user
- **`follow_me` / `unfollow_me` are still bound-but-dead.** No proposed use
  yet — open question whether they're in scope at all for this jam build.
  (`together_skill` is now implemented — see below.)
- **No death/game-over condition exists.** `MyCharacterController.takeDamage()`
  clamps health at 0 with no further consequence — no game-over, no score
  penalty. This was a pre-existing gap, made more visible now that debris
  spawn faster (see "Resolved this session" below). Needs a design decision:
  does hitting 0 health matter at all, or is health purely cosmetic pressure?

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
- **TOGETHER/JUNTOS theme mechanic — reworked to per-character (supersedes the
  original shared-meter version).** Originally a single shared charge meter
  filled by any character's kills. Now: each character's own (previously
  unused) `power_ProgressBar` fills from kills *they personally* land, via a
  new `debris_destroyed_by_character` signal bubbled skill → character →
  player controller → scene (`@export powerPerKill` on `LevelJamController`,
  default 25.0 — 4 kills/character to fill). The together-clear only unlocks
  once **all 4** characters are full, gating `JUNTOS! [SPACE]` on
  `_allCharactersFull()`. This structurally forces cycling through all 4
  characters to ever unlock it — intentional for a mechanic named "together."
  The old shared `together_ProgressBar` now shows aggregate readiness across
  all 4 instead of an independent value.
- **Selected-character highlight** — a `ReferenceRect` (`selectionHighlight`)
  over each portrait in `player-ui-layout.tscn`, toggled by
  `CharacterUiController.set_selected()`. This required connecting
  `PlayerController.on_current_character_change`, which existed and was
  emitted but had **never been wired to anything** — so before this there was
  no on-screen indication of which character you were controlling.
- **Selected-skill highlight — same pattern, newly added.** A cyan
  `ReferenceRect` over each of the 3 skill icons, toggled by
  `CharacterUiController.set_selected_skill()`, wired to
  `PlayerController.on_selected_skill_change_notify` (existed, emitted, had
  zero listeners before this).
- **Character on-screen order now matches HUD order.** Swapped
  `player2_Node2D`/`player4_Node2D` x-positions only (240/320/370/420) so
  ascending `characterIndexId` matches ascending on-screen x — screen order
  is now VDD, Scorpio, Enigma, Shield Guard, same as the HUD panels.
- **`skill3` is no longer an inert placeholder.** Now a temporary movement
  speed boost (`skills-controller/SpeedBoostSkill.gd`, 2x speed for 3s by
  default) on all 4 characters, via a new `speedMultiplier` field on
  `MyCharacterController` (plain `var`, not `@export`, to avoid a 0.0 default
  freezing movement on load).
- **Shockwave enlarged and debris spawn rate tuned up.** `shockwave_radius`
  default 72.0 → 110.0; `debrisSpawner_Node` spawn interval 1.0–2.5s →
  0.8–2.0s. Playtest both — not final numbers.
- **Basic camera shake added.** New `Camera2D` (didn't exist before) +
  `_commons/camera/CameraShake.gd` (trauma-based decay), triggered on
  shockwave use and debris landings.
- **End-of-run screen split across two branches, deliberately.** A plain
  donate-line placeholder (`donate_Label`, no photo dependency) merged to
  `main` directly. A band-member slideshow (`band-slideshow/`, flat-color
  placeholders standing in for VDD/Scorpio/Enigma/Shield Guard photos, one
  member per lore character, auto-advance + manual arrows) lives on
  `feat/band-slideshow-endgame`, pushed to origin but **intentionally not
  merged to `main`** — it needs real photos and a real donation URL first.
  Don't merge that branch until both exist; swapping in real photos only
  needs a `photo` key added per entry in `band-slideshow.gd`'s `members`
  array, no code changes.
- **Untested** — no Godot binary was available in the environment this was
  built in; every change above needs a manual run-through in the editor
  before this counts as actually working, not just plausible on a static
  read.
- **Concurrent teammate push, merged cleanly.** While this session's work was
  in progress, a teammate (Kevin Esaa) pushed walk-animation support
  (`feat: animation holders`) touching the same two files this session was
  editing: `player-controller/MyCharacterController.gd` (their idle/walking
  animation-state machine in `moveCharacter()`/`_process()`) and
  `level-jam/level-jam.tscn` (walk `SpriteFrames` + `path_animation_controller`
  wiring per character). Reconciled via a real `git merge` (not a rebase that
  would've rewritten shared history): `moveCharacter()` now applies
  `speedMultiplier` *and* runs their walking/idle state-and-flip logic in the
  same function; the `.tscn` merge was conflict-free apart from one
  `ext_resource` id line, resolved by keeping both entries.

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
- This session's work is now committed (two commits, originally on
  `feat/falling-debris-skills`, then merged to `main`), so it no longer rests
  on a single working directory. `CLAUDE.md` stays deliberately untracked
  (gitignored) and therefore exists only in the canonical copy.

## Known pre-existing issues (not caused by this session's work)
- `level-jam/level-jam.tscn91616243952.tmp` — stray Godot scene backup file
  sitting in the repo; likely safe to delete but not touched without asking.
- Several read-but-unused inputs in `PlayerController` (`togetherSkill`,
  `upgradeCurrentSkill`, `basicSkill`, `followme`, `unfollowme`) were dead
  scaffolding before this session.
- `endPlay_Node/Timer.wait_time` is `155.0` (seconds) — the teammate's value,
  and what is committed. It was briefly set to `3.0` locally for fast
  iteration during this session and restored before committing, so no debug
  value reached the branch. At 155s the JUNTOS meter fills comfortably (needs
  ~10 debris kills), so the together skill is reachable in a normal run.
  Caveat for future sessions: two commit bodies on this branch
  (`3b55145`, `15ac33e`) claim the timer "is still 3.0" — that was written
  from a stale read and is wrong; trust the file, not those messages.

## Explicitly out of scope for this build
- Wave escalation / enemy AI.
- Skills for VDD, Scorpio, Enigma beyond whatever already exists.
- Any WFP/WFP USA branding (disallowed by jam rules — see `docs/JAM_BRIEF.md`).
