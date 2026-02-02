extends Area2D

enum Pickups {GUN, HEALTH} # 枚举

signal get_pickup(pos: Vector2, pickup_type: Pickups) # 道具位置和道具类型的信号

@export var pickup_type: Pickups = Pickups.HEALTH

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if pickup_type == Pickups.GUN:
			body.upgrade_weapon()
		elif pickup_type == Pickups.HEALTH:
			body.upgrade_health()
		animation_player.play("pickup")
		await animation_player.animation_finished
		queue_free()
		
