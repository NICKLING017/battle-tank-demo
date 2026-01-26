extends Area2D

var direction: Vector2 = Vector2.ZERO # 方向
var target_pos: Vector2 = Vector2.ZERO # 鼠标指向位置
var speed: float = 0 # 移动速度

@export var max_speed: float = 300 ## 最大移动速度
@export var bullet_scene: PackedScene ## 炮弹场景

@onready var gun: Sprite2D = $Gun
@onready var marker_2d: Marker2D = $Gun/Marker2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	move(delta)
	target()
	shoot()


func move(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta) # 确保坦克朝向和方向一致
		speed = move_toward(speed, max_speed, max_speed * delta)
	else :
		speed = move_toward(speed, 0, 2 * max_speed * delta) # 减速得更快 是加速的2倍
	
	#print(speed)
	position += transform.x * speed * delta
	check_border()


func check_border():
	var size = get_viewport_rect().size # 返回视口边界 Vector2
	position = position.clamp(Vector2.ZERO, size) # 限定位置在窗口内


func target():
	target_pos = get_global_mouse_position() # 目标位置 = 鼠标位置 
	gun.look_at(target_pos)


func shoot():
	if Input.is_action_just_pressed("shoot"):
		print("发射子弹" + str(target_pos))
		var bullet = bullet_scene.instantiate() as Area2D
		bullet.global_position = marker_2d.global_position
		bullet.look_at(target_pos)
		bullet.top_level = true
		add_child(bullet)
