extends Node2D

var leader : Node2D
var follower1 : Area2D
var follower2 : Area2D

func _ready() -> void:
	leader = $Leader
	follower1 = $Follower1
	follower2 = $Follower2
	
	if leader and follower1:
		leader.connect("followMe", Callable(follower1, "follow"))
		follower1.connect("followMe", Callable(follower2, "follow"))
	pass
