extends Area2D

var position_pool = []

var distance = 0
var hooked = false
var offset = Vector2(24, 12)
var currentDir = Vector2(1, -0.5)

func follow(targetDirection, targetSpeed, targetPosition, perDistance):
	if position_pool.is_empty():
		position_pool.append([targetDirection, targetPosition,perDistance])
	if position_pool.back()[1] != targetPosition:
		position_pool.append([targetDirection, targetPosition,perDistance])

	if not hooked:
		distance += perDistance.length()

	if offset.length() < distance  and targetSpeed > 0:
		var turningPoint = position_pool.pop_front()
		currentDir = turningPoint[0]
		global_position = turningPoint[1]
		hooked = true
