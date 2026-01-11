extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready() -> void:
	print("parameters/conditions/is_moving",animation_tree.get("parameters/conditions/is_moving"))
	update_animation_parameters(starting_direction)

func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
		Input.get_action_strength('right') - Input.get_action_strength('left'),
		Input.get_action_strength('down') - Input.get_action_strength('up')
	)

	update_animation_parameters(input_direction)
	
	velocity = input_direction.normalized() * move_speed if input_direction != Vector2.ZERO else Vector2.ZERO
	
	move_and_slide()

	pass

func update_animation_parameters(move_input: Vector2) -> void:
	# 使用 playback 手动旅行到指定状态
	if move_input.length() > 0.1:
		state_machine.travel("Walk") # 确保这里的字符串和状态机里的状态名完全一致
	else:
		state_machine.travel("Idle")
	
	# 方向更新保持不变
	if move_input.length() > 0.1:
		var dir = move_input.normalized()
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Walk/blend_position", dir)
