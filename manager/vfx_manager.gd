extends Node2D

@export var exp_anim_scene: PackedScene # 爆炸动画的打包场景

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	Gamemanager.enemy_killed.connect(explode)


func explode(pos: Vector2):
	var exp_anim = exp_anim_scene.instantiate() as AnimatedSprite2D
	exp_anim.global_position = pos
	add_child(exp_anim)
	audio_stream_player.play()
	exp_anim.play("explosion")
	await exp_anim.animation_finished # 等待爆炸动画播放完毕再销毁
	exp_anim.queue_free()
