extends Node

@export var exp_anim_scene: PackedScene   # 保存击毁特效场景
@export var exp_particle_scene: PackedScene  # 保存击中后特效场景
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var exp_sound: AudioStreamPlayer2D = $ExpSound


func _ready():
	Gamemanager.bullet_hit.connect(on_bullet_hit) # 子弹击中信号
	Gamemanager.entity_died.connect(on_entity_died) # 单位死亡信号

func on_entity_died(pos:Vector2, groups:Array):
	# 根据标签播放不同的爆炸动画
	if "Enemy" in groups:
		explode(pos,"regular_exp")
	elif "Player" in groups:
		explode(pos,"sonic_exp")

func on_bullet_hit(pos: Vector2):
	spawn_exp_particle(pos)
	hit_sound.global_position = pos
	hit_sound.play()


# 播放爆炸特效和音效
func explode(pos: Vector2, name: String):
	var exp_anim = exp_anim_scene.instantiate()
	exp_anim.global_position = pos
	add_child(exp_anim)
	exp_anim.play(name)
	exp_sound.global_position = pos
	exp_sound.play()
	await exp_anim.animation_finished
	exp_anim.queue_free() # 爆炸播放完毕后销毁自身


func spawn_exp_particle(pos: Vector2):
	var exp_particle = exp_particle_scene.instantiate() as CPUParticles2D
	exp_particle.global_position = pos
	add_child(exp_particle)
	exp_particle.emitting = true
	await exp_particle.finished
	exp_particle.queue_free()# 特效结束后销毁自身
