extends CharacterBody2D

signal followMe()

var direction = Vector2(1, -0.5)
var maxSpeed = 2

func _physics_process(delta: float) -> void:
	var speed = maxSpeed
	if Input.is_action_pressed("ui_up"):
		direction = Vector2(1, -0.5)
	elif Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0.5)
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(-1, 0.5)
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, -0.5)
	else:
		speed = 0

	global_position += direction * speed
	emit_signal("followMe", direction, speed, global_position, direction*speed)
	#velocity = direction * speed
	#move_and_slide()
