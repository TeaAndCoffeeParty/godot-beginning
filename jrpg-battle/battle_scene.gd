extends Node2D

var player_data = {
	"hp": 100,
	"max_hp": 100,
	"attack": 20
}

var enemy_data = {
	"hp": 80,
	"max_hp": 80,
	"attack": 15
}

var is_player_turn = true
var game_over = false

@onready var button_attack = $HUD/MarginContainer/VBoxContainer/ButtonAttack
@onready var button_end_turn = $HUD/MarginContainer/VBoxContainer/ButtonEndTurn
@onready var status_label = $HUD/MarginContainer/VBoxContainer/Label
@onready var player_hp_label =$HPLabels/PlayerHPLabel
@onready var enemy_hp_label = $HPLabels/EnemyHPLabel

func _ready() -> void:
	update_ui()
	
func update_ui() -> void:
	if not game_over:
		status_label.text = "Current Turn : %s" % ("Player" if is_player_turn else "Enemy")
		button_attack.disabled = not is_player_turn
		button_end_turn.disabled = not is_player_turn

	var player_percent = player_data.hp / player_data.max_hp
	var enemy_percent = enemy_data.hp / enemy_data.max_hp
	
	player_hp_label.text = "HP: %d/%d" % [player_data.hp, player_data.max_hp]
	enemy_hp_label.text = "HP: %d/%d" % [enemy_data.hp, enemy_data.max_hp]
	

func _on_button_attack_pressed() -> void:
	if game_over or not is_player_turn:
		return
	enemy_data.hp -= player_data.attack
	enemy_data.hp = max(0, enemy_data.hp)
	
	print("Player attack! make %d damage." % player_data.attack)
	
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
	player_data.hp -= enemy_data.attack
	player_data.hp = max(0, player_data.hp)
	print("Enemy attack! make %d damage" % enemy_data.attack)
	
	update_ui()
	check_game_over()

	if not game_over:
		is_player_turn = true
		update_ui()

func check_game_over() -> void:
	if player_data.hp <= 0:
		status_label.text = "Game Over: You Lose!"
		disable_buttons()
		game_over = true
	elif enemy_data.hp <= 0:
		status_label.text = "Game Over: You Win!"
		disable_buttons()
		game_over = true
		

func disable_buttons() -> void:
	button_attack.disabled = true
	button_end_turn.disabled = true
