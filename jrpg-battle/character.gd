extends Node2D

@export var character_name: String = "Character"
@export var hp: int = 100
@export var max_hp: int = 100
@export var attack: int = 10

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var name_label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_ui()
	pass # Replace with function body.

	
func take_damage(damage_amount: int):
	hp -= damage_amount
	hp = max(0, hp)
	print("%s takes %d damage. HP is now %d" % [character_name, damage_amount, hp])
	update_ui()

func update_ui():
	if progress_bar:
		progress_bar.max_value = max_hp
		progress_bar.value = hp
	if name_label:
		name_label.text = "%s\nHP: %d/%d" % [character_name, hp, max_hp]

func is_dead() -> bool:
	return hp <= 0
