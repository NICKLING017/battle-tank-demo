extends Area2D

@export var bullet_scene: PackedScene ## 子弹场景
@export var health: int = 3 ## 初始血量

@onready var gun: Sprite2D = $Gun
@onready var marker_2d: Marker2D = $Gun/Marker2D
@onready var timer: Timer = $Timer
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	timer.start(1)
	Gamemanager.player_killed.connect(on_player_killed)


func _process(_delta: float) -> void:
	find_player()


func find_player():
	var player_pos = player.global_position # 在不同节点之间传递位置信息的时候，要用全局坐标
	if not player_pos: # 如果玩家节点为空
		printerr("玩家节点为空")
		return
	#var player_pos = get_global_mouse_position() # 暂时用鼠标位置
	gun.look_at(player_pos) # look_at旋转该节点，使其局部 X 轴的正方向指向 point，该参数应使用全局坐标。


func shoot():
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.rotation = gun.rotation # 子弹方向和炮管方向一致
	bullet.global_position = marker_2d.global_position # 子弹场景在对应位置生成
	bullet.top_level = true # 将子弹提升为“世界级节点”
	add_child(bullet)


func _on_timer_timeout() -> void:
	shoot()
	timer.start(randf_range(1, 3)) # 随机冷却时间


func reduce_health():
	if health > 0:
		health -= 1
	if health <= 0:
		Gamemanager.enemy_killed.emit(global_position)
		queue_free()


func on_player_killed():
	timer.stop() # 玩家死亡后不再发射炮弹
	
