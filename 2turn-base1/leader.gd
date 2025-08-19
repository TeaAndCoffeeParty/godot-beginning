extends CharacterBody2D

signal followMe()

var direction = Vector2(1, -0.5)
var maxSpeed = 2
var currentDir

func _physics_process(delta: float) -> void:
	var speed = maxSpeed
	if currentDir == "TopRight" and Input.is_action_pressed("ui_up"):
		direction = Vector2(1, -0.5)
	elif currentDir == "DownRight" and Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0.5)
	elif currentDir == "DownLeft" and Input.is_action_pressed("ui_down"):
		direction = Vector2(-1, 0.5)
	elif currentDir == "TopLeft" and Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, -0.5)
	else:
		speed = 0

	global_position += direction * speed
	emit_signal("followMe", direction, speed, global_position, direction*speed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		currentDir = "TopRight"
	elif event.is_action_pressed("ui_right"):
		currentDir = "DownRight"
	elif event.is_action_pressed("ui_down"):
		currentDir = "DownLeft"
	elif event.is_action_pressed("ui_left"):
		currentDir = "TopLeft"
	pass
