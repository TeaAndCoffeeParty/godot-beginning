extends CharacterBody2D

enum COW_STATE{ IDLE, WALK }
@export var move_speed : float = 10
@export var idle_time : float = 5
@export var walk_time : float = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprint2d = $Sprite2D
@onready var timer = $Timer

var move_direction : Vector2 = Vector2.ZERO
var current_state: COW_STATE = COW_STATE.IDLE

func _ready() -> void:
	
	pick_new_state()
	
func _physics_process(delta: float) -> void:
	if(current_state == COW_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()

func select_direction() -> void:
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)
	
	if(move_direction.x < 0):
		sprint2d.flip_h = true
	elif(move_direction.x > 0):
		sprint2d.flip_h = false
	

func pick_new_state() -> void:
	if(current_state == COW_STATE.IDLE):
		state_machine.travel("Walk_right")
		current_state = COW_STATE.WALK
		select_direction()
		timer.start(walk_time)
	else:
		state_machine.travel("Idle_right")
		current_state = COW_STATE.IDLE
		select_direction()
		timer.start(idle_time)

func _on_timer_timeout() -> void:
	pick_new_state()
