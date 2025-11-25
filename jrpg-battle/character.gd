extends Node2D

var core: PlayerGD

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var name_label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	core = PlayerGD.new()
	update_ui()
	pass # Replace with function body.

func get_attack() -> int:
	if core:
		return core.get_attack()
	return 0

func take_damage(damage_amount: int):
	core.take_damage(damage_amount)
	print("%s takes %d damage. HP is now %d" % [core.get_name(), damage_amount, core.get_current_hp()])
	update_ui()

func update_ui():
	var current_hp = core.get_current_hp()
	var max_hp = core.get_max_hp()
	var character_name = core.get_name()

	if progress_bar:
		progress_bar.max_value = max_hp
		progress_bar.value = current_hp
	if name_label:
		name_label.text = "%s\nHP: %d/%d" % [character_name, current_hp, max_hp]

func is_dead() -> bool:
	return !core.is_alive()
