extends CharacterBody2D
## Cyan square player — WASD / arrow movement within arena bounds.

const SPEED := 280.0
const HALF_SIZE := 14.0

var _arena_rect: Rect2 = Rect2(40, 40, 880, 460)
var _can_move: bool = false


func _ready() -> void:
	add_to_group("player")


func set_arena_rect(rect: Rect2) -> void:
	_arena_rect = rect


func set_can_move(enabled: bool) -> void:
	_can_move = enabled
	if not enabled:
		velocity = Vector2.ZERO


func reset_to(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if not _can_move:
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	_clamp_to_arena()


func _clamp_to_arena() -> void:
	var min_x := _arena_rect.position.x + HALF_SIZE
	var max_x := _arena_rect.end.x - HALF_SIZE
	var min_y := _arena_rect.position.y + HALF_SIZE
	var max_y := _arena_rect.end.y - HALF_SIZE
	global_position.x = clampf(global_position.x, min_x, max_x)
	global_position.y = clampf(global_position.y, min_y, max_y)
