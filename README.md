# Arena Dodger

Top-down 2D survival dodger built with **Godot 4.7 / GDScript**.

**Source of truth:** [https://github.com/aditzel/arena-dodger](https://github.com/aditzel/arena-dodger)

## Status

MVP playable loop: title → survive in the arena → game over → restart. Procedural art only (Polygon2D). No Steam, multiplayer, or engine plugins.

| Item | Value |
|------|--------|
| Engine | Godot **4.7.x** (verified target: **4.7.2**) |
| Language | GDScript only |
| Renderer | Forward Plus |
| Main scene | `scenes/main.tscn` |

## Open / run (Linux)

```bash
git clone https://github.com/aditzel/arena-dodger.git
cd arena-dodger
```

1. Install [Godot 4.7.2](https://godotengine.org/download) (standard build, not .NET).
2. Open the project folder in the Godot Project Manager (or `godot --path .`).
3. Press **F5** / Play — main scene is already set.

Headless smoke (import + short boot):

```bash
./scripts/smoke.sh
# or: GODOT_BIN=/path/to/Godot_v4.7.2 ./scripts/smoke.sh
```

## Controls

| Action | Keys |
|--------|------|
| Move | **WASD** or **Arrow keys** |
| Start / Restart | **Enter** or **Space**, or the on-screen button |

## Gameplay

- Cyan square = you. Stay inside the arena.
- Red diamonds spawn at the edges and chase you.
- Touch an enemy → game over.
- Score = survival time (seconds). Session best is shown on the HUD / game-over screen.

## Layout

```
project.godot
scenes/          # main.tscn, player.tscn, enemy.tscn
scripts/         # GDScript + smoke.sh
assets/          # procedural / minimal (icon.svg)
AGENTS.md        # agent conventions + definition of done
README.md
.gitignore
```

## License

Content in this repo is for the Arena Dodger harness / game project unless noted otherwise.
