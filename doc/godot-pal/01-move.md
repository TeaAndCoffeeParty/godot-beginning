# 01 移动篇

## 一、Game的基本框架搭建

1. 在创建Godot工程后，新建一个Game的Node2D节点
2. 在Game节点下新建两个Node2D节点,一个是BattleField(暂不涉及)和Field，并把他们保存成场景

## 二、丰富Field场景的内容

1. 在Field节点下创建，地图（png图片拖进去），重命名成Background
2. 新建CharactorBody2D,重命名成Leader，并把他们保存成场景
    1. 新建一个Sprite2D的节点，
    2. 新建一个碰撞体积CollisionShape2D
    3. 新建一个Camera2D,Zoom选在2.0比例

## 三、丰富Leader

1. 给Sprite添加Texture，李逍遥的右下贴图
2. 给它新建一个子结点AnimationPlayer
3. 添加一个CollisionShape2D的Shape为CircleShape，移动到角色贴图下部，调整形状包含贴图

## 四、添加Follower

1. Follower节点属性是Area2D，都大差不差
2. 和Leader一样，它有SPrite2D,添加赵灵儿（右下贴图)，下面有AnimationPlayer
3. 有CollisionShape2D,一样的位置

## 五、给Leader添加一个脚本Leader

仙剑里的网格布局是一个等轴测投影，所以移动向右是y-=0.5, x-=1
以此类推

```gdscript
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
```

## 六、增加follower跟随Leader功能

本质上是一个人形的贪吃蛇

1. 当距离小于x，follower不动
2. 一旦距离大于等于x，follower开始追随
3. 追随者的步伐和leader之前的轨迹是一样的

```gdscript
#Leader发送位置和方向信息
 global_position += direction * speed
 emit_signal("followMe", direction, speed, global_position, direction*speed)

#Follower节点跟随位置
```gdscript
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

#Filed里需要连接它们
extends Node2D

var leader : Node2D
var follower1 : Area2D

func _ready() -> void:
  leader = $Leader
  follower1 = $Follower1

  if leader and follower1:
    leader.connect("followMe", Callable(follower1, "follow"))
 pass
```

## 七、代码优化
