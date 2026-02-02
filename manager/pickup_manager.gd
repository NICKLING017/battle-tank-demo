extends Node

@export var pick_up_gun_scene: PackedScene
@export var pick_up_health_scene: PackedScene

@onready var pick_up_array = [pick_up_gun_scene, pick_up_health_scene]


func _ready() -> void:
	Gamemanager.entity_died.connect(on_entity_died)


func on_entity_died(pos: Vector2, groups: Array):
	if "Enemy" in groups:
		if randi_range(1, 10) > 5: # 50%概率掉落道具
			call_deferred("spawn_pickup",pos)


func spawn_pickup(pos: Vector2):
	var pick_up_scene = pick_up_array.pick_random() as PackedScene # 随机选一个道具掉落
	var pick_up = 	pick_up_scene.instantiate()
	pick_up.global_position = pos
	add_child(pick_up)
