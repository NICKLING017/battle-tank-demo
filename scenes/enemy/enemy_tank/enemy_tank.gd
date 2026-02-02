extends PathFollow2D

@export var speed: float = 100  #速度变量

@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_component: Node2D = $WeaponComponent
@onready var player = get_tree().get_first_node_in_group("Player")

var moving_forward: bool = true  # 控制移动方向

func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)
	loop = false  # 禁用 PathFollow2D 的循环
	progress = 0  # 从路径起点开始


func _process(delta: float) -> void:
	# 移动逻辑 - 到达终点后反向
	if moving_forward:
		progress += speed * delta
		# 到达终点，反向
		if progress_ratio >= 1.0:
			moving_forward = false
			progress = max(0, progress - 1)
	else:
		progress -= speed * delta
		# 到达起点，正向
		if progress_ratio <= 0.0:
			moving_forward = true
			progress = min(progress, progress + 1)
	
	# 检测玩家并开火
	if player:
		weapon_component.target(player.global_position)
		weapon_component.shoot(player.global_position)


func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()

func on_get_damage(damage):
	animation_player.play("flash")
