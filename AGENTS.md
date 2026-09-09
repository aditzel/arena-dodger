# AGENTS.md — Arena Dodger

Conventions for coding agents working on this repository.

## Source of truth

- GitHub: **https://github.com/aditzel/arena-dodger**
- Prefer PRs into `main` from `cursor/<feature>-*` branches.
- Do not treat Origin (or any other forge) as authoritative for this project.

## Stack constraints

- **Godot 4.7.x** (target editor: **4.7.2**), **GDScript only** — no C# / GDExtension.
- Renderer: **Forward Plus** (`project.godot`).
- Procedural visuals: **Polygon2D** / **ColorRect** (UI dims). No asset packs or third-party art.
- Keep scope lean: no Steam, multiplayer, networking frameworks, or plugin bloat.

## Project layout

| Path | Role |
|------|------|
| `project.godot` | Project settings, input map, main scene |
| `scenes/` | `.tscn` scenes (`main.tscn` is the run scene) |
| `scripts/` | GDScript (`.gd`) and `smoke.sh` |
| `assets/` | Minimal project assets (e.g. `icon.svg`) |
| `README.md` | How to open/run, controls, status |
| `AGENTS.md` | This file |

## Input map (do not rename)

- `move_left`, `move_right`, `move_up`, `move_down`
- `confirm` — Enter / Space for start & restart

## Definition of done

A change is done when:

1. Project opens in Godot 4.7.2 without missing scripts/scenes.
2. Playable loop works: title → move/dodge → collision game over → restart (key + button).
3. Score (survival time) and session best display correctly.
4. `README.md` / `AGENTS.md` still accurate if behavior or layout changed.
5. `./scripts/smoke.sh` exits 0 on a machine with Godot 4.7.x available.

## Headless smoke

```bash
./scripts/smoke.sh
```

Requirements:

- `GODOT_BIN` pointing at a Godot **4.7.x** binary, **or** `godot` / `godot4` on `PATH`.
- Script runs `--import` then a short `--headless` boot of the project and quits.

Agents in environments without Godot installed should still keep `scripts/smoke.sh` valid and note that smoke was not executed locally.

## Coding notes

- Prefer small, readable GDScript files under `scripts/` with scenes in `scenes/`.
- Use typed GDScript where practical (`:=`, return types).
- Enemy/player art stays procedural polygons (cyan square player, red diamond enemies).
- After structural changes, verify `run/main_scene` still points at `res://scenes/main.tscn`.
