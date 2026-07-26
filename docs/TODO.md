# TODO / Deferred decisions

Items intentionally punted during the crunch build starting 2026-07-26.
Revisit if time remains after the skill + falling-target loop is playable.

## Needs a decision from the user
- **Theme tie-in for `together_skill` / `follow_me` / `unfollow_me`.**
  These input actions are already bound in `project.godot` and read (unused)
  in `PlayerController._process`. Proposed default, not yet approved: pressing
  `together_skill` triggers a party-wide ultimate on its own cooldown that
  destroys/damages every currently-falling debris target on screen — a direct,
  cheap expression of the TOGETHER/JUNTOS jam theme reusing the
  `SkillController` cooldown pattern. Needs explicit go-ahead before building.
  `follow_me`/`unfollow_me` have no proposed use yet — open question whether
  they're in scope at all for this jam build.

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
- `endPlay_Node/Timer.wait_time` is currently `3.0` (seconds) — clearly a
  local test value, not tuned for an actual playtest. Bump it back up before
  a real run-through.

## Explicitly out of scope for this build
- Wave escalation / enemy AI.
- Skills for VDD, Scorpio, Enigma beyond whatever already exists.
- Any WFP/WFP USA branding (disallowed by jam rules — see `docs/JAM_BRIEF.md`).
