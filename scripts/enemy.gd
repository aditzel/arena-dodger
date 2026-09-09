extends Area2D
## Red diamond enemy — moves toward the player.

signal hit_player

const BASE_SPEED := 110.0
const SPEED_VARIANCE := 40.0

var _speed: float = BASE_SPEED
var _player: Node2D = null
var _active: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_speed = BASE_SPEED + randf_range(-SPEED_VARIANCE * 0.25, SPEED_VARIANCE)


func activate(player: Node2D) -> void:
	_player = player
	_active = true


func deactivate() -> void:
	_active = false
	_player = null


func _physics_process(delta: float) -> void:
	if not _active or _player == null or not is_instance_valid(_player):
		return
	var direction := (_player.global_position - global_position).normalized()
	global_position += direction * _speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit_player.emit()
