extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO  #方向控制
var speed: float = 0  #速度控制
var can_shake := false  #控制镜头抖动

@export var max_speed : float = 300 ## 最大速度
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var weapon_component: Node2D = $WeaponComponent
@onready var trail_compoment: Node2D = $TrailCompoment
@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var camera_2d: Camera2D = $Camera2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	hurt_box_component.get_damage.connect(on_get_damage)
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(on_died)
	Gamemanager.player_win.connect(on_player_win)


func _physics_process(delta: float) -> void:
	move(delta)
	if can_shake:
		shake()


func move(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		var angle_red = direction.angle() # 取得夹角
		rotation = rotate_toward(rotation, angle_red, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
		trail_compoment.start()
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
		trail_compoment.stop()
	
	velocity = transform.x * speed # 方向 * 速度值 = 移动速度
	move_and_slide()


func shake(): # 镜头晃动
	camera_2d.offset = Vector2(randf_range(-3,3),randf_range(-3,3))


func _unhandled_input(event: InputEvent): # 处理没有被UI控件等处理的输入 防止点击按钮的同时还发射子弹
	# print("shoot")
	var target_pos = get_global_mouse_position() # 获取鼠标的世界坐标
	weapon_component.target(target_pos)
	if event.is_action_pressed("shoot"):
		weapon_component.shoot(target_pos)


func on_get_damage(value):
	animation_player.play("flash")
	can_shake = true
	timer.start()
	


func on_health_changed(health):
	Gamemanager.update_health_ui.emit(health)


func on_died():
	Gamemanager.entity_died.emit(global_position, get_groups()) # 获取死亡单位的分组
	Gamemanager.player_killed.emit()
	set_physics_process(false) # 禁止玩家控制
	hide() # 隐藏自身
	hurt_box_component.set_deferred("monitorable", false) # 关闭监测区域


func on_player_win():
	set_physics_process(false) # 禁止玩家控制


func _on_timer_timeout() -> void:
	can_shake = false


func upgrade_weapon(value: float = 0.1):
	weapon_component.upgrade(value)


func upgrade_health(value: float = 1.0):
	health_component.upgrade(value)
