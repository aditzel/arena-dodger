extends Node2D
## Arena Dodger main loop — title, play, game over, score / session best.

enum State { TITLE, PLAYING, GAME_OVER }

const ARENA_RECT := Rect2(48, 48, 864, 444)
const SPAWN_INTERVAL_START := 1.15
const SPAWN_INTERVAL_MIN := 0.35
const SPAWN_INTERVAL_DECAY := 0.018
const MAX_ENEMIES := 40

@onready var player: CharacterBody2D = $Player
@onready var enemies: Node2D = $Enemies
@onready var arena_border: Polygon2D = $Arena/Border
@onready var arena_floor: Polygon2D = $Arena/Floor
@onready var hud: CanvasLayer = $HUD
@onready var title_panel: Control = $HUD/TitlePanel
@onready var game_over_panel: Control = $HUD/GameOverPanel
@onready var play_hud: Control = $HUD/PlayHUD
@onready var score_label: Label = $HUD/PlayHUD/ScoreLabel
@onready var best_label: Label = $HUD/PlayHUD/BestLabel
@onready var final_score_label: Label = $HUD/GameOverPanel/FinalScoreLabel
@onready var final_best_label: Label = $HUD/GameOverPanel/FinalBestLabel
@onready var start_button: Button = $HUD/TitlePanel/StartButton
@onready var restart_button: Button = $HUD/GameOverPanel/RestartButton

var _enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
var _state: State = State.TITLE
var _survival_time: float = 0.0
var _session_best: float = 0.0
var _spawn_timer: float = 0.0
var _spawn_interval: float = SPAWN_INTERVAL_START


func _ready() -> void:
	randomize()
	_setup_arena_visuals()
	player.set_arena_rect(ARENA_RECT)
	player.reset_to(ARENA_RECT.get_center())
	player.set_can_move(false)

	start_button.pressed.connect(_on_start_pressed)
	restart_button.pressed.connect(_on_restart_pressed)

	_show_title()


func _process(delta: float) -> void:
	if _state == State.PLAYING:
		_survival_time += delta
		_spawn_timer -= delta
		if _spawn_timer <= 0.0:
			_spawn_enemy()
			_spawn_interval = maxf(SPAWN_INTERVAL_MIN, _spawn_interval - SPAWN_INTERVAL_DECAY)
			_spawn_timer = _spawn_interval
		_update_play_hud()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		match _state:
			State.TITLE:
				_start_game()
			State.GAME_OVER:
				_start_game()
			_:
				pass


func _setup_arena_visuals() -> void:
	arena_floor.polygon = PackedVector2Array([
		ARENA_RECT.position,
		Vector2(ARENA_RECT.end.x, ARENA_RECT.position.y),
		ARENA_RECT.end,
		Vector2(ARENA_RECT.position.x, ARENA_RECT.end.y),
	])
	var r := ARENA_RECT.grow(4.0)
	arena_border.polygon = PackedVector2Array([
		r.position,
		Vector2(r.end.x, r.position.y),
		r.end,
		Vector2(r.position.x, r.end.y),
	])


func _show_title() -> void:
	_state = State.TITLE
	_clear_enemies()
	player.reset_to(ARENA_RECT.get_center())
	player.set_can_move(false)
	title_panel.visible = true
	game_over_panel.visible = false
	play_hud.visible = false
	_update_play_hud()


func _start_game() -> void:
	_state = State.PLAYING
	_survival_time = 0.0
	_spawn_interval = SPAWN_INTERVAL_START
	_spawn_timer = 0.4
	_clear_enemies()
	player.reset_to(ARENA_RECT.get_center())
	player.set_can_move(true)
	title_panel.visible = false
	game_over_panel.visible = false
	play_hud.visible = true
	_update_play_hud()


func _game_over() -> void:
	if _state != State.PLAYING:
		return
	_state = State.GAME_OVER
	player.set_can_move(false)
	for child in enemies.get_children():
		if child.has_method("deactivate"):
			child.deactivate()
	if _survival_time > _session_best:
		_session_best = _survival_time
	play_hud.visible = true
	title_panel.visible = false
	game_over_panel.visible = true
	final_score_label.text = "Survived %s" % _format_time(_survival_time)
	final_best_label.text = "Session best %s" % _format_time(_session_best)
	_update_play_hud()


func _on_start_pressed() -> void:
	if _state == State.TITLE:
		_start_game()


func _on_restart_pressed() -> void:
	if _state == State.GAME_OVER:
		_start_game()


func _spawn_enemy() -> void:
	if enemies.get_child_count() >= MAX_ENEMIES:
		return
	var enemy: Area2D = _enemy_scene.instantiate()
	enemies.add_child(enemy)
	enemy.global_position = _edge_spawn_position()
	enemy.hit_player.connect(_game_over)
	enemy.activate(player)


func _edge_spawn_position() -> Vector2:
	var side := randi() % 4
	var margin := 18.0
	match side:
		0: # top
			return Vector2(randf_range(ARENA_RECT.position.x, ARENA_RECT.end.x), ARENA_RECT.position.y - margin)
		1: # bottom
			return Vector2(randf_range(ARENA_RECT.position.x, ARENA_RECT.end.x), ARENA_RECT.end.y + margin)
		2: # left
			return Vector2(ARENA_RECT.position.x - margin, randf_range(ARENA_RECT.position.y, ARENA_RECT.end.y))
		_: # right
			return Vector2(ARENA_RECT.end.x + margin, randf_range(ARENA_RECT.position.y, ARENA_RECT.end.y))


func _clear_enemies() -> void:
	for child in enemies.get_children():
		child.queue_free()


func _update_play_hud() -> void:
	score_label.text = "Score %s" % _format_time(_survival_time)
	best_label.text = "Best %s" % _format_time(_session_best)


func _format_time(seconds: float) -> String:
	return "%.1fs" % seconds
