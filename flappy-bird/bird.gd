extends CharacterBody2D

#物理常量
const JUMP_VELOCITY = -500.0  # 向上飞行的瞬时速度（y轴负方向为上）
const GRAVITY = 1500          # 模拟重力加速度

# 预加载音效资源，提高运行效率
const HIT = preload("res://assets/hit.wav")
const POINT = preload("res://assets/point.wav")
const WING = preload("res://assets/wing.wav")

var rot_degree = 0            # 用于记录当前的旋转角度
var is_dead = true            # 死亡状态标识，默认死亡（等待游戏正式开始）

@export var max_speed := 700  # 最大下落速度限制，使用 @export 方便在编辑器中微调
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cpu_particles_2d = $CPUParticles2D
@onready var fly_sound: AudioStreamPlayer2D = $FlySound
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound

func _ready():
	# 暂时留空，后续用于初始化逻辑
	pass

func _physics_process(delta):
	# 只有当小鸟存活时，才处理物理逻辑
	if not is_dead:
		# 1. 应用重力：速度 = 加速度 * 时间
		velocity.y += GRAVITY * delta

		# 2. 处理玩家输入：检测到名为 "fly" 的动作按下
		if Input.is_action_just_pressed("fly"):
			velocity.y = JUMP_VELOCITY     # 给小鸟一个向上的速度
			fly_sound.stream = WING        # 设置扑翼音效
			fly_sound.play()               # 播放声音

		# 3. 计算旋转角度：根据当前纵向速度改变仰俯角
		# 使用 clampf 将旋转限制在 -30° 到 30° 之间，避免“翻车”
		rot_degree = clampf(-30 * velocity.y / JUMP_VELOCITY, -30, 30)
		rotation_degrees = rot_degree

		# 4. 速度限制：确保下落速度不会无限增加
		velocity.y = clampf(velocity.y, -max_speed, max_speed)

		# 5. 执行移动：根据 velocity 自动处理碰撞与滑动
		move_and_slide()
