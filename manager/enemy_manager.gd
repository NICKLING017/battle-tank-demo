extends Node

signal wave_died # 整个波次的坦克全部被击毁

var died_tank: int # 被击毁的坦克数量
var died_enemy: int # 被击毁的敌方单位数量
var total_enemy_size: int # 游戏中所有敌方单位数量

@export var enemy_tank_scene: PackedScene
@export var path_holder: Node2D  #用于管理路径节点
@export var wave_number: int = 3   #敌方攻击波次数量
@export var enemy_in_wave: int = 8  #每个波次的坦克数量
@export var enemy_spawn_time: int = 2  #坦克的出生间隔时间
@export var enemies_holder: Node2D   #容器节点用于收纳坦克

@onready var paths: Array  #用于保存路径的数组


func _ready() -> void:
	Gamemanager.entity_died.connect(on_entity_died)
	check_enemy_size()
	paths = path_holder.get_children()
	spawn_waves()


# 获取敌人总数量
func check_enemy_size():
	for enemy in enemies_holder.get_children():
		if "EnemyTower" in enemy.get_groups(): # 炮塔敌人放置在主场景的，需要手动加入进组
			total_enemy_size += 1
		total_enemy_size = wave_number * enemy_in_wave
	Gamemanager.set_total_enemy_size(total_enemy_size)


# 进入到下一波次
func spawn_waves():
	for i in wave_number:
		await spawn_wave()
		await wave_died


# 生成下一波敌人
func spawn_wave():
	died_tank = 0
	for i in enemy_in_wave:
		call_deferred("spawn_enemy")
		await get_tree().create_timer(enemy_spawn_time).timeout # 间隔2秒后再生成下一个

# 实例化坦克
func spawn_enemy():
	var enemy_tank = enemy_tank_scene.instantiate()
	var path = paths.pick_random() # 随机坦克路径
	enemy_tank.speed = randi_range(100,150)
	path.add_child(enemy_tank)


func on_entity_died(pos, groups):
	check_wave_end(groups)
	check_killed_enemy(groups)


func check_wave_end(groups):
	if "EnemyTank" in groups:
		died_tank += 1
		if died_tank == enemy_in_wave:
			wave_died.emit() # 发出波次结束信号


func check_killed_enemy(groups):
	if "Enemy" in groups:
		died_enemy += 1
		Gamemanager.score_update.emit() # 发出得分更新信号
		if died_enemy == total_enemy_size:
			Gamemanager.player_win.emit() # 发出玩家获胜信号
