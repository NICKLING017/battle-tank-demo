extends Node2D

var can_shoot: bool = true # 能否射击
var min_cool_down: float = 0.2 # 最小冷却时间

@export var cool_down: float = 0.5 # 射击冷却时间
@export var bullet_scene: PackedScene # 子弹场景

@onready var marker_2d: Marker2D = $Gun/Marker2D
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func shoot(target_pos: Vector2):
	if can_shoot == true:
		timer.start(cool_down)
		if cool_down < 0.5: # 如果冷却时间变短，动画播放时间也要更短
			animation_player.speed_scale = 0.5 / cool_down # speed_scale 值越大 播放速度更快
		animation_player.play("shoot")
		can_shoot = false
		var bullet = bullet_scene.instantiate() # 实例化子弹场景
		bullet.global_position = marker_2d.global_position
		bullet.look_at(target_pos)
		bullet.top_level = true
		add_child(bullet)
	


# 炮管指向瞄准方向
func target(target_pos: Vector2):
	look_at(target_pos)


func upgrade(value):
	cool_down = max(min_cool_down, cool_down-value)


func _on_timer_timeout() -> void:
	can_shoot = true
