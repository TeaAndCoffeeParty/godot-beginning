extends CharacterBody2D

signal followMe()

var direction = Vector2(1, -0.5)
var maxSpeed = 2
var currentDir
var previousDir

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
		if previousDir != currentDir:
			previousDir = currentDir
		currentDir = "TopRight"
	elif event.is_action_pressed("ui_right"):
		if previousDir != currentDir:
			previousDir = currentDir
		currentDir = "DownRight"
	elif event.is_action_pressed("ui_down"):
		if previousDir != currentDir:
			previousDir = currentDir
		currentDir = "DownLeft"
	elif event.is_action_pressed("ui_left"):
		if previousDir != currentDir:
			previousDir = currentDir
		currentDir = "TopLeft"
	
	var u = event.is_action_released("ui_up")
	var r = event.is_action_released("ui_right")
	var d = event.is_action_released("ui_down")
	var l = event.is_action_released("ui_left")

	if u and currentDir == "TopRight":
		currentDir = previousDir
	if r and currentDir == "DownRight":
		currentDir = previousDir
	if d and currentDir == "DownLeft":
		currentDir = previousDir
	if l and currentDir == "TopLeft":
		currentDir = previousDir

	pass
