extends Node2D

@onready var player_unit: Node2D = $PlayerTeam/PlayerUnit
@onready var enemy_unit: Node2D = $EnemyTeam/EnemyUnit

var is_player_turn = true
var game_over = false

@onready var button_attack = $HUD/MarginContainer/VBoxContainer/ButtonAttack
@onready var button_end_turn = $HUD/MarginContainer/VBoxContainer/ButtonEndTurn
@onready var status_label = $HUD/MarginContainer/VBoxContainer/Label

func _ready() -> void:
	update_ui()
	
func update_ui() -> void:
	if not game_over:
		status_label.text = "Current Turn : %s" % ("Player" if is_player_turn else "Enemy")
		button_attack.disabled = not is_player_turn
		button_end_turn.disabled = not is_player_turn
	

func _on_button_attack_pressed() -> void:
	if game_over or not is_player_turn:
		return
	var damage = player_unit.get_attack()
	enemy_unit.take_damage(damage)
	
	update_ui()
	check_game_over()

func _on_button_end_turn_pressed() -> void:
	if game_over or not is_player_turn:
		return
	
	is_player_turn = false
	update_ui()
	
	await get_tree().create_timer(0.5).timeout
	if not game_over:
		_enemy_turn()

func _enemy_turn() -> void:
	var damage = enemy_unit.get_attack()
	player_unit.take_damage(damage)
	
	update_ui()
	check_game_over()

	if not game_over:
		is_player_turn = true
		update_ui()

func check_game_over() -> void:
	if player_unit.is_dead():
		status_label.text = "Game Over: You Lose!"
		disable_buttons()
		game_over = true
	elif enemy_unit.is_dead():
		status_label.text = "Game Over: You Win!"
		disable_buttons()
		game_over = true
		

func disable_buttons() -> void:
	button_attack.disabled = true
	button_end_turn.disabled = true
