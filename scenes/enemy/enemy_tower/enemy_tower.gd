extends StaticBody2D

@onready var weapon_component: Node2D = $WeaponComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var detect_component: Area2D = $DetectComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# 承伤组件的get_damage信号连接到生命值组件的get_damage函数
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)


func _process(delta: float) -> void:
	find_player()


func find_player():
	var player_pos = detect_component.get_player_pos()
	if player_pos: # 如果寻找到玩家，则开火
		weapon_component.target(player_pos)
		weapon_component.shoot(player_pos)


func on_died():
	# 发出死亡信号
	Gamemanager.entity_died.emit(global_position, get_groups())
	queue_free()


func on_get_damage(damage):
	animation_player.play("flash")
	
