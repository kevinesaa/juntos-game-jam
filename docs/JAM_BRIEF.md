# Jam Brief — Juntos: Game Jam for Venezuela Earthquake Relief

## Event
- Global Game Jam charity event, 2026-07-24 → 2026-07-26, benefiting WFP USA's
  Venezuela earthquake relief effort. itch.io jam page:
  https://itch.io/jam/juntos-game-jam-venezuela-earthquake-relief
- **Theme: TOGETHER / JUNTOS.**
- WFP/WFP USA branding must NOT appear in the game.

## Time budget for this build
- Total jam window: 48h. **Remaining at start of this session: 5h.**
- The repo already has menu/splash/scene-loading/HUD scaffolding and input
  bindings for a 4-character party, but no core gameplay loop — no enemies,
  no win/loss, no implemented skill effects. Closing that gap is the entire
  job for the remaining time.
- Priority order: playable loop > the two requested features (skill +
  falling target) > everything else (see `docs/TODO.md` for what's
  deliberately deferred).
- This is a multi-person repo. A teammate independently built an end-of-run
  panel + music system in parallel with this session's falling-debris/score
  system, on the same files. They were merged (not a straight pull) — see
  `docs/TODO.md` for what that merge decided.

## Confirmed scope decisions (this build)
1. **Falling target = destroyable debris.** Debris objects descend from the
   top of the arena on a timer/lane. Destroying one (via attack/skill) before
   it lands scores points; letting it land damages whichever character
   occupies that lane.
2. **Game loop = survive to the end-of-run trigger, score-based.** Ending
   the run is owned by the teammate's `endPlay_Node/Timer` →
   `on_end_game_listener()` (shows the endgame panel, freezes player input).
   Score accrues from destroyed debris and is shown live during play and
   again in the endgame panel's result label. No wave escalation, no enemy AI.
3. **Ranged shot + shockwave are shared by all 4 characters.** Originally
   only VDD had the shockwave (skill1) and only Shield Guard had a ranged
   shot; scope changed mid-build so every character gets both: **skill1 =
   shockwave** (destroys debris in a radius) and **skill2 = ranged shot**
   (`skills-controller/RangedShotSkill.gd`, a `SkillController` subclass —
   destroys the nearest debris in range), on all 4 `skills_node_paths`.
   skill3 remains an inert placeholder for every character.
4. **Theme tie-in (`together_skill`, `follow_me`/`unfollow_me`) — deferred.**
   These inputs exist in `project.godot` and are read in
   `PlayerController._process` but not acted on. Not built in this pass.
   See `docs/TODO.md`.

## Lore context (VDD — condensed from `VDD LORE.pdf`)
Dystopian city ruled by a corrupt aristocracy that uses radiation
contamination to keep the poor sick and controllable — some survivors gain
mutant abilities instead of dying. Four rebels, each with a private
grievance, work together to try to bring the regime down:

| Player slot | Character | Role | Motivation |
|---|---|---|---|
| player1 | VDD | Melee | Wants to kill the aristocracy leader personally |
| player2 | Scorpio | Healer | Ex-government scientist mutated by the same radiation he studied; needs a cure |
| player3 | Enigma | Tank | Unrevealed |
| player4 | Shield Guard | Ranged (firearms) | Guerrilla-raised; avenging his family, killed by the Guardia Nocturna |

Note: the lore doc's label for this last character is "Agent Shield," but the
in-scene HUD name (and this codebase's canonical name going forward) is
**"Shield Guard"** — use that name consistently in code, docs, and comments.

Main antagonists: **La Guardia Nocturna** (deniable government death squad,
skull+X forehead tattoo) and **Los Bokors** (black-magic sorcerers rumored to
work for the state). This lore is flavor/UI-copy material only — it does not
change any mechanic decided above unless the user says otherwise.

## Reference art already in `art-visuals/`
- `player1.png`–`player4.png`, `player_portrait.png`: the 4 party members.
- `game-play-background.png`: arena backdrop (matches the in-editor
  screenshot with 4 character sprites + spotlighted stage).
- `skill_place-holder.png`: generic skill icon placeholder.
- `splash_loading.png`: splash screen art.

## Audio
- `audio-music/gameplay.mp3` — teammate-added background music, autoplaying
  via `music_Node/AudioStreamPlayer2D` in `level-jam.tscn`.
