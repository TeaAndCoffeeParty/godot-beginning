extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree

func _ready() -> void:
#	animation_tree.set("parameters/Idle/blend_position", starting_direction)
	animation_tree.set("parameters/Walk/blend_position", starting_direction)
	pass

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	)

	velocity = input_direction * move_speed
	
	move_and_slide()
	pass
